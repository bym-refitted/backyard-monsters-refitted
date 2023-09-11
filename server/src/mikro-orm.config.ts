import { MikroORM } from '@mikro-orm/core';
import { SqliteDriver } from '@mikro-orm/sqlite';
import path from 'path';
import { Save } from './models/save.model';
import { User } from './models/user.model';

// The configuration for the ORM - Any Entities added need to be put in here, other than that probably doesn't need to be touched
// tslint:disable-next-line: no-object-literal-type-assertion
export default {
  type: 'sqlite',
  // clientUrl: DATABASE_URL,
  allowGlobalContext: false,
  debug: true,
  entities: [Save, User],
  dbName: 'src/database/bym-db',
  migrations: {
    path: path.join(__dirname, '../src/database/migrations'),
    pattern: /^[\w-]+\d+\.[j]s$/,
  },
} as Parameters<typeof MikroORM.init<SqliteDriver>>[0];