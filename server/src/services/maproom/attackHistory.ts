import { NeighbourAttack, type NeighbourAttackType } from "../../database/models/neighbourattack.model.js";
import { postgres } from "../../server.js";
import type { NeighbourData } from "../../types/NeighbourData.js";
import { ATTACK_LIMIT_EXCLUSION_DAYS, DAILY_ATTACK_LIMIT, REVENGE_WINDOW_DAYS } from "../../config/NeighbourConfig.js";

/**
 * Records one attack. The only writer of attack history between neighbours.
 *
 * @param {number} attackerId - The player attacking
 * @param {number} defenderId - The player being attacked
 * @param {NeighbourAttackType} type - Which yard the attack is on
 */
export const recordAttack = async (attackerId: number, defenderId: number, type: NeighbourAttackType) => {
  const pair = { type, attacker_id: attackerId, defender_id: defenderId };

  let neighbourAttack = await postgres.em.findOne(NeighbourAttack, pair);

  if (!neighbourAttack) neighbourAttack = postgres.em.create(NeighbourAttack, pair);

  const todayStart = new Date();
  todayStart.setHours(0, 0, 0, 0);

  const isFirstToday = neighbourAttack.last_attack_at < todayStart;

  neighbourAttack.attacks += 1;
  neighbourAttack.attacks_today = isFirstToday ? 1 : neighbourAttack.attacks_today + 1;
  neighbourAttack.last_attack_at = new Date();

  postgres.em.persist(neighbourAttack);
  await postgres.em.flush();
};

/**
 * The players someone has attacked, or been attacked by, recently enough that
 * a retaliation is still owed one way or the other.
 *
 * @param {number} userId - The player
 * @param {NeighbourAttackType} type - Which yard the attacks were on
 * @returns {Promise<Set<number>>} The other players' user ids
 */
export const getRecentOpponentIds = async (userId: number, type: NeighbourAttackType): Promise<Set<number>> => {
  const cutoff = new Date(Date.now() - REVENGE_WINDOW_DAYS * 24 * 60 * 60 * 1000);

  const where = { 
    type, 
    last_attack_at: { $gte: cutoff }, 
    $or: [{ attacker_id: userId }, { defender_id: userId }] 
  };

  const neighbourAttacks = await postgres.em.find(NeighbourAttack, where, { fields: ["attacker_id", "defender_id"] });

  return new Set(
    neighbourAttacks.map(({ attacker_id, defender_id }) => (attacker_id === userId ? defender_id : attacker_id))
  );
};

/**
 * Sets the attack counts on a neighbour list from the reader's point of view,
 * and drops any neighbour the daily attack limit was reached with in the last
 * two weeks, in either direction. attacks_today keeps the count from the day
 * of the last attack, so it stays at the limit until the attacker strikes again.
 *
 * @param {number} userId - The player reading the list
 * @param {NeighbourData[]} neighbours - The list, untouched
 * @param {NeighbourAttackType} type - Which yard the list is for
 * @returns {Promise<NeighbourData[]>} The list with attacksto and attacksfrom filled in
 */
export const applyAttackHistory = async (userId: number, neighbours: NeighbourData[], type: NeighbourAttackType): Promise<NeighbourData[]> => {
  if (!neighbours.length) return neighbours;

  const neighbourIds = neighbours.map((neighbour) => neighbour.userid);

  const neighbourAttacks = await postgres.em.find(NeighbourAttack, {
    type,
    $or: [
      { attacker_id: userId, defender_id: { $in: neighbourIds } },
      { defender_id: userId, attacker_id: { $in: neighbourIds } },
    ],
  });

  const exclusionStart = new Date(Date.now() - ATTACK_LIMIT_EXCLUSION_DAYS * 24 * 60 * 60 * 1000);

  const attacksTo = new Map<number, number>();
  const attacksFrom = new Map<number, number>();
  const excluded = new Set<number>();

  for (const { attacker_id, defender_id, attacks, attacks_today, last_attack_at } of neighbourAttacks) {
    const isAttacker = attacker_id === userId;
    const neighbourId = isAttacker ? defender_id : attacker_id;

    if (isAttacker) attacksTo.set(neighbourId, attacks);
    else attacksFrom.set(neighbourId, attacks);

    if (attacks_today >= DAILY_ATTACK_LIMIT && last_attack_at >= exclusionStart) {
      excluded.add(neighbourId);
    }
  }

  return neighbours
    .filter((neighbour) => !excluded.has(neighbour.userid))
    .map((neighbour) => ({
      ...neighbour,
      attacksto: attacksTo.get(neighbour.userid) ?? 0,
      attacksfrom: attacksFrom.get(neighbour.userid) ?? 0,
    }));
};
