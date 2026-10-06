import { Entity, Index, PrimaryKey, Property, Unique } from "@mikro-orm/decorators/es";
import type { Opt } from "@mikro-orm/core";

import type { NeighbourAttackType } from "./neighbourattack.model.js";

@Entity({ tableName: "neighbour_link" })
@Unique({ properties: ["type", "user_a_id", "user_b_id"] })
@Index({ properties: ["type", "user_b_id"] })
export class NeighbourLink {
  @PrimaryKey({ autoincrement: true, type: "number" })
  id!: number;

  @Property({ type: "string" })
  type!: NeighbourAttackType;

  @Property({ type: "number" })
  user_a_id!: number;

  @Property({ type: "number" })
  user_b_id!: number;

  @Property({ type: Date })
  created_at: Opt<Date> = new Date();
}
