import {
  Connection,
  Entity,
  EntityManager,
  IDatabaseDriver,
  PrimaryKey,
  Property,
} from "@mikro-orm/core";
import { User } from "./user.model";

interface Tribedata {
  baseid: bigint | number;
  tribeHealthData: any;
}

@Entity({ tableName: "maproom1" })
export class MapRoom1 {
  @PrimaryKey()
  userid!: number;

  @Property({ type: "json", nullable: true })
  tribedata: Tribedata[] = [];

  @Property()
  createdAt: Date = new Date();

  @Property({ onUpdate: () => new Date() })
  lastupdateAt: Date = new Date();

  public static setupMapRoom1Data = async (
    em: EntityManager<IDatabaseDriver<Connection>>,
    user: User
  ) => {
    const maproom = em.create(MapRoom1, {
      userid: user.userid,
    });

    await em.persistAndFlush(maproom);
    return maproom;
  };
}
