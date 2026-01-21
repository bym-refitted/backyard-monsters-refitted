import { MikroORM } from "@mikro-orm/core";
import ormConfig from "./mikro-orm.config.js";
import { seedWorldMapUsers } from "./database/seeds/seedWorldMapUsers.js";
import { logger } from "./utils/logger.js";

/**
 * Seed the database with dummy users.
 *
 * This function initializes the MikroORM, seeds the database with dummy users,
 * and then closes the ORM connection. It logs the status of the seeding process.
 *
 * @async
 * @function
 * @returns {Promise<void>}
 */
(async () => {
  try {
    const orm = await MikroORM.init(ormConfig);
    const em = orm.em.fork();

    await seedWorldMapUsers(em);

    await orm.close(true);
  } catch (err) {
    logger.error(err);
    process.exit(1);
  }
})();
