import { User } from "../../database/models/user.model.js";

/**
 * Whether the account has opted into no-shiny mode.
 *
 * @param {User} user - The requesting account
 * @returns {boolean} True while shiny is locked
 */
export const isShinyLocked = (user: User): boolean => user.shiny_locked;

/**
 * The shiny balance to report to the client.
 *
 * @param {User} user - The requesting account
 * @param {number} credits - The real balance from the owner's main save
 * @returns {number} The balance the client should see
 */
export const visibleCredits = (user: User, credits: number): number => isShinyLocked(user) ? 0 : credits;
