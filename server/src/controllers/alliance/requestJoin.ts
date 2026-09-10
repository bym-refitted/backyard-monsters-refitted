import { AllianceInviteType } from "../../enums/Alliance.js";
import { Status } from "../../enums/StatusCodes.js";
import { Alliance } from "../../models/alliance.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { RequestJoinSchema } from "../../schemas/AllianceSchemas.js";
import { getWorldMapVersion } from "../../services/maproom/knownWorlds.js";
import { openInvite } from "../../services/alliance/allianceInvites.js";
import {
  allianceNoWorldErr,
  joinMapVersionErr,
  mustLeaveAllianceErr,
  permissionErr,
} from "../../errors/errors.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Asks an alliance to take the authenticated player in, from the Browse tab's
 * Request to Join button. The request lands in the leader's Invites tab as a
 * pending row for them to accept or decline.
 *
 * Alliances can be joined from any world on the same Map Room version, which is
 * what the Browse tab lists.
 *
 * @param {Context} ctx - Koa context.
 */
export const requestJoin: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await postgres.em.populate(user, ["save"]);

  const { alliance_id } = RequestJoinSchema.parse(ctx.request.body);

  if (user.alliance_id) throw mustLeaveAllianceErr();

  const alliance = await postgres.em.findOne(Alliance, { id: alliance_id });
  if (!alliance) throw permissionErr();

  const worldid = user.save?.worldid;
  if (!worldid) throw allianceNoWorldErr();

  const mapVersion = await getWorldMapVersion(worldid);
  const sameMapVersion = mapVersion === alliance.map_version;

  if (!sameMapVersion) throw joinMapVersionErr();

  await openInvite(alliance, user.userid, AllianceInviteType.REQUEST);

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
