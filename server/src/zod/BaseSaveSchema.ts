import z from "zod";
import { Resources } from "../services/base/updateResources.js";

/**
 * Schema for validating and transforming base save data.
 * The client sends data stringified, or in unexpected ways, so we need to transform it.
 * Add more properties as needed and handle accordingly.
 *
 * @type {z.ZodObject}
 */
export const BaseSaveSchema = z.object({
  /**
   * The baseid of the save.
   * @type {string}
   */
  baseid: z.string(),

  /**
   * The basesaveid of the save, transformed from a string to a number.
   * @type {number}
   */
  basesaveid: z.string().transform((id) => parseInt(id)),

  /**
   * The purchase data, transformed from a JSON string to an array.
   * This property is optional.
   * @type {[string, number] | undefined}
   */
  purchase: z
    .string()
    .optional()
    .transform((data) =>
      data ? (JSON.parse(data) as [string, number]) : undefined
    ),

  /**
   * The champion data, transformed from a JSON string to a stringified JSON object.
   * This property is optional.
   * @type {string | undefined}
   */
  champion: z
    .string()
    .optional()
    .transform((data) => (data ? JSON.stringify(JSON.parse(data)) : null)),

  /**
   * The attacker champion data, transformed from a JSON string.
   * This property is optional.
   * @type {string | undefined}
   */
  attackerchampion: z
    .string()
    .optional()
    .transform((data) => (data ? JSON.stringify(JSON.parse(data)) : undefined)),

  /**
   * The building data, transformed from a JSON string to an object.
   * This property is required.
   * @type {object | undefined}
   */
  buildingdata: z.string().transform((data) => JSON.parse(data)),

  /**
   * The building health data, transformed from a JSON string to an object.
   * This property is optional.
   * @type {object | undefined}
   */
  buildinghealthdata: z
    .string()
    .optional()
    .transform((data) => (data ? JSON.parse(data) : undefined)),

  /**
   * The monster update data, transformed from a JSON string to an array of objects.
   * This field is optional, and if present, the data is parsed from a stringified JSON format.
   * The client always sends it initially as an empty array, so it is expected to be an array of objects.
   * @type {any[] | undefined}
   */
  monsterupdate: z
    .string()
    .optional()
    .transform((data) => (data ? (JSON.parse(data) as any[]) : undefined)),

  /**
   * The attack loot data, transformed from a JSON string to an object.
   * This property is optional.
   * @type {object | undefined}
   */
  attackloot: z
    .string()
    .optional()
    .transform((data) => (data ? (JSON.parse(data) as Resources) : undefined)),

  /**
   * The monsters data, transformed from a JSON string to an object.
   * This property is optional.
   * @type {object | undefined}
   */
  monsters: z
    .string()
    .optional()
    .transform((data) => (data ? JSON.parse(data) : undefined)),

  /**
   * The attack creatures data, transformed from a JSON string to an object.
   * This property is optional.
   * @type {object | undefined}
   */
  attackcreatures: z
    .string()
    .optional()
    .transform((data) => (data ? JSON.parse(data) : undefined)),

  attackersiege: z
    .string()
    .optional()
    .transform((data) => (data ? JSON.parse(data) : undefined)),

  /**
   * The 'over' property, which indicates a state.
   * This property is optional and remains as a string.
   * @type {number | undefined}
   */
  over: z
    .string()
    .optional()
    .transform((data) => parseInt(data, 10)),

  /**
   * The destroyed state, transformed from a string to a number, or undefined.
   * This property is optional.
   * @type {number | undefined}
   */
  destroyed: z
    .string()
    .optional()
    .transform((data) => parseInt(data, 10)),

  /**
   * The attack ID, transformed from a string to a number, or undefined.
   * This property is optional.
   * @type {number | undefined}
   */
  attackid: z.string().optional(),
});
