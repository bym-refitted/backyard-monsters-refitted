import { Entity, Index, PrimaryKey, Property } from "@mikro-orm/core";
import { ORMContext } from "../server";
import { FrontendKey } from "../utils/FrontendKey";
import { v4 } from "uuid";
import { User } from "./user.model";

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
  threadid!: string;

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

  @Property()
  @FrontendKey
  message!: string;

  @Property()
  @FrontendKey
  subject!: string;

  @Property({ persist: false })
  @FrontendKey
  messagecount!: number;

  @Property({ nullable: true })
  @FrontendKey
  reportid: string;

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

  selectUnread(currentUserId: number): void {
    this.unread =
      this.userid === currentUserId ? this.userUnread : this.targetUnread;
  }

  setAsRead(currentUserId: number): void {
    if (this.userid === currentUserId) {
      this.userUnread = 0;
      this.unread = this.userUnread;
      return;
    }
    this.targetUnread = 0;
    this.unread = this.targetUnread;
  }

  public static async countUnreadMessage(id: number) {
    return ORMContext.em.count(Message, {
      $or: [
        {
          userid: id,
          userUnread: 1,
        },
        {
          targetid: id,
          targetUnread: 1,
        },
      ],
    });
  }

  public static async findUserMessages(user: User, additionalQuery: object) {
    const messages = await ORMContext.em.find(
      Message,
      {
        $or: [{ userid: user.userid }, { targetid: user.userid }],
        ...additionalQuery,
      },
      {
        orderBy: { createdAt: "ASC" },
      }
    );
    messages.forEach((message, index) => {
      message.selectUnread(user.userid);
      message.messageid = index.toString();
    });
    return messages;
  }
}
