import { ErrorCodes } from "../enums/ErrorCodes";
import { Status } from "../enums/StatusCodes";
import { ClientSafeError } from "../middleware/clientSafeError";

/**
 * Creates a new instance of `ClientSafeError` with the specified properties.
 *
 * @returns A new `ClientSafeError` instance.
 */
export const authFailureErr = () =>
  new ClientSafeError({
    message: "Could not authenticate",
    status: Status.UNAUTHORIZED,
    code: ErrorCodes.AUTH_ERROR,
    data: null,
  });

export const emailPasswordErr = () =>
  new ClientSafeError({
    message:
      "Your login credentials are incorrect. Please check and try again. If you forgot your password, you can reset it by clicking on 'Forgot Password'.",
    status: Status.CONFLICT,
    code: ErrorCodes.INVALID_CREDENTIALS,
    data: null,
  });

export const usernameUniqueErr = () =>
  new ClientSafeError({
    message: "An account with this username already exists.",
    status: Status.CONFLICT,
    code: ErrorCodes.USERNAME_EXISTS,
    data: null,
  });

export const emailUniqueErr = () =>
  new ClientSafeError({
    message: "An account with this email address already exists.",
    status: Status.CONFLICT,
    code: ErrorCodes.EMAIL_EXISTS,
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

export const loadFailureErr = () =>
  new ClientSafeError({
    message: "We could not load the requested data",
    status: Status.NOT_FOUND,
    code: ErrorCodes.LOAD_ERROR,
    data: null,
  });
