import { Entity, Property, PrimaryKey } from "@mikro-orm/core";

interface FieldData {
  [key: string | number]: any;
}

@Entity()
export class Save {
  @PrimaryKey()
  basesaveid!: number;

  // Primatives
  @Property()
  basevalue!: number;

  @Property()
  timeplayed!: number;

  @Property()
  flinger!: number;

  @Property()
  baseid!: number;

  @Property()
  catapult!: number;

  @Property()
  version!: number;

  @Property()
  clienttime!: number;

  @Property()
  baseseed!: number;

  @Property()
  damage!: number;

  @Property()
  healtime!: number;

  @Property()
  points!: number;

  @Property()
  empirevalue!: number;

  @Property({ type: "json", nullable: true })
  buildingdata?: FieldData;

  // Json properties
  @Property({ type: "json", nullable: true })
  researchdata?: FieldData;

  @Property({ type: "json", nullable: true })
  stats?: FieldData;

  @Property({ type: "json", nullable: true })
  rewards?: FieldData;

  @Property({ type: "json", nullable: true })
  aiattacks?: FieldData;

  @Property({ type: "json", nullable: true })
  monsters?: FieldData;

  @Property({ type: "json", nullable: true })
  resources?: FieldData;

  @Property({ type: "json", nullable: true })
  lockerdata?: FieldData;

  @Property({ type: "json", nullable: true })
  events?: FieldData;

  @Property({ type: "json", nullable: true })
  inventory?: FieldData;

  @Property({ type: "json", nullable: true })
  monsterbaiter?: FieldData;

  @Property({ type: "json", nullable: true })
  mushrooms?: FieldData;

  @Property({ type: "json", nullable: true })
  monsterupdate?: FieldData;

  @Property({ type: "json", nullable: true })
  buildinghealthdata?: FieldData;

  @Property({ type: "json", nullable: true })
  frontpage?: FieldData;

  @Property()
  createdAt: Date = new Date();

  @Property({ onUpdate: () => new Date() })
  lastupdate: Date = new Date();

  // array ints
  // achieved
  // effects

  public static jsonKeys: (keyof FieldData)[] = [
    "buildingdata",
    "researchdata",
    "stats",
    "rewards",
    "aiattacks",
    "monsters",
    "resources",
    "lockerdata",
    "events",
    "inventory",
    "monsterbaiter",
    "mushrooms",
    "monsterupdate",
    "buildinghealthdata",
    "frontpage",
  ];
}
