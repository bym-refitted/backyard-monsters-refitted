import { Entity, PrimaryKey, Property } from "@mikro-orm/decorators/es";

import { FrontendKey } from "../utils/FrontendKey.js";
import type { FieldData } from "./save.model.js";

@Entity({ tableName: "report" })
export class Report {
  @PrimaryKey({ type: 'number' })
  userid!: number;

  @Property({ type: 'string', unique: true })
  @FrontendKey
  username!: string;

  @Property({ type: 'string', nullable: true })
  discord_tag: string | null = null;

  @Property({ type: "json", nullable: true })
  report?: FieldData;

  @Property({ type: "json", nullable: true })
  banReason?: FieldData;

  @Property({ type: 'number', default: 0 })
  violations: number = 0;

  @Property({ type: 'number', default: 0 })
  attackViolations: number = 0;

  @Property({ type: Date })
  createdAt: Date = new Date();

  @Property({ type: Date, onUpdate: () => new Date() })
  lastupdateAt: Date = new Date();
}
