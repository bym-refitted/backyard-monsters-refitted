import { Entity, Index, OneToOne, PrimaryKey, Property } from "@mikro-orm/decorators/es";
import { v4 } from "uuid";
import { Message } from "./message.model.js";
import type { TruceStatus } from "../enums/TruceStatus.js";

@Index({ properties: ["userid", "threadid"] })
@Index({ properties: ["targetid", "threadid"] })
@Entity({ tableName: "thread" })
export class Thread {
  @PrimaryKey({ type: 'string' })
  id: string = v4();

  @Index()
  @Property({ type: 'number', unique: true })
  threadid!: number;

  @Property({ type: 'number' })
  userid!: number;

  @Property({ type: 'number' })
  targetid!: number;

  @OneToOne(() => Message, { nullable: true })
  lastMessage?: Message;

  @Property({ type: 'number' })
  messagecount!: number;

  @Index()
  @Property({ type: 'number', nullable: true })
  truce_id?: number;

  @Property({ type: 'string', nullable: true })
  trucestate?: TruceStatus;

  @Property({ type: Date, onCreate: () => new Date() })
  createdAt: Date = new Date();
}
