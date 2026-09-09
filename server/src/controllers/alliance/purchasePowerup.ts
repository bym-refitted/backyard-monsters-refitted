import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { PurchasePowerupSchema } from "../../schemas/AllianceSchemas.js";
import { requireAllianceMember } from "../../services/alliance/allianceAccess.js";
import { reducePowerupCharge, type PowerupPurchase } from "../../services/alliance/powerups.js";
import { isShinyLocked } from "../../services/user/shinyLock.js";
import { shinyLockedErr } from "../../errors/errors.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Fields loaded off the paying player's save.
 */
const PAYING_SAVE_FIELDS = ["save.basesaveid", "save.credits"] as const;

/**
 * Spends the caller's Shiny to shorten a power-up's charge for the whole alliance.
 *
 * Any member may do this - the leader-only rule covers activation, not
 * contributing towards it.
 *
 * @param {Context} ctx - Koa context.
 */
export const purchasePowerup: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const alliance = await requireAllianceMember(user);

  const shinyLock = await isShinyLocked(user);
  
  if (shinyLock) throw shinyLockedErr();

  const { powerup_id, purchase_hours } = PurchasePowerupSchema.parse(ctx.request.body);

  await postgres.em.populate(user, ["save"], { fields: PAYING_SAVE_FIELDS });

  const purchase: PowerupPurchase = {
    allianceId: alliance.id,
    userSave: user.save!,
    powerupId: powerup_id,
    hours: purchase_hours,
  };

  const resolved = await reducePowerupCharge(purchase);

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
  ctx.body = { error: 0, powerups, credits: user.save!.credits };
};
