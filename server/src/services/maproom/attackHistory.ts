import { NeighbourAttack, type NeighbourAttackType } from "../../database/models/neighbourattack.model.js";
import { postgres } from "../../server.js";
import type { NeighbourData } from "../../types/NeighbourData.js";
import { AttackPermission } from "../../enums/MapRoom.js";
import { ATTACK_LIMIT_EXCLUSION_DAYS, DAILY_ATTACK_LIMIT, REVENGE_WINDOW_DAYS } from "../../config/NeighbourConfig.js";

/**
 * Records one attack. The only writer of attack history between neighbours.
 *
 * It also keeps the count of retaliations a player is owed. Attacking someone
 * far above your level hands them one against you. Attacking in vengeance
 * spends one of your own. Any other attack leaves them as they are, so what a
 * pair did to each other while they were close in level never counts.
 *
 * @param {number} attackerId - The player attacking
 * @param {number} defenderId - The player being attacked
 * @param {NeighbourAttackType} type - Which yard the attack is on
 * @param {AttackPermission} permission - What the attacker's level allowed when the attack began
 */
export const recordAttack = async (attackerId: number, defenderId: number, type: NeighbourAttackType, permission: AttackPermission) => {
  const pair = { type, attacker_id: attackerId, defender_id: defenderId };

  let neighbourAttack = await postgres.em.findOne(NeighbourAttack, pair);

  if (!neighbourAttack) neighbourAttack = postgres.em.create(NeighbourAttack, pair);

  const todayStart = new Date();
  todayStart.setHours(0, 0, 0, 0);

  const isFirstToday = neighbourAttack.last_attack_at < todayStart;

  neighbourAttack.attacks += 1;
  neighbourAttack.attacks_today = isFirstToday ? 1 : neighbourAttack.attacks_today + 1;
  neighbourAttack.last_attack_at = new Date();

  if (permission === AttackPermission.HIGHER_LEVEL) {
    neighbourAttack.retaliations_owed += 1;
  }

  if (permission === AttackPermission.VENGEANCE_MODE) {
    const where = { type, attacker_id: defenderId, defender_id: attackerId };
    const incomingAttack = await postgres.em.findOne(NeighbourAttack, where);

    if (incomingAttack) {
      incomingAttack.retaliations_owed = Math.max(0, incomingAttack.retaliations_owed - 1);
    }
  }

  postgres.em.persist(neighbourAttack);
  await postgres.em.flush();
};

/**
 * How many times a player may still hit back at another, who attacked them
 * from too far below for them to attack otherwise.
 *
 * @param {number} userId - The player who was attacked
 * @param {number} otherId - The player who attacked them
 * @param {NeighbourAttackType} type - Which yard the attacks were on
 * @returns {Promise<number>} Retaliations left, zero when there are none
 */
export const getRetaliationsOwed = async (userId: number, otherId: number, type: NeighbourAttackType) => {
  const where = { type, attacker_id: otherId, defender_id: userId };
  const incomingAttack = await postgres.em.findOne(NeighbourAttack, where, { fields: ["retaliations_owed"] });

  if (!incomingAttack) return 0;

  return incomingAttack.retaliations_owed;
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
 * along with how many retaliations the reader is owed against each neighbour,
 * and drops any neighbour the daily attack limit was reached with in the last
 * two weeks, in either direction. attacks_today keeps the count from the day
 * of the last attack, so it stays at the limit until the attacker strikes again.
 *
 * @param {number} userId - The player reading the list
 * @param {NeighbourData[]} neighbours - The list, untouched
 * @param {NeighbourAttackType} type - Which yard the list is for
 * @returns {Promise<NeighbourData[]>} The list with attacksto, attacksfrom and retaliatecount filled in
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
  const retaliations = new Map<number, number>();
  const excluded = new Set<number>();

  for (const { attacker_id, defender_id, attacks, attacks_today, last_attack_at, retaliations_owed } of neighbourAttacks) {
    const isAttacker = attacker_id === userId;
    const neighbourId = isAttacker ? defender_id : attacker_id;

    if (isAttacker) {
      attacksTo.set(neighbourId, attacks);
    } else {
      attacksFrom.set(neighbourId, attacks);
      retaliations.set(neighbourId, retaliations_owed);
    }

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
      retaliatecount: retaliations.get(neighbour.userid) ?? 0,
    }));
};
