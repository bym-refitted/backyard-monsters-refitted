import { MapRoomVersion } from "../../enums/MapRoom.js";
import { Status } from "../../enums/StatusCodes.js";
import { mailboxErr } from "../../errors/errors.js";
import { Thread } from "../../models/thread.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { KoaController } from "../../utils/KoaController.js";

interface TargetUser {
  friend: number;
  mapver: number;
  first_name: string;
  last_name?: string;
  pic_square: string;
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

    const threads = await postgres.em.find(
      Thread,
      {
        $or: [{ userid: user.userid }, { targetid: user.userid }],
      },
      { orderBy: { threadid: "DESC" } }
    );

    if (!threads.length) {
      ctx.status = Status.OK;
      ctx.body = { targets: {} };
      return;
    }

    // Unique user IDs that have had message threads with the authenticated user
    const conversationPartnerIds = [
      ...new Set(
        threads.map((thread) =>
          thread.userid === user.userid ? thread.targetid : thread.userid
        )
      ),
    ];

    const users = await postgres.em.find(
      User,
      {
        userid: { $in: conversationPartnerIds },
      },
      {
        fields: ["userid", "username", "last_name", "pic_square"],
      }
    );

    const targets: TargetUsers = Object.fromEntries(
      users.map((user) => [
        user.userid,
        {
          friend: 0,
          mapver: MapRoomVersion.V2,
          first_name: user.username,
          last_name: user.last_name,
          pic_square: user.pic_square,
        },
      ])
    );

    ctx.status = Status.OK;
    ctx.body = { targets };
  } catch (err) {
    throw mailboxErr();
  }
};
