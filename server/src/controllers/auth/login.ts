import { User } from "../../models/user.model";
import { ORMContext } from "../../server";
import { FilterFrontendKeys } from "../../utils/FrontendKey";
import { KoaController } from "../../utils/KoaController";
import { ClientSafeError } from "../../middleware/clientSafeError";
import z from "zod";
import bcrypt from "bcrypt";
import JWT from "jsonwebtoken";
import { Context } from "koa";

// ToDo:
// 1. Auth middleware for all routes
// 2. Improve client side errors
const UserLoginSchema = z.object({
  email: z.string().optional(),
  password: z.string().optional(),
  token: z.string().optional(),
});

const loginFailureError = new ClientSafeError({
  message: "Could not authenticate",
  status: 403,
  code: "AUTH_ERROR",
  data: null,
});

const authenticateWithToken = async (ctx: Context) => {
  const { token } = UserLoginSchema.parse(ctx.request.body);

  try {
    const { userId } = <JWT.UserIDJwtPayload>(
      JWT.verify(token, process.env.SECRET_KEY || "MISSING_SECRET")
    );

    let user = await ORMContext.em.findOne(User, { userid: userId });

    if (!user) {
      throw loginFailureError;
    }

    return user;
  } catch (err) {
    throw loginFailureError;
  }
};

export const login: KoaController = async (ctx) => {
  const { email, password, token } = UserLoginSchema.parse(ctx.request.body);

  if (token) {
    const user = await authenticateWithToken(ctx);
    const filteredUser = FilterFrontendKeys(user);
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
      h: "someHashValue",
    };
  } else {
    const user = await ORMContext.em.findOne(User, { email });
    if (!user) {
      throw loginFailureError;
    }

    const isMatch = await bcrypt.compare(password, user.password);

    if (isMatch) {
      // Generate and set the token
      const sessionLifeTime = parseInt(process.env.SESSION_LIFETIME) || 1;
      const token = JWT.sign({ userId: user.userid }, process.env.SECRET_KEY, {
        // expiresIn: `${sessionLifeTime}d`,
        expiresIn: `${sessionLifeTime}d`,
      });

      const filteredUser = FilterFrontendKeys(user);
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
        h: "someHashValue",
      };

      // const cookieExpiryTime = sessionLifeTime * (24 * 60 * 60) * 1000;
      // const expires = new Date(Date.now() + cookieExpiryTime);
      // ctx.cookies.set("x-bym-refitted", token, {
      //   expires,
      // });
    } else {
      throw loginFailureError;
    }
  }
};
