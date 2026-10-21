import bcrypt from "bcrypt";
import JWT, { type SignOptions } from "jsonwebtoken";

import { User } from "../../database/models/user.model.js";
import { postgres, redis } from "../../server.js";
import { FilterFrontendKeys } from "../../utils/FrontendKey.js";
import type { KoaController } from "../../utils/KoaController.js";
import {
  emailPasswordErr,
  discordVerifyErr,
  userPermaBannedErr,
  tokenAuthFailureErr,
} from "../../errors/errors.js";
import { logger } from "../../utils/logger.js";
import { sessionTokenKey, type JwtClaims, verifyJwtToken } from "../../middleware/auth.js";
import { Status } from "../../enums/StatusCodes.js";
import { UserLoginSchema } from "../../schemas/AuthSchemas.js";
import { Env } from "../../enums/Env.js";
import { SessionType } from "../../enums/SessionType.js";
import { fetchDiscordAvatar } from "../../services/discord/fetchDiscordAvatar.js";

type SessionLifetime = NonNullable<SignOptions["expiresIn"]>;

/** Launcher and website tokens with less than this many seconds left are renewed rather than reused. */
const RENEW_WITHIN_SECONDS = 7 * 24 * 60 * 60;

/**
 * Authenticates a user using a JWT token.
 *
 * This function verifies the provided JWT token and retrieves the associated user record
 * from the database. If the token is valid and the user exists, it returns the user record.
 * If the token is invalid or the user does not exist, it throws an authentication failure error.
 *
 * @param {string} token - The token presented by the client.
 * @returns {Promise<{ userRecord: User; sessionId: string; sessionType: SessionType }>} - The user,
 * the session the token belongs to so that signing back in renews that device rather than opening
 * another, and the session type the token was issued for.
 * @throws {Error} - Throws an error if the token is invalid or the user does not exist.
 */
const authenticateWithToken = async (token: string) => {
  const { user } = verifyJwtToken(token);

  if (!user.sessionId) throw tokenAuthFailureErr();

  const storedToken = await redis.get(sessionTokenKey(user.sessionType, user.email, user.sessionId));
  if (storedToken !== token) throw tokenAuthFailureErr();

  let userRecord = await postgres.em.findOne(User, { email: user.email });
  if (!userRecord) throw emailPasswordErr();

  const sessionId = user.sessionId;

  return { userRecord, sessionId, sessionType: user.sessionType };
};

/**
 * How long the session key should live, read from the token it holds so that an
 * abandoned session leaves Redis at the same moment its token stops being accepted.
 *
 * @param {string} token - The freshly signed token.
 * @returns {number} Seconds until the token expires, never less than one.
 */
const sessionTtlSeconds = (token: string): number => {
  const expiresAt = JWT.decode(token, { json: true })?.exp ?? 0;

  return Math.max(1, expiresAt - Math.floor(Date.now() / 1000));
};

/**
 * Whether a token login can hand back the token it was given instead of signing a new one.
 * Game sessions are always renewed, since a new game token is what evicts an older game client.
 *
 * @param {string} token - The verified token the client signed in with.
 * @param {SessionType} tokenSessionType - The session type the token was issued for.
 * @param {SessionType} sessionType - The session type the client is signing in to.
 * @returns {boolean} True when the token can be returned as it is.
 */
const canReuseToken = (token: string, tokenSessionType: SessionType, sessionType: SessionType): boolean =>
  sessionType !== SessionType.GAME &&
  tokenSessionType === sessionType &&
  sessionTtlSeconds(token) > RENEW_WITHIN_SECONDS;

/**
 * Controller to handle user login.
 *
 * This controller authenticates a user based on either their email & password, or token.
 * A new token is stored in Redis to later be validated in the middleware, except when a launcher or
 * website signs in with a token that is still far from expiry, which is handed back unchanged.
 * Additionally, the controller checks if the user is banned or has verified their Discord account.
 * The token signature is then constructed with the user's email and Discord ID, along with a flag
 * indicating if the user meets the Discord age check requirement.
 *
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 * @throws {Error} - Throws an error if authentication fails or if the request body is invalid.
 */
export const login: KoaController = async (ctx) => {
  let { email, password, token, sessionType } = UserLoginSchema.parse(ctx.request.body);
  let user: User | null = null;
  let sessionId: string | undefined;
  let reusableToken: string | undefined;

  if (token) {
    try {
      const authenticated = await authenticateWithToken(token);

      user = authenticated.userRecord;
      sessionId = authenticated.sessionId;

      const reuse = canReuseToken(token, authenticated.sessionType, sessionType);

      if (reuse) reusableToken = token;
    } catch (err) {
      if (!email || !password) throw err;
      logger.warn(`Token login failed: ${(err as Error).message}`);
    }
  }

  if (!user) {
    user = await postgres.em.findOne(User, { email });
    if (!user) throw emailPasswordErr();

    const isMatch = await bcrypt.compare(password!, user.password);
    if (!isMatch) throw emailPasswordErr();
  }

  if (user.banned) throw userPermaBannedErr();

  // Generate and set the token
  const sessionLifeTime = process.env.SESSION_LIFETIME || "30d";
  let discordId: string | null | undefined;

  sessionId ??= crypto.randomUUID();

  // Check if the user has verified their Discord account
  if (process.env.ENV === Env.PROD) {
    if (!user.discord_verified) throw discordVerifyErr();
    discordId = user.discord_id;

    if (discordId) fetchDiscordAvatar(user.userid, discordId);
  }

  let newToken = reusableToken;

  if (!newToken) {
    newToken = JWT.sign(
      {
        user: {
          email: user.email,
          discordId,
          sessionType,
          sessionId,
        },
      } satisfies JwtClaims,
      process.env.SECRET_KEY!,
      {
        expiresIn: sessionLifeTime as SessionLifetime,
      }
    );

    const tokenTtl = sessionTtlSeconds(newToken);
    await redis.setex(sessionTokenKey(sessionType, user.email, sessionId), tokenTtl, newToken);
  }

  postgres.em.persist(user);
  await postgres.em.flush();

  const filteredUser = FilterFrontendKeys(user);
  const userAgent = ctx.get("user-agent") || "none";

  logger.info("User {username} logged in | ID: {userid} | IP: {ip}", {
    event: "login",
    username: filteredUser.username,
    userid: filteredUser.userid,
    email: filteredUser.email,
    ip: ctx.ip,
    userAgent,
  });

  ctx.status = Status.OK;
  ctx.body = {
    error: 0,
    userId: filteredUser.userid,
    ...filteredUser,
    version: 128,
    token: newToken,
    mapversion: 2,
    mailversion: 1,
    soundversion: 1,
    languageversion: 8,
    sendinvite: 1,
    app_id: "",
    tpid: "",
    currency_url: "",
    language: "en",
    settings: {},
    // TODO: add remaining keys that the client expects
  };
};
