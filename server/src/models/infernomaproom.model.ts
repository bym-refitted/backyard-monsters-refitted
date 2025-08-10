import {
  Connection,
  Entity,
  EntityManager,
  IDatabaseDriver,
  PrimaryKey,
  Property,
} from "@mikro-orm/core";
import { User } from "./user.model";
import { NeighbourData } from "../services/maproom/inferno/createNeighbourData";

export interface TribeData {
  baseid: string;
  tribeHealthData: Record<string, number>;
  destroyed?: number;
  destroyedAt?: number;
}

@Entity({ tableName: "inferno_maproom" })
export class InfernoMaproom {
  @PrimaryKey()
  userid!: number;

  @Property({ type: "json", nullable: true })
  tribedata: TribeData[] = [];

  @Property({ type: "json", defaultRaw: "'[]'::json" })
  neighbors: NeighbourData[] = [];

  @Property({ nullable: true })
  neighborsLastCalculated?: Date;

  @Property()
  createdAt: Date = new Date();

  @Property({ onUpdate: () => new Date() })
  lastupdateAt: Date = new Date();

  public static setupMapRoom1Data = async (
    em: EntityManager<IDatabaseDriver<Connection>>,
    user: User
  ) => {
    const maproom = em.create(InfernoMaproom, {
      userid: user.userid,
    });

    await em.persistAndFlush(maproom);
    return maproom;
  };
}
