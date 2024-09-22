import z from "zod";
import nodemailer from "nodemailer";
import path from "path";

import { Status } from "../../enums/StatusCodes";
import { KoaController } from "../../utils/KoaController";
import { errorLog } from "../../utils/logger";
import { Env } from "../../enums/Env";
import { promises as fs } from "fs";

const ForgotPasswordSchema = z.object({
  email: z.string().email().toLowerCase(),
});

/** SMTP transporter configuration */
const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: parseInt(process.env.SMTP_PORT),
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASSWORD,
  },
  tls: { rejectUnauthorized: false },
  secure: process.env.ENV === Env.PROD,
  connectionTimeout: 30000,
});

/**
 * Controller to handle forgot password functionality.
 *
 * This function validates the email provided in the request body,
 * reads the HTML template for the password reset email, and sends
 * the email using the configured SMTP transporter.
 *
 * @param {Object} ctx - Koa context object.
 * @returns {Promise<void>} - A promise that resolves when the email is sent or an error occurs.
 */
export const forgotPassword: KoaController = async (ctx) => {
  try {
    const { email } = ForgotPasswordSchema.parse(ctx.request.body);
    
    const templatePath = "../../templates/forgot-password.html";

    const template = path.join(__dirname, templatePath);
    const html = await fs.readFile(template, "utf-8");

    const mailOptions = {
      from: "Backyard Monsters Refitted <info@bymrefitted.com>",
      to: email,
      subject: "Password reset request | BYM Refitted",
      html,
    };

    await transporter.sendMail(mailOptions);

    ctx.status = Status.OK;
    ctx.body = { message: "Password reset email sent successfully." };
  } catch (error) {
    errorLog(`Error in forgotPassword controller: ${error}`);
    ctx.status = Status.INTERNAL_SERVER_ERROR;
    ctx.body = { message: "An error occurred while attempting to send an email." };
  }
};
