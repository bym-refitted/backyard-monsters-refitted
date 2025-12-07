import { FilterQuery } from "@mikro-orm/core";
import { Status } from "../../enums/StatusCodes";
import { loadFailureErr } from "../../errors/errors";
import { AttackLogs } from "../../models/attacklogs.model";
import { postgres, redis } from "../../server";
import { KoaController } from "../../utils/KoaController";
import { AttackLogFilter } from "../../enums/AttackLogFilter";
import { User } from "../../models/user.model";

/**
 * Time-to-live (TTL) for attack logs cache in Redis.
 * 30 minutes (1800 seconds).
 * @constant {number}
 */
const AL_CACHE_TTL = 1800;

/**
 * Controller to handle the retrieval of attack logs based on authenticated user ID and filter type.
 *
 * @param {Koa.Context} ctx - The Koa context object.
 * @returns {Promise<void>} - A promise that resolves when the operation is complete.
 */
export const getAttackLogs: KoaController = async (ctx) => {
  const { filter } = ctx.query;
  const { userid }: User = ctx.authUser;

  const filterType = (filter as string) || "both";
  const cacheKey = `attackLogs:${userid}:${filter}`;

  try {
    const cachedAttackLogs = await redis.get(cacheKey);

    if (cachedAttackLogs) {
      ctx.status = Status.OK;
      ctx.body = { attackLogs: JSON.parse(cachedAttackLogs) };
      return;
    }

    let whereCondition: FilterQuery<AttackLogs>;

    switch (filterType) {
      case AttackLogFilter.MY_ATTACKS:
        whereCondition = { attacker_userid: userid };
        break;

      case AttackLogFilter.MY_DEFENCES:
        whereCondition = { defender_userid: userid };
        break;

      case AttackLogFilter.BOTH:
      default:
        whereCondition = {
          $or: [
            { attacker_userid: userid },
            { defender_userid: userid },
          ],
        };
        break;
    }

    const attackLogs = await postgres.em.find(AttackLogs, whereCondition, {
      orderBy: { attacktime: "DESC" },
      limit: 50,
    });

    await redis.setEx(cacheKey, AL_CACHE_TTL, JSON.stringify(attackLogs));

    ctx.status = Status.OK;
    ctx.body = { attackLogs };
  } catch (error) {
    throw loadFailureErr();
  }
};
