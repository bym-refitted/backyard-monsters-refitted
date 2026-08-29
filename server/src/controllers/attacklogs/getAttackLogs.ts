import type { FilterQuery } from "@mikro-orm/core";
import { Status } from "../../enums/StatusCodes.js";
import { loadFailureErr } from "../../errors/errors.js";
import { AttackLogs } from "../../models/attacklogs.model.js";
import { postgres, redis } from "../../server.js";
import type { KoaController } from "../../utils/KoaController.js";
import { AttackLogFilter } from "../../enums/AttackLogFilter.js";
import { User } from "../../models/user.model.js";

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
  // Key on the normalised filterType, not the raw query string: `?filter=garbage`
  // falls through to `both` data, and keying it under `garbage` would cache that
  // under a key persistBattleReport can never bust.
  const cacheKey = `attackLogs:${userid}:${filterType}`;

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

    // Explicit projection: the list view never needs the (potentially large)
    // `attackreport` jsonb — that is served per-row by GET /attacklogs/:id — and
    // `attackid` is an internal correlation key. Excluding `attackreport` here
    // also keeps it out of the 30-minute Redis cache.
    const attackLogs = await postgres.em.find(AttackLogs, whereCondition, {
      orderBy: { attacktime: "DESC" },
      limit: 50,
      fields: [
        "id",
        "attacker_userid",
        "attacker_username",
        "attacker_pic_square",
        "defender_userid",
        "defender_username",
        "defender_pic_square",
        "type",
        "x",
        "y",
        "loot",
        "attacktime",
      ],
    });

    await redis.setex(cacheKey, AL_CACHE_TTL, JSON.stringify(attackLogs));

    ctx.status = Status.OK;
    ctx.body = { attackLogs };
  } catch (error) {
    throw loadFailureErr();
  }
};
