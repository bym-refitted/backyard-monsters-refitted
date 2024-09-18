import z from "zod";
import bcrypt from "bcrypt";
import JWT from "jsonwebtoken";

import { User } from "../../models/user.model";
import { ORMContext } from "../../server";
import { FilterFrontendKeys } from "../../utils/FrontendKey";
import { KoaController } from "../../utils/KoaController";
import { authFailureErr } from "../../errors/errors";
import { logging } from "../../utils/logger";
import { BymJwtPayload } from "../../middleware/auth";
import { Status } from "../../enums/StatusCodes";
import { Context } from "koa";

const UserLoginSchema = z.object({
  email: z.string().email().toLowerCase().optional(),
  password: z.string().optional(),
  token: z.string().optional(),
});

const authenticateWithToken = async (ctx: Context) => {
  const { token } = UserLoginSchema.parse(ctx.request.body);

  const { user } = JWT.verify(
    token,
    process.env.SECRET_KEY || "MISSING_SECRET"
  ) as BymJwtPayload;

  let userRecord = await ORMContext.em.findOne(User, { email: user.email });

  if (!userRecord) throw authFailureErr();

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
  let { email, password, token } = UserLoginSchema.parse(ctx.request.body);
  let user: User | null = null;

  if (token) {
    try {
      user = await authenticateWithToken(ctx);
    } catch (err) {
      // If token authentication fails, proceed to email and password authentication
    }
  }

  if (!user) {
    user = await ORMContext.em.findOne(User, { email });
    if (!user) throw authFailureErr();

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) throw authFailureErr();
  }

  // Generate and set the token
  const sessionLifeTime = process.env.SESSION_LIFETIME || "30d";
  token = JWT.sign(
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
