import z from "zod";

/**
 * Schema to validate alliance creation data.
 */
export const CreateAllianceSchema = z.object({
  alliance_name: z.string().trim().min(1).max(30),
  alliance_image: z.coerce.number().int().min(1).max(41),
  alliance_desc: z.string().trim().min(1).max(255),
});

/**
 * Schema to validate alliance edit data.
 */
export const EditAllianceSchema = z.object({
  alliance_image: z.coerce.number().int().min(1).max(41),
  alliance_desc: z.string().trim().min(1).max(255),
});

/**
 * Schema to validate Browse-tab search/pagination params. `world` limits results
 * to the player's own world - the tab's "This World" filter, as opposed to "All".
 */
export const SearchAlliancesSchema = z.object({
  search: z.string().trim().max(30).optional(),
  page: z.coerce.number().int().min(0).catch(0),

  // TODO: this is shit, this is a string because alliance calls use URLLoaderApi.load (form-encoded).
  // Moving them to invokeApiRequest (JSON) would make this a plain z.boolean(), but that
  // first needs invokeApiRequest to route server error bodies to onComplete the way load()
  // does, or the tabs lose their error messages. Change both together - stringbool() rejects
  // a real boolean, so the filter would silently stop working.
  world: z.stringbool().catch(false),
});
