import { User } from "../../models/user.model.js";
import { loadFailureErr } from "../../errors/errors.js";
import { logAttackViolation } from "../base/reportManager.js";
import { type MonsterProps, monsterStats } from "../../data/stats/monsterStats.js";
import type { AttackData } from "../../zod/AttackSchema.js";
import { type ChampionProps, championStats } from "../../data/stats/championStats.js";

// TODO:
// Validate monster count from flinger
type StatValue = number[] | string[];

/**
 * Validates the attack data sent by the client.
 * Ensures the structure is intact and all monster/champion stats match server-side definitions.
 * Logs and throws if data is invalid.
 * 
 * @param {User} user - The user initiating the attack.
 * @param {AttackData} attackData - The payload sent from the client for an attack.
 * @throws Will throw an error if the data is missing, malformed, or tampered with.
 */
export const validateAttack = async (user: User, attackData: AttackData) => {
  if (!attackData || Object.keys(attackData).length === 0) {
    const message = "Attack payload was missing. Client modified.";
    await logAttackViolation(user, message);
    throw loadFailureErr();
  }

  if (!attackData.champions || !attackData.monsters) {
    const message = "Attack payload structure changed. Client modified.";
    await logAttackViolation(user, message);
    throw loadFailureErr();
  }

  if (attackData.monsters.length > 0) {
    for (const monster of attackData.monsters) {
      const { id, stats } = monster;

      if (!monsterStats[id]) {
        const message = `Invalid monster ID: ${id}. Client modified.`;
        await logAttackViolation(user, message);
        throw loadFailureErr();
      }

      const monsterProps: MonsterProps = monsterStats[id].props;
      const monsterPropsKeys = Object.keys(monsterProps) as Array<keyof typeof monsterProps>;

      for (const key of monsterPropsKeys) {
        const received = stats[key];
        const expected = monsterProps[key];

        if (!isMonsterStatsEqual(received, expected)) {
          const message = `${id}'s stat '${key}' was modified. Received: ${stats[key]} but expected ${monsterProps[key]}`;
          await logAttackViolation(user, message);
          throw loadFailureErr();
        }
      }
    }
  }

  if (attackData.champions.length > 0) {
    for (const champion of attackData.champions) {
      const { type, stats } = champion;

      if (!championStats[type]) {
        const message = `Invalid champion type: ${type}. Client modified.`;
        await logAttackViolation(user, message);
        throw loadFailureErr();
      }

      const championProps: ChampionProps = championStats[type].props;
      const championPropsKeys = Object.keys(championProps) as Array<keyof typeof championProps>;

      for (const key of championPropsKeys) {
        const received = stats[key];
        const expected = championProps[key];

        if (!isChampionStatsEqual(received, expected)) {
          const message = `${type}'s stat '${key}' was modified. Received: ${stats[key]} but expected ${championProps[key]}`;
          await logAttackViolation(user, message);
          throw loadFailureErr();
        }
      }
    }
  }
};

/**
 * Compares two numeric arrays representing monster stats.
 * All monster stats are represented as arrays of numbers.
 * 
 * @param {number[]} arr1 - First array of numeric stats.
 * @param {number[]} arr2 - Second array of numeric stats.
 * @returns {boolean} - True if arrays are equal within 2 decimal places, otherwise false.
 */
const isMonsterStatsEqual = (arr1: number[], arr2: number[]) => {
  if (!Array.isArray(arr1) || !Array.isArray(arr2) || arr1.length !== arr2.length)
    return false;

  return arr1.every(
    (num, i) => Number(num.toFixed(2)) === Number(arr2[i].toFixed(2))
  );
};


/**
 * Compares champion stat values (number array, or string array) for equality.
 * 
 * @param {StatValue} val1 - First stat value.
 * @param {StatValue} val2 - Second stat value.
 * @returns {boolean} - True if values are considered equal, false otherwise.
 */
const isChampionStatsEqual = (val1: StatValue, val2: StatValue) => {
  if (!Array.isArray(val1) || !Array.isArray(val2) || val1.length !== val2.length) 
    return false;

  const isNumberArray = typeof val1[0] === "number";
  const isStringArray = typeof val1[0] === "string";

  if (isNumberArray) {
    return (val1 as number[]).every(
      (num, i) => Number(num.toFixed(2)) === Number((val2 as number[])[i].toFixed(2))
    );
  }

  if (isStringArray)
    return (val1 as string[]).every((str, i) => str === (val2 as string[])[i]);

  return false;
};
