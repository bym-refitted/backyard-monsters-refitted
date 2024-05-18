import { User } from "../../models/user.model";
import { ORMContext } from "../../server";
import { FilterFrontendKeys } from "../../utils/FrontendKey";
import { KoaController } from "../../utils/KoaController";
import z from "zod";
import bcrypt from "bcrypt";
import JWT from "jsonwebtoken";
import { authFailureErr } from "../../errors/errorCodes.";
import { logging } from "../../utils/logger";
import { BymJwtPayload } from "../../middleware/auth";

const UserLoginSchema = z.object({
  email: z.string().optional(),
  password: z.string().optional(),
});

export const login: KoaController = async (ctx) => {
  const { email, password } = UserLoginSchema.parse(ctx.request.body);

  const user = await ORMContext.em.findOne(User, { email });
  if (!user) throw authFailureErr();

  const isMatch = await bcrypt.compare(password, user.password);
  if (!isMatch) throw authFailureErr();

  // Generate and set the token
  const sessionLifeTime = process.env.SESSION_LIFETIME || "30d";
  const token = JWT.sign(
    {
      user: {
        email: user.email,
      },
    } satisfies BymJwtPayload,
    process.env.SECRET_KEY,
    {
      expiresIn: sessionLifeTime,
    }
  );

  const filteredUser = FilterFrontendKeys(user);
  logging(
    `User ${filteredUser.username} successful login | ID: ${filteredUser.userid} | Email: ${filteredUser.email} | IP Address: ${ctx.ip}`
  );

  ctx.session.userid = filteredUser.userid;

  ctx.status = 200;
  ctx.body = {
    error: 0,
    ...filteredUser,
    version: 128,
    token,
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
