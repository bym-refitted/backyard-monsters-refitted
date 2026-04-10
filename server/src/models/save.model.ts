import { Entity, Property, PrimaryKey, OneToOne, Index } from "@mikro-orm/decorators/es";
import { EntityManager, PostgreSqlDriver } from "@mikro-orm/postgresql";
import { FrontendKey } from "../utils/FrontendKey.js";
import { getDefaultBaseData } from "../data/getDefaultBaseData.js";
import { User } from "./user.model.js";
import { BaseType } from "../enums/Base.js";
import { WorldMapCell } from "./worldmapcell.model.js";
import { type RequiredEntityData, BigIntType } from "@mikro-orm/core";
import type { AttackDetails } from "../controllers/base/load/modes/baseModeAttack.js";
import type { Stats } from "../services/events/wmi/invasionUtils.js";

export interface FieldData {
  [key: string | number]: any;
}

const NEXT_USER_BASEID = `SELECT nextval('bym.user_baseid_seq') AS baseid`;

@Index({ properties: ["type", "worldid", "userid"] })
@Entity({ tableName: "save" })
export class Save {
  // IDs & Foreign Keys
  @FrontendKey
  @PrimaryKey({ autoincrement: true, type: 'number' })
  basesaveid!: number;

  @Index()
  @FrontendKey
  @Property({ type: 'string', default: "0" })
  baseid!: string;

  @OneToOne({
    nullable: true,
    orphanRemoval: true,
    inversedBy: "save",
    entity: () => WorldMapCell,
  })
  cell?: WorldMapCell | null;

  @FrontendKey
  @Property({ type: new BigIntType('number'), default: 0 })
  homebaseid!: number;

  @Index()
  @FrontendKey
  @Property({ type: 'number' })
  userid!: number;

  @Index()
  @FrontendKey
  @Property({ type: 'number' })
  saveuserid!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  attackid!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  id!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  baseid_inferno!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  wmid!: number;

  // Primatives
  @Index()
  @FrontendKey
  @Property({ type: 'string', default: "main" })
  type!: string;

  @FrontendKey
  @Property({ type: 'number' })
  createtime!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  savetime!: number; // Updates each time a save is triggered

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  seed!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  bookmarked!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  fan!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  emailshared!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  unreadmessages!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  giftsentcount!: number;

  @FrontendKey
  @Property({ type: 'boolean', default: false })
  canattack!: boolean;

  @FrontendKey
  @Property({ type: 'string', nullable: true })
  fbid?: string | null;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  fortifycellid!: number;

  @FrontendKey
  @Property({ type: 'string' })
  name!: string;

  @FrontendKey
  @Property({ type: 'number', default: 1 })
  level!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  catapult!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  flinger!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  destroyed!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  damage!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  locked!: number;

  @FrontendKey
  @Property({ type: 'string', default: "0" })
  points!: string;

  @FrontendKey
  @Property({ type: 'string', default: "0" })
  basevalue!: string;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  tutorialstage!: number;

  @FrontendKey
  @Property({ type: 'number', default: 1 })
  protected!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  lastupdate!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  usemap!: number;

  @FrontendKey
  @Property({ type: 'number', check: "credits >= 0" })
  credits!: number;

  @Property({ type: 'number', default: 0 })
  monthly_credits: number = 0;

  @FrontendKey
  @Property({ type: "json", nullable: true, default: "null" })
  champion?: string | null;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  empiredestroyed!: number;

  @FrontendKey
  @Property({ type: 'string', nullable: true })
  worldid?: string | null;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  event_score!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  chatenabled!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  relationship!: number;

  // Client save primitives
  @FrontendKey
  @Property({ type: 'number', default: 0 })
  timeplayed!: number;

  @FrontendKey
  @Property({ type: 'number', default: 128 })
  version!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  clienttime!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  baseseed!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  healtime!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  empirevalue!: number;

  @FrontendKey
  @Property({ type: 'string', default: "basename" })
  basename!: string;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  over!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  protect!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  purchasecomplete!: number;

  @FrontendKey
  @Property({ type: 'number', nullable: true })
  cantmovetill?: number | null;

  // Attack Objects
  @FrontendKey
  @Property({ type: "json" })
  attacks: AttackDetails[] = [];

  // MR3 specific Objects
  @FrontendKey
  @Property({ type: "json", nullable: true })
  buildingkeydata?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  buildinghealthdata?: FieldData | null = {};

  // Objects
  @FrontendKey
  @Property({ type: "json", nullable: true })
  buildingdata?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  researchdata?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  stats?: Stats | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  academy?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  rewards?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  aiattacks?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  monsters?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  resources?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  iresources?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  lockerdata?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  events?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  inventory?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  monsterbaiter?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  loot?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "text", nullable: true })
  attackreport?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  storedata?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  coords?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  quests?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  player?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  krallen?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  siege?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  buildingresources?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  mushrooms?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  frontpage?: FieldData | null = {};

  @Property({ type: Date })
  takeoverDate: Date = new Date();

  @Property({ type: Date })
  createdAt: Date = new Date();

  @Property({ type: Date, onUpdate: () => new Date() })
  lastupdateAt: Date = new Date();

  // Client save objects
  @FrontendKey
  @Property({ type: "json", nullable: true })
  attackloot?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  lootreport?: FieldData | null = {};

  @FrontendKey
  @Property({ type: "json", nullable: true })
  attackersiege?: FieldData | null = {};

  // Arrays
  @FrontendKey
  @Property({ type: "json", nullable: true })
  monsterupdate?: FieldData | null = [];

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
  homebase: string[] | null = [];

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
    "tutorialstage",
  ];

  public static attackSaveKeys: (keyof FieldData)[] = [
    "destroyed",
    "damage",
    "locked",
    "protected",
    "monsters",
    "champion",
    "over",
    "buildingdata",
    "buildinghealthdata",
    "buildingresources",
    "attackreport",
    "attackersiege",
    "attackcreatures",
  ];

  public static createMainSave = async (em: EntityManager<PostgreSqlDriver>, user: User) => {
    const baseSave = em.create(Save, getDefaultBaseData(user, BaseType.MAIN) as unknown as RequiredEntityData<Save>);

    const [result] = await em.execute<[{ baseid: string }]>(NEXT_USER_BASEID);
    const baseid = result.baseid;

    baseSave.baseid = baseid;
    baseSave.homebaseid = parseInt(baseid, 10);
    em.persist(baseSave);
    await em.flush();

    user.save = baseSave;
    em.persist(user);
    await em.flush();

    return baseSave;
  };

  public static createInfernoSave = async (em: EntityManager<PostgreSqlDriver>, user: User) => {
    const save = user.save!;
    const infernoSave = em.create(Save, getDefaultBaseData(user, BaseType.INFERNO) as unknown as RequiredEntityData<Save>);

    const [result] = await em.execute<[{ baseid: string }]>(NEXT_USER_BASEID);
    const baseid = result.baseid;

    infernoSave.type = BaseType.INFERNO;
    infernoSave.baseid = baseid;
    infernoSave.homebaseid = parseInt(baseid, 10);
    infernoSave.stats = save.stats;
    infernoSave.worldid = save.worldid;
    infernoSave.credits = 0;
    save.iresources = {
      r1: 59168,
      r2: 60090,
      r3: 59849,
      r4: 55864,
    };

    user.infernosave = infernoSave;
    em.persist(infernoSave);
    await em.flush();

    return infernoSave;
  };
}
