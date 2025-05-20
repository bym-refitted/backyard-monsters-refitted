import "dotenv/config";
import mikroOrmConfig from "../mikro-orm.config";

import { MikroORM } from "@mikro-orm/core";
import { Save } from "../models/save.model";

/**
 * This script is responsible for adding shiny to all main yard saves.
 * Current configurations runs once a month on the 20th at 13:00 UTC.
 *
 * To run this script on a production server (using pm2):
 * 1) cd into the server directory
 * 2) run the command:
 * `pm2 start dist/scripts/monthly-shiny.js --cron "0 13 20 * *" --name "monthly-shiny" --no-autorestart`
 */
(async () => {
  try {
    const shinyAmount = 400;

    const orm = await MikroORM.init(mikroOrmConfig);
    const em = orm.em.fork();

    const saves = await em.find(Save, { type: "main" });

    console.log(`Adding ${shinyAmount} credits to each save...`);

    for (const save of saves) {
      save.credits += shinyAmount;
      save.monthly_credits += shinyAmount;
    }

    await em.flush();
    console.log(`Updated ${saves.length} save(s) with +${shinyAmount} credits`);

    await orm.close();
    process.exit(0);
  } catch (error) {
    console.error("Failed to run monthly-shiny job:", error);
    process.exit(1);
  }
})();
