import { Status } from "../enums/StatusCodes";
import { ClientSafeError } from "../middleware/clientSafeError";

enum ErrorCodes {
  AUTH_ERROR = "AUTH_ERROR",
  DEBUG_ERROR = "DEBUG_ERROR",
  SAVE_ERROR = "SAVE_ERROR",
}

export const authFailureErr = () =>
  new ClientSafeError({
    message: "Could not authenticate",
    status: Status.UNAUTHORIZED,
    code: ErrorCodes.AUTH_ERROR,
    data: null,
  });

export const debugClientErr = () =>
  new ClientSafeError({
    message: "Sorry, it appears this cannot be found.",
    status: Status.NOT_FOUND,
    code: ErrorCodes.DEBUG_ERROR,
    data: null,
  });

export const saveFailureErr = () =>
  new ClientSafeError({
    message: "We encountered an unexpected error",
    status: Status.INTERNAL_SERVER_ERROR,
    code: ErrorCodes.SAVE_ERROR,
    data: null,
  });
