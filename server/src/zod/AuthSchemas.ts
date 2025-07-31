import z from "zod";

const emailError = "Invalid email address";

const passwordRegex = /^(?=.*[A-Z])(?=.*[\W_])(?=.{8,})/;
const passwordLengthError = "Password must be at least 8 characters long";
const passwordError =
  "Password must contain at least one uppercase letter and one special character";

/**
 * Schema to validate passwords.
 * - Must be at least 8 characters long.
 * - Must contain at least one uppercase letter.
 * - Must contain at least one special character.
 */
const passwordSchema = z.preprocess((arg) => {
  if (typeof arg === "string" && arg === "") {
    return undefined;
  } else {
    return arg;
  }
}, z.string().min(8, passwordLengthError).regex(new RegExp(".*[A-Z].*"), passwordError).regex(new RegExp(".*[`~<>?,./!@#$%^&*()\\-_+=\"'|{}\\[\\];:\\\\].*"), passwordError).optional());

/**
 * Schema to validate email addresses.
 * - Must be a valid email format.
 * - Converts the email to lowercase.
 */
const emailSchema = z.string().email(emailError).toLowerCase();

/**
 * Schema to validate user login data.
 * - Email is optional.
 * - Password is optional.
 * - Token is optional.
 */
export const UserLoginSchema = z.object({
  email: emailSchema.optional(),
  password: passwordSchema.optional(),
  token: z.string().optional(),
});

/**
 * Schema to validate user registration data.
 * - Username must be between 2 and 12 characters.
 * - Email must meet the email schema requirements.
 * - Password must meet the password schema requirements.
 */
export const UserRegistrationSchema = z.object({
  username: z.string().min(2).max(12),
  email: emailSchema,
  password: passwordSchema,
});

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
