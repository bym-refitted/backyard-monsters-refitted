import { Entity, Property, PrimaryKey, OneToOne, Index } from "@mikro-orm/core";
import { FieldData, Save } from "./save.model";
import { FrontendKey } from "../utils/FrontendKey";

@Entity({ tableName: "user" })
export class User {
  @FrontendKey
  @PrimaryKey({ autoincrement: true })
  userid!: number;

  @OneToOne(() => Save, { nullable: true })
  save?: Save;
  
  @OneToOne(() => Save, { nullable: true })
  infernosave?: Save;

  @Property({ unique: true })
  @FrontendKey
  username!: string;

  @Property({ default: false })
  banned?: boolean;

  @FrontendKey
  @Property({ unique: true })
  @Index()
  email!: string;

  @Property()
  password!: string;

  @Property({ default: false })
  discord_verified: boolean;

  @Property({ nullable: true })
  discord_id: string;

  @Property({ nullable: true })
  discord_tag: string;

  @Property({ type: "json", nullable: true })
  ban_report?: FieldData;

  @Property({ default: "" })
  @FrontendKey
  last_name?: string;

  @Property({ default: "" })
  resetToken?: string;

  @FrontendKey
  @Property({ nullable: true })
  pic_square?: string;

  @FrontendKey
  @Property({ default: 0 })
  timeplayed?: number;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  stats?: FieldData;

  @FrontendKey
  @Property({ default: 0 })
  friendcount?: number;

  @FrontendKey
  @Property({ default: 0 })
  sessioncount?: number;

  @FrontendKey
  @Property({ default: 100 })
  addtime?: number;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  bookmarks?: FieldData;

  @FrontendKey
  @Property({ default: 0 })
  _isFan?: number;

  @FrontendKey
  @Property({ default: 0 })
  sendgift?: number;

  @FrontendKey
  @Property({ default: 0 })
  sendinvite?: number;
}
