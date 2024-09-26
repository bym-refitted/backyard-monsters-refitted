import { ORMContext } from "../server";
import { User } from "../models/user.model";
import { Context, Next } from "koa";
import { authFailureErr } from "../errors/errors";
import JWT, { JwtPayload } from "jsonwebtoken";

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
export const auth = async (ctx: Context, next: Next) => {
  const authHeader = ctx.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) throw authFailureErr();

  const token = authHeader.replace("Bearer ", "");

  ctx.authUser = await ORMContext.em.findOne(User, {
    email: verifyJwtToken(token).user.email,
  });

  if (!ctx.authUser) throw authFailureErr();
  await next();
};

/**
 * A temporary type definition to work around issues with the JWT library types.
 * This type should be removed in the future if the JWT library types are fixed. */
type DisgustingJwtPayloadHack = Pick<
  JwtPayload,
  "iss" | "sub" | "aud" | "exp" | "nbf" | "iat" | "jti"
>;

export interface BymJwtPayload extends DisgustingJwtPayloadHack {
  user: {
    email: string;
  };
}

/**
 * Verifies a JWT token and returns the decoded payload.
 *
 * @param {string} token - The JWT token to verify.
 * @returns {BymJwtPayload} The decoded JWT payload.
 * @throws Will throw an error if the token is invalid or verification fails.
 */
export const verifyJwtToken = (token: string): BymJwtPayload => {
  try {
    return <BymJwtPayload>JWT.verify(token, process.env.SECRET_KEY);
  } catch (err) {
    throw authFailureErr();
  }
};
