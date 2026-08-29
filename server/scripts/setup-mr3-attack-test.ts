/**
 * DEV-ONLY setup: give `test` (userid 1) an attackable MR3 opponent.
 *
 * Creates one opponent account ("victim") with a full sandbox base, spins up /
 * joins an MR3 world, and places both `test` and `victim` in it. `test`'s save
 * is switched to MR3 and given the same sandbox base so it loads cleanly.
 *
 * Idempotent: re-running tears down the previous `victim` and re-places `test`.
 *
 * Run from server/:  bun scripts/setup-mr3-attack-test.ts
 *
 * Wiring note: joinNewWorldMap / leaveWorld read the module-level `postgres` from
 * src/server.ts, so that module (and its app.listen IIFE) is in the import graph.
 * ./_forceEphemeralPort neutralises the port bind (PORT=0) so a running dev
 * server is untouched; we let the IIFE do the single MikroORM.init.
 */

import "./_forceEphemeralPort.js";

import bcrypt from "bcrypt";
import { RequestContext } from "@mikro-orm/core";
import { postgres } from "../src/server.js";
import { User } from "../src/models/user.model.js";
import { Save } from "../src/models/save.model.js";
import { WorldMapCell } from "../src/models/worldmapcell.model.js";
import { BaseType } from "../src/enums/Base.js";
import { EnumYardType } from "../src/enums/EnumYardType.js";
import { MapRoomVersion } from "../src/enums/MapRoom.js";
import { getDefaultBaseData } from "../src/game-data/getDefaultBaseData.js";
import { overworldYardSandbox } from "../src/utils/sandbox/overworldYard.js";
import { joinNewWorldMap } from "../src/services/maproom/v3/joinNewWorldMap.js";
import { leaveWorld } from "../src/services/maproom/v2/leaveWorld.js";
import { getCurrentDateTime } from "../src/utils/getCurrentDateTime.js";

const VICTIM_EMAIL = "victim@bymr.test";
const VICTIM_NAME = "victim";
const VICTIM_PASS = "Dev12345!";
const TEST_USERID = 1;

/** Rich base fields copied from the sandbox onto a minimal default save. */
const RICH_KEYS = [
  "buildingdata",
  "buildinghealthdata",
  "buildingkeydata",
  "resources",
  "iresources",
  "monsters",
  "champion",
  "stats",
  "academy",
  "researchdata",
  "coords",
  "quests",
  "level",
  "points",
  "basevalue",
  "empirevalue",
] as const;

const overlaySandbox = (save: Save, user: User) => {
  const sandbox = overworldYardSandbox(user) as Record<string, unknown>;
  for (const k of RICH_KEYS) {
    if (sandbox[k] !== undefined) (save as unknown as Record<string, unknown>)[k] = sandbox[k];
  }
  save.mapversion = MapRoomVersion.V3;
  save.protected = 0;
  save.canattack = true;
  save.catapult = 1;
  save.flinger = 1;
  save.savetime = getCurrentDateTime();
};

const waitForOrm = async () => {
  for (let i = 0; i < 120; i++) {
    if (postgres.orm && postgres.em) return;
    await new Promise((r) => setTimeout(r, 250));
  }
  throw new Error("postgres.orm never became ready (server.ts IIFE init timed out)");
};

const homeCellFor = (uid: number) =>
  postgres.em.findOne(WorldMapCell, {
    uid,
    base_type: EnumYardType.PLAYER,
    map_version: MapRoomVersion.V3,
  });

const main = async () => {
  await waitForOrm();

  await RequestContext.create(postgres.em, async () => {
    const em = postgres.em;

    // 1. Tear down any prior victim (and its world membership + cells).
    const prior = await em.findOne(
      User,
      { email: VICTIM_EMAIL },
      { populate: ["save"] },
    );
    if (prior) {
      if (prior.save?.worldid) await leaveWorld(prior, prior.save);
      await em.nativeDelete(Save, { userid: prior.userid });
      await em.nativeDelete(WorldMapCell, { uid: prior.userid });
      await em.nativeDelete(User, { userid: prior.userid });
      em.clear();
      console.log(`Removed previous "${VICTIM_NAME}" (userid ${prior.userid}).`);
    }

    // 2. Create the opponent user.
    const victim = em.create(User, {
      username: VICTIM_NAME,
      email: VICTIM_EMAIL,
      password: await bcrypt.hash(VICTIM_PASS, 10),
    } as unknown as User);
    em.persist(victim);
    await em.flush();

    // 3. Opponent MAIN save: minimal default skeleton + sandbox base overlay.
    const skeleton = getDefaultBaseData(victim, BaseType.MAIN);
    const vsave = em.create(Save, {
      ...skeleton,
      saveuserid: victim.userid,
      userid: victim.userid,
      type: BaseType.MAIN,
    } as unknown as Save);
    const [{ baseid }] = await em.execute<[{ baseid: string }]>(
      `SELECT nextval('bym.user_baseid_seq') AS baseid`,
    );
    vsave.baseid = baseid;
    vsave.homebaseid = parseInt(baseid, 10);
    vsave.worldid = "";
    overlaySandbox(vsave, victim);
    victim.save = vsave;
    em.persist(vsave);
    await em.flush();

    // 4. Join / create the MR3 world (also lays down victim's 6 defender cells).
    await joinNewWorldMap(victim, vsave, em);

    // 5. Move `test` into the same MR3 world with a matching sandbox base.
    const test = await em.findOne(
      User,
      { userid: TEST_USERID },
      { populate: ["save"] },
    );
    if (!test?.save) throw new Error(`user ${TEST_USERID} has no save row`);
    const tsave = test.save;
    tsave.type = BaseType.MAIN;
    if (!tsave.worldid) tsave.worldid = "";
    overlaySandbox(tsave, test);
    em.persist(tsave);
    await em.flush();
    await joinNewWorldMap(test, tsave, em);

    // 6. Report.
    const vcell = await homeCellFor(victim.userid);
    const tcell = await homeCellFor(TEST_USERID);
    em.clear();
    const freshV = await em.findOne(Save, { userid: victim.userid, type: BaseType.MAIN });

    console.log("\n===========================================================");
    console.log(" MR3 attack test ready");
    console.log("===========================================================");
    console.log(` World uuid   : ${freshV?.worldid}`);
    console.log(` Opponent     : ${VICTIM_NAME} / ${VICTIM_EMAIL} / ${VICTIM_PASS}`);
    console.log(`   userid ${victim.userid}  baseid ${freshV?.baseid}  cell (${vcell?.x}, ${vcell?.y})`);
    console.log(` test (userid 1) cell (${tcell?.x}, ${tcell?.y}), now mapversion V3`);
    console.log("");
    console.log(" Log in as `test`, open the Map Room, find `victim`'s base and attack it.");
    console.log(" After the attack ends, the battle report lands in bym.attack_logs;");
    console.log(" check it with:");
    console.log(`   SELECT id, attackid, loot, jsonb_pretty(attackreport)`);
    console.log(`     FROM bym.attack_logs ORDER BY id DESC LIMIT 1;`);
    console.log("===========================================================\n");
  });

  await postgres.orm.close(true);
  process.exit(0);
};

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
