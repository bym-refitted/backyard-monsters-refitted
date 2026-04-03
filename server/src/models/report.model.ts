import { Entity, PrimaryKey, Property } from "@mikro-orm/core";

import { FrontendKey } from "../utils/FrontendKey.js";
import type { FieldData } from "./save.model.js";

@Entity({ tableName: "report" })
export class Report {
  @PrimaryKey()
  userid!: number;

  @Property({ unique: true })
  @FrontendKey
  username!: string;

  @Property({ nullable: true })
  discord_tag: string | null = null;

  @Property({ type: "json", nullable: true })
  report?: FieldData;

  @Property({ type: "json", nullable: true })
  banReason?: FieldData;

  @Property({ default: 0 })
  violations: number = 0;

  @Property({ default: 0 })
  attackViolations: number = 0;

  @Property()
  createdAt: Date = new Date();

  @Property({ onUpdate: () => new Date() })
  lastupdateAt: Date = new Date();
}
