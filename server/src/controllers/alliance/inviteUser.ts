import { AllianceInviteType, AllianceRole } from "../../enums/Alliance.js";
import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { InviteUserSchema } from "../../schemas/AllianceSchemas.js";
import { requireAllianceMember } from "../../services/alliance/allianceAccess.js";
import { getWorldMapVersion } from "../../services/maproom/knownWorlds.js";
import { openInvite } from "../../services/alliance/allianceInvites.js";
import {
  inviteLeaderOnlyErr,
  inviteMapVersionErr,
  permissionErr,
  userAlreadyInAllianceErr,
} from "../../errors/errors.js";
import type { KoaController } from "../../utils/KoaController.js";

const INVITE_FIELDS = ["userid", "username", "alliance_id", "save.worldid"] as const;

/**
 * Invites a player into the leader's alliance, from the Suggested tab or the map
 * room popup. The invite lands in that player's Invites tab for them to answer.
 *
 * Membership is checked before rank so an ordinary member is told the invitation
 * is the leader's to send rather than being refused outright. The original's map
 * room enabled the button for every member, so members do reach here.
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

  const alliance = await requireAllianceMember(user);

  // Not confirmed: The original's map room enabled the button for every member, so members do reach here,
  // so not sure yet if this was a leader-only action.
  if (user.alliance_role !== AllianceRole.LEADER) throw inviteLeaderOnlyErr();

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
