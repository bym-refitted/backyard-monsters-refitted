import { Entity, PrimaryKey, Property } from "@mikro-orm/decorators/es";
import { EntityManager, PostgreSqlDriver } from "@mikro-orm/postgresql";
import { User } from "./user.model.js";
import type { NeighbourData } from "../types/NeighbourData.js";
import type { TribeData } from "../types/TribeData.js";

@Entity({ tableName: "maproom" })
export class Maproom {
  @PrimaryKey({ type: "number" })
  userid!: number;

  @Property({ columnType: "jsonb", nullable: true })
  tribedata: TribeData[] = [];

  @Property({ columnType: "jsonb" })
  neighbors: NeighbourData[] = [];

  @Property({ type: Date, nullable: true })
  neighborsLastCalculated?: Date;

  @Property({ type: Date })
  createdAt: Date = new Date();

  @Property({ type: Date, onUpdate: () => new Date() })
  lastupdateAt: Date = new Date();

  public static setupMapRoomData = async (em: EntityManager<PostgreSqlDriver>, user: User) => {
    const maproom = em.create(Maproom, {
      userid: user.userid,
    } as unknown as Maproom);

    em.persist(maproom);
    await em.flush();
    return maproom;
  };
}
