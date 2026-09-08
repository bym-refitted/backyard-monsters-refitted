import { AllianceRole } from "../../enums/Alliance.js";
import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../models/user.model.js";
import { ActivatePowerupSchema } from "../../schemas/AllianceSchemas.js";
import { requireAllianceMember } from "../../services/alliance/allianceAccess.js";
import { startPowerup } from "../../services/alliance/powerups.js";
import { powerupLeaderOnlyErr } from "../../errors/errors.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Starts a fully charged power-up, buffing every member of the alliance for its
 * running time.
 *
 * Leader only. Membership is checked before rank so an ordinary member is told
 * whose call it is rather than being refused outright - the original showed them
 * a disabled Activate button carrying the same sentence.
 *
 * @param {Context} ctx - Koa context.
 */
export const activatePowerup: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const alliance = await requireAllianceMember(user);

  if (user.alliance_role !== AllianceRole.LEADER) throw powerupLeaderOnlyErr();

  const { powerup_id } = ActivatePowerupSchema.parse(ctx.request.body);

  const resolved = await startPowerup(alliance.id, powerup_id);

  const powerups = resolved.map(({ rules, status }) => ({
    powerup_id: rules.powerup_id,
    type: rules.type,
    active: status.active,
    endTime: status.end_time,
    hourly_cost: rules.hourly_cost,
    total_running_time: rules.running_time,
    total_recharge_time: rules.recharge_time,
  }));

  ctx.status = Status.OK;
  ctx.body = { error: 0, powerups };
};
