import bcrypt from "bcrypt";

import { EntityManager } from "@mikro-orm/core";
import { getDefaultBaseData } from "../../data/getDefaultBaseData";
import { Save } from "../../models/save.model";
import { User } from "../../models/user.model";
import { joinOrCreateWorld } from "../../services/maproom/v2/joinOrCreateWorld";
import { errorLog, logging } from "../../utils/logger";
import { MapRoom } from "../../enums/MapRoom";
import { BaseType } from "../../enums/Base";

export const seedWorldMapUsers = async (em: EntityManager) => {
  // Check if users already exist
  const existingUsers = await em.count(User, {});
  if (existingUsers > 0) {
    errorLog(`
      There are users already in the database. Run the following commands first before seeding:
      - npm run db:drop
      - npm run db:init
    `);
    return;
  }

  // Generate dummy user data from the MapRoom.MAX_PLAYERS constant
  const users = Array.from({ length: MapRoom.MAX_PLAYERS }, (_, i) => ({
    username: `user${i + 1}`,
    email: `user${i + 1}@test.com`,
    password: "Dev12345!",
  }));

  // Insert users and their saves into the database
  for (const userData of users) {
    const hashedPassword = await bcrypt.hash(userData.password, 10);
    const user = em.create(User, { ...userData, password: hashedPassword });
    await em.persistAndFlush(user); // Persist user first to get the ID

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
};
