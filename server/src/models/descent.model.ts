import {
  Connection,
  Entity,
  EntityManager,
  IDatabaseDriver,
  Property,
} from "@mikro-orm/core";
import { Save } from "./save.model";
import { descentTribes } from "../data/tribes/descentTribes";
import { WorldMapCell } from "./worldmapcell.model";

@Entity({ tableName: "descent" })
export class Descent extends Save {
  @Property({ persist: false, type: WorldMapCell })
  declare cell: WorldMapCell;

  public static createDescentTribes = async (
    em: EntityManager<IDatabaseDriver<Connection>>
  ) => {
    const fork = em.fork();

    const existingTribes = await fork.count(Descent);
    if (existingTribes > 0) return;

    const tribes = descentTribes.map((tribe) => fork.create(Descent, tribe));
    await fork.persistAndFlush(tribes);
  };
}
