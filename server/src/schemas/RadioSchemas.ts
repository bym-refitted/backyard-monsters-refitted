import z from "zod";

/**
 * Schema to validate the query string of a Radio Tower unsubscribe link.
 * - u is the player's user id.
 * - t is the signed token for that player.
 */
export const UnsubscribeSchema = z.object({
  u: z.coerce.number().int().positive(),
  t: z.string().min(1),
});
