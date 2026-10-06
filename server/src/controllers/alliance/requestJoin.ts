import { AllianceInviteType } from "../../enums/Alliance.js";
import { Status } from "../../enums/StatusCodes.js";
import { Alliance } from "../../database/models/alliance.model.js";
import { User } from "../../database/models/user.model.js";
import { postgres } from "../../server.js";
import { RequestJoinSchema } from "../../schemas/AllianceSchemas.js";
import { openInvite } from "../../services/alliance/allianceInvites.js";
import { canJoinAlliance } from "../../services/alliance/allianceWorlds.js";
import { MapRoomVersion } from "../../enums/MapRoom.js";
import {
  allianceNoWorldErr,
  joinMapVersionErr,
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
 * A Map Room 2 alliance belongs to one world, so only players already in that world
 * can ask to join it. The Browse tab still lists alliances from every world on the
 * Map Room version, as the original's did - looking is not joining. A Map Room 3
 * alliance reaches across worlds, so any Map Room 3 player can ask.
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

  const joinAlliance = await canJoinAlliance(alliance, worldid);

  if (!joinAlliance) 
    throw alliance.map_version === MapRoomVersion.V3 ? joinMapVersionErr() : joinOutsideWorldErr();

  await openInvite(alliance, user.userid, AllianceInviteType.REQUEST);

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
