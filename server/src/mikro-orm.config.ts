import { MikroORM } from "@mikro-orm/core";
import { MariaDbDriver } from "@mikro-orm/mariadb";
import path from "path";
import { Save } from "./models/save.model";
import { User } from "./models/user.model";
import { ENV } from "./enums/Env";

// The configuration for the ORM - Any Entities added need to be put in here, other than that probably doesn't need to be touched
// tslint:disable-next-line: no-object-literal-type-assertion
export default {
  type: "mariadb",
  allowGlobalContext: false,
  debug: process.env.ENV !== ENV.PROD ? true : false,
  entities: [Save, User],
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
