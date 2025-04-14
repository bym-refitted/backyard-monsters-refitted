import z from "zod";

/**
 * Schema for validating request body of getmessage
 *
 * @type {z.ZodObject}
 */
export const GetMessageSchema = z.object({
  /**
   * the id of the thread
   * @type {number}
   */
  threadid: z.string().transform((id) => parseInt(id)),
});
