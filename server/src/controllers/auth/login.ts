import bcrypt from "bcrypt";
import JWT from "jsonwebtoken";

import { User } from "../../models/user.model";
import { ORMContext } from "../../server";
import { FilterFrontendKeys } from "../../utils/FrontendKey";
import { KoaController } from "../../utils/KoaController";
import { authFailureErr, emailPasswordErr } from "../../errors/errors";
import { logging } from "../../utils/logger";
import { BymJwtPayload } from "../../middleware/auth";
import { Status } from "../../enums/StatusCodes";
import { Context } from "koa";
import { ClientSafeError } from "../../middleware/clientSafeError";
import { UserLoginSchema } from "./validation";

/**
 * Authenticates a user using a JWT token.
 *
 * This function verifies the provided JWT token and retrieves the associated user record
 * from the database. If the token is valid and the user exists, it returns the user record.
 * If the token is invalid or the user does not exist, it throws an authentication failure error.
 *
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<User>} - A promise that resolves to the authenticated user record.
 * @throws {Error} - Throws an error if the token is invalid or the user does not exist.
 */
const authenticateWithToken = async (ctx: Context) => {
  const { token } = UserLoginSchema.parse(ctx.request.body);

  const { user } = JWT.verify(
    token,
    process.env.SECRET_KEY || "MISSING_SECRET"
  ) as BymJwtPayload;

  let userRecord = await ORMContext.em.findOne(User, { email: user.email });

  if (!userRecord) throw emailPasswordErr();

  return userRecord;
};

/**
 * Controller to handle user login.
 *
 * This controller authenticates a user based on the provided email & password.
 * If the authentication is successful, it generates a JWT token and returns the
 * user information along with the token. If authentication fails, it throws an
 * authentication failure error.
 *
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 * @throws {Error} - Throws an error if authentication fails or if the request body is invalid.
 */
export const login: KoaController = async (ctx) => {
  try {
    let { email, password, token } = UserLoginSchema.parse(ctx.request.body);
    let user: User | null = null;

    if (token) {
      try {
        user = await authenticateWithToken(ctx);
      } catch (err) {}
    }

    if (!user) {
      user = await ORMContext.em.findOne(User, { email });
      if (!user) throw emailPasswordErr();

      const isMatch = await bcrypt.compare(password, user.password);
      if (!isMatch) throw emailPasswordErr();
    }

    // Generate and set the token
    const sessionLifeTime = process.env.SESSION_LIFETIME || "30d";
    const newToken = JWT.sign(
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

    ctx.status = Status.OK;
    ctx.body = {
      error: 0,
      ...filteredUser,
      version: 128,
      token: newToken,
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
  } catch (err) {
    if (err instanceof ClientSafeError) {
      ctx.status = err.status;
      ctx.body = { message: err.message, code: err.code };
    } else throw authFailureErr();
  }
};
