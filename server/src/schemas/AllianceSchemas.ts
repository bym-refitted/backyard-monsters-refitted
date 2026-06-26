import z from "zod";

/**
 * Schema to validate alliance creation data.
 */
export const CreateAllianceSchema = z.object({
  alliance_name: z.string().trim().min(1).max(30),
  alliance_image: z.coerce.number().int().min(1).max(41),
  alliance_desc: z.string().trim().max(255).optional().default(""),
});
