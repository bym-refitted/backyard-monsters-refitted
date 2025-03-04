import {
  Entity,
  Property,
  PrimaryKey,
  EntityManager,
  Connection,
  IDatabaseDriver,
  OneToOne,
  Index,
} from "@mikro-orm/core";
import { FrontendKey } from "../utils/FrontendKey";
import { getDefaultBaseData } from "../data/getDefaultBaseData";
import { User } from "./user.model";
import { WorldMapCell } from "./worldmapcell.model";
import { AttackDetails } from "../controllers/base/load/modes/baseModeAttack";
import { BaseType } from "../enums/Base";

export interface FieldData {
  [key: string | number]: any;
}

@Entity({ tableName: "save" })
export class Save {
  // IDs & Foreign Keys
  @FrontendKey
  @PrimaryKey({ autoincrement: true })
  basesaveid!: number;

  @Index()
  @FrontendKey
  @Property({ default: "0" })
  baseid!: string;

  @OneToOne({
    nullable: true,
    orphanRemoval: true,
    inversedBy: "save",
    entity: () => WorldMapCell,
  })
  cell: WorldMapCell;

  @FrontendKey
  @Property({ default: 0 })
  homebaseid!: number;

  @Index()
  @FrontendKey
  @Property()
  userid!: number;

  @Index()
  @FrontendKey
  @Property()
  saveuserid!: number;

  @FrontendKey
  @Property({ default: 0 })
  attackid!: number;

  @FrontendKey
  @Property({ default: 0 })
  id!: number;

  @FrontendKey
  @Property({ default: 0 })
  baseid_inferno!: number;

  @FrontendKey
  @Property({ default: 0 })
  wmid!: number;

  // Damage Protection
  @Property({ nullable: true })
  mainProtectionTime: number | null;

  @Property({ nullable: true })
  outpostProtectionTime: number | null;

  @Property({ default: false })
  initialProtectionOver!: boolean;

  @Property({ default: false })
  initialOutpostProtectionOver!: boolean;

  // Primatives
  @Index()
  @FrontendKey
  @Property({ default: "main" })
  type!: string;

  @FrontendKey
  @Property()
  createtime!: number;

  @FrontendKey
  @Property({ default: 0 })
  savetime!: number; // Updates each time a save is triggered

  @FrontendKey
  @Property({ default: 0 })
  seed!: number;

  @FrontendKey
  @Property({ default: 0 })
  bookmarked!: number;

  @FrontendKey
  @Property({ default: 0 })
  fan!: number;

  @FrontendKey
  @Property({ default: 0 })
  emailshared!: number;

  @FrontendKey
  @Property({ default: 0 })
  unreadmessages!: number;

  @FrontendKey
  @Property({ default: 0 })
  giftsentcount!: number;

  @FrontendKey
  @Property({ default: false })
  canattack!: boolean;

  @FrontendKey
  @Property({ nullable: true })
  fbid?: string;

  @FrontendKey
  @Property({ default: 0 })
  fortifycellid!: number;

  @FrontendKey
  @Property()
  name!: string;

  @FrontendKey
  @Property({ default: 1 })
  level!: number;

  @FrontendKey
  @Property({ default: 0 })
  catapult!: number;

  @FrontendKey
  @Property({ default: 0 })
  flinger!: number;

  @FrontendKey
  @Property({ default: 0 })
  destroyed!: number;

  @FrontendKey
  @Property({ default: 0 })
  damage!: number;

  @FrontendKey
  @Property({ default: 0 })
  locked!: number;

  @FrontendKey
  @Property({ default: "0" })
  points!: string;

  @FrontendKey
  @Property({ default: "0" })
  basevalue!: string;

  @FrontendKey
  @Property({ default: 0 })
  tutorialstage!: number;

  @FrontendKey
  @Property({ default: 1 })
  protected!: number;

  @FrontendKey
  @Property({ default: 0 })
  lastupdate!: number;

  @FrontendKey
  @Property({ default: 0 })
  usemap!: number;

  @FrontendKey
  @Property()
  credits!: number;

  @FrontendKey
  @Property({ type: "json", nullable: true, default: "null" })
  champion?: string;

  @FrontendKey
  @Property({ default: 0 })
  empiredestroyed!: number;

  @FrontendKey
  @Property({ nullable: true })
  worldid?: string;

  @FrontendKey
  @Property({ default: 0 })
  event_score!: number;

  @FrontendKey
  @Property({ default: 0 })
  chatenabled!: number;

  @FrontendKey
  @Property({ default: 0 })
  relationship!: number;

  // Client save primitives
  @FrontendKey
  @Property({ default: 0 })
  timeplayed!: number;

  @FrontendKey
  @Property({ default: 128 })
  version!: number;

  @FrontendKey
  @Property({ default: 0 })
  clienttime!: number;

  @FrontendKey
  @Property({ default: 0 })
  baseseed!: number;

  @FrontendKey
  @Property({ default: 0 })
  healtime!: number;

  @FrontendKey
  @Property({ default: 0 })
  empirevalue!: number;

  @FrontendKey
  @Property({ default: "basename" })
  basename!: string;

  @FrontendKey
  @Property({ default: 0 })
  over!: number;

  @FrontendKey
  @Property({ default: 0 })
  protect!: number;

  @FrontendKey
  @Property({ default: 0 })
  purchasecomplete!: number;

  @FrontendKey
  @Property({ nullable: true })
  cantmovetill?: number | null;

  // Attack Objects
  @FrontendKey
  @Property({ type: "json" })
  attacks: AttackDetails[] = [];

  // MR3 specific Objects
  @FrontendKey
  @Property({ type: "json", nullable: true })
  buildingkeydata?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  buildinghealthdata?: FieldData = {};

  // Objects
  @FrontendKey
  @Property({ type: "json", nullable: true })
  buildingdata?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  researchdata?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  stats?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  academy?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  rewards?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  aiattacks?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  monsters?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  resources?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  iresources?: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  lockerdata?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  events?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  inventory?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  monsterbaiter?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  loot?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  attackreport!: FieldData;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  storedata?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  coords?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  quests?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  player?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  krallen?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  siege?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  buildingresources?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  mushrooms?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  frontpage?: FieldData = {};

  @Property()
  createdAt: Date = new Date();

  @Property({ onUpdate: () => new Date() })
  lastupdateAt: Date = new Date();

  // Client save objects
  @FrontendKey
  @Property({ type: "json", nullable: true })
  attackloot?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  lootreport?: FieldData = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  attackersiege?: FieldData = {};

  // Arrays
  @FrontendKey
  @Property({ type: "json", nullable: true })
  monsterupdate?: FieldData = [];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  savetemplate: any[] = [];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  updates: any[] = [];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  effects: (string | number)[][] = [];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  homebase: string[] = [];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  outposts: [number, number, string][] = [];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  wmstatus: number[][] = [];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  chatservers: string[] = ["bym-chat.kixeye.com"];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  achieved: any[] = [];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  gifts: any[] = [];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  sentinvites: any[] = [];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  sentgifts: any[] = [];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  fbpromos: any[] = [];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  powerups: string[] = [];

  @FrontendKey
  @Property({ type: "json", nullable: true })
  attpowerups: string[] = [];

  public static saveKeys: (keyof FieldData)[] = [
    "buildingdata",
    "buildingkeydata",
    "researchdata",
    "stats",
    "rewards",
    "tutorialstage",
    "aiattacks",
    "monsters",
    "resources",
    "iresources",
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
    "fbpromos",
    "purchase",
    "powerups",
    "attpowerups",
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
    "tutorialstage"
  ];

  public static attackSaveKeys: (keyof FieldData)[] = [
    "destroyed",
    "damage",
    "locked",
    "protected",
    "champion",
    "over",
    "buildinghealthdata",
    "buildingresources",
    "attackreport",
    "attackersiege"
  ];

  public static createMainSave = async (
    em: EntityManager<IDatabaseDriver<Connection>>,
    user: User
  ) => {
    const baseSave = em.create(Save, getDefaultBaseData(user, BaseType.MAIN));
    // Persist the entity to generate basesaveid
    await em.persistAndFlush(baseSave);

    // Update the baseid and homebase to match the basesaveid
    baseSave.baseid = baseSave.basesaveid.toString();
    baseSave.homebaseid = baseSave.basesaveid;
    await em.persistAndFlush(baseSave);

    user.save = baseSave;
    await em.persistAndFlush(user);

    return baseSave;
  };

  public static createInfernoSave = async (
    em: EntityManager<IDatabaseDriver<Connection>>,
    user: User
  ) => {
    const infernoSave = em.create(Save, getDefaultBaseData(user, BaseType.INFERNO));
    await em.persistAndFlush(infernoSave);

    infernoSave.type = BaseType.INFERNO;
    infernoSave.baseid = infernoSave.basesaveid.toString();
    infernoSave.homebaseid = infernoSave.basesaveid;
    infernoSave.stats = user.save.stats;
    infernoSave.credits = 0;
    user.save.iresources = {
      r1: 59168,
      r2: 60090,
      r3: 59849,
      r4: 55864,
    }

    await em.persistAndFlush(infernoSave);
    return infernoSave;
  };
}
