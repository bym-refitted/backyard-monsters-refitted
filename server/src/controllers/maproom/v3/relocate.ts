import { BaseType } from "../../../enums/Base.js";
import { MapRoomVersion } from "../../../enums/MapRoom.js";
import { Save } from "../../../database/models/save.model.js";
import { Status } from "../../../enums/StatusCodes.js";
import { User } from "../../../database/models/user.model.js";
import { World } from "../../../database/models/world.model.js";
import { areFriends } from "../../../services/friends/friendList.js";
import { BASE_URL, PORT, postgres } from "../../../server.js";
import { joinNewWorldMap, type Destination } from "../../../services/maproom/v3/joinNewWorldMap.js";
import { loadFailureErr, permissionErr } from "../../../errors/errors.js";
import type { KoaController } from "../../../utils/KoaController.js";
import { RelocateSchema } from "../../../schemas/RelocateSchema.js";

/**
 * Works out where a player asked to land, when they picked a friend from the list.
 *
 * @param {User} user - The player relocating.
 * @param {number} targetId - The friend they chose.
 * @returns {Promise<Destination>} The world and position to land near.
 */
const findDestination = async (user: User, targetId: number): Promise<Destination> => {
  const isFriend = await areFriends(user.userid, targetId);

  if (!isFriend) throw permissionErr();

  const target = await postgres.em.findOne(
    Save,
    { userid: targetId, type: BaseType.MAIN, mapversion: MapRoomVersion.V3 },
    { populate: ["cell"] }
  );

  if (!target?.cell || !target.worldid) throw loadFailureErr();

  const world = await postgres.em.findOne(World, { uuid: target.worldid });

  if (!world) throw loadFailureErr();

  return { world, x: target.cell.x, y: target.cell.y };
};

/**
 * Moves the player's main yard, either to a random spot or next to a friend.
 *
 * @param {Context} ctx - The Koa context object.
 */
export const relocate: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { userid } = RelocateSchema.parse(ctx.request.body);

  await postgres.em.populate(user, ["save"]);

  const destination = userid ? await findDestination(user, userid) : undefined;

  await joinNewWorldMap(user, user.save!, postgres.em, destination);

  ctx.status = Status.OK;
  ctx.body = {
    error: 0,
    mapheaderurl: `${BASE_URL}:${PORT}/api/bm/getnewmap`,
  };
};
