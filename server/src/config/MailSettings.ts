import nodemailer from "nodemailer";
import { Env } from "../enums/Env.js";

/** SMTP transporter configuration */
export const transporter = nodemailer.createTransport({
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
