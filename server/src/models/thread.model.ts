import { Entity, Index, OneToOne, PrimaryKey, Property, Unique } from "@mikro-orm/core";

import { v4 } from "uuid";
import { Message } from "./message.model";

@Entity({ tableName: "thread" })
@Unique({ properties: ["threadid"] })
@Index({ properties: ['userid', 'threadid'] })
@Index({ properties: ['targetid', 'threadid'] })
export class Thread {

  @PrimaryKey()
  id: string = v4();

  @Index()
  @Unique()
  @Property()
  threadid!: number;

  @Property()
  userid!: number;

  @Property()
  targetid!: number;

  @Property({ onCreate: () => new Date() })
  createdAt: Date = new Date();

  @Property()
  messagecount!: number;

  @OneToOne(() => Message, { nullable: true })
  lastMessage?: Message;
}
