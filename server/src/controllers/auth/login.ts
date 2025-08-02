import bcrypt from "bcrypt";
import JWT from "jsonwebtoken";

import { User } from "../../models/user.model";
import { ORMContext, redisClient } from "../../server";
import { FilterFrontendKeys } from "../../utils/FrontendKey";
import { KoaController } from "../../utils/KoaController";
import {
  emailPasswordErr,
  discordVerifyErr,
  userPermaBannedErr,
} from "../../errors/errors";
import { logging } from "../../utils/logger";
import { BymJwtPayload, verifyJwtToken } from "../../middleware/auth";
import { Status } from "../../enums/StatusCodes";
import { Context } from "koa";
import { UserLoginSchema } from "../../zod/AuthSchemas";
import { Env } from "../../enums/Env";
import type { StringValue } from "ms";

/**
 * Authenticates a user using a JWT token.
 *
 * This function verifies the provided JWT token and retrieves the associated user record
 * from the database. If the token is valid and the user exists, it returns the user record.
 * If the token is invalid or the user does not exist, it throws an authentication failure error.
 *
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<User>} - A promise that resolves to the authenticated user record.
 * @throws {Error} - Throws an error if the token is invalid or the user does not exist.
 */
const authenticateWithToken = async (token: string) => {
  const { user } = verifyJwtToken(token);

  let userRecord = await ORMContext.em.findOne(User, { email: user.email });
  if (!userRecord) throw emailPasswordErr();

  return userRecord;
};

/**
 * Controller to handle user login.
 *
 * This controller authenticates a user based on either their email & password, or token.
 * The token is stored in Redis for each login request, to later be validated in the middleware.
 * Additionally, the controller checks if the user is banned or has verified their Discord account.
 * The token signature is then constructed with the user's email and Discord ID, along with a flag
 * indicating if the user meets the Discord age check requirement.
 *
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 * @throws {Error} - Throws an error if authentication fails or if the request body is invalid.
 */
export const login: KoaController = async (ctx) => {
  let { email, password, token } = UserLoginSchema.parse(ctx.request.body);
  let user: User | null = null;

  if (token) user = await authenticateWithToken(token);

  if (!user) {
    user = await ORMContext.em.findOne(User, { email });
    if (!user) throw emailPasswordErr();

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) throw emailPasswordErr();
  }

  if (user.banned) throw userPermaBannedErr();

  // Generate and set the token
  const sessionLifeTime = process.env.SESSION_LIFETIME || "30d";
  let discordId: string;

  // Check if the user has verified their Discord account
  if (process.env.ENV === Env.PROD) {
    if (!user.discord_verified) throw discordVerifyErr();
    discordId = user.discord_id;
  }

  const isOlderThanOneWeek = (snowflakeId: string) => {
    // Discord's epoch starts at 2015-01-01T00:00:00 UTC
    const discordEpoch = 1420070400000;

    // Extract the timestamp from the Snowflake ID (first 42 bits)
    const timestamp = Number(BigInt(snowflakeId) >> 22n) + discordEpoch;

    const creationDate = new Date(timestamp);
    const sevenDaysAgo = new Date();

    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

    return creationDate < sevenDaysAgo;
  };

  const newToken = JWT.sign(
    {
      user: {
        email: user.email,
        discordId,
        meetsDiscordAgeCheck:
          process.env.ENV !== Env.PROD || isOlderThanOneWeek(discordId),
      },
    } satisfies BymJwtPayload,
    process.env.SECRET_KEY,
    {
      expiresIn: sessionLifeTime as StringValue,
    }
  );

  await redisClient.set(`user-token:${user.email}`, newToken);
  await ORMContext.em.persistAndFlush(user);

  const filteredUser = FilterFrontendKeys(user);
  logging(
    `User ${filteredUser.username} successful login | ID: ${filteredUser.userid} | Email: ${filteredUser.email} | IP Address: ${ctx.ip}`
  );

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
    app_id: "",
    tpid: "",
    currency_url: "",
    language: "en",
    settings: {},
  };
};
