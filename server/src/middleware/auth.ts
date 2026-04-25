import { postgres, redis } from "../server.js";
import { User } from "../models/user.model.js";
import type { Context, Next } from "koa";
import {
  authFailureErr,
  discordAgeErr,
  tokenAuthFailureErr,
} from "../errors/errors.js";
import JWT from "jsonwebtoken";
import { Env } from "../enums/Env.js";
import type { SessionType } from "../enums/SessionType.js";

export interface AuthTokenPayload {
  user: {
    email: string;
    discordId: string | null | undefined;
    meetsDiscordAgeCheck: boolean;
    sessionType: SessionType.GAME | SessionType.LAUNCHER;
  };
}

/**
 * Middleware to enforce authentication for protected routes.
 *
 * This middleware checks for the presence of a valid Bearer token in the
 * Authorization header, verifies the token's authenticity, and loads the
 * associated user from the database.
 *
 * @param {Context} ctx - The Koa context object.
 * @param {Next} next - The Koa next middleware function.
 * @throws Will throw an error if the Authorization header is missing or invalid, or if the user cannot be found.
 */
export const verifyUserAuth = async (ctx: Context, next: Next) => {
  const authHeader = ctx.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) throw authFailureErr();

  const token = authHeader.replace("Bearer ", "");
  const decodedToken = verifyJwtToken(token);

  const sessionType = decodedToken.user.sessionType;
  const email = decodedToken.user.email;

  const storedToken = await redis.get(`user-token:${sessionType}:${email}`);

  if (storedToken !== token) throw authFailureErr();

  const user = await postgres.em.findOne(User, { email });

  if (!user || user.banned) throw authFailureErr();

  ctx.authUser = user;
  ctx.meetsDiscordAgeCheck = decodedToken.user.meetsDiscordAgeCheck;

  if (!ctx.authUser) throw authFailureErr();
  await next();
};

/**
 * Middleware to validate a user's eligibility for multiplayer access.
 *
 * This middleware checks for the presence of a valid Bearer token in the
 * Authorization header, verifies the token, and ensures the user meets
 * the Discord account age requirement.
 *
 * @param {Context} ctx - The Koa context object.
 * @param {Next} next - The Koa next middleware function.
 * @throws {Error} Throws `tokenAuthFailureErr` if the Authorization header is missing or invalid.
 * @throws {Error} Throws `discordAgeErr` if the user's Discord account creation date does not meet the requirement.
 */
export const verifyAccountStatus = async (ctx: Context, next: Next) => {
  if (!ctx.meetsDiscordAgeCheck) throw discordAgeErr();
  await next();
};

/**
 * Verifies a JWT token and returns the decoded payload.
 *
 * For local development, we return a basic payload with the user's email.
 * In production, we introduce discord authentication.
 *
 * @param {string} token - The JWT token to verify.
 * @returns {AuthTokenPayload} The decoded JWT payload.
 * @throws Will throw an error if the token is invalid or verification fails.
 */
export const verifyJwtToken = (token: string): AuthTokenPayload => {
  if (process.env.ENV === Env.LOCAL) {
    const decoded = JWT.decode(token) as AuthTokenPayload;

    return {
      user: {
        email: decoded.user?.email,
        discordId: null,
        meetsDiscordAgeCheck: true,
        sessionType: decoded.user?.sessionType,
      },
    };
  }

  try {
    return <AuthTokenPayload>JWT.verify(token, process.env.SECRET_KEY!);
  } catch (err) {
    throw tokenAuthFailureErr();
  }
};
