import { Save } from "../../../models/save.model.js";
import { User } from "../../../models/user.model.js";


/**
 * Optional initialization function for the anti-cheat module.
 */
export const initialize = async (): Promise<void> => {};

/**
 * STUB: Public no-op implementation for open-source builds.
 *
 * This is a placeholder stub that performs no validation.
 * Production uses a private implementation (anticheat.private.ts) with actual anti-cheat logic.
 *
 * If you're running your own server, you can implement your own anti-cheat system
 * by creating a file at: server/src/scripts/anticheat/anticheat.private.ts
 *
 * Your private implementation should:
 * - Export a `validateSave` function with the same signature as below
 * - Ban users by setting user.banned = true
 * - Create Report records with ban reasons for audit trail
 * - Throw antiCheatBanErr() to notify the client immediately
 *
 * @param user - The user making the save request
 * @param save - The save data being validated
 * @param rawBody - The raw request body for additional validation
 * @returns Promise that resolves if validation passes
 * @throws Should throw antiCheatBanErr() if cheating is detected
 */
export const validateSave = async (_user: User, _save: Save, _rawBody: unknown): Promise<void> => {
  // No-op stub - no validation performed
  // Real anti-cheat implementation is private and only on production servers
  return;
};
