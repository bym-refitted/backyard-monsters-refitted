import { Entity, Index, OneToOne, PrimaryKey, Property } from "@mikro-orm/core";
import { v4 } from "uuid";
import { Message } from "./message.model";

@Index({ properties: ["userid", "threadid"] })
@Index({ properties: ["targetid", "threadid"] })
@Entity({ tableName: "thread" })
export class Thread {
  @PrimaryKey()
  id: string = v4();

  @Index()
  @Property({ unique: true })
  threadid!: number;

  @Property()
  userid!: number;

  @Property()
  targetid!: number;

  @OneToOne(() => Message, { nullable: true })
  lastMessage?: Message;

  @Property()
  messagecount!: number;

  @Property({ onCreate: () => new Date() })
  createdAt: Date = new Date();
}
