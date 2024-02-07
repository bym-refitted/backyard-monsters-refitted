import { MariaDbDriver } from '@mikro-orm/mariadb';
// Needed for all envs to load in Mikro v6 unless we use specific env names
import "dotenv/config";
import path from 'path';
import { Save } from './models/save.model';
import { User } from './models/user.model';
import {Migrator} from "@mikro-orm/migrations";

// The configuration for the ORM - Any Entities added need to be put in here, other than that probably doesn't need to be touched
// tslint:disable-next-line: no-object-literal-type-assertion
export default {
  driver: MariaDbDriver,
  allowGlobalContext: false,
  debug: true,
  entities: [Save, User],
  dbName: process.env.DB_NAME,
  port: Number(process.env.DB_PORT),
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  extensions: [Migrator],
  migrations: {
    path: path.join(__dirname, '../src/database/migrations'),
    pattern: /^[\w-]+\d+\.[j]s$/,
  },
};
