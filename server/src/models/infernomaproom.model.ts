import { Entity, PrimaryKey, Property } from "@mikro-orm/decorators/es";
import { EntityManager, PostgreSqlDriver } from "@mikro-orm/postgresql";
import { User } from "./user.model.js";
import type { InfernoMaproomData } from "../types/EntityData.js";
import type { NeighbourData } from "../types/NeighbourData.js";

export interface TribeData {
  baseid: string;
  tribeHealthData: Record<string, number>;
  monsters?: Record<string, number>;
  destroyed?: number;
  destroyedAt?: number;
}

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

  public static setupMapRoom1Data = async (em: EntityManager<PostgreSqlDriver>, user: User) => {
    const maproom = em.create(InfernoMaproom,
    {
      userid: user.userid,
    } as unknown as InfernoMaproomData);

    em.persist(maproom);
    await em.flush();
    return maproom;
  };
}
