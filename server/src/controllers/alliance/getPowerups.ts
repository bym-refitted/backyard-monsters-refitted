import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../models/user.model.js";
import { requireAllianceMember } from "../../services/alliance/allianceAccess.js";
import { alliancePowerup } from "../../services/alliance/powerups.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Returns the caller's alliance power-ups for the Power-Ups tab, which calls this
 * each time it is opened and again when a run ends.
 *
 * Reading is also what advances a finished run back into charging, since there is
 * no scheduler - see resolvePowerups.
 *
 * The rows drop the original's `image`, `name`, `description` and `headerImage`
 * language keys. Those were a Flash-era indirection through
 * `alliances.userData.strings`; our client derives all four from `type`, and our
 * language file has no icon-path keys to resolve them against.
 *
 * @param {Context} ctx - Koa context.
 */
export const getPowerups: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const alliance = await requireAllianceMember(user);

  const resolved = await alliancePowerup(alliance.id);

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
