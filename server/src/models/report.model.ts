import { Entity, PrimaryKey, Property } from "@mikro-orm/decorators/es";

import { FrontendKey } from "../utils/FrontendKey.js";
import type { JsonObject } from "../types/JsonObject.js";

@Entity({ tableName: "report" })
export class Report {
  @PrimaryKey({ type: 'number' })
  userid!: number;

  @Property({ type: 'string', unique: true })
  @FrontendKey
  username!: string;

  @Property({ type: 'string', nullable: true })
  discord_tag: string | null = null;

  @Property({ columnType: "jsonb", nullable: true })
  report?: JsonObject = {};

  @Property({ columnType: "jsonb", nullable: true })
  banReason?: JsonObject = {};

  @Property({ type: 'number', default: 0 })
  violations: number = 0;

  @Property({ type: 'number', default: 0 })
  attackViolations: number = 0;

  @Property({ type: Date })
  createdAt: Date = new Date();

  @Property({ type: Date, onUpdate: () => new Date() })
  lastupdateAt: Date = new Date();
}
