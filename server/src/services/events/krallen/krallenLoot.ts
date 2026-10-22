import type z from "zod";

import { Save } from "../../../database/models/save.model.js";
import { BaseSaveSchema } from "../../../schemas/BaseSaveSchema.js";
import type { KrallenStoredData } from "../../../schemas/KrallenSchema.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import { getCurrentRound, isKrallenEligible } from "./krallenRound.js";

type BaseSaveData = z.infer<typeof BaseSaveSchema>;

type KrallenAttackSave = Pick<BaseSaveData, "lootreport" | "attackid">;

/**
 * Adds the loot from an attack save to the attacker's Hunt for Krallen round.
 *
 * The client reports the attack's running loot total on every save of the attack, so
 * only the part not counted on an earlier save of the same attack is added. Inferno
 * loot doesn't count.
 *
 * @param {Save} save - The attacker's main yard
 * @param {KrallenAttackSave} attack - The attack's running loot total and attack id
 * @param {number} now - The current time, in seconds
 */
export const addKrallenLoot = (save: Save, attack: KrallenAttackSave, now = getCurrentDateTime()) => {
  const { lootreport: report, attackid: attackId } = attack;

  if (!report || !attackId || report.isInferno) return;

  const canTakePart = isKrallenEligible(save);

  if (!canTakePart) return;

  const round = getCurrentRound(save, now);
  const attackTotal = report.r1 + report.r2 + report.r3 + report.r4;

  const isSameAttack = attackId === round.attackId;
  const alreadyCounted = isSameAttack ? round.attackLoot : 0;

  if (attackTotal <= alreadyCounted) return;

  const updatedRound: KrallenStoredData = {
    ...round,
    loot: round.loot + attackTotal - alreadyCounted,
    attackId,
    attackLoot: attackTotal,
  };

  save.krallen = updatedRound;
};
