import { Context, Next } from "koa";
import fs from "fs/promises";
import { errorLog } from "../utils/logger";

const languageFilePath = "./public/gamestage/assets/en.v8.json";

export const processLanguagesFile = async (ctx: Context, next: Next) => {
  if (ctx.path === "/gamestage/assets/en.v8.json") {
    try {
      const rawData = await fs.readFile(languageFilePath, "utf8");
      const data = JSON.parse(rawData);

      ctx.body = { data };
      ctx.type = "application/json";
    } catch (error) {
      ctx.status = 500;
      ctx.body = "Error processing JSON data";
      errorLog(error);
    }
  } else {
    await next();
  }
};
