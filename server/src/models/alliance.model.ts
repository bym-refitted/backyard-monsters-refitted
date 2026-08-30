import { Entity, Index, OneToOne, PrimaryKey, Property } from "@mikro-orm/decorators/es";
import { AllianceStats } from "./alliancestats.view.js";

@Entity({ tableName: "alliance" })
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

  @Property({ type: "number", default: 2 })
  map_version: number = 2;

  @Property({ type: Date })
  created_at: Date = new Date();

  @OneToOne({ entity: () => AllianceStats, mappedBy: "alliance" })
  stats?: AllianceStats;
}
