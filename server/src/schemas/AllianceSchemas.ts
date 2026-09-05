import z from "zod";

import { AllianceInviteStatus } from "../enums/AllianceInvite.js";
import { AllianceStance } from "../enums/AllianceStance.js";

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

/**
 * Schema for the Browse tab's Request to Join button.
 */
export const RequestJoinSchema = z.object({
  alliance_id: z.coerce.number().int().positive(),
});

/**
 * Schema for the Members and Suggested tabs' Invite button.
 */
export const InviteUserSchema = z.object({
  userid: z.coerce.number().int().positive(),
});

/**
 * Schema for the Members tab's leader-only Kick and Promote buttons.
 */
export const MemberActionSchema = z.object({
  userid: z.coerce.number().int().positive(),
});

/**
 * Schema for answering a pending invite or request. The original sent only
 * "accepted" or "declined" here - pending is not a status a player may set.
 */
export const ChangeInviteStatusSchema = z.object({
  invite_id: z.coerce.number().int().positive(),
  status: z.enum([AllianceInviteStatus.ACCEPTED, AllianceInviteStatus.DECLINED]),
});

/**
 * Schema for the Invites tab's Delete button, which posts the checked rows as a
 * comma-separated list of ids.
 */
export const DeleteMessagesSchema = z.object({
  invite_ids: z
    .string()
    .transform((ids) => ids.split(",").map(Number))
    .pipe(z.array(z.number().int().positive()).max(100)),
});

/**
 * Schema for the Browse tab's leader-only Foe / Neutral / Ally buttons.
 */
export const ChangeRelationshipSchema = z.object({
  target_alliance_id: z.coerce.number().int().positive(),
  relationship: z.coerce.number().int().pipe(z.enum(AllianceStance)),
});
