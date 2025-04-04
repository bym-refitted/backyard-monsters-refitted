import { Entity, Index, OneToOne, PrimaryKey, Property, Unique } from "@mikro-orm/core";

import { v4 } from "uuid";
import { ORMContext } from "../server";
import { Message } from "./message.model";
import { saveFailureErr } from "../errors/errors";

@Entity({ tableName: "thread" })
@Unique({ properties: ["threadid"] })
@Index({ properties: ['userid', 'targetid', 'threadid'], name: 'idx_thread_user_target' }) 
export class Thread {

  @PrimaryKey()
  id: string = v4();

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

  private static async findThread(threadId: number, userId: number, targetId: number) {
    if (threadId === 0) {
      return null;
    }
    const foundThread = await ORMContext.em.findOne(Thread, {
      threadid: threadId,
      $or: [
        { userid: userId },
        { targetid: userId}
      ]
    }, { orderBy: { threadid: "DESC" } });

    return foundThread;
  }

  public static async findOrCreateThread(threadId: number, userId: number, targetId: number): Promise<Thread> {
    const foundedThread = await this.findThread(threadId, userId, targetId);
    if (foundedThread) {
      return foundedThread;
    }
    if (threadId !== 0 && !foundedThread) {
      throw saveFailureErr();
    }
    // if threadId is 0
    const [lastThread] = await ORMContext.em.find(Thread, {}, { orderBy: { threadid: "DESC" }, limit: 1 });
    const newThread = new Thread();
    newThread.userid = userId;
    newThread.targetid = targetId;
    newThread.threadid = lastThread ? lastThread.threadid + 1 : 1;
    newThread.messagecount = 0;
    await ORMContext.em.persistAndFlush(newThread);

    return newThread;
  }
}
