import { Message } from "../../models/message.model";
import { ORMContext } from "../../server";

export const countUnreadMessage = (id: number) => {
  return ORMContext.em.count(Message, {
    $or: [
      {
        userid: id,
        userUnread: 1,
      },
      {
        targetid: id,
        targetUnread: 1,
      },
    ],
  });
};
