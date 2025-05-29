import path from "path";

import { MikroORM } from "@mikro-orm/core";
import { Save } from "./models/save.model";
import { User } from "./models/user.model";
import { WorldMapCell } from "./models/worldmapcell.model";
import { World } from "./models/world.model";
import { Env } from "./enums/Env";
import { Report } from "./models/report.model";
import { InfernoMaproom } from "./models/infernomaproom.model";
import { Message } from "./models/message.model";
import { Thread } from "./models/thread.model";
import { AttackLogs } from "./models/attacklogs.model";
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
  allowGlobalContext: false,
  entities,
  debug: process.env.ENV !== Env.PROD,
  dbName: process.env.DB_NAME,
  port: Number(process.env.DB_PORT),
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  migrations: {
    path: path.join(__dirname, "../src/database/migrations"),
    pattern: /^[\w-]+\d+\.[j]s$/,
  },
} as Parameters<typeof MikroORM.init<PostgreSqlDriver>>[0];

export default mikroOrmConfig;
