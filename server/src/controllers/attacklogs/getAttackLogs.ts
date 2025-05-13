import { FilterQuery } from "@mikro-orm/core";
import { Status } from "../../enums/StatusCodes";
import { loadFailureErr } from "../../errors/errors";
import { AttackLogs } from "../../models/attacklogs.model";
import { ORMContext, redisClient } from "../../server";
import { KoaController } from "../../utils/KoaController";
import { AttackLogFilter } from "../../enums/AttackLogFilter";

/**
 * Time-to-live (TTL) for attack logs cache in Redis.
 * 30 minutes (1800 seconds).
 * @constant {number}
 */
const AL_CACHE_TTL = 1800;

/**
 * Controller to handle the retrieval of attack logs based on user ID and filter type.
 *
 * @param {Koa.Context} ctx - The Koa context object.
 * @returns {Promise<void>} - A promise that resolves when the operation is complete.
 */
export const getAttackLogs: KoaController = async (ctx) => {
  const { userid, filter } = ctx.query;

  if (!userid) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: "userid is required" };
    return;
  }

  const parsedUserId = parseInt(userid as string);
  const filterType = (filter as string) || "both";
  const cacheKey = `attackLogs:${userid}:${filter}`;

  try {
    const cachedAttackLogs = await redisClient.get(cacheKey);

    if (cachedAttackLogs) {
      ctx.status = Status.OK;
      ctx.body = { attackLogs: JSON.parse(cachedAttackLogs) };
      return;
    }

    let whereCondition: FilterQuery<AttackLogs>;

    switch (filterType) {
      case AttackLogFilter.MY_ATTACKS:
        whereCondition = { attacker_userid: parsedUserId };
        break;

      case AttackLogFilter.MY_DEFENCES:
        whereCondition = { defender_userid: parsedUserId };
        break;

      case AttackLogFilter.BOTH:
      default:
        whereCondition = {
          $or: [
            { attacker_userid: parsedUserId },
            { defender_userid: parsedUserId },
          ],
        };
        break;
    }

    const attackLogs = await ORMContext.em.find(AttackLogs, whereCondition, {
      orderBy: { attacktime: "DESC" },
      limit: 50,
    });

    await redisClient.setEx(cacheKey, AL_CACHE_TTL, JSON.stringify(attackLogs));

    ctx.status = Status.OK;
    ctx.body = { attackLogs };
  } catch (error) {
    throw loadFailureErr();
  }
};
