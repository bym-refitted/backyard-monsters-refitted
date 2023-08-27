import { ErrorRequestHandler } from "express";

/**
 * Error which is marked and formatted to be safe for the client
 */
export class ClientSafeError extends Error {
  code: string;
  status: number;
  data: object;
  constructor({
    message = "Something went wrong, please contact support.",
    status = 500,
    code = "INTERNAL_ERROR",
    data = {},
  }) {
    super(message);
    this.name = "ClientSafeError";
    this.code = code;
    this.status = status;
    this.data = data;
  }
}

/**
 *  This middleware intercepts errors that are thrown and hides them from the user unless the are specifically thrown as clientSafeErrors
 *
 *
 */
export const ErrorInterceptor: ErrorRequestHandler = async (
  err,
  req,
  res,
  next
) => {
  // Check if the error is client safe
  const isSafe = err instanceof ClientSafeError;
  // if (!inProd) console.error(err);

  // Generate or format response to be consistent - we don't want to include the stack trace etc
  const clientError = isSafe
    ? {
        message: err.message,
        code: err.code,
        status: err.status,
        data: err.data,
      }
    : {
        message: "Something went wrong, please contact support.",
        code: "INTERNAL_ERROR",
        status: 500,
        data: err,
      };
  if (!isSafe) console.error(clientError);
  return res.status(clientError.status).json({ error: clientError });
};
