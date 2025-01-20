import { Entity, PrimaryKey, Property } from "@mikro-orm/core";

import { FrontendKey } from "../utils/FrontendKey";
import { FieldData } from "./save.model";

@Entity({ tableName: "incident_report" })
export class IncidentReport {
  @PrimaryKey()
  userid!: number;

  @Property({ unique: true })
  @FrontendKey
  username!: string;

  @Property({ nullable: true })
  discord_tag: string;

  @Property({ type: "json", nullable: true })
  report?: FieldData;

  @Property()
  createdAt: Date = new Date();

  @Property({ onUpdate: () => new Date() })
  lastupdateAt: Date = new Date();
}
