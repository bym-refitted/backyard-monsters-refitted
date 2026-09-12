import { Entity, Property, PrimaryKey, OneToOne, Index } from "@mikro-orm/decorators/es";
import { EntityManager, PostgreSqlDriver } from "@mikro-orm/postgresql";
import { FrontendKey } from "../../utils/FrontendKey.js";
import { getDefaultBaseData } from "../../game-data/getDefaultBaseData.js";
import { User } from "./user.model.js";
import { BaseType } from "../../enums/Base.js";
import { WorldMapCell } from "./worldmapcell.model.js";
import { BigIntType, type Opt, PrimaryKeyProp, UniqueConstraintViolationException } from "@mikro-orm/core";
import type { AttackDetails } from "../../controllers/base/load/modes/baseModeAttack.js";
import type { Stats } from "../../services/events/wmi/invasionUtils.js";
import type { ChampionData } from "../../schemas/ChampionSchema.js";
import type { JsonObject } from "../../types/JsonObject.js";
import type { BuildingData } from "../../types/BuildingData.js";
import { MapRoomVersion } from "../../enums/MapRoom.js";

const NEXT_USER_BASEID = `SELECT nextval('bym.user_baseid_seq') AS baseid`;

@Index({ properties: ["type", "worldid", "userid"] })
@Index({ properties: ["userid", "type"] })
@Entity({ tableName: "save" })
export class Save {

  [PrimaryKeyProp]?: "basesaveid";

  // IDs & Foreign Keys
  @FrontendKey
  @PrimaryKey({ autoincrement: true, type: 'number' })
  basesaveid!: number;

  @Index()
  @FrontendKey
  @Property({ type: 'string', default: "0" })
  baseid!: Opt<string>;

  @OneToOne({
    nullable: true,
    orphanRemoval: true,
    inversedBy: "save",
    entity: () => WorldMapCell,
  })
  cell?: WorldMapCell | null;

  @FrontendKey
  @Property({ type: new BigIntType('number'), default: 0 })
  homebaseid!: Opt<number>;

  @Index()
  @FrontendKey
  @Property({ type: 'number' })
  userid!: number;

  @FrontendKey
  @Property({ type: 'number' })
  saveuserid!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  attackid!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  id!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  baseid_inferno!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  wmid!: Opt<number>;

  // Primatives
  @Index()
  @FrontendKey
  @Property({ type: 'string', default: "main" })
  type!: Opt<string>;

  @FrontendKey
  @Property({ type: 'number' })
  createtime!: number;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  savetime!: Opt<number>; // Updates each time a save is triggered

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  seed!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  bookmarked!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  fan!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  emailshared!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  unreadmessages!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  giftsentcount!: Opt<number>;

  @FrontendKey
  @Property({ type: 'boolean', default: false })
  canattack!: Opt<boolean>;

  @FrontendKey
  @Property({ type: 'string', nullable: true })
  fbid?: string | null;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  fortifycellid!: Opt<number>;

  @FrontendKey
  @Property({ type: 'string' })
  name!: string;

  @FrontendKey
  @Property({ type: 'number', default: 1 })
  level!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  catapult!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  flinger!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  destroyed!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  damage!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  locked!: Opt<number>;

  @FrontendKey
  @Property({ type: 'string', default: "0" })
  points!: Opt<string>;

  @FrontendKey
  @Property({ type: 'string', default: "0" })
  basevalue!: Opt<string>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  tutorialstage!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 1 })
  protected!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  lastupdate!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  usemap!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', check: "credits >= 0" })
  credits!: number;

  @Property({ type: 'number', default: 0 })
  monthly_credits: Opt<number> = 0;

  @FrontendKey
  @Property({ columnType: "jsonb" })
  champion: Opt<ChampionData[]> = [];

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  empiredestroyed!: Opt<number>;

  @FrontendKey
  @Property({ type: 'string', nullable: true })
  worldid?: string | null;

  @Property({ type: 'number', default: MapRoomVersion.V1 })
  mapversion: Opt<number> = MapRoomVersion.V1;

  @Property({ type: 'boolean', default: false })
  mr2upgraded: Opt<boolean> = false;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  event_score!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  chatenabled!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  relationship!: Opt<number>;

  // Client save primitives
  @FrontendKey
  @Property({ type: 'number', default: 0 })
  timeplayed!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 128 })
  version!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  clienttime!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  baseseed!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  healtime!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  empirevalue!: Opt<number>;

  @FrontendKey
  @Property({ type: 'string', default: "basename" })
  basename!: Opt<string>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  over!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  protect!: Opt<number>;

  @Property({ type: 'string', nullable: true })
  lastattackername?: string | null;

  @FrontendKey
  @Property({ type: 'number', default: 0 })
  purchasecomplete!: Opt<number>;

  @FrontendKey
  @Property({ type: 'number', nullable: true })
  cantmovetill?: number | null;

  // Attack Objects
  @FrontendKey
  @Property({ columnType: "jsonb" })
  attacks: Opt<AttackDetails[]> = [];

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
  buildingdata?: Record<string, BuildingData> | null = {};

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
  @Property({ columnType: "jsonb", type: "json", nullable: true })
  krallen?: JsonObject | null = null;

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
  takeoverDate: Opt<Date> = new Date();

  @Property({ type: Date })
  createdAt: Opt<Date> = new Date();

  @Property({ type: Date, onUpdate: () => new Date() })
  lastupdateAt: Opt<Date> = new Date();

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
  savetemplate: Opt<any[]> = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  updates: Opt<any[]> = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  effects: Opt<(string | number)[][]> = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  homebase: string[] | null = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  outposts: Opt<[number, number, string][]> = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  wmstatus: Opt<number[][]> = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  chatservers: Opt<string[]> = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  achieved: Opt<any[]> = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  gifts: Opt<any[]> = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  sentinvites: Opt<any[]> = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  sentgifts: Opt<any[]> = [];

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  fbpromos: Opt<any[]> = [];


  public static saveKeys: Extract<keyof Save, string>[] = [
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

  public static attackSaveKeys: Extract<keyof Save, string>[] = [
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
    try {
      const baseSave = em.create(Save, getDefaultBaseData(user, BaseType.MAIN));

      const [result] = await em.execute<[{ baseid: string }]>(NEXT_USER_BASEID);
      const baseid = result.baseid;

      baseSave.baseid = baseid;
      baseSave.homebaseid = parseInt(baseid, 10);

      em.persist(baseSave);
      await em.flush();
    } catch (err) {
      if (!(err instanceof UniqueConstraintViolationException)) throw err;
    }

    const mainSave = await em.findOneOrFail(Save, { userid: user.userid, type: BaseType.MAIN });

    user.save = mainSave;
    em.persist(user);
    await em.flush();

    return mainSave;
  };

  public static createInfernoSave = async (em: EntityManager<PostgreSqlDriver>, user: User) => {
    const save = user.save!;
    const infernoSave = em.create(Save, getDefaultBaseData(user, BaseType.INFERNO));

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
