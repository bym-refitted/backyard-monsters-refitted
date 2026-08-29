import { expect, test } from "bun:test";
import { CompactAttackReportSchema } from "./AttackReportSchema.js";

const valid = () => ({
  v: 1,
  d: 87,
  dur: 143,
  o: 1,
  loot: [12000, 4300, 0, 900],
  b: [{ t: 24, x: 15, y: 20, hp: 0, mhp: 1200, l: 5400 }],
  atk: { m: [[3, 40], [7, 12]], c: 2 },
  s: [[0, 3]],
  cat: [[8, 2]],
});

test("accepts a well-formed report", () => {
  expect(CompactAttackReportSchema.safeParse(valid()).success).toBe(true);
});

test("accepts a minimal report (no optional keys)", () => {
  const r = { v: 1, d: 0, dur: 0, o: 0, loot: [0, 0, 0, 0], b: [], atk: { m: [], c: -1 } };
  expect(CompactAttackReportSchema.safeParse(r).success).toBe(true);
});

test("rejects a wrong schema version", () => {
  expect(CompactAttackReportSchema.safeParse({ ...valid(), v: 2 }).success).toBe(false);
});

test("rejects more than 600 building entries", () => {
  const b = Array.from({ length: 601 }, () => ({ t: 1, x: 0, y: 0, hp: 0, mhp: 1 }));
  expect(CompactAttackReportSchema.safeParse({ ...valid(), b }).success).toBe(false);
});

test("rejects a negative loot value", () => {
  expect(CompactAttackReportSchema.safeParse({ ...valid(), loot: [-1, 0, 0, 0] }).success).toBe(false);
});

test("rejects loot that is not a 4-tuple", () => {
  expect(CompactAttackReportSchema.safeParse({ ...valid(), loot: [1, 2, 3] }).success).toBe(false);
});

test("rejects an oversized ml array on a building", () => {
  const ml = Array.from({ length: 31 }, () => [0, 1]);
  const b = [{ t: 1, x: 0, y: 0, hp: 0, mhp: 1, ml }];
  expect(CompactAttackReportSchema.safeParse({ ...valid(), b }).success).toBe(false);
});

test("strips unknown top-level keys", () => {
  const parsed = CompactAttackReportSchema.parse({ ...valid(), bogus: 123 });
  expect("bogus" in parsed).toBe(false);
});
