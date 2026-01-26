import bcrypt from "bcrypt";
import * as jwt from "jsonwebtoken";

import { Status } from "../../enums/StatusCodes.js";
import type { KoaController } from "../../utils/KoaController.js";
import { authFailureErr } from "../../errors/errors.js";
import { postgres } from "../../server.js";
import { User } from "../../models/user.model.js";
import { logger } from "../../utils/logger.js";
import { ResetPasswordSchema } from "../../zod/AuthSchemas.js";
import { verifyJwtToken } from "../../middleware/auth.js";

const { JsonWebTokenError, TokenExpiredError } = jwt;

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

    const decodedToken = verifyJwtToken(token);

    // Verify the token
    const { email } = decodedToken.user;

    const user = await postgres.em.findOne(User, { email });
    if (!user || user.resetToken !== token){
      console.log("User not found or token mismatch");
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    // Update the user's password
    user.password = hashedPassword;
    user.resetToken = "";
    await postgres.em.persistAndFlush(user);

    ctx.status = Status.OK;
    ctx.body = {
      message: "Password has been reset successfully.",
    };
  } catch (error) {
    logger.error(`Error resetting password: ${error}`);
    if (error instanceof TokenExpiredError) {
      ctx.status = Status.UNAUTHORIZED;
      ctx.body = {
        message:
          "Password reset token has expired. Please request a new password change.",
      };
      return;
    }

    if (error instanceof JsonWebTokenError) logger.error(`Invalid token: ${error}`);
    throw authFailureErr();
  }
};  
