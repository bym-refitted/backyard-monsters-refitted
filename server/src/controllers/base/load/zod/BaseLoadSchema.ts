import z from "zod";
import { AttackPayload } from "../../validateAttack";

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
   * @type {AttackPayload | undefined}
   */
  attackPayload: z
    .string()
    .optional()
    .transform((data): AttackPayload | undefined =>
      data ? JSON.parse(data) : undefined
    ),
});
