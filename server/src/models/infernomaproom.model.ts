import { Entity, PrimaryKey, Property } from "@mikro-orm/decorators/es";
import { EntityManager, PostgreSqlDriver } from "@mikro-orm/postgresql";
import { User } from "./user.model.js";
import type { InfernoMaproomData } from "../types/EntityData.js";
import type { NeighbourData } from "../types/NeighbourData.js";
import type { TribeData } from "../types/TribeData.js";

export type { TribeData };

@Entity({ tableName: "inferno_maproom" })
export class InfernoMaproom {
  @PrimaryKey({ type: 'number' })
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

  public static setupInfernoMapRoomData = async (em: EntityManager<PostgreSqlDriver>, user: User) => {
    const maproom = em.create(InfernoMaproom,
    {
      userid: user.userid,
    } as unknown as InfernoMaproomData);

    em.persist(maproom);
    await em.flush();
    return maproom;
  };
}
