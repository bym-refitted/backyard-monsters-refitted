import 'dotenv/config';
import path from "path";

import { MikroORM } from "@mikro-orm/core";
import { MariaDbDriver } from "@mikro-orm/mariadb";
import { Save } from "./models/save.model";
import { User } from "./models/user.model";
import { WorldMapCell } from "./models/worldmapcell.model";
import { World } from "./models/world.model";
import { Env } from "./enums/Env";
import { IncidentReport } from "./models/incidentreport";

/**
 * Array of entities to be used by the ORM.
 * Add any new entities to this array.
 */
const entities = [User, Save, World, WorldMapCell, IncidentReport];

/**
 * Configuration for MikroORM.
 * This configuration sets up the ORM to use MariaDB as the database driver.
 *
 * @type {Options<MariaDbDriver> | Configuration<MariaDbDriver>}
 */
const mikroOrmConfig = {
  driver: MariaDbDriver,
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
} as Parameters<typeof MikroORM.init<MariaDbDriver>>[0];

export default mikroOrmConfig;
