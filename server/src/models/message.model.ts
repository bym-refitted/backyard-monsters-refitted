import { Entity, Index, PrimaryKey, Property } from "@mikro-orm/core";
import { FrontendKey } from "../utils/FrontendKey";
import { v4 } from "uuid";

@Index({ properties: ["userid", "userUnread"] })
@Index({ properties: ["targetid", "targetUnread"] })
@Index({ properties: ["userid", "createdAt"] })
@Index({ properties: ["targetid", "createdAt"] })
@Entity({ tableName: "message" })
export class Message {
  @PrimaryKey()
  @Property()
  id: string = v4();

  @Property({ persist: false })
  @FrontendKey
  messageid: string;

  @Index()
  @Property()
  @FrontendKey
  threadid!: number;

  @FrontendKey
  @Property()
  updatetime!: number;

  @Property()
  @FrontendKey
  userid!: number;

  @Property()
  @FrontendKey
  targetid!: number;

  @Property()
  @FrontendKey
  messagetype!: string;

  @Property()
  userUnread!: number;

  @Property()
  targetUnread!: number;

  @FrontendKey
  @Property({ persist: false })
  unread: number;

  @Property({ nullable: true, length: 580 })
  @FrontendKey
  message: string;

  @Property()
  @FrontendKey
  subject!: string;

  @Property({ persist: false })
  @FrontendKey
  messagecount!: number;

  @Property({ default: "0" })
  @FrontendKey
  reportid: string = "0";

  @Property({ nullable: true })
  @FrontendKey
  truceid: string;

  @Property({ nullable: true })
  @FrontendKey
  trucestate: string;

  @Property({ nullable: true })
  @FrontendKey
  migratestate: string;

  @Property({ nullable: true, type: "json" })
  @FrontendKey
  coords: number[];

  @Property({ nullable: true })
  @FrontendKey
  worldid: string;

  @Property({ nullable: true })
  @FrontendKey
  baseid: string;

  @Property({ onCreate: () => new Date() })
  createdAt: Date = new Date();

  selectUnread(userid: number) {
    this.unread = this.userid === userid ? this.userUnread : this.targetUnread;
  }
}
