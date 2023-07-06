import 'reflect-metadata';
import { SqliteDriver } from '@mikro-orm/sqlite';
import { EntityManager, EntityRepository, MikroORM, RequestContext } from '@mikro-orm/core';
import ormConfig from './mikro-orm.config';
import express, { Express } from "express";
import fs from "fs";
import morgan from "morgan";
import { logging } from "./utils/logger.js";
import { ascii_node } from "./utils/ascii_art.js";

import debug from "./routes/debug.routes.js";
import baseLoad from "./routes/baseload.routes.js";
import baseSave from "./routes/basesave.routes.js";
import worldmap from './routes/worldmap.routes.js';

export const ORMContext = {} as {
  orm: MikroORM,
  em: EntityManager,
};

// Top level await hack
(async () => {
  ORMContext.orm = await MikroORM.init<SqliteDriver>(ormConfig);
  ORMContext.em = ORMContext.orm.em;

  const app: Express = express();
  const port = 3001;
  
  app.use((req, res, next) => {
    RequestContext.create(ORMContext.orm.em, next);
  });

  app.use(express.urlencoded({ extended: true, limit: '50mb' }));
  app.use(express.json({limit: '50mb'}));
  app.use(morgan("combined"));
  
  // Register routes
  app.use(baseLoad);
  app.use(baseSave);
  app.use(worldmap);
  app.use(debug);
  
  app.get("/crossdomain.xml", (_: any, res) => {
    res.set("Content-Type", "text/xml");
  
    const crossdomain = fs.readFileSync("./crossdomain.xml");
    res.send(crossdomain);
  });
  
  app.use(express.static("./public"));
  app.use(express.static(__dirname + '/public'));
  
  app.listen(process.env.PORT || port, () => {
    logging(`
    ${ascii_node} Admin dashboard: http://localhost:${port}
    `);
  });
  
})().catch(e => {
  // Deal with the fact the chain failed
  console.error(e)
});