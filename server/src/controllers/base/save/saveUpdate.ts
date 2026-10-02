import { Status } from "../../../enums/StatusCodes.js";
import type { KoaController } from "../../../utils/KoaController.js";

/**
 * Stub for the per-base activity feed. The client posts a building event here
 * whenever one happens on a base: placements, upgrades and fortifies over an
 * hour, gifts, edited signs, and help given to someone else (the `BH` opcode).
 *
 * The original stored these against the base and handed them to its owner, who
 * replayed them on their next load. `BH` is the one that matters: it pushes the
 * helper onto the building's help list and knocks time off the owner's timer,
 * which is also what produces the "X helped you build your Y" popup.
 *
 * Nothing is stored yet, so the empty list tells the client there is nothing to
 * replay. This exists because `UPDATES.CreateB` only posts here once a player
 * has friends - it returns early while `friendcount` is 0 - so the friend
 * system turns this traffic on, and without the route it would 404. Storing the
 * events is how friend help gets implemented; see docs/launcher-friend-system.md.
 *
 * @param {Context} ctx - The Koa context object.
 */
export const saveUpdate: KoaController = async (ctx) => {
  ctx.status = Status.OK;
  ctx.body = { error: 0, updates: [] };
};
