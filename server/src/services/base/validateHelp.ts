import { permissionErr } from "../../errors/errors.js";
import { areFriends } from "../friends/friendList.js";
import type { Save } from "../../database/models/save.model.js";
import type { User } from "../../database/models/user.model.js";

/**
 * Help is friends only. Helping knocks time off someone else's build timers, so it is
 * kept to players who agreed to each other rather than anyone who can reach the base.
 *
 * @param {User} user - The visiting player.
 * @param {Save} save - The base they are asking to help on.
 * @throws {ClientSafeError} When the base does not belong to one of their friends.
 */
export const validateHelp = async (user: User, save: Save) => {
  const isFriend = await areFriends(user.userid, save.userid);

  if (!isFriend) throw permissionErr();
};
