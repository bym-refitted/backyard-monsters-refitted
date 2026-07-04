import { Entity, Index, PrimaryKey, Property } from "@mikro-orm/decorators/es";
import { BigIntType } from "@mikro-orm/core";

@Entity({ tableName: "alliance" })
@Index({ properties: ["world_id", "empire_points"] })
export class Alliance {
  @PrimaryKey({ autoincrement: true, type: "number" })
  id!: number;

  @Property({ type: "string" })
  name!: string;

  @Property({ type: "number", default: 1 })
  image: number = 1;

  @Property({ type: "string", default: "" })
  description: string = "";

  @Index()
  @Property({ type: "number" })
  leader_userid!: number;

  @Property({ type: "string", default: "" })
  leader_name: string = "";

  @Property({ type: "string" })
  world_id!: string;

  @Property({ type: "number", default: 0 })
  member_count: number = 0;

  @Property({ type: new BigIntType("number"), default: 0 })
  empire_points: number = 0;

  @Property({ type: Date })
  created_at: Date = new Date();
}
