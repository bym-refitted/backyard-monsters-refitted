import "reflect-metadata";

import Koa, { type Context, type Next } from "koa";
import Router from "@koa/router";
import bodyParser from "koa-bodyparser";
import serve from "koa-static";
import ormConfig from "./mikro-orm.config.js";
import router from "./app.routes.js";

import { RedisClient } from "bun";
import { MikroORM, RequestContext } from "@mikro-orm/core";
import { EntityManager, PostgreSqlDriver } from "@mikro-orm/postgresql";
import { logger } from "./utils/logger.js";
import { ascii_node } from "./utils/ascii_art.js";
import { ErrorInterceptor } from "./middleware/clientSafeError.js";
import { processLanguagesFile } from "./middleware/processLanguageFile.js";
import { logMissingAssets, morganLogging } from "./middleware/morganLogging.js";
import { corsCacheControl } from "./middleware/corsCacheControlSetup.js";
import { Env } from "./enums/Env.js";

export const app = new Koa();
app.proxy = true;

export const PORT = process.env.PORT || 3001;
export const BASE_URL = process.env.BASE_URL;

export const getApiVersion = () => "v1.4.4-beta";

export const postgres = {} as {
  orm: MikroORM<PostgreSqlDriver>;
  em: EntityManager<PostgreSqlDriver>;
};

export const redis = new RedisClient(process.env.REDIS_URL);

redis.onconnect = () => logger.info(`Connected to Redis server`);
redis.onclose = (err) => logger.error(`Redis disconnected: ${err.message}`);

// CORS & Cache Control
app.use(corsCacheControl);

// Entry point for all modules.
const api = new Router();
api.get("/", (ctx: Context) => (ctx.body = {}));

(async () => {
  postgres.orm = await MikroORM.init<PostgreSqlDriver>(ormConfig);
  postgres.em = postgres.orm.em;

  await redis.connect();

  app.use(
    bodyParser({
      enableTypes: ["json", "form"],
      jsonLimit: "50mb",
      formLimit: "50mb",
    }),
  );

  app.use((_, next: Next) => RequestContext.createAsync(postgres.orm.em, next));

  // Logs
  app.use(logMissingAssets);

  if (process.env.ENV !== Env.LOCAL) {
    app.use(morganLogging);
  }

  app.use(processLanguagesFile);

  // Serve static files
  app.use(serve("public/"));

  process.on("unhandledRejection", (reason, promise) => {
    logger.error(`Unhandled Rejection at: ${promise} reason: ${reason}`);
  });

  app.use(ErrorInterceptor);

  // Routes
  app.use(router.routes());
  app.use(router.allowedMethods());

  app.listen(PORT, () => {
    console.log(`
${ascii_node}
Server running on: ${BASE_URL}:${PORT}
    `);
  });
})().catch((e) => logger.error(e));
