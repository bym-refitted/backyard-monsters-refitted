import { Context, Next } from "koa";
import { errorLog } from "../utils/logger";

interface ConstructorParams {
  code: string;
  status: number;
  data: object;
  internalInfo?: Error;
  message: string;
}

/**
 * Error which is marked and formatted to be safe for the client
 *
 * Removes internal details while logging them for debugging on our end
 */
export class ClientSafeError extends Error {
  code: string;
  status: number;
  data: object;
  internalInfo?: Error;

  constructor({
    message = "Something went wrong, please contact support.",
    status = 500,
    code = "INTERNAL_ERROR",
    data = {},
    internalInfo,
  }: ConstructorParams) {
    super(message);
    this.name = "ClientSafeError";
    this.code = code;
    this.status = status;
    this.data = data;
    this.internalInfo = internalInfo;
  }

  // Create the json to return safely to client
  public toSafeJson() {
    return {
      message: this.message,
      code: this.code,
      status: this.status,
      data: this.data,
      internalInfo: this.internalInfo?.stack, // This should be removed in Prod
    };
  }
}

/**
 *  This middleware intercepts errors that are thrown and hides them from the user unless the are specifically thrown as clientSafeErrors
 *
 *
 */
export const ErrorInterceptor = async (ctx: Context, next: Next) => {
  try {
    await next();
  } catch (err) {
    // Check if the error is client safe
    const isSafe = err instanceof ClientSafeError;
    let clientError = isSafe
      ? err
      : new ClientSafeError({
          message: "Something went wrong, please contact support.",
          code: "INTERNAL_ERROR",
          status: 500,
          data: {},
          internalInfo: err,
        });
    const errorObj = clientError.toSafeJson();
    if (!isSafe) errorLog(`${JSON.stringify(errorObj)}`);
    ctx.status = errorObj.status;
    ctx.body = { error: errorObj };
  }
};
