import { WorldMapCell } from "../../../models/worldmapcell.model";
import { User } from "../../../models/user.model";
import { Save } from "../../../models/save.model";
import { logging } from "../../../utils/logger";
import { World } from "../../../models/world.model";
import { MapRoom, MapRoomCell } from "../../../enums/MapRoom";
import { EntityManager, PostgreSqlDriver } from "@mikro-orm/postgresql";
import { ORMContext } from "../../../server";
import { findFreeCell } from "./findFreeCell";

/**
 * Assigns a user to a world by either joining an existing one with available space
 * or creating a new world if all are full. Optionally relocates the user to a new
 * position within the world.
 *
 * If the user is not relocating and already in the assigned world, no action is taken.
 * If relocating, a new position is found, and the user's base is updated accordingly.
 *
 * @param {User} user - The user who is joining or relocating in the world.
 * @param {Save} save - The user's save data.
 * @param {EntityManager} em - The entity manager for database operations.
 * @param {boolean} relocate - Flag indicating whether the user is relocating.
 * @returns {Promise<void>} - A promise that resolves when the operation is complete.
 */
export const joinOrCreateWorld = async (
  user: User,
  save: Save,
  em: EntityManager<PostgreSqlDriver> = ORMContext.em,
  relocate: Boolean = false
) => {
  let world: World | null = null;

  let availableWorlds = await em.find(World, {
    playerCount: { $lt: MapRoom.MAX_PLAYERS },
  });

  const shuffledWorlds = availableWorlds.sort(() => Math.random() - 0.5);

  if (shuffledWorlds.length > 0) {
    world = shuffledWorlds[0];
    logging(`User assigned to existing world: ${world.name}`);
  } else {
    world = em.create(World, {});
    world.name = "New World";
    logging("All worlds full, created new world.");
  }

  // If not relocating, check if the user is already in the world
  if (!relocate) {
    if (save.worldid === world.uuid) return;
    world.playerCount += 1;
  }

  save.usemap = 1;
  save.worldid = world.uuid;

  // Find an available cell for the user
  const { x, y, terrainHeight } = await findFreeCell(world, em);

  if (relocate)
    logging(
      `${user.username} relocated to new cell (${x}, ${y}) in world ${world.uuid}`
    );

  // Create a new home cell for the user
  const homeCell = new WorldMapCell(world, x, y, terrainHeight);
  homeCell.uid = user.userid;
  homeCell.base_type = MapRoomCell.HOMECELL;
  homeCell.baseid = save.baseid;

  // Update the user save data with the new home cell
  save.cell = homeCell;
  save.worldid = world.uuid;
  save.homebase = [homeCell.x.toString(), homeCell.y.toString()];

  await em.persistAndFlush([world, homeCell, save]);
};
