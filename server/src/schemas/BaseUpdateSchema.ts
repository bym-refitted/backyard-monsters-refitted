import z from "zod";

import type { BaseUpdateEvent } from "../services/base/baseUpdates.js";

const BaseUpdateEventSchema = z.tuple([z.number(), z.string()]).rest(z.unknown());

/**
 * Parses what the client posts to `saveupdate`.
 *
 * `data` arrives as a JSON string holding an array of events, and `help` as a Flash
 * boolean string. Anything that cannot be read - a malformed body, an event that is not
 * shaped like one - is dropped rather than failing the request, since the client fires
 * these alongside play and ignores the outcome.
 */
export const BaseUpdateSchema = z.object({
  baseid: z.coerce.string(),
  help: z.coerce.string().transform((value) => value === "true"),
  data: z
    .string()
    .transform((value) => {
      try {
        const parsed = JSON.parse(value);

        if (!Array.isArray(parsed)) return [];

        return parsed.flatMap((event) => {
          const result = BaseUpdateEventSchema.safeParse(event);

          return result.success ? [result.data as BaseUpdateEvent] : [];
        });
      } catch {
        return [];
      }
    })
    .catch([]),
});
