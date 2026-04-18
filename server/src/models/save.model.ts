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
import type { ChampionData } from "../types/ChampionData.js";
import type { JsonObject } from "../types/JsonObject.js";

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
  @Property({ columnType: "jsonb" })
  champion: ChampionData[] = [];

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  empiredestroyed!: number;

  @FrontendKey
  @Property({ type: 'string', nullable: true })
  worldid?: string | null;

  @Property({ type: 'number', nullable: true })
  mapversion?: number | null;

  @Property({ type: 'boolean', default: false })
  mr2upgraded: boolean = false;

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
  @Property({ columnType: "jsonb" })
  attacks: AttackDetails[] = [];

  // MR3 specific Objects
  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  buildingkeydata?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  buildinghealthdata?: JsonObject | null = {};

  // Objects
  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  buildingdata?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  researchdata?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  stats?: Stats | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  academy?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  rewards?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  aiattacks?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  monsters?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  resources?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  iresources?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  lockerdata?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  events?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  inventory?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  monsterbaiter?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  loot?: JsonObject | null = {};

  @FrontendKey
  @Property({ type: "text", nullable: true })
  attackreport?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  storedata?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  coords?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  quests?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  player?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  krallen?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  siege?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  buildingresources?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  mushrooms?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  frontpage?: JsonObject | null = {};

  @Property({ type: Date })
  takeoverDate: Date = new Date();

  @Property({ type: Date })
  createdAt: Date = new Date();

  @Property({ type: Date, onUpdate: () => new Date() })
  lastupdateAt: Date = new Date();

  // Client save objects
  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  attackloot?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  lootreport?: JsonObject | null = {};

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  attackersiege?: JsonObject | null = {};

  // Arrays
  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  monsterupdate?: JsonObject | null = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  savetemplate: any[] = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  updates: any[] = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  effects: (string | number)[][] = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  homebase: string[] | null = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  outposts: [number, number, string][] = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  wmstatus: number[][] = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  chatservers: string[] = ["bym-chat.kixeye.com"];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  achieved: any[] = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  gifts: any[] = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  sentinvites: any[] = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  sentgifts: any[] = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  fbpromos: any[] = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  powerups: string[] = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  attpowerups: string[] = [];

  public static saveKeys: (keyof Save)[] = [
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

  public static attackSaveKeys: (keyof Save)[] = [
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
