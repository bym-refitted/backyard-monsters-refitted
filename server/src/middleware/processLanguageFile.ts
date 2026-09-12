import type { Context, Next } from "koa";
import fs from "fs/promises";
import { Env } from "../enums/Env.js";
import { logger } from "../utils/logger.js";
import { Status } from "../enums/StatusCodes.js";

const matchLanguage = /^\/gamestage\/assets\/([a-zA-Z]+)\.json$/;

const languageCache = new Map<string, Promise<string>>();

/**
 * Locally the language files are the ones being edited, and bun --watch does not
 * restart for a change under public/, so a cached copy would go stale until the
 * server is restarted by hand.
 */
const cacheLanguageFiles = process.env.ENV !== Env.LOCAL;

/**
 * Reads a language file, validates it as JSON, and returns the response body.
 *
 * @param {string} languageCode - The language code taken from the request path.
 * @returns {Promise<string>} The JSON body to serve.
 */
const loadLanguageFile = async (languageCode: string) => {
  const rawData = await fs.readFile(`./public/gamestage/assets/${languageCode}.json`, "utf8");

  return JSON.stringify(JSON.parse(rawData));
};

/**
 * Middleware to process language files based on the request path.
 *
 * @param {Context} ctx - The Koa context object.
 * @param {Next} next - The Koa next middleware function.
 * @returns {Promise<void>} - A promise that resolves when the middleware is complete.
 */
export const processLanguagesFile = async (ctx: Context, next: Next) => {
  const match = ctx.path.match(matchLanguage);

  if (!match) {
    await next();
    return;
  }

  const languageCode = match[1];

  try {
    let body = cacheLanguageFiles ? languageCache.get(languageCode) : undefined;

    if (!body) {
      body = loadLanguageFile(languageCode);
      if (cacheLanguageFiles) languageCache.set(languageCode, body);
    }

    ctx.status = Status.OK;
    ctx.body = await body;
    ctx.type = "application/json";
  } catch (error) {
    languageCache.delete(languageCode);

    ctx.status = Status.INTERNAL_SERVER_ERROR;
    ctx.body = { error: "Error processing JSON data" };
    logger.error(`Error processing language file for code ${languageCode}: ${error}`);
  }
};
