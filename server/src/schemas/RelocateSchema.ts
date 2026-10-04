import z from "zod";

/**
 * Schema for relocating a main yard in Map Room 3. The friend's id is present when the
 * player picked someone to move next to, and absent when they asked for a random spot.
 *
 * It is coerced because the id arrives in a form body, which sends it as a string.
 */
export const RelocateSchema = z.object({
  userid: z.coerce.number().int().positive().optional(),
});
