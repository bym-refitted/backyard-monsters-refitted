import ormConfig from "../mikro-orm.config";
import { MikroORM } from "@mikro-orm/core";
import { MariaDbDriver } from "@mikro-orm/mariadb";
import { errorLog, logging } from "../utils/logger";

(async () => {
  let orm: MikroORM<MariaDbDriver>;

  try {
    orm = await MikroORM.init<MariaDbDriver>(ormConfig);
    const shinyIncreaseAmount = 600;

    await orm.em
      .getConnection()
      .execute(`UPDATE Save SET credits = credits + ?`, [shinyIncreaseAmount]);

    logging("Credits updated successfully");
  } catch (error) {
    errorLog(`Error updating credits: ${error}`);
  } finally {
    if (orm) await orm.close(true);
  }

  process.exit();
})();
