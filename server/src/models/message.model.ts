import { Entity, Index, PrimaryKey, Property } from "@mikro-orm/decorators/es";
import { FrontendKey } from "../utils/FrontendKey.js";
import { v4 } from "uuid";

@Index({ properties: ["userid", "userUnread"] })
@Index({ properties: ["targetid", "targetUnread"] })
@Index({ properties: ["userid", "createdAt"] })
@Index({ properties: ["targetid", "createdAt"] })
@Entity({ tableName: "message" })
export class Message {
  @PrimaryKey({ type: 'string' })
  @Property({ type: 'string' })
  id: string = v4();

  @Property({ type: 'string', persist: false })
  @FrontendKey
  messageid!: string;

  @Index()
  @Property({ type: 'number' })
  @FrontendKey
  threadid!: number;

  @FrontendKey
  @Property({ type: 'number' })
  updatetime!: number;

  @Property({ type: 'number' })
  @FrontendKey
  userid!: number;

  @Property({ type: 'number' })
  @FrontendKey
  targetid!: number;

  @Property({ type: 'string' })
  @FrontendKey
  messagetype!: string;

  @Property({ type: 'number' })
  userUnread!: number;

  @Property({ type: 'number' })
  targetUnread!: number;

  @FrontendKey
  @Property({ type: 'number', persist: false })
  unread!: number;

  @Property({ type: 'string', nullable: true, length: 580 })
  @FrontendKey
  message!: string;

  @Property({ type: 'string' })
  @FrontendKey
  subject!: string;

  @Property({ type: 'number', persist: false })
  @FrontendKey
  messagecount!: number;

  @Property({ type: 'string', default: "0" })
  @FrontendKey
  reportid: string = "0";

  @Property({ type: 'string', nullable: true })
  @FrontendKey
  truceid: string | null = null;

  @Property({ type: 'string', nullable: true })
  @FrontendKey
  trucestate: string | null = null;

  @Property({ type: 'string', nullable: true })
  @FrontendKey
  migratestate: string | null = null;

  @Property({ nullable: true, type: "json", columnType: "jsonb" })
  @FrontendKey
  coords: number[] | null = null;

  @Property({ type: 'string', nullable: true })
  @FrontendKey
  worldid: string | null = null;

  @Property({ type: 'string', nullable: true })
  @FrontendKey
  baseid: string | null = null;

  @Property({ type: Date, onCreate: () => new Date() })
  createdAt: Date = new Date();

  selectUnread(userid: number) {
    this.unread = this.userid === userid ? this.userUnread : this.targetUnread;
  }
}
