// import { DATABASE_URL, inProd } from './constants';
// import { User } from './models/User';
// import { Pilot } from './models/pilot/Pilot';
import { MikroORM } from '@mikro-orm/core';
import path from 'path';
// import { Licence } from './models/pilot/Licence';
// import { Company } from './models/contacts/Company';
// import { Client } from './models/contacts/Client';

// The configuration for the ORM - Any Entities added need to be put in here, other than that probably doesn't need to be touched
// tslint:disable-next-line: no-object-literal-type-assertion
export default {
  type: 'sqlite',
  clientUrl: DATABASE_URL,
  debug: true,
  entities: [],
  migrations: {
    path: path.join(__dirname, './db/migrations'),
    pattern: /^[\w-]+\d+\.[j]s$/,
  },
} as Parameters<typeof MikroORM.init>[0];