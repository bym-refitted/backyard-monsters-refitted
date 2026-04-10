import { Entity, Index, PrimaryKey, Property } from "@mikro-orm/decorators/es";
import type { FieldData } from "./save.model.js";

@Index({ properties: ["attacker_userid", "attacktime"] })
@Index({ properties: ["defender_userid", "attacktime"] })
@Entity({ tableName: "attack_logs" })
export class AttackLogs {
  @PrimaryKey({ type: 'number' })
  id!: number;

  @Property({ type: 'number' })
  attacker_userid!: number;

  @Property({ type: 'string' })
  attacker_username!: string;

  @Property({ type: 'string', nullable: true })
  attacker_pic_square?: string;

  @Property({ type: 'number' })
  defender_userid!: number;

  @Property({ type: 'string' })
  defender_username!: string;

  @Property({ type: 'string', nullable: true })
  defender_pic_square?: string;

  @Property({ type: 'string' })
  type!: string;

  @Property({ type: 'number', nullable: true })
  x?: number;

  @Property({ type: 'number', nullable: true })
  y?: number;

  @Property({ type: "json", nullable: true })
  loot?: FieldData;

  @Property({ type: "json", nullable: true })
  attackreport!: FieldData;

  @Property({ type: Date })
  attacktime: Date = new Date();
}
