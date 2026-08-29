/**
 * Enum tables for the compact attack battle report.
 *
 * APPEND-ONLY. Never reorder or remove an entry — the index IS the wire value,
 * and old reports stored in attack_logs.attackreport reference it by position.
 *
 * The single source of truth is attackReportEnums.fixture.json; this file and the
 * AS3 mirror (client/scripts/AttackReportEnums.as) are both checked against it.
 *
 * Sources:
 *  - monsters:  server/src/game-data/stats/monsterStats.ts key order (C1..C19, IC1..IC8)
 *  - champions: server/src/game-data/stats/championStats.ts (G1..G5)
 *  - siege:     client/scripts/com/monsters/siege/weapons/{Decoy,Vacuum,Jars}.as ID
 *  - powerups:  client/scripts/com/monsters/effects/ResourceBombs.as catapult-item list
 */

export const MONSTER_ENUM = [
  "C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10",
  "C11", "C12", "C13", "C14", "C15", "C16", "C17", "C18", "C19",
  "IC1", "IC2", "IC3", "IC4", "IC5", "IC6", "IC7", "IC8",
] as const;

export const CHAMPION_ENUM = ["G1", "G2", "G3", "G4", "G5"] as const;

export const SIEGE_ENUM = ["decoy", "vacuum", "jars"] as const;

export const POWERUP_ENUM = [
  "tw0", "tw1", "tw2", "pb0", "pb1", "pb2", "pb3", "pu0", "pu1", "pu2", "pu3",
] as const;
