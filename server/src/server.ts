import "reflect-metadata";
import "dotenv/config";

import Koa, { Context, Next } from "koa";
import Router from "@koa/router";
import bodyParser from "koa-bodyparser";
import fs from "fs/promises";
import morgan from "koa-morgan";
import serve from "koa-static";
import ormConfig from "./mikro-orm.config";
import router from "./app.routes";

import { SqliteDriver } from "@mikro-orm/sqlite";
import { EntityManager, MikroORM, RequestContext } from "@mikro-orm/core";
import { errorLog, logging } from "./utils/logger.js";
import { ascii_node } from "./utils/ascii_art.js";
import { ErrorInterceptor } from "./middleware/clientSafeError.js";
import { registerDevUser } from "./database/seeds/dev.user";
import { processLanguagesFile } from "./middleware/processLanguageFile";

export const ORMContext = {} as {
  orm: MikroORM;
  em: EntityManager;
};

export const app = new Koa();
const port = process.env.PORT || 3001;

// Entry point for all modules.
const api = new Router();
api.get("/", (ctx: Context) => (ctx.body = {}));

(async () => {
  ORMContext.orm = await MikroORM.init<SqliteDriver>(ormConfig);
  ORMContext.em = ORMContext.orm.em;

  app.use(
    bodyParser({
      enableTypes: ["json", "form"],
      jsonLimit: "50mb",
      formLimit: "50mb",
    })
  );

  // Register a dev user
  const em = ORMContext.em.fork();
  registerDevUser(em);

  app.use((_, next: Next) =>
    RequestContext.createAsync(ORMContext.orm.em, next)
  );

  app.use(
    morgan("combined", {
      skip: (ctx) => {
        const isAssetsDisabled = process.env.LOG_ASSETS !== "enabled";
        return isAssetsDisabled && ctx.url.startsWith("/assets");
      },
    })
  );
  
  app.use(processLanguagesFile);

  app.use(serve("./public"));
  app.use(serve(__dirname + "/public"));

  // Routes
  app.use(router.routes());
  app.use(router.allowedMethods());

  process.on("unhandledRejection", (reason, promise) => {
    console.error("Unhandled Rejection at:", promise, "reason:", reason);
    // Handle the error or exit gracefully
  });

  app.use(async (ctx, next) => {
    if (ctx.path === "/crossdomain.xml") {
      ctx.type = "text/xml";
      const crossdomain = await fs.readFile("./crossdomain.xml", "utf-8");
      ctx.body = crossdomain;
    } else {
      await next();
    }
  });

  app.use(ErrorInterceptor);

  app.listen(port, () => {
    logging(`
    ${ascii_node} Admin dashboard: http://localhost:${port}
    `);
  });
})().catch((e) => errorLog(e));
