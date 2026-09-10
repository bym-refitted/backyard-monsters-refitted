import { Status } from "../../enums/StatusCodes.js";
import { AllianceMessageType, AllianceRole } from "../../enums/Alliance.js";
import { User } from "../../models/user.model.js";
import { requireAllianceMember } from "../../services/alliance/allianceAccess.js";
import { countOtherMembers, removeAllianceMember } from "../../services/alliance/membership.js";
import { leaderMustTransferErr } from "../../errors/errors.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Removes the authenticated user from their alliance. An ordinary member leaves
 * directly; a leader may only leave once no other members remain, otherwise they
 * must transfer leadership first. Clearing membership and disbanding an empty
 * alliance are handled by the membership service.
 *
 * @param {Context} ctx - Koa context.
 */
export const leaveAlliance: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const alliance = await requireAllianceMember(user);

  const otherMembers = await countOtherMembers(user, alliance.id);

  if (user.alliance_role === AllianceRole.LEADER && otherMembers > 0) {
    throw leaderMustTransferErr(alliance.name);
  }

  await removeAllianceMember(user, alliance, AllianceMessageType.LEFT, otherMembers);

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
