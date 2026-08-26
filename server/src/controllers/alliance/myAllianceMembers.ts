import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../models/user.model.js";
import { requireAllianceMember } from "../../services/alliance/allianceAccess.js";
import { getAllianceMembers } from "../../services/alliance/allianceMembers.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Returns a list of alliance members associated with the authenticated user's alliance for the Members tab.
 *
 * @param {Context} ctx - Koa context.
 */
export const myAllianceMembers: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const alliance = await requireAllianceMember(user);

  const members = await getAllianceMembers(alliance.id);

  ctx.status = Status.OK;
  ctx.body = { error: 0, members };
};
