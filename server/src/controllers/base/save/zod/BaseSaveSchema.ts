import z from "zod";
import { Resources } from "../../../../services/base/updateResources";

type Monster = {
  health: number;
  ownerID: number;
  q: number;
};

/**
 * Schema for validating and transforming base save data.
 * The client sends data stringified, or in unexpected ways, so we need to transform it.
 * Add more properties as needed and handle accordingly.
 *
 * @type {z.ZodObject}
 */
export const BaseSaveSchema = z.object({
  /**
   * The ID of the base save, transformed from a string to a number.
   * @type {number}
   */
  basesaveid: z.string().transform((id) => parseInt(id, 10)),

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
    .transform((data) => (data ? JSON.stringify(JSON.parse(data)) : undefined)),

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
   * The attacker champion data, transformed from a JSON string.
   * This property is optional.
   * @type {string | undefined}
   */
  attackerchampion: z
    .string()
    .optional()
    .transform((data) => (data ? JSON.stringify(JSON.parse(data)) : undefined)),

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
   * The 'over' property, which indicates a state.
   * This property is optional and remains as a string.
   * @type {number | undefined}
   */
  over: z
    .string()
    .optional()
    .transform((over) => parseInt(over, 10)),

  /**
   * The destroyed state, transformed from a string to a number, or undefined.
   * This property is optional.
   * @type {number | undefined}
   */
  destroyed: z
    .string()
    .optional()
    .transform((des) => parseInt(des, 10)),

  /**
   * The monsterupdate data, transformed from a JSON string.
   *
   * - If the client sends an empty array (i.e., `"[]"`), it will return an empty array `[]`.
   * - If the client sends a valid JSON string representing a record (object),
   *   it will be cast to `Record<string, Monster[]>`.
   * - If no data is provided, it will return `undefined`.
   *
   * This field is optional and must be a string when sent by the client.
   * I hate this so much, but the client is miserable.
   * @type {Record<string, Monster[]> | [] | undefined}
   */
  monsterupdate: z
    .string()
    .optional()
    .transform((data) => {
      if (!data) return undefined;
      const parsedData = JSON.parse(data);
      return Array.isArray(parsedData) && parsedData.length === 0
        ? []
        : (parsedData as Record<string, Monster[]>);
    }),
});
