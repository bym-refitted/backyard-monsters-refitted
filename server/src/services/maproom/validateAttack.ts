import { User } from "../../models/user.model";
import { loadFailureErr } from "../../errors/errors";
import { logBanReport, logReport } from "../base/reportManager";
import { MonsterProps, monsterStats } from "../../data/monsterStats";
import { AttackData } from "../../zod/AttackSchema";

// TODO:
// 1. Validate  counts from flinger
// 2. Validate champion with `championStats.ts`
export const validateAttack = async (user: User, attackData: AttackData) => {
  const { champion } = user.save;

  if (!attackData || Object.keys(attackData).length === 0) {
    const message = "Attack payload was missing. Client modified.";
    await logReport(user, message);
    throw loadFailureErr();
  }

  const attackMonsters = attackData.monsters;
  const attackChampions = attackData.champions;

  if (!attackChampions && !attackMonsters) {
    const message = "Attack payload structure changed. Client modified.";
    await logReport(user, message);
    throw loadFailureErr();
  }

  // Validate monsters
  if (attackData.monsters.length > 0) {
    for (const monster of attackData.monsters) {
      const { id, stats, count } = monster;

      if (!monsterStats[id]) {
        const message = `Invalid monster ID: ${id}. Client modified.`;
        await logReport(user, message);
        throw loadFailureErr();
      }

      const monsterProps: MonsterProps = monsterStats[id].props;

      for (const stat of Object.keys(monsterProps) as Array<keyof typeof monsterProps>) {
        const received = stats[stat];
        const expected = monsterProps[stat];

        if (!isArrayEqual(received, expected)) {
          const message = `${id}'s stat '${stat}' was modified. Received: ${stats[stat]} but expected ${monsterProps[stat]}`;
          await logBanReport(user, message);
          throw loadFailureErr();
        }
      }
    }
  }
};

const isArrayEqual = (arr1: number[], arr2: number[]) => {
  if (!Array.isArray(arr1) || !Array.isArray(arr2) || arr1.length !== arr2.length)
    return false;

  return arr1.every(
    (num, i) => Number(num.toFixed(2)) === Number(arr2[i].toFixed(2))
  );
};
