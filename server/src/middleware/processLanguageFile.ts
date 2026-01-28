import type { Context, Next } from "koa";
import fs from "fs/promises";
import { logger } from "../utils/logger.js";
import { Status } from "../enums/StatusCodes.js";

/**
 * Middleware to process language files based on the request path.
 *
 * @param {Context} ctx - The Koa context object.
 * @param {Next} next - The Koa next middleware function.
 * @returns {Promise<void>} - A promise that resolves when the middleware is complete.
 */
export const processLanguagesFile = async (ctx: Context, next: Next) => {
  const matchLanguage = /^\/gamestage\/assets\/([a-zA-Z]+)\.json$/;
  const match = ctx.path.match(matchLanguage);

  if (!match) {
    await next();
    return;
  }

  const languageCode = match[1];
  const languageFilePath = `./public/gamestage/assets/${languageCode}.json`;

  try {
    const rawData = await fs.readFile(languageFilePath, "utf8");
    const data = JSON.parse(rawData);

    ctx.status = Status.OK;
    ctx.body = data ;
    ctx.type = "application/json";
  } catch (error) {
    ctx.status = Status.INTERNAL_SERVER_ERROR;
    ctx.body = { error: "Error processing JSON data" };
    logger.error(error);
  }
};
