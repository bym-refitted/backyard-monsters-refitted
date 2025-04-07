import { saveFailureErr } from "../../errors/errors";
import { Thread } from "../../models/thread.model";
import { ORMContext } from "../../server";

const findThread = async (threadId: number, userId: number) => {
    const foundThread = await ORMContext.em.findOne(Thread, {
      threadid: threadId,
      $or: [
        { userid: userId },
        { targetid: userId}
      ]
    });

    return foundThread;
  }

export const findOrCreateThread = async (threadId: number, userId: number, targetId: number): Promise<Thread> => {
    if (threadId === 0) {
        const [lastThread] = await ORMContext.em.find(Thread, {}, { orderBy: { threadid: "DESC" }, limit: 1 });
        const newThread = new Thread();
        newThread.userid = userId;
        newThread.targetid = targetId;
        newThread.threadid = lastThread ? lastThread.threadid + 1 : 1;
        newThread.messagecount = 0;
        await ORMContext.em.persistAndFlush(newThread);
    
        return newThread;
    }
    const foundedThread = await findThread(threadId, userId);
    if (!foundedThread) {
      throw saveFailureErr();
    }
    return foundedThread;
  }