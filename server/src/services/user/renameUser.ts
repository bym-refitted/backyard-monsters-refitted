import { UniqueConstraintViolationException } from "@mikro-orm/core";

import { User } from "../../models/user.model.js";
import { Save } from "../../models/save.model.js";
import { World } from "../../models/world.model.js";
import { postgres, redis } from "../../server.js";
import { usernameUniqueErr } from "../../errors/errors.js";

/** How long a player must wait between username changes. */
export const USERNAME_CHANGE_COOLDOWN_MONTHS = 6;

/**
 * When the cooldown started at changedAt expires.
 *
 * @param {Date} changedAt - When the rename happened
 * @returns {Date} The expiry date
 */
const cooldownExpiry = (changedAt: Date): Date => {
  const expiresAt = new Date(changedAt);

  expiresAt.setUTCMonth(expiresAt.getUTCMonth() + USERNAME_CHANGE_COOLDOWN_MONTHS);
  return expiresAt;
};

/**
 * The account's remaining rename cooldown.
 *
 * @param {User} user - The account to check
 * @returns {Date | null} When the cooldown expires, or null if they can rename now
 */
export const getUsernameCooldown = (user: User): Date | null => {
  if (!user.username_changed_at) return null;

  const expiresAt = cooldownExpiry(user.username_changed_at);

  return expiresAt > new Date() ? expiresAt : null;
};

/**
 * Renames an account and every copy of the old username the server owns.
 *
 * The single writer for username changes, moving user.username, the cooldown stamp,
 * save.name on every yard they own and any world labelled after them together in
 * one transaction.
 *
 * @param {User} user - The account being renamed, already loaded by the caller
 * @param {string} username - The validated new username
 * @returns {Promise<Date>} When the cooldown this rename started expires
 */
export const renameUser = async (user: User, username: string): Promise<Date> => {
  const previousUsername = user.username;
  const changedAt = new Date();

  let worldsRenamed = 0;

  try {
    await postgres.em.transactional(async (em) => {
      const existing = await em.findOne(User, { username });

      if (existing) throw usernameUniqueErr();

      await em.nativeUpdate(User, { userid: user.userid }, { username, username_changed_at: changedAt });
      await em.nativeUpdate(Save, { saveuserid: user.userid }, { name: username });

      worldsRenamed = await em.nativeUpdate(
        World,
        { name: { $in: [previousUsername, `${previousUsername} Server`] } },
        { name: `${username} Server` }
      );
    });
  } catch (err) {
    if (err instanceof UniqueConstraintViolationException) throw usernameUniqueErr();
    throw err;
  }

  user.username = username;
  user.username_changed_at = changedAt;

  if (worldsRenamed > 0) await redis.del("availableWorlds");

  return cooldownExpiry(changedAt);
};
