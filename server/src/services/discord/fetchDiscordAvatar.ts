import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { logger } from "../../utils/logger.js";

const DISCORD_CDN = "https://cdn.discordapp.com";

const CHECK_INTERVAL_MS = 24 * 60 * 60 * 1000;

interface DiscordUser { avatar?: string | null; }

/**
 * Fetches the latest avatar hash from Discord for a user and persists it if changed.
 * Skips the API call if the avatar was checked within the last 24 hours.
 * Also updates pic_square so all existing callers see the correct avatar automatically.
 * Uses a forked EntityManager so it is safe to call fire-and-forget after a response.
 *
 * @param {number} userid - The internal user ID to update.
 * @param {string} discordid - The user's Discord snowflake ID.
 */
export const fetchDiscordAvatar = async (userid: number, discordid: string) => {
  const discordToken = process.env.DISCORD_TOKEN;

  if (!discordToken) return;

  try {
    const em = postgres.em.fork();
    const user = await em.findOne(User, { userid });

    if (!user) return;

    const lastChecked = user.discord_avatar_checked_at;

    if (lastChecked && Date.now() - lastChecked.getTime() < CHECK_INTERVAL_MS) return;

    const response = await fetch(`https://discord.com/api/v10/users/${discordid}`, {
      headers: { Authorization: `Bot ${discordToken}` },
    });

    if (!response.ok) return;

    const { avatar } = await response.json() as DiscordUser;

    const newPicSquare = fetchAvatarUrl(user.username, discordid, avatar);

    user.discord_avatar_checked_at = new Date();

    if (user.pic_square !== newPicSquare) user.pic_square = newPicSquare;

    await em.flush();
  } catch (err) {
    logger.warn`Failed to refresh Discord avatar for user ${userid}: ${err}`;
  }
};

/**
 * Resolves the effective avatar URL for a user.
 * Prefers the Discord CDN when an avatar hash is present, falls back to DiceBear.
 */
export const fetchAvatarUrl = (username: string, discordId?: string | null, avatarHash?: string | null) => {
  if (discordId && avatarHash) 
    return `${DISCORD_CDN}/avatars/${discordId}/${avatarHash}.png`;

  return `${process.env.AVATAR_URL}?seed=${username}&size=50`;
};