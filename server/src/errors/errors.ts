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
    data: null,
    isClientFriendly: true,
  });

export const tokenAuthFailureErr = () =>
  new ClientSafeError({
    message: "Could not authenticate with user token",
    status: Status.UNAUTHORIZED,
    data: null,
    isClientFriendly: true,
  });

export const emailPasswordErr = () =>
  new ClientSafeError({
    message:
      "Your login credentials are incorrect. Please check and try again. If you forgot your password, you can reset it by clicking on 'Forgot Password'.",
    status: Status.CONFLICT,
    data: null,
    isClientFriendly: true,
  });

export const usernameUniqueErr = () =>
  new ClientSafeError({
    message: "An account with this username already exists.",
    status: Status.CONFLICT,
    data: null,
    isClientFriendly: true,
  });

export const emailUniqueErr = () =>
  new ClientSafeError({
    message: "An account with this email address already exists.",
    status: Status.CONFLICT,
    data: null,
    isClientFriendly: true,
  });

export const debugClientErr = () =>
  new ClientSafeError({
    message: "Sorry, it appears this cannot be found.",
    status: Status.NOT_FOUND,
    data: null,
    isClientFriendly: true,
  });

export const saveFailureErr = () =>
  new ClientSafeError({
    message: "We encountered an unexpected error",
    status: Status.INTERNAL_SERVER_ERROR,
    data: null,
    isClientFriendly: true,
  });

export const loadFailureErr = () =>
  new ClientSafeError({
    message: "We could not load the requested data",
    status: Status.NOT_FOUND,
    data: null,
    isClientFriendly: true,
  });

export const userPermaBannedErr = () =>
  new ClientSafeError({
    message:
      "Your account has been permanently banned. If you believe this is an error, please contact support.",
    status: Status.FORBIDDEN,
    data: null,
  });

export const discordVerifyErr = () =>
  new ClientSafeError({
    message:
      "In order to continue, you must verify your account on our Discord server, in the <b>#claim-account channel</b>.",
    status: Status.UNAUTHORIZED,
    data: null,
  });

export const discordAgeErr = () =>
  new ClientSafeError({
    message:
      "Your discord account must be at least 1 week old in order to access this feature.",
    status: Status.UNAUTHORIZED,
    data: null,
  });
