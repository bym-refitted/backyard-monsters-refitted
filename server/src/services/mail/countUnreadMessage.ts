import { Message } from "../../models/message.model";
import { postgres } from "../../server";

/**
 * Count unread messages for a user.
 * This function counts the number of unread messages for a given user ID.
 *
 * @param {number} userid - The user ID for which to count unread messages.
 * @returns
 */
export const countUnreadMessage = (userid: number) => {
  return postgres.em.count(Message, {
    $or: [
      {
        userid: userid,
        userUnread: 1,
      },
      {
        targetid: userid,
        targetUnread: 1,
      },
    ],
  });
};
