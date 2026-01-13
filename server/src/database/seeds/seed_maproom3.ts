import "dotenv/config";
import bcrypt from "bcrypt";
import ormConfig from "../../mikro-orm.config";

import { MikroORM } from "@mikro-orm/core";
import { errorLog, logging } from "../../utils/logger";
import { getDefaultBaseData } from "../../data/getDefaultBaseData";
import { BaseType } from "../../enums/Base";
import { Save } from "../../models/save.model";
import { User } from "../../models/user.model";
import { joinNewWorldMap } from "../../services/maproom/v3/joinNewWorldMap";
import { MapRoom3 } from "../../enums/MapRoom";

/**
 * Seed the database with Map Room 3 dummy users.
 *
 * This function initializes the MikroORM, seeds the database with dummy users
 * for Map Room 3 (count determined by MapRoom3.MAX_PLAYERS constant),
 * and then closes the ORM connection. Each user is assigned a cell in the Map Room 3 world
 * using the procedural generation system with sector placement.
 *
 * Usage:
 * - npm run db:seed:mr3
 *
 * @async
 * @function
 * @returns {Promise<void>}
 */
(async () => {
  try {
    const orm = await MikroORM.init(ormConfig);
    const em = orm.em.fork();

    logging(`Seeding Map Room 3 with ${MapRoom3.MAX_PLAYERS} users`);

    const users = Array.from({ length: MapRoom3.MAX_PLAYERS }, (_, i) => ({
      username: `mr3user${i + 1}`,
      email: `mr3user${i + 1}@test.com`,
      password: "Dev12345!",
    }));

    // Insert users and their saves into the database
    for (let i = 0; i < users.length; i++) {
      const userData = users[i];
      const hashedPassword = await bcrypt.hash(userData.password, 10);
      const user = em.create(User, { ...userData, password: hashedPassword });
      await em.persistAndFlush(user);

      // Create a default save for the user
      const saveData = getDefaultBaseData(user, BaseType.MAIN);
      const save = em.create(Save, { ...saveData, saveuserid: user.userid });
      user.save = save;

      // Persist save first to generate baseid
      await em.persistAndFlush(save);

      // Join user to Map Room 3 world and assign them a cell
      await joinNewWorldMap(user, save, em);
    }

    logging(
      `Seeding completed successfully! 🌱`
    );

    await orm.close(true);
  } catch (err) {
    errorLog(err);
    process.exit(1);
  }
})();
