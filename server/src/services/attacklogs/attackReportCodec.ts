import { championStats } from "../../game-data/stats/championStats.js";
import type { CompactAttackReport } from "../../schemas/AttackReportSchema.js";
import {
  CHAMPION_ENUM,
  MONSTER_ENUM,
  POWERUP_ENUM,
  SIEGE_ENUM,
} from "./attackReportEnums.js";

export interface AttackReportView {
  version: number;
  damagePercent: number;
  durationSeconds: number;
  outcome: "retreat" | "timeout" | "flattened";
  lootTotals: { r1: number; r2: number; r3: number; r4: number };
  buildings: Array<{
    type: number;
    x: number;
    y: number;
    hp: number;
    maxHp: number;
    looted: number;
    damageDealt: number;
    kills: number;
    monstersLost: Array<{ monster: string; count: number }>;
  }>;
  attackingForce: {
    monsters: Array<{ monster: string; count: number }>;
    champion: string | null;
    monsterLosses: Array<{ monster: string; count: number }>;
  };
  siege: Array<{ type: string; count: number }>;
  catapult: Array<{ powerUp: string; count: number }>;
}

const OUTCOMES = ["retreat", "timeout", "flattened"] as const;

const at = (table: readonly string[], i: number) => table[i] ?? "unknown";

const monsterCounts = (pairs: ReadonlyArray<readonly [number, number]> = []) =>
  pairs.map(([id, count]) => ({ monster: at(MONSTER_ENUM, id), count }));

/**
 * Expands a stored compact battle report into the shape the launcher renders.
 * Absent optionals become 0 / []. Out-of-range enum ids become "unknown" rather
 * than throwing — a report is best-effort data, not a contract.
 */
export const decodeAttackReport = (c: CompactAttackReport): AttackReportView => {
  const championKey = c.atk.c === -1 ? null : CHAMPION_ENUM[c.atk.c];
  const champion =
    c.atk.c === -1
      ? null
      : championKey
        ? (championStats[championKey as keyof typeof championStats]?.name ?? championKey)
        : "unknown";

  return {
    version: c.v,
    damagePercent: c.d,
    durationSeconds: c.dur,
    outcome: OUTCOMES[c.o] ?? "timeout",
    lootTotals: { r1: c.loot[0], r2: c.loot[1], r3: c.loot[2], r4: c.loot[3] },
    buildings: c.b.map((b) => ({
      type: b.t,
      x: b.x,
      y: b.y,
      hp: b.hp,
      maxHp: b.mhp,
      looted: b.l ?? 0,
      damageDealt: b.dd ?? 0,
      kills: b.k ?? 0,
      monstersLost: monsterCounts(b.ml),
    })),
    attackingForce: {
      monsters: monsterCounts(c.atk.m),
      champion,
      monsterLosses: monsterCounts(c.atk.ml),
    },
    siege: (c.s ?? []).map(([id, count]) => ({ type: at(SIEGE_ENUM, id), count })),
    catapult: (c.cat ?? []).map(([id, count]) => ({
      powerUp: at(POWERUP_ENUM, id),
      count,
    })),
  };
};
