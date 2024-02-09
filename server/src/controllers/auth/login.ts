import { User } from "../../models/user.model";
import { ORMContext } from "../../server";
import { FilterFrontendKeys } from "../../utils/FrontendKey";
import { KoaController } from "../../utils/KoaController";
import z from "zod";
import bcrypt from "bcrypt";
import JWT from "jsonwebtoken";
import { Context } from "koa";
import { verifyJwtToken } from "../../utils/verifyJwtToken";
import { authFailureErr } from "../../errors/errorCodes.";
import { logging } from "../../utils/logger";

const UserLoginSchema = z.object({
  email: z.string().optional(),
  password: z.string().optional(),
  token: z.string().optional(),
});

const authenticateWithToken = async (ctx: Context) => {
  const { token } = UserLoginSchema.parse(ctx.request.body);

  let user = await ORMContext.em.findOne(User, {
    userid: verifyJwtToken(token).userId,
  });

  if (!user) throw authFailureErr;
  return user;
};

export const login: KoaController = async (ctx) => {
  const { email, password, token } = UserLoginSchema.parse(ctx.request.body);

  if (token) {
    const user = await authenticateWithToken(ctx);
    const filteredUser = FilterFrontendKeys(user);
    ctx.session.userid = filteredUser.userid;

    ctx.body = {
      error: 0,
      ...filteredUser,
      version: 128,
      token,
      mapversion: 3,
      mailversion: 1,
      soundversion: 1,
      languageversion: 8,
      app_id: "",
      tpid: "",
      currency_url: "",
      language: "en",
      settings: {},
    };
  } else {
    const user = await ORMContext.em.findOne(User, { email });
    if (!user) throw authFailureErr;

    const isMatch = await bcrypt.compare(password, user.password);

    if (isMatch) {
      // Generate and set the token
      const sessionLifeTime = process.env.SESSION_LIFETIME || "30d";
      const token = JWT.sign({ userId: user.userid }, process.env.SECRET_KEY, {
        expiresIn: sessionLifeTime,
      });

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
        mapversion: 3,
        mailversion: 1,
        soundversion: 1,
        languageversion: 8,
        app_id: "",
        tpid: "",
        currency_url: "",
        language: "en",
        settings: {},
      };
    } else throw authFailureErr;
  }
};
