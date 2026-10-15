import z from "zod";
import { parseJsonSafely } from "../utils/parseJsonSafely.js";

export type KrallenData = z.infer<typeof KrallenSchema>;

export type KrallenStoredData = z.infer<typeof KrallenStoredSchema>;

/**
 * A player's Hunt for Krallen progress, in the shape KOTHHandler reads it.
 */
export const KrallenSchema = z.object({
  tier: z.number().int().min(0).catch(0),             // reward tier from the last finished round
  wins: z.number().int().min(0).catch(0),             // rounds won in a row
  loot: z.number().min(0).catch(0),                   // loot gathered in the current round
  countdown: z.number().min(0).catch(0),              // seconds until the current round ends
  lastShownTier: z.number().int().min(0).catch(0),    // highest mid-round popup already shown
});


/**
 * A player's Hunt for Krallen progress as stored: what the client reads, plus the round
 * the loot belongs to and how much of the latest attack's loot has been counted.
 */
export const KrallenStoredSchema = KrallenSchema.extend({
  roundEnd: z.number().catch(0),                            // end of the round the loot belongs to
  attackId: z.string().catch(""),                           // the attack whose loot was counted last
  attackLoot: z.number().min(0).catch(0),                   // loot from that attack already counted
});

/**
 * The part of the Hunt for Krallen data the client is allowed to save, read from the
 * stringified data it sends. Anything unusable resolves to undefined, so a bad value
 * is ignored rather than failing the whole base save.
 */
export const KrallenClientSchema = z
  .string()
  .optional()
  .transform(parseJsonSafely)
  .pipe(
    z
      .object({
        lastShownTier: z.coerce.number().int().min(0).max(2),
      })
      .optional(),
  )
  .catch(undefined);

export type KrallenClientData = NonNullable<z.infer<typeof KrallenClientSchema>>;
