import bcrypt from "bcrypt";

import { EntityManager, MikroORM } from "@mikro-orm/core";
import { getDefaultBaseData } from "../../data/getDefaultBaseData";
import mikroOrmConfig from "../../mikro-orm.config";
import { Save } from "../../models/save.model";
import { User } from "../../models/user.model";
import { joinOrCreateWorld } from "../../services/maproom/v2/joinOrCreateWorld";
import { errorLog, logging } from "../../utils/logger";
import { MapRoom } from "../../enums/MapRoom";

export const seedWorldMapUsers = async (em: EntityManager) => {
  // Check if users already exist
  const existingUsers = await em.count(User, {});
  if (existingUsers > 0) {
    logging("Users already exist, skipping seeding.");
    return;
  }

  // Generate dummy user data from the MapRoom.MAX_PLAYERS constant
  const users = Array.from({ length: MapRoom.MAX_PLAYERS }, (_, i) => ({
    username: `user${i + 1}`,
    email: `user${i + 1}@test.com`,
    password: "dev12345",
  }));

  // Insert users and their saves into the database
  for (const userData of users) {
    const hashedPassword = await bcrypt.hash(userData.password, 10);
    const user = em.create(User, { ...userData, password: hashedPassword });
    await em.persistAndFlush(user); // Persist user first to get the ID

    // Create a default save for the user
    const saveData = getDefaultBaseData(user);
    const save = em.create(Save, { ...saveData, saveuserid: user.userid });
    user.save = save;

    // Join user to a world and assign them a cell
    await Promise.all([
      joinOrCreateWorld(user, save, em),
      em.persistAndFlush(save),
    ]);
  }
};