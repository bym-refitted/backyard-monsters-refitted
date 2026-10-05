import { MikroORM } from "@mikro-orm/core";
import type { PostgreSqlDriver } from "@mikro-orm/postgresql";
import mikroOrmConfig from "../../mikro-orm.config.js";
import { BaseType } from "../../enums/Base.js";
import { MapRoomVersion } from "../../enums/MapRoom.js";
import { Save } from "../../database/models/save.model.js";
import { calculateBaseLevel } from "../../services/base/calculateBaseLevel.js";

/**
 * Script: sync-save-levels
 *
 * Brings save.level up to date for every Map Room 1 main base, using the same
 * calculateBaseLevel the game does. The neighbour search filters on that
 * column, and before baseSave started maintaining it the column was only
 * refreshed when its owner loaded their base, which left most rows stale.
 *
 * Run it once per environment, before or with the deploy that introduces
 * neighbour links. It is safe to run again: rows already correct are skipped.
 *
 * DRY-RUN by default — pass --apply to write to the database.
 *
 *   bun src/scripts/mr1/sync-save-levels.ts           # dry run
 *   bun src/scripts/mr1/sync-save-levels.ts --apply   # apply
 */

const APPLY = process.argv.includes("--apply");
const BATCH_SIZE = 1000;

(async () => {
  const orm = await MikroORM.init<PostgreSqlDriver>({ ...mikroOrmConfig, debug: false });
  const em = orm.em.fork();

  try {
    const saves = await em.find(
      Save,
      { type: BaseType.MAIN, mapversion: MapRoomVersion.V1 },
      { fields: ["basesaveid", "points", "basevalue", "level"] }
    );

    console.log(`Map Room 1 main bases: ${saves.length}`);

    const staleByLevel = new Map<number, number[]>();
    let largestGap = 0;

    for (const save of saves) {
      const level = calculateBaseLevel(save.points, save.basevalue);

      if (level === save.level) continue;

      largestGap = Math.max(largestGap, Math.abs(level - save.level));

      if (!staleByLevel.has(level)) staleByLevel.set(level, []);

      staleByLevel.get(level)!.push(save.basesaveid);
    }

    const staleCount = [...staleByLevel.values()].reduce((total, ids) => total + ids.length, 0);

    console.log(`Stale levels: ${staleCount}`);
    console.log(`Largest gap between stored and real level: ${largestGap}`);

    if (!APPLY) {
      console.log("\nDRY RUN — no database changes made.");
      console.log("Re-run with --apply to update the stale levels.");
      return;
    }

    let updated = 0;

    for (const [level, saveIds] of staleByLevel) {
      for (let start = 0; start < saveIds.length; start += BATCH_SIZE) {
        const batch = saveIds.slice(start, start + BATCH_SIZE);

        updated += await em.nativeUpdate(Save, { basesaveid: { $in: batch } }, { level });
      }
    }

    console.log(`\nUpdated ${updated} bases.`);
  } finally {
    await orm.close();
  }
})();
