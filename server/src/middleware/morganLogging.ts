import { Context } from "vm";
import { devConfig } from "../config/DevSettings";
import { errorLog } from "../utils/logger";
import morgan from "koa-morgan";
import { Next } from "koa";

export const logMissingAssets = async (ctx: Context, next: Next) => {
  await next();

  const assetURI = ctx.url.startsWith("/assets");

  if (assetURI && ctx.status === 404 && devConfig.logMissingAssets) {
    errorLog(`${`Missing Asset:`.toUpperCase()} ${ctx.status} ${ctx.url}`);
  }
};

const logFormat = "Server: :method :status :url";
export const morganLogging = morgan(logFormat, {
  skip: (ctx) => ctx.url.startsWith("/assets"),
});
