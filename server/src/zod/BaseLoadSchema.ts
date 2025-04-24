import z from "zod";
import { AttackData } from "./AttackSchema";

export const BaseLoadSchema = z.object({
  /**
   * The baseMode type to load.
   * @type {string}
   */
  type: z.string(),

  /**
   * The user ID of the user making the request.
   * @type {string}
   */
  userid: z.string(),

  /**
   * The base ID of the base to load.
   * @type {string}
   */
  baseid: z.string(),

  /**
   * The attack payload, transformed from a JSON string to an AttackPayload object.
   * @type {AttackData | undefined}
   */
  attackData: z
    .string()
    .optional()
    .transform((data): AttackData | undefined =>
      data ? JSON.parse(data) : undefined
    ),
});
