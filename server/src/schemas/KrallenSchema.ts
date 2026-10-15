import z from "zod";
import { parseJsonSafely } from "../utils/parseJsonSafely.js";

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

export type KrallenData = z.infer<typeof KrallenSchema>;

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
