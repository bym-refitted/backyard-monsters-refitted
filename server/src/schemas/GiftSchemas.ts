import z from "zod";

/**
 * Gift ids the client reports in a save: the sacks it collected, and the accepted
 * gifts it has shown the sender. Sent as a JSON array of numbers.
 */
export const GiftIdsSchema = z
  .string()
  .optional()
  .transform((data) => {
    if (!data) return [];

    try {
      const parsed = JSON.parse(data);

      if (!Array.isArray(parsed)) return [];

      return parsed.map(Number).filter((id) => Number.isInteger(id) && id > 0);
    } catch (_) {
      return [];
    }
  });

/**
 * Schema for sending a gift, which names the friend receiving it.
 */
export const SendGiftSchema = z.object({
  userid: z.coerce.number().int().positive(),
});
