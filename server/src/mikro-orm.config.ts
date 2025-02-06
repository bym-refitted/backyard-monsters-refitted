import path from "path";

import { MikroORM } from "@mikro-orm/core";
import { MariaDbDriver } from "@mikro-orm/mariadb";
import { Save } from "./models/save.model";
import { User } from "./models/user.model";
import { WorldMapCell } from "./models/worldmapcell.model";
import { World } from "./models/world.model";
import { Env } from "./enums/Env";
import { IncidentReport } from "./models/incidentreport";
import { MapRoom1 } from "./models/maproom1.model";

/**
 * Configuration for MikroORM.
 * 
 * This configuration sets up the ORM to use MariaDB as the database driver.
 * Additional Entities must be added to the `entities` array.
 * 
 * @type {Options<MariaDbDriver> | Configuration<MariaDbDriver>}
 */
const mikroOrmConfig = {
  type: "mariadb",
  allowGlobalContext: false,
  entities: [User, Save, World, WorldMapCell, IncidentReport, MapRoom1],
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
