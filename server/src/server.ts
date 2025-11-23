import "reflect-metadata";
import "dotenv/config";

import Koa, { Context, Next } from "koa";
import Router from "@koa/router";
import bodyParser from "koa-bodyparser";
import serve from "koa-static";
import ormConfig from "./mikro-orm.config";
import router from "./app.routes";

import { createClient } from "redis";
import { MikroORM, RequestContext } from "@mikro-orm/core";
import { EntityManager, PostgreSqlDriver } from "@mikro-orm/postgresql";
import { errorLog, logging } from "./utils/logger";
import { ascii_node } from "./utils/ascii_art";
import { ErrorInterceptor } from "./middleware/clientSafeError";
import { processLanguagesFile } from "./middleware/processLanguageFile";
import { logMissingAssets, morganLogging } from "./middleware/morganLogging";
import { corsCacheControl } from "./middleware/corsCacheControlSetup";

export const app = new Koa();
app.proxy = true;

export const PORT = process.env.PORT || 3001;
export const BASE_URL = process.env.BASE_URL;

export const getApiVersion = () => "v1.4.2-beta";

export const ORMContext = {} as {
  orm: MikroORM<PostgreSqlDriver>;
  em: EntityManager<PostgreSqlDriver>;
};

export const redisClient = createClient({
  url: process.env.REDIS_URL || "redis://localhost:6379",
});

redisClient.on("connect", () => logging("Connected to Redis client."));
redisClient.on("error", (err) => errorLog("Redis client error:", err));

// CORS & Cache Control
app.use(corsCacheControl);

// Entry point for all modules.
const api = new Router();
api.get("/", (ctx: Context) => (ctx.body = {}));

(async () => {
  ORMContext.orm = await MikroORM.init<PostgreSqlDriver>(ormConfig);
  ORMContext.em = ORMContext.orm.em;

  await redisClient.connect();

  app.use(
    bodyParser({
      enableTypes: ["json", "form"],
      jsonLimit: "50mb",
      formLimit: "50mb",
    })
  );

  app.use((_, next: Next) =>
    RequestContext.createAsync(ORMContext.orm.em, next)
  );

  // Logs
  app.use(logMissingAssets);
  app.use(morganLogging);

  app.use(processLanguagesFile);

  // Serve static files
  app.use(serve("public/"));

  process.on("unhandledRejection", (reason, promise) => {
    errorLog(`Unhandled Rejection at: ${promise} reason: ${reason}`);
  });

  app.use(ErrorInterceptor);

  // Routes
  app.use(router.routes());
  app.use(router.allowedMethods());

  app.listen(PORT, () => {
    logging(`
    ${ascii_node} Server running on: ${BASE_URL}:${PORT}
    `);
  });
})().catch((e) => errorLog(e));
