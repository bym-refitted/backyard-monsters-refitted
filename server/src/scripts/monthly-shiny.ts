import 'dotenv/config'; 
import mikroOrmConfig from "../mikro-orm.config";

import { MikroORM } from "@mikro-orm/core";
import { Save } from "../models/save.model";

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
