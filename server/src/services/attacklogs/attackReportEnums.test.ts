import { expect, test } from "bun:test";
import fixture from "./attackReportEnums.fixture.json" with { type: "json" };
import {
  CHAMPION_ENUM,
  MONSTER_ENUM,
  POWERUP_ENUM,
  SIEGE_ENUM,
} from "./attackReportEnums.js";

test("enum arrays match the shared fixture exactly", () => {
  // @ts-ignore - fixture is generic string[], enums have literal types, but values match
  expect(Array.from(MONSTER_ENUM)).toEqual(fixture.monsters);
  // @ts-ignore
  expect(Array.from(CHAMPION_ENUM)).toEqual(fixture.champions);
  // @ts-ignore
  expect(Array.from(SIEGE_ENUM)).toEqual(fixture.siege);
  // @ts-ignore
  expect(Array.from(POWERUP_ENUM)).toEqual(fixture.powerups);
});

test("no enum array has duplicate entries", () => {
  for (const arr of [MONSTER_ENUM, CHAMPION_ENUM, SIEGE_ENUM, POWERUP_ENUM]) {
    expect(new Set(arr).size).toBe(arr.length);
  }
});
