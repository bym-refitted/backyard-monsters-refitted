import { Status } from "../enums/StatusCodes.js";
import { ClientSafeError } from "../middleware/clientSafeError.js";

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
      "Your login credentials are incorrect. Please check and try again. If you forgot your password, you can reset it by clicking on forgot password.",
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
    message: "We encountered an error while saving",
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
    isClientFriendly: true
  });

export const antiCheatBanErr = () =>
  new ClientSafeError({
    message:
      "Hey bud, it seems you got caught by a very basic anti-cheat, you're not that guy pal, enjoy the ban.",
    status: Status.FORBIDDEN,
    data: null,
    isClientFriendly: true
  });

export const discordVerifyErr = () =>
  new ClientSafeError({
    message:
      "In order to continue, you must verify your account on our Discord server, in the #claim-account channel.",
    status: Status.UNAUTHORIZED,
    data: null,
    isClientFriendly: true
  });

export const discordAgeErr = () =>
  new ClientSafeError({
    message:
      "Your discord account must be at least 1 week old in order to access this feature.",
    status: Status.UNAUTHORIZED,
    data: null,
  });

export const permissionErr = () =>
  new ClientSafeError({
    message: "You do not have permission to complete this operation.",
    status: Status.FORBIDDEN,
    data: null,
    isClientFriendly: true,
  });

export const mailboxErr = () =>
  new ClientSafeError({
    message: "Mailbox failed with an error.",
    status: Status.NOT_FOUND,
    data: null,
    isClientFriendly: true,
  });

export const relocateOutpostErr = () =>
  new ClientSafeError({
    message:
      "You cannot relocate while owning outposts in this world.",
    status: Status.FORBIDDEN,
    data: null,
    isClientFriendly: true,
  });
