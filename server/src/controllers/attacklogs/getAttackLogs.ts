import { Status } from "../../enums/StatusCodes";
import { loadFailureErr } from "../../errors/errors";
import { AttackLogs } from "../../models/attacklogs.model";
import { ORMContext } from "../../server";
import { KoaController } from "../../utils/KoaController";

export const getAttackLogs: KoaController = async (ctx) => {
  const { userid } = ctx.query;

  if (!userid) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: "userid is required" };
    return;
  }

  const parsedUserId = parseInt(userid as string);

  try {
    const attackLogs = await ORMContext.em.find(AttackLogs, {
      $or: [
        { attacker_userid: parsedUserId },
        { defender_userid: parsedUserId }
      ]
    }, {
      orderBy: { attacktime: 'DESC' },
      limit: 50
    });

    ctx.status = Status.OK;
    ctx.body = { attackLogs };
  } catch (error) {
    throw loadFailureErr();
  }
};
