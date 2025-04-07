import z from "zod";

/**
 * Schema for validating and transforming send message data.
 * The client sends data stringified, or in unexpected ways, so we need to transform it.
 * Add more properties as needed and handle accordingly.
 *
 * @type {z.ZodObject}
 */
export const SendMessageSchema = z.object({
    /**
     * The subject of the message, set when compose first thread
     * @type {string}
     */
    subject: z.string(),

    /**
     * The message type, possible value between message,trucerequest,truceaccept,trucereject,migraterequest
     * @type {string}
     */
    type: z.string(),

    /**
     * the content of the message
     */
    message: z.string().max(580).min(1),

    /**
     * userid of the recipient of the message
     * @type {number}
     */
    targetid: z.string().transform((id) => parseInt(id)),

    /**
     * the id of the thread
     * @type {number}
     */
    threadid: z.string().transform((id) => parseInt(id)),

    /**
     * The baseid of the reciepent for migraterequest.
     * @type {string}
     */
    targetbaseid: z.string(),

    /**
     * The baseid for migraterequest.
     * @type {string}
     */
    baseid: z.string().optional()
});
