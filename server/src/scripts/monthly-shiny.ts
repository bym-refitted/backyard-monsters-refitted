import { Save } from "../models/save.model";
import { ORMContext } from "../server";

(async () => {
  try {
    const shinyAmount = 400;
    const em = ORMContext.em.fork();

    const saves = await em.find(Save, { type: "main" });

    for (const save of saves) {
      save.credits += shinyAmount;
      save.monthly_credits += shinyAmount;
    }

    await em.flush();
    console.log(`Updated ${saves.length} save(s) with +${shinyAmount} credits`);

    process.exit(0);
  } catch (error) {
    console.error("Failed to run monthly-shiny job:", error);
    process.exit(1);
  }
})();
