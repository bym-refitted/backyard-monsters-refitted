import path from "path";

import { defineConfig } from "@mikro-orm/postgresql";
import { Migrator } from "@mikro-orm/migrations";
import { Save } from "./database/models/save.model.js";
import { User } from "./database/models/user.model.js";
import { WorldMapCell } from "./database/models/worldmapcell.model.js";
import { World } from "./database/models/world.model.js";
import { Env } from "./enums/Env.js";
import { Report } from "./database/models/report.model.js";
import { InfernoMaproom } from "./database/models/infernomaproom.model.js";
import { Maproom } from "./database/models/maproom.model.js";
import { Message } from "./database/models/message.model.js";
import { Thread } from "./database/models/thread.model.js";
import { AttackLogs } from "./database/models/attacklogs.model.js";
import { Truce } from "./database/models/truce.model.js";
import { Alliance } from "./database/models/alliance.model.js";
import { AllianceInvite } from "./database/models/allianceinvite.model.js";
import { AllianceMessage } from "./database/models/alliancemessage.model.js";
import { AlliancePowerup } from "./database/models/alliancepowerup.model.js";
import { AllianceRelationship } from "./database/models/alliancerelationship.model.js";
import { AllianceStats } from "./database/models/alliancestats.view.js";

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
  Alliance,
  AllianceInvite,
  AllianceMessage,
  AlliancePowerup,
  AllianceRelationship,
  AllianceStats,
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
  },
});
