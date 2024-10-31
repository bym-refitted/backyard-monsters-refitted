import JWT, { JsonWebTokenError, TokenExpiredError } from "jsonwebtoken";
import bcrypt from "bcrypt";

import { Status } from "../../enums/StatusCodes";
import { KoaController } from "../../utils/KoaController";
import { authFailureErr } from "../../errors/errors";
import { ORMContext } from "../../server";
import { User } from "../../models/user.model";
import { errorLog } from "../../utils/logger";
import { ResetPasswordSchema } from "./zod/AuthSchemas";
import { verifyJwtToken } from "../../middleware/auth";

/**
 * Controller to handle password reset requests.
 *
 * This controller validates the password and token provided in the request body,
 * verifies the token, retrieves the user associated with the token from the database,
 * and updates the user's password. If the token is expired, an error is returned.
 *
 * @param {Context} ctx - Koa context object.
 * @returns {Promise<void>} - A promise that resolves when the password reset process is complete.
 */
export const resetPassword: KoaController = async (ctx) => {
  try {
    const { password, token } = ResetPasswordSchema.parse(ctx.request.body);

    // Verify the token
    const { email } = verifyJwtToken(token).user;

    const user = await ORMContext.em.findOne(User, { email });
    if (!user || user.resetToken !== token) throw authFailureErr();

    const hashedPassword = await bcrypt.hash(password, 10);

    // Update the user's password
    user.password = hashedPassword;
    user.resetToken = "";
    await ORMContext.em.persistAndFlush(user);

    ctx.status = Status.OK;
    ctx.body = {
      message: "Password has been reset successfully.",
    };
  } catch (error) {
    errorLog(`Error resetting password: ${error}`);
    if (error instanceof TokenExpiredError) {
      ctx.status = Status.UNAUTHORIZED;
      ctx.body = {
        message:
          "Password reset token has expired. Please request a new password change.",
      };
      return;
    }

    if (error instanceof JsonWebTokenError) errorLog(`Invalid token: ${error}`);
    throw authFailureErr();
  }
};
