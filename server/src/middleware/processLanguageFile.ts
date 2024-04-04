import { Context, Next } from "koa";
import fs from "fs/promises";
import { errorLog } from "../utils/logger";

export const processLanguagesFile = async (ctx: Context, next: Next) => {
  const matchLanguage = /^\/gamestage\/assets\/([a-zA-Z]+)\.json$/;
  const match = ctx.path.match(matchLanguage);

  if (match) {
    const languageCode = match[1];
    const languageFilePath = `./public/gamestage/assets/${languageCode}.json`;

    try {
      const rawData = await fs.readFile(languageFilePath, "utf8");
      const data = JSON.parse(rawData);

      ctx.body = { data };
      ctx.type = "application/json";
    } catch (error) {
      ctx.status = 404;
      ctx.body = "Error processing JSON data";
      errorLog(error);
    }
  } else {
    await next();
  }
};
