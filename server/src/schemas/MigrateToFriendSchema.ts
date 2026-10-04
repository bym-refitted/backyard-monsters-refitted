import z from "zod";

export const MigrateToFriendSchema = z.object({
  /**
   * The base ID of the outpost being moved onto.
   * @type {string}
   */
  baseid: z.string(),

  /**
   * The mailbox thread the invitation was sent on, transformed from a string to a number.
   * @type {number}
   */
  threadid: z.coerce.number().int().positive(),

  /**
   * The resources the client quoted for the move, transformed from a JSON string to an
   * object. Only its presence is read, since the server charges its own cost.
   * @type {object | undefined}
   */
  resources: z
    .string()
    .transform((res) => JSON.parse(res))
    .optional(),

  /**
   * The amount of shiny the client quoted instead of resources, transformed from a string
   * to a number. Only its presence is read, since the server charges its own cost.
   * @type {number | undefined}
   */
  shiny: z.coerce.number().int().positive().optional(),
});
