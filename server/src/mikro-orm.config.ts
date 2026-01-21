import path from "path";

import { MikroORM } from "@mikro-orm/core";
import { Save } from "./models/save.model.js";
import { User } from "./models/user.model.js";
import { WorldMapCell } from "./models/worldmapcell.model.js";
import { World } from "./models/world.model.js";
import { Env } from "./enums/Env.js";
import { Report } from "./models/report.model.js";
import { InfernoMaproom } from "./models/infernomaproom.model.js";
import { Message } from "./models/message.model.js";
import { Thread } from "./models/thread.model.js";
import { AttackLogs } from "./models/attacklogs.model.js";
import { PostgreSqlDriver } from "@mikro-orm/postgresql";

/**
 * List of entities to be used with MikroORM.
 * These entities represent the database tables.
 */
const entities = [
  User,
  Save,
  World,
  WorldMapCell,
  Report,
  InfernoMaproom,
  Message,
  Thread,
  AttackLogs
];

/**
 * Configuration for MikroORM.
 *
 * This configuration sets up the ORM to use PostgreSql as the database driver.
 * Additional Entities must be added to the `entities` array.
 *
 * @type {Options<PostgreSqlDriver> | Configuration<PostgreSqlDriver>}
 */
const mikroOrmConfig = {
  type: "postgresql",
  schema: "bym",
  allowGlobalContext: false,
  entities,
  debug: process.env.ENV !== Env.PROD,
  dbName: process.env.DB_NAME,
  port: Number(process.env.DB_PORT),
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  migrations: {
    path: path.join(import.meta.dirname, "../dist/database/migrations"),
    pattern: /^[\w-]+\d+\.[j]s$/,
  },
} as Parameters<typeof MikroORM.init<PostgreSqlDriver>>[0];

export default mikroOrmConfig;
