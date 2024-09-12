import {
  Entity,
  Property,
  PrimaryKey,
  BeforeUpdate,
  EntityManager,
  Connection,
  IDatabaseDriver,
  OneToOne,
} from "@mikro-orm/core";
import { FrontendKey } from "../utils/FrontendKey";
import { getDefaultBaseData } from "../data/getDefaultBaseData";
import { User } from "./user.model";
import { WorldMapCell } from "./worldmapcell.model";
export interface FieldData {
  [key: string | number]: any;
}

@Entity()
export class Save {
  @BeforeUpdate()
  checkForNegativeInteger(): void {
    // Handle negative values for credits & resources
    this.credits = Math.max(0, this.credits);

    if (this.resources) {
      Object.keys(this.resources).forEach((resource) => {
        this.resources[resource] = Math.max(0, this.resources[resource]);
      });
    }
  }

  // Primatives
  @FrontendKey
  @PrimaryKey()
  basesaveid!: number;

  @FrontendKey
  @Property()
  baseid!: string;

  @FrontendKey
  @Property()
  type!: string;

  @FrontendKey
  @Property()
  userid!: number;

  @FrontendKey
  @Property()
  wmid!: number;

  @FrontendKey
  @Property()
  createtime!: number;

  @FrontendKey
  @Property()
  savetime!: number;

  @FrontendKey
  @Property()
  seed!: number;

  @FrontendKey
  @Property()
  saveuserid!: number;

  @FrontendKey
  @Property()
  bookmarked!: number;

  @FrontendKey
  @Property()
  fan!: number;

  @FrontendKey
  @Property()
  emailshared!: number;

  @FrontendKey
  @Property()
  unreadmessages!: number;

  @FrontendKey
  @Property()
  giftsentcount!: number;

  @FrontendKey
  @Property()
  id!: number;

  @FrontendKey
  @Property()
  canattack!: boolean;

  @OneToOne({
    nullable: true,
    orphanRemoval: true,
    inversedBy: "save",
    entity: () => WorldMapCell,
  })
  cell: WorldMapCell;

  @FrontendKey
  @Property()
  baseid_inferno!: number;

  @FrontendKey
  @Property()
  fbid!: string;

  @FrontendKey
  @Property()
  fortifycellid!: number;

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
  locked!: number;

  @FrontendKey
  @Property()
  points!: number;

  @FrontendKey
  @Property({ default: 0 })
  tutorialstage!: number;

  @FrontendKey
  @Property()
  basevalue!: number;

  @FrontendKey
  @Property()
  protected!: number;

  @FrontendKey
  @Property()
  lastupdate!: number;

  @FrontendKey
  @Property()
  usemap!: number;

  @FrontendKey
  @Property()
  homebaseid!: number;

  @FrontendKey
  @Property()
  credits!: number;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  champion?: string;

  @FrontendKey
  @Property()
  empiredestroyed!: number;

  @FrontendKey
  @Property()
  worldid!: string;

  @FrontendKey
  @Property()
  event_score!: number;

  @FrontendKey
  @Property()
  chatenabled!: number;

  @FrontendKey
  @Property()
  relationship!: number;

  // Client save primitives
  @FrontendKey
  @Property()
  timeplayed!: number;

  @FrontendKey
  @Property()
  version!: number;

  @FrontendKey
  @Property()
  clienttime!: number;

  @FrontendKey
  @Property()
  baseseed!: number;

  @FrontendKey
  @Property()
  healtime!: number;

  @FrontendKey
  @Property()
  empirevalue!: number;

  @FrontendKey
  @Property()
  basename!: string;

  @FrontendKey
  @Property()
  attackreport!: string;

  @FrontendKey
  @Property()
  over!: number;

  @FrontendKey
  @Property()
  protect!: number;

  @FrontendKey
  @Property()
  attackid!: number;

  @FrontendKey
  @Property()
  purchasecomplete!: number;

  // Objects
  @FrontendKey
  @Property({ type: "json", nullable: true })
  buildingdata?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  buildingkeydata?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  researchdata?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  stats?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  academy?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  rewards?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  aiattacks?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  monsters?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  resources?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  lockerdata?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  events?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  inventory?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  monsterbaiter?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  loot?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  storedata?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  coords?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  quests?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  player?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  krallen?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  siege?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  buildingresources?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  mushrooms?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  iresources?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  monsterupdate?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  buildinghealthdata?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  frontpage?: FieldData;

  @Property()
  createdAt: Date = new Date();

  @Property({ onUpdate: () => new Date() })
  lastupdateAt: Date = new Date();

  // Client save objects
  @FrontendKey
  @Property({ type: "json", nullable: true })
  attackcreatures?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  attackloot?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  lootreport?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  attackersiege?: FieldData;

  // Arrays
  @FrontendKey
  @Property({ type: "json", nullable: true })
  savetemplate: any[];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  updates: any[];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  effects: (string | number)[][];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  homebase: string[];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  outposts: number[][];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  wmstatus: number[][];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  chatservers: string[];

  // Client save arrays
  @FrontendKey
  @Property({ type: "json", nullable: true })
  achieved: any[];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  attacks: any[];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  gifts: any[];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  sentinvites: any[];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  sentgifts: any[];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  attackerchampion: any[];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  fbpromos: any[];

  public static jsonKeys: (keyof FieldData)[] = [
    "buildingdata",
    "buildingkeydata",
    "researchdata",
    "stats",
    "rewards",
    "tutorialstage",
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
    "attackcreatures",
    "attackloot",
    "lootreport",
    "attackersiege",
    "updates",
    "effects",
    "homebase",
    "outposts",
    "wmstatus",
    "chatservers",
    "achieved",
    "attacks",
    "gifts",
    "sentinvites",
    "sentgifts",
    "attackerchampion",
    "fbpromos",
    "purchase",
  ];

  // What is this?
  public static nonJsonKeys: (keyof FieldData)[] = [
    "level",
    "catapult",
    "flinger",
    "destroyed",
    "damage",
    "locked",
    "protected",
    "champion",
    "over",
    "usemap",
    "basevalue",
    "empirevalue",
    "points",
    "tutorialstage",
    "attackreport",
  ];

  public static createDefaultUserSave = async (
    em: EntityManager<IDatabaseDriver<Connection>>,
    user: User
  ) => {
    const baseSave = em.create(Save, getDefaultBaseData(user));
    // Add the user &save to the database
    await em.persistAndFlush([baseSave, user]);
    return baseSave;
  };
}
