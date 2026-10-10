import z from "zod";

/**
 * Schema for a replayable event call, which names the event by the id the client knows it by.
 */
export const EventIdSchema = z.object({
  eventid: z.coerce.number().int().positive(),
});

/**
 * Schema for a score update, which carries the points gained since the last one.
 */
export const UpdateEventScoreSchema = EventIdSchema.extend({
  delta: z.coerce.number().int().positive(),
});
