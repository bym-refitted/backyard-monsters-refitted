import { Context, Next } from "koa";
import { errorLog } from "../utils/logger";
import { Status } from "../enums/StatusCodes";

interface ConstructorParams {
  status: number;
  data: object;
  internalInfo?: Error;
  message: string;
  isClientFriendly?: boolean;
}

/**
 * Error which is marked and formatted to be safe for the client
 * Removes internal details while logging them for debugging on our end
 */
export class ClientSafeError extends Error {
  status: number;
  data: object;
  internalInfo?: Error;
  error: string;
  isClientFriendly: boolean;

  constructor({
    message = "Something went wrong, please contact support.",
    status = Status.INTERNAL_SERVER_ERROR,
    data = {},
    internalInfo,
    isClientFriendly: isNiceError = false,
  }: ConstructorParams) {
    super(message);
    this.name = "ClientSafeError";
    this.status = status;
    this.data = data;
    this.internalInfo = internalInfo;
    this.error = message;
    this.isClientFriendly = isNiceError;
  }

  // Create the json to return safely to client
  toSafeJson() {
    const responseBody = {
      error: undefined as string | undefined,
      status: this.status,
      data: this.data,
      internalInfo: this.internalInfo?.stack, // This should be removed from the codebase
      message: this.message,
    };

    if (!this.isClientFriendly) responseBody.error = this.message;

    return responseBody;
  }
}

/**
 * Middleware to intercept errors and hide them from the user unless they are specifically thrown as ClientSafeErrors.
 *
 * @param {Context} ctx - The Koa context object.
 * @param {Next} next - The Koa next middleware function.
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
          status: Status.INTERNAL_SERVER_ERROR,
          data: {},
          internalInfo: err,
          isClientFriendly: true,
        });
    const errorObj = clientError.toSafeJson();
    if (!isSafe) errorLog(`${JSON.stringify(errorObj)}`);

    console.error(
      `ErrorInterceptor error: ${errorObj.error} | status: ${errorObj.status}`
    );

    // Put me in jail for my sins - this is bad to accomdate for the client
    ctx.status = errorObj.error ? Status.OK : errorObj.status;
    ctx.body = { error: errorObj.error, errorDetails: errorObj };
  }
};
