import z from "zod";

export const TakeoverCellSchema = z.object({
  /**
   * The base ID of the base to takeover.
   * @type {string}
   */
  baseid: z.string(),

  /**
   * The resources to be used for the takeover, transformed from a JSON string to an object.
   * @type {object | undefined}
   */
  resources: z
    .string()
    .transform((res) => JSON.parse(res))
    .optional(),

  /**
   * The amount of shiny to be used for the takeover, transformed from a string to a number.
   * @type {number | undefined}
   */
  shiny: z
    .string()
    .transform((shiny) => parseInt(shiny))
    .optional(),
});
