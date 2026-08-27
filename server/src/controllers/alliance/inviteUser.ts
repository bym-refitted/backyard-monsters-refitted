import { AllianceInviteType } from "../../enums/AllianceInvite.js";
import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { InviteUserSchema } from "../../schemas/AllianceSchemas.js";
import { requireAllianceLeader } from "../../services/alliance/allianceAccess.js";
import { openInvite } from "../../services/alliance/allianceInvites.js";
import {
  cannotInviteOutsideWorldErr,
  permissionErr,
  userAlreadyInAllianceErr,
} from "../../errors/errors.js";
import type { KoaController } from "../../utils/KoaController.js";

const INVITE_FIELDS = ["userid", "username", "alliance_id", "save.worldid"] as const;

/**
 * Invites a player into the leader's alliance, from the Members and Suggested
 * tabs. The invite lands in that player's Invites tab for them to answer.
 *
 * Alliances are bound to a world, so a player elsewhere on the map cannot be
 * invited - the original told the leader to have them relocate instead.
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

  if (player.save?.worldid !== alliance.world_id)
    throw cannotInviteOutsideWorldErr(player.username);

  await openInvite(alliance, player.userid, AllianceInviteType.INVITE);

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
