import "dotenv/config";
import bcrypt from "bcrypt";
import ormConfig from "../../mikro-orm.config";

import { MikroORM } from "@mikro-orm/core";
import { errorLog, logging } from "../../utils/logger";
import { getDefaultBaseData } from "../../data/getDefaultBaseData";
import { BaseType } from "../../enums/Base";
import { MapRoom2 } from "../../enums/MapRoom";
import { Save } from "../../models/save.model";
import { User } from "../../models/user.model";
import { joinOrCreateWorld } from "../../services/maproom/v2/joinOrCreateWorld";

/**
 * Seed the database with Map Room 2 dummy users.
 *
 * This function initializes the MikroORM, seeds the database with dummy users
 * for Map Room 2 (count determined by MapRoom2.MAX_PLAYERS constant),
 * and then closes the ORM connection. Each user is assigned a cell in the Map Room 2 world.
 *
 * Usage:
 * - npm run db:seed:mr2
 *
 * @async
 * @function
 * @returns {Promise<void>}
 */
(async () => {
  try {
    const orm = await MikroORM.init(ormConfig);
    const em = orm.em.fork();

    logging(`Seeding Map Room 2 with ${MapRoom2.MAX_PLAYERS} users`);

    const users = Array.from({ length: MapRoom2.MAX_PLAYERS }, (_, i) => ({
      username: `user${i + 1}`,
      email: `user${i + 1}@test.com`,
      password: "Dev12345!",
    }));

    // Insert users and their saves into the database
    for (const userData of users) {
      const hashedPassword = await bcrypt.hash(userData.password, 10);
      const user = em.create(User, { ...userData, password: hashedPassword });
      await em.persistAndFlush(user);

      // Create a default save for the user
      const saveData = getDefaultBaseData(user, BaseType.MAIN);
      const save = em.create(Save, { ...saveData, saveuserid: user.userid });
      user.save = save;

      // Join user to a world and assign them a cell
      await Promise.all([
        joinOrCreateWorld(user, save, em),
        em.persistAndFlush(save),
      ]);
      logging("Seeding completed successfully. 🌱");
    }

    await orm.close(true);
  } catch (err) {
    errorLog(err);
    process.exit(1);
  }
})();
