import { mailboxErr } from "../../errors/errors.js";
import { Thread } from "../../models/thread.model.js";
import { postgres } from "../../server.js";

/**
 * Find an existing thread by ID and user, or create a new one if no valid ID is given.
 *
 * @param {number} threadId - ID of the thread to find (0 to create a new thread).
 * @param {number} userId - The requesting user ID.
 * @param {number} targetId - The other participant's user ID.
 * @returns {Promise<Thread>} - A found or newly created Thread entity.
 */
export const findOrCreateThread = async (threadId: number, targetId: number, userId: number) => {
  // First, we attempt to find an existing thread
  if (threadId > 0) {
    const thread = await postgres.em.findOne(Thread, {
      threadid: threadId,
      $or: [{ userid: userId }, { targetid: userId }],
    });

    if (!thread) throw mailboxErr();
    
    return thread;
  }

  // Otherwise, create a new thread
  const [lastThread] = await postgres.em.find(
    Thread,
    {},
    { orderBy: { threadid: "DESC" }, limit: 1 }
  );

  const newThread = new Thread();
  newThread.userid = userId;
  newThread.targetid = targetId;
  newThread.threadid = lastThread ? lastThread.threadid + 1 : 1;
  newThread.messagecount = 0;

  await postgres.em.persistAndFlush(newThread);
  return newThread;
};
