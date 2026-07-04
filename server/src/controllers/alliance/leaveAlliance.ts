import { Status } from "../../enums/StatusCodes.js";
import { AllianceRole } from "../../enums/AllianceRole.js";
import { Alliance } from "../../models/alliance.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { removeAllianceMember } from "../../services/alliance/membership.js";
import { leaderMustTransferErr, permissionErr } from "../../errors/errors.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Removes the authenticated user from their alliance. An ordinary member leaves
 * directly; a leader may only leave once no other members remain, otherwise they
 * must transfer leadership first. Clearing membership, resyncing member_count and
 * disbanding an empty alliance are handled by the membership service.
 *
 * @param {Context} ctx - Koa context.
 */
export const leaveAlliance: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  if (!user.alliance_id) throw permissionErr();

  const alliance = await postgres.em.findOne(Alliance, { id: user.alliance_id });
  if (!alliance) throw permissionErr();

  const { id, name } = alliance;

  if (user.alliance_role === AllianceRole.LEADER) {
    const members = await postgres.em.count(User, { alliance_id: id, userid: { $ne: user.userid } });

    if (members > 0) throw leaderMustTransferErr(name);
  }

  await removeAllianceMember(user, alliance);

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
