import "dotenv/config";

import { MikroORM } from "@mikro-orm/core";
import ormConfig from "./mikro-orm.config";
import { errorLog } from "./utils/logger";
import { Save } from "./models/save.model";

/**
 * Fix the miserably formatted champion data. Fuck you Kixeye.
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

    const championData = await em.find(
      Save,
      {},
      { fields: ["id", "champion"] }
    );

    for (const data of championData) {
      const championValue = data.champion;

      if (championValue !== "null" && championValue) {
        // Parse the champion string into an array
        const championArray = JSON.parse(championValue) as any[];

        const filteredChampion = championArray.filter(
          (champion) => champion.t !== 5
        );

        if (filteredChampion.length === 0) {
          // Set champion value to "null" if no objects remain
          await em.nativeUpdate(Save, { id: data.id }, { champion: "null" });
        } else {

          // Convert the modified array back to a string
          const updatedChampionString = JSON.stringify(filteredChampion);

          await em.nativeUpdate(
            Save,
            { id: data.id },
            { champion: updatedChampionString }
          );
        }
      }
    }

    await orm.close(true);
  } catch (err) {
    errorLog(err);
    process.exit(1);
  }
})();
