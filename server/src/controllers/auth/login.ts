import { User } from "../../models/user.model";
import { ORMContext } from "../../server";
import { FilterFrontendKeys } from "../../utils/FrontendKey";
import { KoaController } from "../../utils/KoaController";
import { ClientSafeError } from "../../middleware/clientSafeError";
import z from "zod";
import bcrypt from "bcrypt";
import JWT from "jsonwebtoken";

const UserLoginSchema = z.object({
  email: z.string(),
  password: z.string(),
});

// TODO:
// 3. Create auth middleware
//    - add token to requests. JWT? Bearer?
//    - Redis / store session token in sqlite -^^^^^
//  4. Clientside ability to skip the login

const loginFailureError = new ClientSafeError({
  message: "Could not authenticate",
  status: 403,
  code: "AUTH_ERROR",
  data: null,
});

export const login: KoaController = async (ctx) => {
  const { email, password } = UserLoginSchema.parse(ctx.request.body);
  let user = await ORMContext.em.findOne(User, { email });
  // No user found
  if (!user) {
    throw loginFailureError;
  }

  const isMatch = await bcrypt.compare(password, user.password);

  if (isMatch) {
    const sessionLifeTime = parseInt(process.env.SESSION_LIFETIME) || 1;
    const token = JWT.sign({ userId: user.userid }, process.env.SECRET_KEY, {
      expiresIn: `${sessionLifeTime}d`,
    });

    const filteredUser = FilterFrontendKeys(user);
    // return logged in user data
    ctx.status = 200;
    ctx.body = {
      error: 0,
      version: 128,
      token,
      mapversion: 3,
      mailversion: 1,
      soundversion: 1,
      languageversion: 8,
      app_id: "2de76fv89",
      tpid: "t76fbxXsw",
      currency_url: "",
      language: "en",
      h: "someHashValue",
      ...filteredUser,
    };

    const cookieExpiryTime = sessionLifeTime * (24 * 60 * 60) * 1000;
    const expires = new Date(Date.now() + cookieExpiryTime);
    ctx.cookies.set("x-bym-refitted", token, {
      expires,
    });
  } else {
    throw loginFailureError;
  }
};
