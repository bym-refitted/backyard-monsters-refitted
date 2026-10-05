import { AllianceInviteType } from "../../enums/Alliance.js";
import { Status } from "../../enums/StatusCodes.js";
import { Alliance } from "../../database/models/alliance.model.js";
import { User } from "../../database/models/user.model.js";
import { postgres } from "../../server.js";
import { RequestJoinSchema } from "../../schemas/AllianceSchemas.js";
import { openInvite } from "../../services/alliance/allianceInvites.js";
import {
  allianceNoWorldErr,
  joinOutsideWorldErr,
  mustLeaveAllianceErr,
  permissionErr,
} from "../../errors/errors.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Asks an alliance to take the authenticated player in, from the Browse tab's
 * Request to Join button. The request lands in the leader's Invites tab as a
 * pending row for them to accept or decline.
 *
 * An alliance belongs to one world, so only players already in that world can ask to
 * join it. The Browse tab still lists alliances from every world on the Map Room
 * version, as the original's did - looking is not joining.
 *
 * @param {Context} ctx - Koa context.
 */
export const requestJoin: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await postgres.em.populate(user, ["save"], { fields: ["save.worldid"] });

  const { alliance_id } = RequestJoinSchema.parse(ctx.request.body);

  if (user.alliance_id) throw mustLeaveAllianceErr();

  const alliance = await postgres.em.findOne(Alliance, { id: alliance_id });
  if (!alliance) throw permissionErr();

  const worldid = user.save?.worldid;
  if (!worldid) throw allianceNoWorldErr();

  if (worldid !== alliance.world_id) throw joinOutsideWorldErr();

  await openInvite(alliance, user.userid, AllianceInviteType.REQUEST);

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
