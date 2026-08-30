import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../models/user.model.js";
import { requireAllianceLeader } from "../../services/alliance/allianceAccess.js";
import { getSuggestedMembers } from "../../services/alliance/suggestedMembers.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Returns players the leader could recruit, for the Suggested tab.
 *
 * Leader-only, as it was in the original - the tab is only rendered for whoever can
 * actually send an invite.
 *
 * @param {Context} ctx - Koa context.
 */
export const suggestedMembers: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const alliance = await requireAllianceLeader(user);

  const members = await getSuggestedMembers(alliance);

  ctx.status = Status.OK;
  ctx.body = { error: 0, members };
};
