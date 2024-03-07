import { ORMContext } from "../../server";
import { EntityManager } from "@mikro-orm/mariadb";

interface MonsterUpdate {
    baseid: number,
    m: any,
}

export const monsterUpdateBases = async (monsterupdates: Array<MonsterUpdate>) => {
    console.log("monsterupdates");
    const fork = ORMContext.em.fork() as EntityManager;
    const k = fork.getKnex()


    const queries = [];
    for (const update of monsterupdates) {
        queries.push(k.raw("UPDATE save SET monsters = ? WHERE baseid = ?", [update.m, update.baseid]))
    }
    await Promise.all(queries)
}