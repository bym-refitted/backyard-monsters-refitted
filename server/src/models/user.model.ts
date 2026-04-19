import {
  Entity,
  Property,
  PrimaryKey,
  OneToOne,
  Index,
} from "@mikro-orm/decorators/es";
import { Save } from "./save.model.js";
import { FrontendKey } from "../utils/FrontendKey.js";
import type { JsonObject } from "../types/JsonObject.js";

@Entity({ tableName: "user" })
export class User {
  @FrontendKey
  @PrimaryKey({ autoincrement: true, type: "number" })
  userid!: number;

  @OneToOne(() => Save, { nullable: true })
  save?: Save | null;

  @OneToOne(() => Save, { nullable: true })
  infernosave?: Save | null;

  @Property({ type: "string", unique: true })
  @FrontendKey
  username!: string;

  @Property({ type: "boolean", default: false })
  banned: boolean = false;

  @FrontendKey
  @Property({ type: "string", unique: true })
  @Index()
  email!: string;

  @Property({ type: "string" })
  password!: string;

  @Property({ type: "boolean", default: false })
  discord_verified: boolean = false;

  @Property({ type: "string", nullable: true })
  discord_id?: string | null;

  @Property({ type: "string", nullable: true })
  discord_tag?: string | null;

  @Property({ type: "Date", nullable: true })
  discord_avatar_checked_at?: Date | null;

  @Property({ type: "string", default: "" })
  @FrontendKey
  last_name: string = "";

  @Property({ type: "string", default: "" })
  resetToken: string = "";

  @FrontendKey
  @Property({ type: "string", nullable: true })
  pic_square?: string | null;

  @FrontendKey
  @Property({ type: "number", default: 0 })
  timeplayed: number = 0;

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  stats?: JsonObject | null = {};

  @FrontendKey
  @Property({ type: "number", default: 0 })
  friendcount: number = 0;

  @FrontendKey
  @Property({ type: "number", default: 0 })
  sessioncount: number = 0;

  @FrontendKey
  @Property({ type: "number", default: 100 })
  addtime: number = 100;

  @FrontendKey
  @Property({ columnType: "jsonb", nullable: true })
  bookmarks?: JsonObject | null = {};

  @Index({ name: "idx_user_blocked_users", type: "gin" })
  @Property({ columnType: "jsonb" })
  blockedUsers: number[] = [];

  @FrontendKey
  @Property({ type: "number", default: 0 })
  _isFan: number = 0;

  @FrontendKey
  @Property({ type: "number", default: 0 })
  sendgift: number = 0;

  @FrontendKey
  @Property({ type: "number", default: 0 })
  sendinvite: number = 0;
}
