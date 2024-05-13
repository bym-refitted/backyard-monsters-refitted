import "reflect-metadata";
import "dotenv/config";

import Koa, { Context, Next } from "koa";
import session from "koa-session";
import Router from "@koa/router";
import bodyParser from "koa-bodyparser";
import serve from "koa-static";
import ormConfig from "./mikro-orm.config";
import router from "./app.routes";
import { MariaDbDriver } from "@mikro-orm/mariadb";
import { EntityManager, MikroORM, RequestContext } from "@mikro-orm/core";
import { errorLog, logging } from "./utils/logger.js";
import { firstRunEnv } from "./utils/firstRunEnv.js";
import { ascii_node } from "./utils/ascii_art.js";
import { ErrorInterceptor } from "./middleware/clientSafeError.js";
import { processLanguagesFile } from "./middleware/processLanguageFile";
import { logMissingAssets, morganLogging } from "./middleware/morganLogging";
import { SESSION_CONFIG } from "./config/SessionConfig";
import { getLatestSwfFromGithub } from "./utils/getLatestSwfFromGithub";

/**
 * ToDos:
 * Frontend handle error
 * Error handling for the download
 * Fix https
 */

export const app = new Koa();

export const ORMContext = {} as {
  orm: MikroORM;
  em: EntityManager;
};

let globalApiVersion: string;

export const setApiVersion = (version: string) => {
  logging(
    `Updating latest client version, server is using: ${globalApiVersion}`
  );
  globalApiVersion = version;
};

export const getApiVersion = () => globalApiVersion;

const PORT = process.env.PORT || 3001;
const BASE_URL = process.env.BASE_URL;

// Entry point for all modules.
const api = new Router();
api.get("/", (ctx: Context) => (ctx.body = {}));

(async () => {
  await firstRunEnv();

  // Sessions
  app.keys = [process.env.SECRET_KEY];
  app.use(session(SESSION_CONFIG, app));

  ORMContext.orm = await MikroORM.init<MariaDbDriver>(ormConfig);
  ORMContext.em = ORMContext.orm.em;

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

  app.use(ErrorInterceptor);

  // Logs
  app.use(logMissingAssets);
  app.use(morganLogging);

  app.use(processLanguagesFile);

  app.use(serve("public/"));

  process.on("unhandledRejection", (reason, promise) => {
    errorLog(`Unhandled Rejection at: ${promise} reason: ${reason}`);
  });

  app.use(async (ctx, next) => {
    if (ctx.path === "/crossdomain.xml") {
      ctx.type = "application/xml";
      ctx.body = `<?xml version="1.0"?>
                  <!DOCTYPE cross-domain-policy SYSTEM "http://www.adobe.com/xml/dtds/cross-domain-policy.dtd">
                  <cross-domain-policy>
                      <site-control permitted-cross-domain-policies="all" />
                      <allow-access-from domain="*" secure="false" />
                      <allow-http-request-headers-from domain="*" headers="Authorization" secure="false" />
                  </cross-domain-policy>`;
    } else {
      await next();
    }
  });

  /**
   * This sets the initial client version to the latest version from github
   *
   * This value can also be set by the github webhook
   */
  if (process.env.USE_VERSION_MANAGEMENT === "enabled") {
    setApiVersion(await getLatestSwfFromGithub());
  }

  // Routes
  app.use(router.routes());
  app.use(router.allowedMethods());

  app.listen(PORT, () => {
    logging(`
    ${ascii_node} Server running on: http://localhost:${port}
    `);
  });
})().catch((e) => errorLog(e));
