import z from "zod";
import { Context } from "koa";
import { User } from "../../models/user.model";
import { discordAgeErr, loadFailureErr } from "../../errors/errors";
import { logBanReport, logReport } from "../base/reportManager";
import { MonsterProps, monsterStats } from "../../data/monsterStats";

const ChampionSchema = z.object({
  type: z.string(),
  stats: z.record(z.any()),
});

const MonsterSchema = z.object({
  id: z.string(),
  count: z.number(),
  stats: z.record(z.any()),
});

const AttackSchema = z.object({
  champions: z.array(ChampionSchema).optional(),
  monsters: z.array(MonsterSchema).optional(),
});

export type AttackPayload = z.infer<typeof AttackSchema> | undefined;

// TODO:
// 1. Validate  counts from flinger
// 2. Validate champion with `championStats.ts` by getting level from db?
export const validateAttack = async (ctx: Context, user: User, attackPayload: AttackPayload) => {
  if (!ctx.meetsDiscordAgeCheck) throw discordAgeErr();

  if (!attackPayload || Object.keys(attackPayload).length === 0) {
    const message = "Attack payload was missing. Client modified.";
    await logReport(user, message);

    throw loadFailureErr();
  }

  const attackMonsters = attackPayload.monsters;
  const attackChampions = attackPayload.champions;

  if (!attackChampions && !attackMonsters) {
    const message = "Attack payload structure changed. Client modified.";
    await logReport(user, message);

    throw loadFailureErr();
  }

  // validate monsters
  if (attackPayload.monsters.length > 0) {
    for (const monster of attackPayload.monsters) {
      const { id, stats } = monster;

      if (!monsterStats[id]) {
        const message = `Invalid monster ID: ${id}. Client modified.`;
        await logReport(user, message);
        throw loadFailureErr();
      }

      // Validate key stats against monsterStats
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
