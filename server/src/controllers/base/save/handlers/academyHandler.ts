import type { Context } from "koa";
import { SaveKeys } from "../../../../enums/SaveKeys.js";
import { Save } from "../../../../models/save.model.js";

interface AcademyRequestBody {
  [SaveKeys.ACADEMY]?: string;
}

interface AcademyData {
  [monster: string]: {
    level?: number;
  };
}

export const academyHandler = (ctx: Context, save: Save) => {
  const body = ctx.request.body as AcademyRequestBody;
  const saveData = body[SaveKeys.ACADEMY];

  if (saveData) {
    const academyData: AcademyData = JSON.parse(saveData);

    for (const [monster, monsterData] of Object.entries(academyData)) {
      if (monsterData && typeof monsterData.level === "number") {
        academyData[monster].level = Math.min(monsterData.level, 6);
      }
    }

    save.academy = academyData;
  }
};
