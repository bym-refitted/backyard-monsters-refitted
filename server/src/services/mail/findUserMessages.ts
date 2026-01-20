import { Message } from "../../models/message.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";

type MessageFilter = { threadid: number };

/**
 * Finds messages for a given user based on the provided filter.
 * Returns an array of messages that match the filter criteria.
 *
 * @param {User} user - The user for whom to find messages.
 * @param {MessageFilter} filter - The filter criteria for finding messages.
 * @returns {Promise<Loaded<Message, never>[]>} - A promise that resolves to an array of messages.
 */
export const findUserMessages = async (user: User, filter: MessageFilter) => {
  const messages = await postgres.em.find(
    Message,
    {
      $or: [{ userid: user.userid }, { targetid: user.userid }],
      ...filter,
    },
    {
      orderBy: { createdAt: "ASC" },
    }
  );

  return messages.map((message, index) => {
    message.selectUnread(user.userid);
    message.messageid = index.toString();

    return message;
  });
};
