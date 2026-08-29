import { expect, test } from "bun:test";
import type { CompactAttackReport } from "../../schemas/AttackReportSchema.js";
import { decodeAttackReport } from "./attackReportCodec.js";

const compact: CompactAttackReport = {
  v: 1,
  d: 87,
  dur: 143,
  o: 2,
  loot: [12000, 4300, 0, 900],
  b: [
    { t: 24, x: 15, y: 20, hp: 0, mhp: 1200, l: 5400 },
    { t: 8, x: 3, y: 4, hp: 50, mhp: 900 },
  ],
  atk: { m: [[6, 40], [19, 12]], c: 2 }, // index 6 = C7, index 19 = IC1, champion 2 = G3 = Fomor
  s: [[0, 3]],   // SIEGE_ENUM[0] = "decoy"
  cat: [[7, 2]], // POWERUP_ENUM[7] = "pu0"
};

test("expands every field to the friendly view", () => {
  const v = decodeAttackReport(compact);
  expect(v.version).toBe(1);
  expect(v.damagePercent).toBe(87);
  expect(v.durationSeconds).toBe(143);
  expect(v.outcome).toBe("flattened");
  expect(v.lootTotals).toEqual({ r1: 12000, r2: 4300, r3: 0, r4: 900 });

  expect(v.buildings[0]).toEqual({
    type: 24, x: 15, y: 20, hp: 0, maxHp: 1200,
    looted: 5400, damageDealt: 0, kills: 0, monstersLost: [],
  });
  expect(v.buildings[1].looted).toBe(0);

  expect(v.attackingForce.monsters).toEqual([
    { monster: "C7", count: 40 },
    { monster: "IC1", count: 12 },
  ]);
  expect(v.attackingForce.champion).toBe("Fomor");
  expect(v.attackingForce.monsterLosses).toEqual([]);

  expect(v.siege).toEqual([{ type: "decoy", count: 3 }]);
  expect(v.catapult).toEqual([{ powerUp: "pu0", count: 2 }]);
});

test("champion -1 decodes to null", () => {
  const v = decodeAttackReport({ ...compact, atk: { m: [], c: -1 } });
  expect(v.attackingForce.champion).toBeNull();
});

test("outcome 0 and 1 map correctly", () => {
  expect(decodeAttackReport({ ...compact, o: 0 }).outcome).toBe("retreat");
  expect(decodeAttackReport({ ...compact, o: 1 }).outcome).toBe("timeout");
});

test("an out-of-range enum id decodes to 'unknown'", () => {
  const v = decodeAttackReport({ ...compact, atk: { m: [[999, 1]], c: 999 } });
  expect(v.attackingForce.monsters[0].monster).toBe("unknown");
  expect(v.attackingForce.champion).toBe("unknown");
});
