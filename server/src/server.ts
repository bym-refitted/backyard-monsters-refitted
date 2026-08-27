import Koa, { type Next } from "koa";
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
import { initAnticheat } from "./scripts/anticheat/anticheat.js";
import { initialize as initVersionManifest } from "./config/VersionManifestConfig.js";
import { startChatServer } from "./chat/chatServer.js";

export const app = new Koa();
app.proxy = true;
app.proxyIpHeader = "CF-Connecting-IP";

export const PORT = process.env.PORT || 3001;
export const BASE_URL = process.env.BASE_URL;


export const postgres = {} as {
  orm: MikroORM<PostgreSqlDriver>;
  em: EntityManager<PostgreSqlDriver>;
};

export const redis = new RedisClient(process.env.REDIS_URL);

redis.onconnect = () => logger.info(`Connected to Redis server`);
redis.onclose = (err) => logger.error(`Redis disconnected: ${err.message}`);

// Initialize MikroORM, Redis, and start the Koa server
(async () => {
  postgres.orm = await MikroORM.init<PostgreSqlDriver>(ormConfig);
  postgres.em = postgres.orm.em;

  if (process.env.ENV !== Env.PROD) {
    try {
      await postgres.orm.migrator.up();
      logger.info("Database migrations applied");
    } catch (err) {
      logger.error(`Database migration failure: ${err}`);
    }
  }

  await redis.connect();

  // Production already serves the Flash socket policy through the chat server.
  // Keep local mode unchanged: the iOS client does not need chat during local
  // development, and opening port 843 there is unnecessary.
  if (process.env.ENV !== Env.LOCAL) startChatServer();

  app.use(corsCacheControl);

  app.use(
    bodyParser({
      enableTypes: ["json", "form"],
      jsonLimit: "50mb",
      formLimit: "50mb",
    }),
  );

  app.use((_, next: Next) => RequestContext.create(postgres.orm.em, next));

  // Logs
  app.use(logMissingAssets);
  if (process.env.ENV !== Env.LOCAL) app.use(morganLogging);

  // Serve static files
  app.use(processLanguagesFile);

  // Flash only honors `allow-http-request-headers-from` (required for the
  // Authorization header on cross-domain API calls, e.g. base/load) when the
  // policy file is served as text/x-cross-domain-policy. koa-static would send
  // application/xml, which silently drops the header permission and makes the
  // client throw SecurityError #2048 right after login. Serve it explicitly.
  app.use(async (ctx, next) => {
    if (ctx.path === "/crossdomain.xml") {
      logger.info(`Flash requested crossdomain.xml policy (ua: ${ctx.headers["user-agent"] || "?"})`);
      // Set the header explicitly (no charset suffix) — Flash matches the bare type.
      ctx.set("Content-Type", "text/x-cross-domain-policy");
      ctx.body =
        '<?xml version="1.0"?>\n' +
        "<cross-domain-policy>\n" +
        '  <site-control permitted-cross-domain-policies="all" />\n' +
        '  <allow-access-from domain="*" secure="false" />\n' +
        '  <allow-http-request-headers-from domain="*" headers="*" secure="false" />\n' +
        "</cross-domain-policy>";
      return;
    }
    await next();
  });

  app.use(serve("public/"));

  process.on("unhandledRejection", (reason, promise) => {
    logger.error(`Unhandled Rejection at: ${promise} reason: ${reason}`);
  });

  app.use(ErrorInterceptor);

  // Routes
  app.use(router.routes());
  app.use(router.allowedMethods());

  await initVersionManifest();
  await initAnticheat();

  app.listen(PORT, () => {
    console.log(`
${ascii_node}
Server running on: ${BASE_URL}:${PORT}
    `);
  });
})().catch((e) => logger.error(`Startup failed: ${e}`));
