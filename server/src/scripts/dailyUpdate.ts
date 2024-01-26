import ormConfig from "../mikro-orm.config";
import { MikroORM } from "@mikro-orm/core";
import { SqliteDriver } from "@mikro-orm/sqlite";
import { Resources } from "../data/updateResources";

(async () => {
  const orm = await MikroORM.init<SqliteDriver>(ormConfig);
  const shinyIncreaseAmount = 200;
  const resourceIncrements: Resources = {
    r1: 50000,
    r2: 50000,
    r3: 50000,
    r4: 50000,
  };

  await orm.em
    .getConnection()
    .execute(`UPDATE Save SET credits = credits + ?`, [shinyIncreaseAmount]);

  let resourceQuery = `UPDATE Save SET resources = json_set(resources, `;

  const temp: string[] = [];

  for (const [key, value] of Object.entries(resourceIncrements)) {
    temp.push(`'$.${key}', json_extract(resources, '$.${key}') + ${value}`);
  }
  resourceQuery += temp.join(", ");
  resourceQuery += `)`;
  await orm.em.getConnection().execute(resourceQuery);

  process.exit();
})();
