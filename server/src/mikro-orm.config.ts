import path from "path";

import { defineConfig } from "@mikro-orm/postgresql";
import { Migrator } from "@mikro-orm/migrations";
import { Save } from "./models/save.model.js";
import { User } from "./models/user.model.js";
import { WorldMapCell } from "./models/worldmapcell.model.js";
import { World } from "./models/world.model.js";
import { Env } from "./enums/Env.js";
import { Report } from "./models/report.model.js";
import { InfernoMaproom } from "./models/infernomaproom.model.js";
import { Maproom } from "./models/maproom.model.js";
import { Message } from "./models/message.model.js";
import { Thread } from "./models/thread.model.js";
import { AttackLogs } from "./models/attacklogs.model.js";
import { Truce } from "./models/truce.model.js";

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
  Maproom,
  Message,
  Thread,
  AttackLogs,
  Truce,
];

/**
 * Configuration for MikroORM.
 *
 * Uses defineConfig from the PostgreSQL driver package for type-safe config.
 * ES stage 3 decorators are used; explicit types are provided on each @Property decorator instead.
 * Migrator is registered as an extension to enable orm.migrator usage.
 */
export default defineConfig({
  schema: "bym",
  allowGlobalContext: false,
  entities,
  extensions: [Migrator],
  debug: process.env.ENV !== Env.PROD,
  dbName: process.env.DB_NAME,
  port: Number(process.env.DB_PORT),
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  migrations: {
    path: path.join(import.meta.dirname, "./database/migrations"),
    pathTs: path.join(import.meta.dirname, "./database/migrations"),
    glob: "*.ts",
    // Must be false: a non-transactional migration (CREATE INDEX CONCURRENTLY in
    // 20260815_AddUniqueMainSaveIndex) cannot proceed while an earlier transactional
    // migration in the same batch is still open on another connection - Postgres
    // makes CONCURRENTLY wait for every in-flight transaction to finish, and the
    // batch transaction only commits after the whole run succeeds. That's a deadlock.
    allOrNothing: false,
  },
});
