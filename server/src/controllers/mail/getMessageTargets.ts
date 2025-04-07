import { Status } from "../../enums/StatusCodes";
import { debugClientErr } from "../../errors/errors";
import { Thread } from "../../models/thread.model";
import { User } from "../../models/user.model";
import { ORMContext } from "../../server";
import { KoaController } from "../../utils/KoaController";

/**
 * Controller to get message targets for MailBox/FriendPicker.
 *
 * This controller get message targets
 *
 * @param {Context} ctx - The Koa context object, which includes the request body.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 * @throws {Error} - Throws an error if the request body is missing required fields or if logging fails.
 */
export const getMessageTargets: KoaController = async (ctx) => {
  try {
    const user: User = ctx.authUser;

    const threads = await ORMContext.em.find(Thread, {
          $or: [
            { userid: user.userid },
            { targetid: user.userid }
          ]
        }, { orderBy: { threadid: "DESC" } });
    const userIds = new Set();
    threads.forEach(thread => {
      userIds.add(thread.userid);
      userIds.add(thread.targetid);
    });
    userIds.delete(user.userid);
    const userIdArray = Array.from(userIds) as number[];
    const users = await ORMContext.em.find(User, {
      userid: { $in: userIdArray }
    }, {
      fields: ['userid', 'username', 'last_name', 'pic_square']
    });
    const mappedTargets = users.reduce((dictionary, item) => {
        const key = item.userid;
        dictionary[key] = {
          friend: 0,
          mapver: 2,
          first_name: item.username,
          last_name: item.last_name,
          pic_square: item.pic_square
        };
        return dictionary;
      }, {});

    ctx.body = { 
      targets: mappedTargets
    };
    ctx.status = Status.OK;
  } catch (err) {
    throw debugClientErr();
  }
};
