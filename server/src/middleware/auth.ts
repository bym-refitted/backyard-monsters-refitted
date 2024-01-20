import { ORMContext } from "../server";
import { User } from "../models/user.model";
import { verifyJwtToken } from "../utils/verifyJwtToken";
import { Context, Next } from "koa";
import { authFailureErr } from "../errors/errorCodes.";

/**
 * This middleware enforces authentication for protected routes. It checks
 * for the presence of a valid Bearer token in the Authorization header,
 * verifies the token's authenticity, and loads the associated user from the
 * database.
 */
export const auth = async (ctx: Context, next: Next) => {
  const authHeader = ctx.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) throw authFailureErr;

  const token = authHeader.replace("Bearer ", "");

  ctx.authUser = await ORMContext.em.findOne(User, {
    userid: verifyJwtToken(token).userId,
  });

  if (!ctx.authUser) throw authFailureErr;
  await next();
};
