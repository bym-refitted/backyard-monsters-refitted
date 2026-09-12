import mikroOrmConfig from "../mikro-orm.config.js";

import { MikroORM, raw } from "@mikro-orm/core";
import { Save } from "../database/models/save.model.js";
import { BaseType } from "../enums/Base.js";

/**
 * This script is responsible for adding shiny to all main yard saves.
 * Current configurations runs once a month on the 20th at 13:00 UTC.
 *
 * The credits are incremented in the database rather than loaded, changed and
 * written back. Loading every main save cost seconds and gigabytes of heap, and
 * a player who spent shiny while the job ran had that spend overwritten.
 *
 * To run this script on a production server (using pm2):
 * 1) cd into the server directory
 * 2) run the command:
 * `pm2 start src/scripts/monthly-shiny.ts --interpreter bun --cron "0 13 20 * *" --name "monthly-shiny" --no-autorestart`
 */
(async () => {
  try {
    const now = new Date();
    const utcDay = now.getUTCDate();

    if (utcDay !== 20) {
      console.log(`Exiting: Current UTC day is ${utcDay}, not the 20th.`);
      return;
    }

    const shinyAmount = 400;

    const orm = await MikroORM.init(mikroOrmConfig);
    const em = orm.em.fork();

    console.log(`Adding ${shinyAmount} credits to each save...`);

    const updated = await em.nativeUpdate(
      Save,
      { type: BaseType.MAIN },
      {
        credits: raw("credits + ?", [shinyAmount]),
        monthly_credits: raw("monthly_credits + ?", [shinyAmount]),
      },
    );

    console.log(`Updated ${updated} save(s) with +${shinyAmount} credits`);

    await orm.close();
    process.exit(0);
  } catch (error) {
    console.error("Failed to run monthly-shiny job:", error);
    process.exit(1);
  }
})();
