import z from "zod";
import { SessionType } from "../enums/SessionType.js";

const emailError = "Invalid email address";

const passwordLengthError = "Password must be at least 8 characters long";
const passwordSpecialError = "Password must contain at least one special character";

/**
 * Schema to validate passwords.
 * - Must be at least 8 characters long.
 * - Must contain at least one special character (any non-alphanumeric character).
 */
const passwordSchema = z.preprocess(
  (input) => (input === "" ? undefined : input),
  z.string()
    .trim()
    .min(8, passwordLengthError)
    .regex(/[^a-zA-Z0-9]/, passwordSpecialError)
    .optional()
);

/**
 * Schema to validate email addresses.
 * - Must be a valid email format.
 * - Converts the email to lowercase.
 */
const emailSchema = z.email(emailError).trim().toLowerCase();

const usernameCharsetError = "Usernames can only contain letters, numbers and underscores";
const usernameLengthError = "Usernames must be between 2 and 12 characters";

/**
 * Schema to validate usernames.
 * - Must be 2 to 12 characters long.
 * - Letters, numbers and underscores only.
 */
const usernameSchema = z
  .string()
  .trim()
  .min(2, usernameLengthError)
  .max(12, usernameLengthError)
  .regex(/^[a-zA-Z0-9_]+$/, usernameCharsetError);

/**
 * Schema to validate user login data.
 * - Email is optional.
 * - Password is optional.
 * - Token is optional.
 * - sessionType distinguishes game sessions from launcher/website sessions.
 */
export const UserLoginSchema = z.object({
  email: emailSchema.optional(),
  password: passwordSchema.optional(),
  token: z.string().optional(),
  sessionType: z.enum([SessionType.GAME, SessionType.LAUNCHER]).default(SessionType.GAME),
});

/**
 * Schema to validate user registration data.
 * - Username must be between 2 and 12 characters.
 * - Email must meet the email schema requirements.
 * - Password must meet the password schema requirements.
 */
export const UserRegistrationSchema = z.object({
  username: usernameSchema,
  email: emailSchema,
  password: passwordSchema,
});

/**
 * Schema to validate a username change request.
 * - Username must meet the username schema requirements.
 */
export const ChangeUsernameSchema = z.object({ username: usernameSchema });

/**
 * Schema to validate password reset data.
 * - Password must meet the password schema requirements.
 * - Token must be a string.
 */
export const ResetPasswordSchema = z.object({
  password: passwordSchema,
  token: z.string(),
});

/**
 * Schema to validate forgot password data.
 * - Email must meet the email schema requirements.
 */
export const ForgotPasswordSchema = z.object({
  email: emailSchema,
});
