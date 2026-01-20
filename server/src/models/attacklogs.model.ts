import { Entity, Index, PrimaryKey, Property } from "@mikro-orm/core";
import { FieldData } from "./save.model.js";

@Index({ properties: ["attacker_userid", "attacktime"] })
@Index({ properties: ["defender_userid", "attacktime"] })
@Entity({ tableName: "attack_logs" })
export class AttackLogs {
  @PrimaryKey()
  id!: number;

  @Property()
  attacker_userid!: number;

  @Property()
  attacker_username!: string;

  @Property({ nullable: true })
  attacker_pic_square?: string;

  @Property()
  defender_userid!: number;

  @Property()
  defender_username!: string;

  @Property({ nullable: true })
  defender_pic_square?: string;

  @Property()
  type!: string;

  @Property({ nullable: true })
  x?: number;

  @Property({ nullable: true })
  y?: number;

  @Property({ type: "json", nullable: true })
  loot?: FieldData;

  @Property({ type: "json", nullable: true })
  attackreport!: FieldData;

  @Property()
  attacktime: Date = new Date();
}
