import z from "zod";

/**
 * A single champion as the Flash client serialises it.
 */
export const ChampionSchema = z.object({
  t: z.number().int().min(1).max(5),                                  // champion type
  hp: z.number().catch(0).transform((hp) => Math.max(0, hp)),         // health points
  l: z.number().catch(0),                                             // evolution level
  ft: z.number().catch(0),                                            // feed time
  fd: z.number().catch(0),                                            // feed count
  fb: z.number().catch(0),                                            // food bonus level
  pl: z.number().catch(0),                                            // power level
  status: z.number().catch(0),                                        // 0 = active, 1 = frozen, 2 = juiced
  nm: z.string().optional().catch(undefined),                          // name
});

export type ChampionData = z.infer<typeof ChampionSchema>;

/**
 * Reads the stringified champion payload without throwing, so a malformed
 * field can never take the entire base save down with it.
 *
 * @param {string | undefined} data - The raw value sent by the client
 * @returns {unknown} The parsed payload, or undefined if it was unreadable
 */
const parseChampionJson = (data: string | undefined): unknown => {
  if (!data) return undefined;

  try {
    return JSON.parse(data);
    
  } catch (_) {
    return undefined;
  }
};

const ChampionEntrySchema = ChampionSchema.nullable().catch(null);

/**
 * Parses the stringified champion list sent by the client, dropping anything
 * unusable instead of rejecting it; champion data rides along on every base
 * save, so a throw here would cost the player the whole save.
 *
 * Resolves to undefined rather than an empty array when nothing usable is left.
 * Callers read that as "nothing was sent" and leave stored champions alone; an
 * empty array is truthy and would wipe them.
 */
export const ChampionListSchema = z
  .string()
  .optional()
  .transform(parseChampionJson)
  .pipe(
    z.array(ChampionEntrySchema).transform((entries) => {
      const champions = entries.filter((entry) => entry !== null);

      return champions.length > 0 ? champions : undefined;
    })
)
  .catch(undefined);
