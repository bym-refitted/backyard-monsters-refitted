import { MapRoomVersion } from "../../enums/MapRoom.js";
import { Status } from "../../enums/StatusCodes.js";
import { mailboxErr } from "../../errors/errors.js";
import { Thread } from "../../database/models/thread.model.js";
import { User } from "../../database/models/user.model.js";
import { postgres } from "../../server.js";
import { getFriendIds } from "../../services/friends/friendList.js";
import type { KoaController } from "../../utils/KoaController.js";

interface TargetUser {
  friend: number;
  mapver: number;
  first_name: string;
  last_name?: string;
  pic_square?: string | null | undefined;
}

type TargetUsers = Record<number, TargetUser>;

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

    const [threads, friendIds] = await Promise.all([
      postgres.em.find(
        Thread,
        {
          $or: [{ userid: user.userid }, { targetid: user.userid }],
        },
        { orderBy: { threadid: "DESC" } }
      ),

      getFriendIds(user.userid),
    ]);

    const partnerIds = threads.map((thread) => thread.userid === user.userid ? thread.targetid : thread.userid);

    const blocked = new Set(user.blockedUsers);

    const targetIds = [...new Set([...partnerIds, ...friendIds])].filter((targetId) => !blocked.has(targetId));

    if (!targetIds.length) {
      ctx.status = Status.OK;
      ctx.body = { targets: {} };
      return;
    }

    const users = await postgres.em.find(
      User,
      {
        userid: { $in: targetIds },
      },
      {
        fields: ["userid", "username", "last_name", "pic_square", "save.mapversion"],
      }
    );

    const targets: TargetUsers = Object.fromEntries(
      users.map((target) => [
        target.userid,
        {
          friend: friendIds.has(target.userid) ? 1 : 0,
          mapver: target.save?.mapversion ?? MapRoomVersion.V1,
          first_name: target.username,
          last_name: target.last_name,
          pic_square: target.pic_square,
        },
      ])
    );

    ctx.status = Status.OK;
    ctx.body = { targets };
  } catch (err) {
    throw mailboxErr();
  }
};
