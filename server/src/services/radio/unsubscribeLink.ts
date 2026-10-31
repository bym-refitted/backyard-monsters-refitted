import { createHmac, timingSafeEqual } from "crypto";

import { BASE_URL, PORT } from "../../server.js";

/**
 * The server's public address. Behind a proxy BASE_URL:PORT isn't reachable, so prod sets SERVER_URL.
 * Read on each call: this module is imported while server.ts is still initialising.
 *
 * @returns {string} The address.
 */
const serverUrl = (): string => process.env.SERVER_URL || `${BASE_URL}:${PORT}`;

/**
 * Signs a player's unsubscribe token. The links never expire; rotating SECRET_KEY revokes them all.
 *
 * @param {number} userid - The player.
 * @returns {string} The token.
 */
const signToken = (userid: number): string =>
  createHmac("sha256", process.env.SECRET_KEY!).update(`radio-unsubscribe:${userid}`).digest("base64url");

/**
 * Builds the one-click unsubscribe link for a player's Radio Tower alerts.
 *
 * @param {number} userid - The player.
 * @returns {string} The unsubscribe URL.
 */
export const unsubscribeLink = (userid: number) => `${serverUrl()}/radio/unsubscribe?u=${userid}&t=${signToken(userid)}`;

/**
 * Whether a token from an unsubscribe link was signed for this player.
 *
 * @param {number} userid - The player the link names.
 * @param {string} token - The token from the link.
 * @returns {boolean} True when the token is genuine.
 */
export const isValidUnsubscribeToken = (userid: number, token: string): boolean => {
  const expected = Buffer.from(signToken(userid));
  const given = Buffer.from(token);

  return given.length === expected.length && timingSafeEqual(given, expected);
};
