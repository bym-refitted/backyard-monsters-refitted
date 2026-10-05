import { AllianceInviteType, AllianceRole } from "../../enums/Alliance.js";
import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../database/models/user.model.js";
import { postgres } from "../../server.js";
import { InviteUserSchema } from "../../schemas/AllianceSchemas.js";
import { requireAllianceMember } from "../../services/alliance/allianceAccess.js";
import { openInvite } from "../../services/alliance/allianceInvites.js";
import {
  inviteLeaderOnlyErr,
  inviteOutsideWorldErr,
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
 * An alliance belongs to one world, so only players in that world can be invited -
 * as in the original, whose refusal pointed the leader at the outpost invitation as
 * the way to bring a distant friend into their world. That is now a feature we have,
 * which is why this is no longer relaxed to the Map Room version.
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

  if (player.save?.worldid !== alliance.world_id) throw inviteOutsideWorldErr(player.username);

  await openInvite(alliance, player.userid, AllianceInviteType.INVITE);

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
