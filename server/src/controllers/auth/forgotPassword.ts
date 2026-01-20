import path from "path";
import JWT from "jsonwebtoken";

import { Status } from "../../enums/StatusCodes.js";
import { KoaController } from "../../utils/KoaController.js";
import { logger } from "../../utils/logger.js";
import { promises as fs } from "fs";
import { postgres } from "../../server.js";
import { User } from "../../models/user.model.js";
import { authFailureErr } from "../../errors/errors.js";
import { ForgotPasswordSchema } from "../../zod/AuthSchemas.js";
import { transporter } from "../../config/MailSettings.js";
/**
 * Controller to handle forgot password functionality.
 *
 * This controller validates the email provided in the request body,
 * generates a short-lived JWT token, stores the token in the database
 * associated with the user's email, reads the HTML template for the
 * password reset email, replaces the placeholder with the reset link,
 * and sends the email using the configured SMTP transporter.
 *
 * @param {Object} ctx - Koa context object.
 * @returns {Promise<void>} - A promise that resolves when the email is sent or an error occurs.
 */
export const forgotPassword: KoaController = async (ctx) => {
  try {
    const { email } = ForgotPasswordSchema.parse(ctx.request.body);

    // Generate a short-lived JWT token
    const token = JWT.sign({ user: { email } }, process.env.SECRET_KEY, {
      expiresIn: "20m",
    });

    // Store the token in the database associated with the user's email
    const user = await postgres.em.findOne(User, { email });
    
    if (!user) {
      logger.error(`ForgotPassword: User not found for email: ${email}`);
      throw authFailureErr();
    }

    user.resetToken = token;
    await postgres.em.persistAndFlush(user);

    // Read the HTML template
    const templatePath = path.resolve(
      import.meta.dirname,
      "../../../public/templates/forgot-password.html"
    );
    const html = await fs.readFile(templatePath, "utf-8");

    // Send user token in email
    const resetLink = `${process.env.WEB_URL}/reset-password?token=${token}`;
    const emailHtml = html.replace("{{resetLink}}", resetLink);

    const mailOptions = {
      from: "Backyard Monsters Refitted <info@bymrefitted.com>",
      to: email,
      subject: "Password reset request | BYM Refitted",
      html: emailHtml,
    };

    // Send the email
    await transporter.sendMail(mailOptions);

    ctx.status = Status.OK;
    ctx.body = { message: "Password reset email sent successfully." };
  } catch (error) {
    logger.error(`Error in forgotPassword controller: ${error}`);
    ctx.status = Status.BAD_REQUEST;
    ctx.body = {
      message: "Failed to send email. Please try again later.",
    };
  }
};
