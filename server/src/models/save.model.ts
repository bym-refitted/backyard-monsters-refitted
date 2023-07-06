import { Entity, Property, PrimaryKey } from "@mikro-orm/core";

@Entity()
export class Save {
  @PrimaryKey()
  id!: number;

  // Primatives
  @Property()
  basevalue!: number;
  @Property()
  timeplayed!: number;
  @Property()
  flinger!: number;
  @Property()
  basesaveid!: number;
  @Property()
  baseid!: number;
  @Property()
  catapult!: number;
  @Property()
  h!: string;
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
  lastupdate!: number;
  @Property()
  empirevalue!: number;
  @Property()
  hn!: number;
}
