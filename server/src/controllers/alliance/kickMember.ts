import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { MemberActionSchema } from "../../schemas/AllianceSchemas.js";
import { requireAllianceLeader } from "../../services/alliance/allianceAccess.js";
import { removeAllianceMember } from "../../services/alliance/membership.js";
import { cannotKickErr } from "../../errors/errors.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Removes a member from the leader's alliance, from the Members tab.
 *
 * @param {Context} ctx - Koa context.
 */
export const kickMember: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { userid } = MemberActionSchema.parse(ctx.request.body);

  const alliance = await requireAllianceLeader(user);

  if (userid === user.userid) throw cannotKickErr();

  const member = await postgres.em.findOne(User, { userid });

  if (!member || member.alliance_id !== alliance.id) throw cannotKickErr();

  await removeAllianceMember(member, alliance);

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
