import z from "zod";
import {ChampionStatus, ChampionType} from "../../../../enums/Champions";

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
    ft: z.number(),

    /**
     * Feed count
     */
    fd: z.number().int(),

    /**
     * Champion Level, 1 - 6
     */
    l: z.number().int()
        .min(1).max(6),

    /**
     * Champion Health
     */
    hp: z.number(),

    /**
     * Champion Name - most probably not being used or set
     */
    nm: z.string().optional(),

    /**
     * Champion Status. Check the Enum for more information.
     */
    status: z.nativeEnum(ChampionStatus),

    /**
     * Food Bonus level.
     */
    fb: z.number().int()
        .min(0).max(3)
        .optional(),

    /**
     * Champion type. Specifies which champion this is. See enum ChampionType
     */
    t: z.nativeEnum(ChampionType),

    // PowerLevel - Used to determine which powers korath may use
    pl: z.number()
});

/**
 * An array of champions, as it is saved in the database as well as sent and received by the client.
 */
export const ChampionDataListSchema = z.array(ChampionDataSchema);

export interface ChampionData extends z.infer<typeof ChampionDataSchema> {}