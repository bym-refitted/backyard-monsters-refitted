import { Entity, Index, PrimaryKey, Property } from "@mikro-orm/core";

import { ORMContext } from "../server";
import { FrontendKey } from "../utils/FrontendKey";
import { v4 } from "uuid";

@Entity({ tableName: "message" })
@Index({ properties: ["userid", "userUnread"] })  // Optimizes unread count
@Index({ properties: ["targetid", "targetUnread"] })  // Optimizes unread count
@Index({ properties: ["userid", "createdAt"] })  // Optimizes message retrieval
@Index({ properties: ["targetid", "createdAt"] })  // Optimizes message retrieval
export class Message {
  @PrimaryKey()
  @Property()
  id: string = v4();

  @Property({ persist: false })
  @FrontendKey
  messageid: string;

  @Property()
  @FrontendKey
  @Index()
  threadid!: string;

  @FrontendKey
  @Property()
  updatetime!: number;

  @Property({ onCreate: () => new Date() })
  createdAt: Date = new Date();

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
  userUnread!: number; //shouldn't trigger updateAt & updatetime
  
  @Property()
  targetUnread!: number; //shouldn't trigger updateAt & updatetime
  
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

  @Property({ nullable: true})
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

  @Property({ nullable: true, type: 'json' })
  @FrontendKey
  coords: number[];

  @Property({ nullable: true })
  @FrontendKey
  worldid: string;

  @Property({ nullable: true })
  @FrontendKey
  baseid: string;

  selectUnread(currentUserId: number): void {
    this.unread = this.userid === currentUserId ? this.userUnread: this.targetUnread
  }

  setAsRead(currentUserId: number): void {
    if(this.userid === currentUserId) {
      this.userUnread = 0;
      this.unread = this.userUnread;
      return;
    }
    this.targetUnread = 0;
    this.unread = this.targetUnread;
  }

  public static async findUserMessages(user, additionalQuery) {
    const messages = await ORMContext.em.find(
          Message,
          {
            $or: [
              { userid: user.userid },
              { targetid: user.userid }
            ],
            ...additionalQuery
          },
          {
            orderBy: { createdAt: 'ASC' }
          }
        );
    messages.forEach((message, index) => { 
      message.selectUnread(user.userid); 
      message.messageid = index.toString();
    });
    return messages;
  }
}
