import { Entity, Index, PrimaryKey, Property, Unique } from "@mikro-orm/decorators/es";
import type { Opt } from "@mikro-orm/core";

import { BaseType } from "../../enums/Base.js";

export type NeighbourAttackType = BaseType.MAIN | BaseType.INFERNO;

@Entity({ tableName: "neighbour_attack" })
@Unique({ properties: ["type", "attacker_id", "defender_id"] })
@Index({ properties: ["type", "defender_id", "last_attack_at"] })
export class NeighbourAttack {
  @PrimaryKey({ autoincrement: true, type: "number" })
  id!: number;

  @Property({ type: "string" })
  type!: NeighbourAttackType;

  @Property({ type: "number" })
  attacker_id!: number;

  @Property({ type: "number" })
  defender_id!: number;

  @Property({ type: "number" })
  attacks: Opt<number> = 0;

  @Property({ type: "number" })
  attacks_today: Opt<number> = 0;

  @Property({ type: Date })
  last_attack_at: Opt<Date> = new Date();
}
