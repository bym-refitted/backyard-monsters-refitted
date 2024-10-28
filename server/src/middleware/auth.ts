import { ORMContext } from "../server";
import { User } from "../models/user.model";
import { Context, Next } from "koa";
import { authFailureErr } from "../errors/errorCodes.";
import JWT, { JwtPayload } from "jsonwebtoken";

/**
 * This middleware enforces authentication for protected routes. It checks
 * for the presence of a valid Bearer token in the Authorization header,
 * verifies the token's authenticity, and loads the associated user from the
 * database.
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
 * This is a disgusting hack because the JWT library types are awful. please remove in future if this is fixed
 */
type DisgustingJwtPayloadHack = Pick<
  JwtPayload,
  "iss" | "sub" | "aud" | "exp" | "nbf" | "iat" | "jti"
>;

export interface BymJwtPayload extends DisgustingJwtPayloadHack {
  user: {
    email: string;
  };
}

export const verifyJwtToken = (token: string): BymJwtPayload => {
  try {
    return <BymJwtPayload>(
      JWT.verify(token, process.env.SECRET_KEY || "MISSING_SECRET")
    );
  } catch (err) {
    throw authFailureErr();
  }
};
