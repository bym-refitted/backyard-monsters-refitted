import {Entity, Property, PrimaryKey} from "@mikro-orm/core";

export interface FieldData {
  [key: string | number]: any;
}

@Entity()
export class Save {
  // Primatives
  @PrimaryKey()
  basesaveid!: number;

  @Property()
  baseid!: string;

  @Property()
  type!: string;

  @Property()
  userid!: number;

  @Property()
  wmid!: number;

  @Property()
  createtime!: number;

  @Property()
  savetime!: number;

  @Property()
  seed!: number;

  @Property()
  saveuserid!: number;

  @Property()
  bookmarked!: number;

  @Property()
  fan!: number;

  @Property()
  emailshared!: number;

  @Property()
  unreadmessages!: number;

  @Property()
  giftsentcount!: number;

  @Property()
  id!: number;

  @Property()
  canattack!: boolean;

  @Property()
  cellid!: number;

  @Property()
  baseid_inferno!: number;

  @Property()
  fbid!: string;

  @Property()
  fortifycellid!: number;

  @Property()
  name!: string;

  @Property()
  level!: number;

  @Property()
  catapult!: number;

  @Property()
  flinger!: number;

  @Property()
  destroyed!: number;

  @Property()
  damage!: number;

  @Property()
  locked!: number;

  @Property()
  points!: number;

  @Property()
  basevalue!: number;

  @Property()
  protectedVal!: number;

  @Property()
  lastupdate!: number;

  @Property()
  usemap!: number;

  @Property()
  homebaseid!: number;

  @Property()
  credits!: number;

  @Property()
  champion!: string;

  @Property()
  empiredestroyed!: number;

  @Property()
  worldid!: string;

  @Property()
  event_score!: number;

  @Property()
  chatenabled!: number;

  @Property()
  relationship!: number;

  @Property()
  currenttime!: number;

  // Client save primitives
  @Property()
  timeplayed!: number;

  @Property()
  version!: number;

  @Property()
  clienttime!: number;

  @Property()
  baseseed!: number;

  @Property()
  healtime!: number;

  @Property()
  empirevalue!: number;

  @Property()
  basename!: string;

  @Property()
  attackreport!: string;

  @Property()
  over!: number;

  @Property()
  protect!: number;

  @Property()
  attackid!: number;

  @Property()
  purchasecomplete!: number;

  // Objects
  @Property({ type: "json", nullable: true })
  buildingdata?: FieldData;

  @Property({ type: "json", nullable: true })
  researchdata?: FieldData;

  @Property({ type: "json", nullable: true })
  stats?: FieldData;

  @Property({ type: "json", nullable: true })
  academy?: FieldData;

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
  loot?: FieldData;

  @Property({ type: "json", nullable: true })
  storedata?: FieldData;

  @Property({ type: "json", nullable: true })
  coords?: FieldData;

  @Property({ type: "json", nullable: true })
  quests?: FieldData;

  @Property({ type: "json", nullable: true })
  player?: FieldData;

  @Property({ type: "json", nullable: true })
  krallen?: FieldData;

  @Property({ type: "json", nullable: true })
  siege?: FieldData;

  @Property({ type: "json", nullable: true })
  buildingresources?: FieldData;

  @Property({ type: "json", nullable: true })
  mushrooms?: FieldData;

  @Property({ type: "json", nullable: true })
  iresources?: FieldData;

  @Property({ type: "json", nullable: true })
  monsterupdate?: FieldData;

  @Property({ type: "json", nullable: true })
  buildinghealthdata?: FieldData;

  @Property({ type: "json", nullable: true })
  frontpage?: FieldData;

  @Property()
  createdAt: Date = new Date();

  @Property({ onUpdate: () => new Date() })
  lastupdateAt: Date = new Date();

  // Client save objects
  @Property({ type: "json", nullable: true })
  purchase?: FieldData;

  @Property({ type: "json", nullable: true })
  attackcreatures?: FieldData;

  @Property({ type: "json", nullable: true })
  attackloot?: FieldData;

  @Property({ type: "json", nullable: true })
  lootreport?: FieldData;

  @Property({ type: "json", nullable: true })
  attackersiege?: FieldData;

  // Arrays
  @Property({ type: "json", nullable: true })
  updates: any[];

  @Property({ type: "json", nullable: true })
  effects: (string | number)[][];

  @Property({ type: "json", nullable: true })
  homebase: string[];

  @Property({ type: "json", nullable: true })
  outposts: string[];

  @Property({ type: "json", nullable: true })
  worldsize: number[];

  @Property({ type: "json", nullable: true })
  wmstatus: number[][];

  @Property({ type: "json", nullable: true })
  chatservers: string[];

  // Client save arrays
  @Property({ type: "json", nullable: true })
  achieved: any[];

  @Property({ type: "json", nullable: true })
  attacks: any[];

  @Property({ type: "json", nullable: true })
  gifts: any[];

  @Property({ type: "json", nullable: true })
  sentinvites: any[];

  @Property({ type: "json", nullable: true })
  sentgifts: any[];

  @Property({ type: "json", nullable: true })
  attackerchampion: any[];

  @Property({ type: "json", nullable: true })
  fbpromos: any[];

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
    "academy",
    "loot",
    "storedata",
    "coords",
    "quests",
    "player",
    "krallen",
    "siege",
    "buildingresources",
    "purchase",
    "attackcreatures",
    "attackloot",
    "lootreport",
    "attackersiege",
    "updates",
    "effects",
    "homebase",
    "outposts",
    "worldsize",
    "wmstatus",
    "chatservers",
    "achieved",
    "attacks",
    "gifts",
    "sentinvites",
    "sentgifts",
    "attackerchampion",
    "fbpromos",
  ];
}
