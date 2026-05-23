import mikroOrmConfig from "../mikro-orm.config.js";

import { MikroORM } from "@mikro-orm/core";
import { RedisClient } from "bun";
import { World } from "../models/world.model.js";
import { MapRoomVersion } from "../enums/MapRoom.js";

/**
 * This script is responsible for syncing each world's name to the username of the
 * player occupying cell (0, 0), then invalidating the availableWorlds Redis cache.
 * Current configuration runs once a day at 00:00 UTC.
 *
 * To run this script on a production server (using pm2):
 * 1) cd into the server directory
 * 2) run the command:
 * `pm2 start dist/scripts/sync-world-names.js --cron "0 0 * * *" --name "sync-world-names" --no-autorestart`
 */
(async () => {
  try {
    const orm = await MikroORM.init(mikroOrmConfig);
    const em = orm.em.fork();
    const redis = new RedisClient(process.env.REDIS_URL);
    await redis.connect();

    console.log("Syncing world names from (0, 0) occupants...");

    const rows = await em.getConnection().execute<{ uuid: string; username: string | null }[]>(
      `SELECT w.uuid, u.username
       FROM bym.world w
       LEFT JOIN bym.world_map_cell wmc ON wmc.world_id = w.uuid AND wmc.x = 0 AND wmc.y = 0
       LEFT JOIN bym.user u ON u.userid = wmc.uid
       WHERE w.map_version = ?`,
      [MapRoomVersion.V2]
    );

    const toUpdate = rows.filter((r) => r.username !== null);
    let updated = 0;

    if (toUpdate.length > 0) {
      const worlds = await em.find(World, { uuid: { $in: toUpdate.map((r) => r.uuid) } });

      for (const world of worlds) {
        const occupant = toUpdate.find((r) => r.uuid === world.uuid)!;
        if (world.name !== occupant.username) {
          console.log(`World ${world.uuid}: "${world.name}" → "${occupant.username}"`);
          world.name = occupant.username!;
          updated++;
        }
      }

      if (updated > 0) await em.flush();
    }

    await redis.del("availableWorlds");
    console.log(`Done. ${updated} world name(s) updated, cache invalidated.`);

    await orm.close();
    redis.close();
    process.exit(0);
  } catch (error) {
    console.error("Failed to run sync-world-names job:", error);
    process.exit(1);
  }
})();
