import { MikroORM } from '@mikro-orm/core';
import { SqliteDriver } from '@mikro-orm/sqlite';
import path from 'path';
import { Save } from './models/save.model';

// The configuration for the ORM - Any Entities added need to be put in here, other than that probably doesn't need to be touched
// tslint:disable-next-line: no-object-literal-type-assertion
export default {
  type: 'sqlite',
  // clientUrl: DATABASE_URL,
  debug: true,
  entities: [Save],
  dbName: 'src/db/bym-db',
  migrations: {
    path: path.join(__dirname, '../src/db/migrations'),
    pattern: /^[\w-]+\d+\.[j]s$/,
  },
} as Parameters<typeof MikroORM.init<SqliteDriver>>[0];