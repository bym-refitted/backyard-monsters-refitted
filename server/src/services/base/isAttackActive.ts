import type { Loaded } from "@mikro-orm/core";
import type { Save } from "../../database/models/save.model.js";
import { getCurrentDateTime } from "../../utils/getCurrentDateTime.js";

type AttackState = Loaded<Save, never, "attackid" | "attacks">;

/**
 * Maximum duration an attack can be considered active (7 minutes).
 * If attackid is non-zero but the attack started longer ago than this,
 * the attackid is treated as stale (e.g. attacker disconnected mid-attack).
 */
export const ATTACK_TIMEOUT = 7 * 60;

/**
 * Determines whether a save is currently under an active attack.
 *
 * An attack is considered active if attackid is non-zero and the last
 * attack started within ATTACK_TIMEOUT seconds. A non-zero attackid
 * outside this window is treated as stale — typically left over from
 * an attacker who disconnected mid-attack.
 *
 * @param {AttackState} save - The save to check
 * @returns {boolean} True if the save is currently under an active attack
 */
export const isAttackActive = (save: AttackState) => {
  if (save.attackid === 0) return false;

  const lastAttack = save.attacks.at(-1);
  
  if (!lastAttack) return false;

  return (getCurrentDateTime() - lastAttack.starttime) < ATTACK_TIMEOUT;
};
