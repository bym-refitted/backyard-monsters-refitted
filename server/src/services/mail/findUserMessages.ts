import { Message } from "../../models/message.model";
import { User } from "../../models/user.model";
import { ORMContext } from "../../server";

export const findUserMessages = async (user: User, additionalQuery: object) => {
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
};
