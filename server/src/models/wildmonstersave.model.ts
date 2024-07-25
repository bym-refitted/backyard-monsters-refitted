import { Entity, Property, PrimaryKey } from "@mikro-orm/core";
import { FrontendKey } from "../utils/FrontendKey";

export interface FieldData {
  [key: string | number]: any;
}

@Entity()
export class WildMonsterSave {
  @FrontendKey
  @PrimaryKey()
  basesaveid!: number;

  @FrontendKey
  @Property()
  baseid!: string;

  @FrontendKey
  @Property({ persist: false })
  get type() {
    return "tribe";
  }

  @FrontendKey
  @Property({ persist: false })
  get userid() {
    return 0;
  }

  @FrontendKey
  @Property()
  wmid!: number;

  @FrontendKey
  @Property()
  id!: number;

  @FrontendKey
  @Property()
  cellid!: number;

  @FrontendKey
  @Property()
  name!: string;

  @FrontendKey
  @Property()
  level!: number;

  @FrontendKey
  @Property()
  catapult!: number;

  @FrontendKey
  @Property()
  flinger!: number;

  @FrontendKey
  @Property()
  destroyed!: number;

  @FrontendKey
  @Property()
  damage!: number;

  @FrontendKey
  @Property()
  basevalue!: number;

  @FrontendKey
  @Property()
  homebaseid!: number;

  @FrontendKey
  @Property()
  worldid!: string;

  @FrontendKey
  @Property()
  baseseed!: number;

  @FrontendKey
  @Property()
  empirevalue!: number;

  @FrontendKey
  @Property()
  basename!: string;

  @FrontendKey
  @Property()
  protect!: number;

  // Objects
  @FrontendKey
  @Property({ type: "json", nullable: true })
  buildingdata?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  buildingkeydata?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  monsters?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  resources?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  loot?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  coords?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  player?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  buildingresources?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  mushrooms?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  buildinghealthdata?: FieldData;

  @Property()
  createdAt: Date = new Date();

  @Property({ onUpdate: () => new Date() })
  lastupdateAt: Date = new Date();

  @FrontendKey
  @Property({ type: "json", nullable: true })
  homebase: string[];
}
