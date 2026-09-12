import mikroOrmConfig from "../mikro-orm.config.js";

import { MikroORM, raw, UniqueConstraintViolationException } from "@mikro-orm/core";
import { JobRun } from "../database/models/jobrun.model.js";
import { Save } from "../database/models/save.model.js";
import { BaseType } from "../enums/Base.js";
import { logger } from "../utils/logger.js";

/**
 * This script is responsible for adding shiny to all main yard saves.
 * Current configurations runs once a month on the 20th at 13:00 UTC. The day and
 * the YYYY-MM period key are both read in UTC, independent of the host clock.
 *
 * The credits are incremented in the database rather than loaded, changed and
 * written back. Loading every main save cost seconds and gigabytes of heap, and
 * a player who spent shiny while the job ran had that spend overwritten.
 *
 * To run this script on a production server:
 * 1) cd into the server directory
 * 2) run the command:
 * `bun src/scripts/monthly-shiny.ts`
 *
 * Schedule it with a systemd timer or cron rather than pm2, which starts a
 * process immediately and restarts it on boot.
 */
(async () => {
  try {
    const now = Temporal.Now.zonedDateTimeISO("UTC");

    if (now.day !== 20) {
      logger.info(`Exiting: Current UTC day is ${now.day}, not the 20th.`);
      return;
    }

    const shinyAmount = 400;

    // Via toPlainDate because Bun does not implement ZonedDateTime.toPlainYearMonth yet.
    const period = now.toPlainDate().toPlainYearMonth().toString();

    const orm = await MikroORM.init(mikroOrmConfig);

    try {
      await orm.em.fork().transactional(async (em) => {
        await em.insert(JobRun, { job: "monthly-shiny", period, ran_at: new Date() });

        logger.info(`Adding ${shinyAmount} credits to each save...`);

        const updated = await em.nativeUpdate(
          Save,
          { type: BaseType.MAIN },
          {
            credits: raw("credits + ?", [shinyAmount]),
            monthly_credits: raw("monthly_credits + ?", [shinyAmount]),
          },
        );

        logger.info(`Updated ${updated} save(s) with +${shinyAmount} credits`);
      });
    } catch (error) {
      if (!(error instanceof UniqueConstraintViolationException)) throw error;
      logger.error(`Exiting: ${period} has already been granted, no credits added.`);
    }

    await orm.close();
    process.exit(0);
  } catch (error) {
    logger.error(`Failed to run monthly-shiny job: ${error}`);
    process.exit(1);
  }
})();
