import { AllianceInviteType } from "../../enums/AllianceInvite.js";
import { Status } from "../../enums/StatusCodes.js";
import { Alliance } from "../../models/alliance.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { RequestJoinSchema } from "../../schemas/AllianceSchemas.js";
import { openInvite } from "../../services/alliance/allianceInvites.js";
import { mustLeaveAllianceErr, permissionErr } from "../../errors/errors.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Asks an alliance to take the authenticated player in, from the Browse tab's
 * Request to Join button. The request lands in the leader's Invites tab as a
 * pending row for them to accept or decline.
 *
 * @param {Context} ctx - Koa context.
 */
export const requestJoin: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { alliance_id } = RequestJoinSchema.parse(ctx.request.body);

  if (user.alliance_id) throw mustLeaveAllianceErr();

  const alliance = await postgres.em.findOne(Alliance, { id: alliance_id });

  if (!alliance) throw permissionErr();

  await openInvite(alliance, user.userid, AllianceInviteType.REQUEST);

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
