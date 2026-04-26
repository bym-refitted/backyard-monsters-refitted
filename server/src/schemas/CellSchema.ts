import z from "zod";

/**
 * Schema for validating and transforming MR3 cellid's from the client.
 * The client sends data stringified, so we need to convert it back to an array.
 *
 * @type {z.ZodObject}
 */
export const CellSchema = z.object({
  /**
   * The list of cell IDs requested by the client.
   * @type {number[] | undefined}
   */
  cellids: z
    .string()
    .transform((val) => JSON.parse(val) as number[])
    .optional(),
});
