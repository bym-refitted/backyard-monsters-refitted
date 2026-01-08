import z from "zod";
import { BaseType } from "../enums/Base";

/**
 * Request schema for migrate base.
 *
 * @type {z.ZodObject}
 */
export const MigrateBaseSchema = z.object({
  /**
   * The baseMode type sent by the client.
   * @type {string}
   */
  type: z.nativeEnum(BaseType),

  /**
   * The base ID of the base which is migration.
   * @type {string}
   */
  baseid: z.string(),

  /**
   * The resources to be used for the migration, transformed from a JSON string to an object.
   * @type {object | undefined}
   */
  resources: z
    .string()
    .transform((res) => JSON.parse(res))
    .optional(),

  /**
   * The amount of shiny to be used for the migration, transformed from a string to a number.
   * @type {number | undefined}
   */
  shiny: z
    .string()
    .transform((shiny) => parseInt(shiny))
    .optional(),
});
