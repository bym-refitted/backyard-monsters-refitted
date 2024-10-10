import z from "zod";

/**
 * Schema for validating and transforming base save data.
 * The client sends data stringified, or in unexpected ways, so we need to transform it. 
 * Add more properties as needed and handle accordingly.
 * 
 * @type {z.ZodObject}
 */
export const BaseSaveSchema = z.object({
  /**
   * The ID of the base save, transformed from a string to an integer.
   * @type {number}
   */
  basesaveid: z.string().transform((id) => parseInt(id, 10)),

  /**
   * The champion data, transformed from a JSON string to a stringified JSON object.
   * @type {string}
   */
  champion: z.string().transform((data) => JSON.stringify(JSON.parse(data))),

  /**
   * The building health data, optionally transformed from a JSON string to an object.
   * @type {object | undefined}
   */
  buildinghealthdata: z
    .string()
    .optional()
    .transform((data) => (data ? JSON.parse(data) : undefined)),
});