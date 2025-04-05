import z from "zod";
import {ChampionStatus, ChampionType} from "../../../../enums/Champions";
import {preprocessChampionData} from "../../../../utils/preprocessChampionData";

/**
 * A champion object containing the important information.
 *
 * For the database schema, use the Array variant `ChampionDataListSchema`
 */
export const ChampionDataSchema = z.object({

  /**
   * A comma separated list of the statuses that the champion has had
   */
  log: z
    .string()
    .optional(),

  /**
   * feed time
   */
  ft: z.number().int()
    .optional(),

  /**
   * Feed count
   */
  fd: z.number().int()
    .optional(),

  /**
   * Champion Level, 1 - 6
   */
  l: z.number().int()
    .min(1).max(6)
    .optional(),

  /**
   * Champion Health
   */
  hp: z.number()
    .optional(),

  /**
   * Champion Name - most probably not being used or set
   */
  nm: z.string()
    .optional(),

  /**
   * Champion Status. Check the Enum for more information.
   */
  status: z.nativeEnum(ChampionStatus)
    .optional(),

  /**
   * Food Bonus level.
   */
  fb: z.number().int()
    .min(0).max(3)
    .optional(),

  /**
   * Champion type. Specifies which champion this is. See enum ChampionType
   */
  t: z.nativeEnum(ChampionType)
    .optional(),

  /**
   * PowerLevel - Used to determine which powers korath (and possibly Krallen) may use
   */
  pl: z.number()
    .optional()
});

/**
 * An array of champions, as it is saved in the database as well as sent and received by the client.
 * The champion data is preprocessed so that we also support JSON string input.
 */
export const ChampionDataListSchema =
  z.preprocess(
    preprocessChampionData,
    z.array(ChampionDataSchema)
      .optional()
      .nullable()
  );

export interface ChampionData extends z.infer<typeof ChampionDataSchema> {
}