import { User } from "../../models/user.model";
import { ORMContext } from "../../server";
import bcrypt from "bcrypt";
import JWT from "jsonwebtoken";
import { FilterFrontendKeys } from "../../utils/FrontendKey";
import { KoaController } from "../../utils/KoaController";
import z from "zod";

const UserLoginSchema = z.object({
  email: z.string(),
  password: z.string(),
});

// TODO:
// 1. Fix clientside error system
//    - Improve the Controller type to force a return of clientside error
// 2. Use FrontendKey for save
// 3. Create auth middleware
//    - add token to requests. JWT? Bearer?
//    - Redis / store session token in sqlite -^^^^^
//  4. Clientside ability to skip the login - Default login credentials for dev?

export const login: KoaController = async ctx => {
  try {
    const { email, password } = UserLoginSchema.parse(ctx.request.body);
    let user = await ORMContext.em.findOne(User, { email });

    // No user found
    if (!user) {
      ctx.status = 404;
      ctx.body = { error: "Could not find user." };
      return;
    }

    const isMatch = await bcrypt.compare(password, user.password);

    if (isMatch) {
      const token = JWT.sign({ userId: user.userid }, process.env.SECRET_KEY, {
        expiresIn: "30d",
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
    } else {
      ctx.status = 401;
      ctx.body = { error: "Password does not match." };
    }
  } catch (error) {
    ctx.status = 500;
    ctx.body = { error };
  }
};
