import { Entity, PrimaryKey, Property } from "@mikro-orm/decorators/es";
import { PrimaryKeyProp } from "@mikro-orm/core";

import { AlliancePowerupType } from "../enums/Alliance.js";

@Entity({ tableName: "alliance_powerup" })
export class AlliancePowerup {
  [PrimaryKeyProp]?: ["alliance_id", "powerup"];

  @PrimaryKey({ type: "number" })
  alliance_id!: number;

  @PrimaryKey({ type: "string" })
  powerup!: AlliancePowerupType;

  @Property({ type: "boolean", default: false })
  active: boolean = false;

  @Property({ type: "number" })
  end_time!: number;

  @Property({ type: Date, onUpdate: () => new Date() })
  updated_at: Date = new Date();
}
