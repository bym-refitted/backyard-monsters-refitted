import bcrypt from "bcrypt";
import { User } from "../../models/user.model";
import { errorLog, logging } from "../../utils/logger";
import { EntityManager } from "@mikro-orm/core";

export const registerDevUser = async (em: EntityManager) => {
  try {
    const email = "dev@test.com";
    const password = await bcrypt.hash("dev12345", 10);
    const existingUser = await em.findOne(User, { email });

    if (!existingUser) {
      const devUser = {
        username: "dev01",
        email,
        password,
        last_name: "",
        pic_square: "",
      };

      const user = em.create(User, devUser);
      await em.persistAndFlush(user);
    } else {
      logging("Dev account available.");
    }
  } catch (error) {
    errorLog("Error inserting dev user: " + error);
  }
};
