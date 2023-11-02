import { ORMContext } from "../server";
import { User } from "../models/user.model";
import { KoaController } from "../utils/KoaController";
import * as jwt from "jsonwebtoken";

// This isn't being used correctly yet
export const auth: KoaController = async (ctx, next) => {
  const rawToken = ctx.cookies.get("x-bym-refitted");
  if (!rawToken) {
    ctx.status = 500;
    ctx.body = null;
    return;
  }

  const { userId } = <jwt.UserIDJwtPayload>(
    jwt.verify(rawToken, process.env.SECRET_KEY || "MISSING_SECRET")
  );

  // Load user from database, or we can just use the userid
  ctx.authUser = await ORMContext.em.findOne(User, { userid: userId });

  if (!ctx.authUser) {
    ctx.status = 500;
    ctx.body = null;
    return;
  }

  await next();
};
