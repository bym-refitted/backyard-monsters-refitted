import { Status } from "../../../../enums/StatusCodes.js";
import { getPlayerBases, MAX_PLAYER_LOOKUP } from "../../../../services/maproom/v2/playerBases.js";
import { getCurrentDateTime } from "../../../../utils/getCurrentDateTime.js";
import type { KoaController } from "../../../../utils/KoaController.js";

/**
 * THIS ENDPOINT IS FOR API CONSUMERS ONLY.
 * ____________________________________________________________
 *
 * Serves the monster housing and outpost production of specific players'
 * bases: the per-base counterpart to /worldmapv2/snapshot, read live for the
 * uids requested.
 *
 * Auth
 *   X-API-Key   An active key from bym.api_consumer (see `bun run consumer:create`). Required.
 *
 * Query
 *   uid   Comma-separated player ids, at most 25. Required.
 *
 * Body
 *   application/json
 *   {
 *     "generatedAt": <unix seconds>,
 *     "players": {
 *       "<uid>": {
 *         "world":     "<world uuid>",
 *         "createdAt": <unix seconds the main save was created>,
 *         "savedate":  <unix seconds of the main save's last save, truncated to the UTC day>,
 *         "main":      { "baseid": <int>, "housed": { "<code>": <count> }, "space": <int> },
 *         "outposts":  [ { "baseid": <int>, "housed": { "<code>": <count> },
 *                          "space": <int>, "finishtime": <unix seconds>,
 *                          "production": { "r1": <int>, "r2": <int>, "r3": <int>, "r4": <int> } }, ... ]
 *       }
 *     }
 *   }
 *
 *   A uid with no main save has no entry. world is the player's world; their
 *   outposts are always in it. baseid matches the snapshot's cell tuple.
 *   housed is monster code to count; space is housing capacity.
 *
 *   finishtime is when the outpost's worker finishes the job recorded at its
 *   last save; treat a value <= now as idle. 0 if none was recorded.
 *
 *   production is the outpost's harvester output per hour (twigs, pebbles,
 *   putty, goo) as the client recorded it at that outpost's last save: healthy
 *   harvesters only, altitude-adjusted, overdrive excluded. Main-yard
 *   production is not recorded by the client and is not served.
 *
 *   A monsters blob with no housed key reports an empty housed and 0 space.
 *   The client writes that form to the attacker's main save after an MR1 or
 *   inferno attack (attackcreatures); MR2 attacks leave the housing blob intact.
 *
 * Caching
 *   None. Responses are live and sent with Cache-Control: no-store.
 *
 * Status
 *   200   the lookup
 *   400   uid missing, malformed, or more than 25 ids
 *   429   rate limited
 *
 * @param {Context} ctx - The Koa request/response context object.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 */
export const getPlayers: KoaController = async (ctx) => {
  const { uid } = ctx.query;

  if (typeof uid !== "string" || !uid) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: "Missing uid" };
    return;
  }

  const uids = [...new Set(uid.split(","))].map(Number);

  if (uids.some((id) => !Number.isInteger(id) || id <= 0)) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: "uid must be a comma-separated list of positive integers" };
    return;
  }

  if (uids.length > MAX_PLAYER_LOOKUP) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: `At most ${MAX_PLAYER_LOOKUP} uids per request` };
    return;
  }

  const players = await getPlayerBases(uids);

  ctx.set("Cache-Control", "no-store");
  ctx.status = Status.OK;
  ctx.body = { generatedAt: getCurrentDateTime(), players };
};
