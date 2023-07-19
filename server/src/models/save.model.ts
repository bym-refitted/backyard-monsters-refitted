import { Entity, Property, PrimaryKey } from "@mikro-orm/core";

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
  @Property()
  createdAt: Date = new Date();

  @Property({ onUpdate: () => new Date() })
  lastupdate: Date = new Date();

  @Property({ type: 'json', nullable: true })
  buildingdata?: { [key: string | number]: any; };
}
