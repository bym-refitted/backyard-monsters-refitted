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
    data: {},
    isClientFriendly: true,
  });

export const tokenAuthFailureErr = () =>
  new ClientSafeError({
    message: "Could not authenticate with user token",
    status: Status.UNAUTHORIZED,
    data: {},
    isClientFriendly: true,
  });

export const emailPasswordErr = () =>
  new ClientSafeError({
    message:
      "Your login credentials are incorrect. Please check and try again. If you forgot your password, you can reset it by clicking on forgot password.",
    status: Status.CONFLICT,
    data: {},
    isClientFriendly: true,
  });

export const usernameUniqueErr = () =>
  new ClientSafeError({
    message: "An account with this username already exists.",
    status: Status.CONFLICT,
    data: {},
    isClientFriendly: true,
  });

export const emailUniqueErr = () =>
  new ClientSafeError({
    message: "An account with this email address already exists.",
    status: Status.CONFLICT,
    data: {},
    isClientFriendly: true,
  });

export const usernameCooldownErr = (nextChangeAt: Date) =>
  new ClientSafeError({
    message: `You can only change your username once every 6 months. You can change it again on ${nextChangeAt.toUTCString()}.`,
    status: Status.CONFLICT,
    data: { nextChangeAt: nextChangeAt.toISOString() },
    isClientFriendly: true,
  });

export const debugClientErr = () =>
  new ClientSafeError({
    message: "Sorry, it appears this cannot be found.",
    status: Status.NOT_FOUND,
    data: {},
    isClientFriendly: true,
  });

export const saveFailureErr = () =>
  new ClientSafeError({
    message: "We encountered an error while saving",
    status: Status.INTERNAL_SERVER_ERROR,
    data: {},
    isClientFriendly: true,
  });

export const loadFailureErr = () =>
  new ClientSafeError({
    message: "We could not load the requested data",
    status: Status.NOT_FOUND,
    data: {},
    isClientFriendly: true,
  });

export const userPermaBannedErr = () =>
  new ClientSafeError({
    message:
      "Your account has been permanently banned. If you believe this is an error, please contact support.",
    status: Status.FORBIDDEN,
    data: {},
    isClientFriendly: true
  });

export const antiCheatBanErr = () =>
  new ClientSafeError({
    message:
      "Hey bud, it seems you got caught by a very basic anti-cheat, you're not that guy pal, enjoy the ban.",
    status: Status.FORBIDDEN,
    data: {},
    isClientFriendly: true
  });

export const discordVerifyErr = () =>
  new ClientSafeError({
    message:
      "In order to continue, you must verify your account on our Discord server, in the #claim-account channel.",
    status: Status.UNAUTHORIZED,
    data: {},
    isClientFriendly: true
  });

export const discordAgeErr = () =>
  new ClientSafeError({
    message:
      "Your discord account must be at least 1 week old in order to access this feature.",
    status: Status.UNAUTHORIZED,
    data: {},
    isClientFriendly: true
  });

export const permissionErr = () =>
  new ClientSafeError({
    message: "You do not have permission to complete this operation.",
    status: Status.FORBIDDEN,
    data: {},
    isClientFriendly: true,
  });

export const mailboxErr = () =>
  new ClientSafeError({
    message: "Mailbox failed with an error.",
    status: Status.NOT_FOUND,
    data: {},
    isClientFriendly: true,
  });

export const relocateOutpostErr = () =>
  new ClientSafeError({
    message:
      "You cannot relocate while owning outposts in this world.",
    status: Status.FORBIDDEN,
    data: {},
    isClientFriendly: true,
  });

export const baseUnderAttackErr = () =>
  new ClientSafeError({
    message: "This base is currently under attack by another player. Please try again later.",
    status: Status.CONFLICT,
    data: {},
    isClientFriendly: false,
  });

export const baseProtectedErr = () =>
  new ClientSafeError({
    message: "This base is currently under damage protection and cannot be attacked.",
    status: Status.FORBIDDEN,
    data: {},
    isClientFriendly: false,
  });

export const userOnlineErr = () =>
  new ClientSafeError({
    message: "This player is currently online and cannot be attacked. Please try again later.",
    status: Status.CONFLICT,
    data: {},
    isClientFriendly: false,
  });

export const takeoverCellErr = () =>
  new ClientSafeError({
    message: "The server attempted to take over this cell but failed unexpectedly. Please try again.",
    status: Status.INTERNAL_SERVER_ERROR,
    data: {},
    isClientFriendly: false,
  });

export const mapRoomDisabledErr = () =>
  new ClientSafeError({
    message: "Map Room is not enabled on this server",
    status: Status.NOT_FOUND,
    data: {},
    isClientFriendly: false,
  });

export const townHallLevelErr = () =>
  new ClientSafeError({
    message: "Town Hall level 6 required to upgrade Map Room.",
    status: Status.FORBIDDEN,
    data: {},
    isClientFriendly: true,
  });

export const truceActiveErr = () =>
  new ClientSafeError({
    message: "You have an active truce with this player and cannot attack them.",
    status: Status.FORBIDDEN,
    data: {},
    isClientFriendly: false,
  });

export const alreadyInAllianceErr = () =>
  new ClientSafeError({
    message: "You are already a member of an alliance.",
    status: Status.CONFLICT,
    data: {},
    isClientFriendly: true,
  });

export const allianceNameTakenErr = () =>
  new ClientSafeError({
    message: "The alliance name is already taken.",
    status: Status.CONFLICT,
    data: {},
    isClientFriendly: true,
  });

export const allianceNoWorldErr = () =>
  new ClientSafeError({
    message: "You must join a world before creating an alliance.",
    status: Status.FORBIDDEN,
    data: {},
    isClientFriendly: true,
  });

export const leaderMustTransferErr = (allianceName: string) =>
  new ClientSafeError({
    message: `Since you're the fearless leader of the ${allianceName} Alliance, you need to elect someone to succeed you before you go.  Go to the Members Tab and promote a current member to leader before you depart.`,
    status: Status.FORBIDDEN,
    data: {},
    isClientFriendly: true,
  });


export const requestPendingErr = () =>
  new ClientSafeError({
    message: "You already have a request pending.",
    status: Status.CONFLICT,
    data: {},
    isClientFriendly: true,
  });

export const invitePendingErr = () =>
  new ClientSafeError({
    message: "They already have an invite pending.",
    status: Status.CONFLICT,
    data: {},
    isClientFriendly: true,
  });

export const userAlreadyInAllianceErr = () =>
  new ClientSafeError({
    message: "User is already in an alliance.",
    status: Status.CONFLICT,
    data: {},
    isClientFriendly: true,
  });

export const mustLeaveAllianceErr = () =>
  new ClientSafeError({
    message: "You must leave your alliance to join another.",
    status: Status.CONFLICT,
    data: {},
    isClientFriendly: true,
  });

export const mustLeaveAllianceToChangeWorldErr = () =>
  new ClientSafeError({
    message: "You must leave your alliance before you can change worlds.",
    status: Status.CONFLICT,
    data: {},
    isClientFriendly: true,
  });

export const mustLeaveAllianceToAcceptErr = () =>
  new ClientSafeError({
    message: "You must leave your current alliance before accepting the invite.",
    status: Status.CONFLICT,
    data: {},
    isClientFriendly: true,
  });

export const inviteNotPendingErr = () =>
  new ClientSafeError({
    message: "Invite has already been resolved.",
    status: Status.CONFLICT,
    data: {},
    isClientFriendly: true,
  });

export const allianceFullErr = () =>
  new ClientSafeError({
    message: "The alliance is already full.",
    status: Status.CONFLICT,
    data: {},
    isClientFriendly: true,
  });

export const cannotKickErr = () =>
  new ClientSafeError({
    message: "You cannot kick members.",
    status: Status.FORBIDDEN,
    data: {},
    isClientFriendly: true,
  });

export const cannotPromoteErr = () =>
  new ClientSafeError({
    message: "You cannot promote members.",
    status: Status.FORBIDDEN,
    data: {},
    isClientFriendly: true,
  });

export const cannotInviteOutsideWorldErr = (username: string) =>
  new ClientSafeError({
    message: `${username} is too far away to join your Alliance. Invite them to move to one of your close-by Outposts.`,
    status: Status.FORBIDDEN,
    data: {},
    isClientFriendly: true,
  });
