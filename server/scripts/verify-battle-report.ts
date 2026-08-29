/**
 * THROWAWAY end-to-end verification for PR 1a "attack battle reports".
 *
 * Exercises the real server pipeline against local Postgres + Redis WITHOUT
 * standing up the HTTP server:
 *   seed attack_logs row -> persistBattleReport() -> re-fetch + assert
 *   -> negative cases -> decodeAttackReport() -> cleanup.
 *
 * Run from server/:  bun scripts/verify-battle-report.ts
 *
 * Note on wiring: persistBattleReport.ts reads the module-level `postgres` /
 * `redis` from src/server.ts, so that module (and its IIFE) is unavoidably in the
 * import graph. We neutralise the IIFE's port bind by forcing PORT=0 before the
 * import (ephemeral throwaway port, never clashes with a running dev server), and
 * we let the IIFE perform the single MikroORM.init. We then wait for
 * `postgres.orm` to be ready and run all DB work inside a RequestContext so the
 * global EntityManager is usable with allowGlobalContext:false.
 */

process.env.PORT = "0";

import { RequestContext } from "@mikro-orm/core";
import { postgres, redis } from "../src/server.js";
import { AttackLogs } from "../src/models/attacklogs.model.js";
import { persistBattleReport } from "../src/services/attacklogs/persistBattleReport.js";
import { decodeAttackReport } from "../src/services/attacklogs/attackReportCodec.js";

let pass = 0;
let fail = 0;
const check = (name: string, cond: boolean, detail = "") => {
  if (cond) {
    pass++;
    console.log(`PASS  ${name}`);
  } else {
    fail++;
    console.log(`FAIL  ${name}${detail ? `  -- ${detail}` : ""}`);
  }
};
const eq = (a: unknown, b: unknown) => JSON.stringify(a) === JSON.stringify(b);

const DEFENDER = 999001;

const goodReport = {
  v: 1,
  d: 73,
  dur: 88,
  o: 1,
  loot: [12000, 3400, 0, 900],
  b: [
    { t: 24, x: 100, y: 200, hp: 0, mhp: 1200, l: 5400 },
    { t: 8, x: 50, y: 60, hp: 120, mhp: 900 },
  ],
  atk: { m: [[6, 40], [19, 12]], c: 2 },
  s: [[0, 2]],
  cat: [[7, 1]],
};

const waitForOrm = async () => {
  for (let i = 0; i < 120; i++) {
    if (postgres.orm && postgres.em) return;
    await new Promise((r) => setTimeout(r, 250));
  }
  throw new Error("postgres.orm never became ready (server.ts IIFE init timed out)");
};

const main = async () => {
  // Step 1 - stack up
  await waitForOrm();
  let redisOk = false;
  try {
    const pong = await redis.send("PING", []);
    redisOk = String(pong).toUpperCase().includes("PONG");
  } catch {
    redisOk = false;
  }
  check("Step 1: Redis reachable (PING)", redisOk);
  check("Step 1: Postgres/MikroORM ready", !!postgres.orm && !!postgres.em);

  await RequestContext.create(postgres.orm.em, async () => {
    const em = postgres.em;

    // pre-clean any leftovers from a previous run
    await em.nativeDelete(AttackLogs, { defender_userid: DEFENDER });

    // Step 2 - seed the primary row
    const rowA = em.create(AttackLogs, {
      attacker_userid: 1,
      attacker_username: "test",
      defender_userid: DEFENDER,
      defender_username: "e2e-victim",
      type: "main",
      attackid: 55555,
      loot: {},
      attackreport: {},
      attacktime: new Date(),
    });
    // second row for the malformed-report negative case
    const rowB = em.create(AttackLogs, {
      attacker_userid: 1,
      attacker_username: "test",
      defender_userid: DEFENDER,
      defender_username: "e2e-victim",
      type: "main",
      attackid: 55556,
      loot: {},
      attackreport: {},
      attacktime: new Date(),
    });
    await em.flush();
    check("Step 2: seeded two attack_logs rows", !!rowA.id && !!rowB.id);

    // Step 3/4 - persist a realistic compact report against attackid 55555
    await persistBattleReport({
      attackerUserId: 1,
      defenderUserId: DEFENDER,
      attackId: 55555,
      rawReport: goodReport,
    });
    await em.flush();

    // Step 5 - re-fetch in a fresh fork and assert
    let snapshotA = "";
    {
      const fork = postgres.orm.em.fork();
      const row = await fork.findOne(AttackLogs, {
        defender_userid: DEFENDER,
        attackid: 55555,
      });
      snapshotA = JSON.stringify(row?.attackreport);
      check("Step 5: row re-fetched", !!row);
      check(
        "Step 5: attackreport.v === 1",
        !!row && (row.attackreport as any).v === 1,
        row ? `got ${JSON.stringify((row.attackreport as any).v)}` : "no row"
      );
      check(
        "Step 5: loot deep-equals {r1:12000,r2:3400,r3:0,r4:900}",
        !!row && eq(row.loot, { r1: 12000, r2: 3400, r3: 0, r4: 900 }),
        row ? JSON.stringify(row.loot) : "no row"
      );
    }

    // Step 6a - unknown attackid: must not throw, must not touch row 55555
    let threw = false;
    try {
      await persistBattleReport({
        attackerUserId: 1,
        defenderUserId: DEFENDER,
        attackId: 44444,
        rawReport: goodReport,
      });
      await em.flush();
    } catch {
      threw = true;
    }
    check("Step 6a: unknown attackid does not throw", !threw);
    {
      const fork = postgres.orm.em.fork();
      const row = await fork.findOne(AttackLogs, {
        defender_userid: DEFENDER,
        attackid: 55555,
      });
      check(
        "Step 6a: row 55555 attackreport still the good report (v===1, byte-identical to pre-noop snapshot)",
        !!row &&
          (row.attackreport as any).v === 1 &&
          JSON.stringify(row.attackreport) === snapshotA,
        row ? JSON.stringify(row.attackreport) : "no row"
      );
    }

    // Step 6b - malformed report {v:2} against a second seeded row (55556):
    // must not throw, row's attackreport must stay {}
    threw = false;
    try {
      await persistBattleReport({
        attackerUserId: 1,
        defenderUserId: DEFENDER,
        attackId: 55556,
        rawReport: { v: 2 },
      });
      await em.flush();
    } catch {
      threw = true;
    }
    check("Step 6b: malformed report does not throw", !threw);
    {
      const fork = postgres.orm.em.fork();
      const row = await fork.findOne(AttackLogs, {
        defender_userid: DEFENDER,
        attackid: 55556,
      });
      check(
        "Step 6b: row 55556 attackreport still {} (untouched)",
        !!row && eq(row.attackreport, {})
      );
    }

    // Step 7 - decode the stored good blob directly
    {
      const fork = postgres.orm.em.fork();
      const row = await fork.findOne(AttackLogs, {
        defender_userid: DEFENDER,
        attackid: 55555,
      });
      const view = decodeAttackReport(row!.attackreport as any);
      check("Step 7: outcome === 'timeout'", view.outcome === "timeout", view.outcome);
      check("Step 7: buildings.length === 2", view.buildings.length === 2, `${view.buildings.length}`);
      check(
        "Step 7: buildings[0].looted === 5400",
        view.buildings[0]?.looted === 5400,
        `${view.buildings[0]?.looted}`
      );
      check(
        "Step 7: attackingForce.monsters === [C7x40, IC1x12]",
        eq(view.attackingForce.monsters, [
          { monster: "C7", count: 40 },
          { monster: "IC1", count: 12 },
        ]),
        JSON.stringify(view.attackingForce.monsters)
      );
      check(
        "Step 7: attackingForce.champion === 'Fomor'",
        view.attackingForce.champion === "Fomor",
        `${view.attackingForce.champion}`
      );
      check(
        "Step 7: siege === [{type:'decoy',count:2}]",
        eq(view.siege, [{ type: "decoy", count: 2 }]),
        JSON.stringify(view.siege)
      );
      check(
        "Step 7: catapult === [{powerUp:'pu0',count:1}]",
        eq(view.catapult, [{ powerUp: "pu0", count: 1 }]),
        JSON.stringify(view.catapult)
      );
    }

    // Step 8 - cleanup
    const deleted = await em.nativeDelete(AttackLogs, { defender_userid: DEFENDER });
    check("Step 8: cleanup removed seeded rows", deleted >= 2, `deleted ${deleted}`);
  });

  console.log(`\n${pass} passed, ${fail} failed`);
  await postgres.orm.close(true);
  try {
    redis.close();
  } catch {}
  process.exit(fail === 0 ? 0 : 1);
};

main().catch((e) => {
  console.error("verify-battle-report crashed:", e);
  process.exit(1);
});
