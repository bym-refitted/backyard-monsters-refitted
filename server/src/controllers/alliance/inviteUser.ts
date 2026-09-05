import { AllianceInviteType } from "../../enums/Alliance.js";
import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { InviteUserSchema } from "../../schemas/AllianceSchemas.js";
import { requireAllianceLeader } from "../../services/alliance/allianceAccess.js";
import { getWorldMapVersion } from "../../services/maproom/knownWorlds.js";
import { openInvite } from "../../services/alliance/allianceInvites.js";
import {
  inviteMapVersionErr,
  permissionErr,
  userAlreadyInAllianceErr,
} from "../../errors/errors.js";
import type { KoaController } from "../../utils/KoaController.js";

const INVITE_FIELDS = ["userid", "username", "alliance_id", "save.worldid"] as const;

/**
 * Invites a player into the leader's alliance, from the Members and Suggested
 * tabs. The invite lands in that player's Invites tab for them to answer.
 *
 * Alliances reach across worlds but not across Map Room versions, so a player on
 * the other version cannot be invited. The original restricted invites to the
 * leader's own world and sector, which assumed players could relocate towards each
 * other; ours cannot choose a world, so the rule is relaxed to match what a player
 * can actually reach by requesting to join.
 *
 * @param {Context} ctx - Koa context.
 */
export const inviteUser: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { userid } = InviteUserSchema.parse(ctx.request.body);

  const alliance = await requireAllianceLeader(user);

  const player = await postgres.em.findOne(User, { userid }, { fields: INVITE_FIELDS });
  if (!player) throw permissionErr();

  if (player.alliance_id) throw userAlreadyInAllianceErr();

  const worldid = player.save?.worldid;
  if (!worldid) throw inviteMapVersionErr(player.username);

  const mapVersion = await getWorldMapVersion(worldid);
  const sameMapVersion = mapVersion === alliance.map_version;

  if (!sameMapVersion) throw inviteMapVersionErr(player.username);

  await openInvite(alliance, player.userid, AllianceInviteType.INVITE);

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
