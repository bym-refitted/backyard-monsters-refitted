import z from "zod";
import { parseJsonSafely } from "../utils/parseJsonSafely.js";

/**
 * The running loot total of an attack, which the attacking client reports on every save
 * of the attack (BASE.getLootReportSaveData). Unlike attackloot it is the loot taken,
 * before anything the attacker spent during the attack.
 */
export const LootReportSchema = z
  .string()
  .optional()
  .transform(parseJsonSafely)
  .pipe(
    z
      .object({
        r1: z.coerce.number().min(0).catch(0),
        r2: z.coerce.number().min(0).catch(0),
        r3: z.coerce.number().min(0).catch(0),
        r4: z.coerce.number().min(0).catch(0),
        isInferno: z.boolean().catch(false),
      })
      .optional(),
  )
  .catch(undefined);

export type LootReport = NonNullable<z.infer<typeof LootReportSchema>>;
