import { Status } from "../../enums/StatusCodes.js";
import { Alliance } from "../../models/alliance.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { ChangeRelationshipSchema } from "../../schemas/AllianceSchemas.js";
import { requireAllianceLeader } from "../../services/alliance/allianceAccess.js";
import { setAllianceRelationship } from "../../services/alliance/relationships.js";
import { cannotChangeRelationshipErr } from "../../errors/errors.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Flags another alliance as Foe, Neutral or Ally, from the Browse tab.
 *
 * The flag is one-directional and private: it changes only how the leader's own
 * alliance sees the target, and the target is never told. It is advisory - the
 * client warns before attacking an ally rather than preventing it - so nothing
 * here restricts what either alliance may do.
 *
 * @param {Context} ctx - Koa context.
 */
export const changeRelationship: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { target_alliance_id, relationship } = ChangeRelationshipSchema.parse(ctx.request.body);

  const alliance = await requireAllianceLeader(user);

  if (target_alliance_id === alliance.id) throw cannotChangeRelationshipErr();

  const target = await postgres.em.findOne(Alliance, { id: target_alliance_id });
  if (!target) throw cannotChangeRelationshipErr();

  const mapVersionMismatch = target.map_version !== alliance.map_version;
  
  if (mapVersionMismatch) throw cannotChangeRelationshipErr();

  await setAllianceRelationship(user, alliance, target, relationship);

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
