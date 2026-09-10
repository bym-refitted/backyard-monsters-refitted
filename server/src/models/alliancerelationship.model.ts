import { Entity, Index, ManyToOne, Property } from "@mikro-orm/decorators/es";

import { AllianceStance } from "../enums/Alliance.js";
import { Alliance } from "./alliance.model.js";

@Entity({ tableName: "alliance_relationship" })
@Index({ properties: ["targetAlliance"] })
export class AllianceRelationship {
  @ManyToOne({ entity: () => Alliance, primary: true })
  alliance!: Alliance;

  @ManyToOne({ entity: () => Alliance, primary: true })
  targetAlliance!: Alliance;

  @Property({ type: "number" })
  relationship!: AllianceStance;

  @Property({ type: Date, onUpdate: () => new Date() })
  updated_at: Date = new Date();
}
