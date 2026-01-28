import { WorldMapCell } from "../../../models/worldmapcell.model.js";
import { User } from "../../../models/user.model.js";
import { Save } from "../../../models/save.model.js";
import { World } from "../../../models/world.model.js";
import { MapRoom3, MapRoomVersion } from "../../../enums/MapRoom.js";
import { EntityManager, PostgreSqlDriver } from "@mikro-orm/postgresql";
import { postgres } from "../../../server.js";
import { findFreeSector } from "./findFreeSector.js";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import { logger } from "../../../utils/logger.js";

/**
 * Assigns a user to a Map Room 3 world by either joining an existing one with available space
 * or creating a new world if all are full.
 *
 * Creates the player's main yard cell and 6 surrounding defender outpost cells in a hexagon formation.
 * Each defender gets its own Save entity with appropriate base data.
 *
 * If the user is not relocating and already in the assigned world, no action is taken.
 * If relocating, a new position is found, and the user's base is updated accordingly.
 *
 * @param {User} user - The user who is joining or relocating in the world
 * @param {Save} save - The user's main save data
 * @param {EntityManager} em - The entity manager for database operations
 * @param {boolean} relocate - Flag indicating whether the user is relocating
 * @returns {Promise<void>} A promise that resolves when the operation is complete
 */
export const joinNewWorldMap = async (
  user: User,
  save: Save,
  em: EntityManager<PostgreSqlDriver> = postgres.em
) => {
  let world: World | null = null;

  // Find available worlds with space (Map Room v3 only)
  const availableWorlds = await em.find(World, {
    playerCount: { $lt: MapRoom3.MAX_PLAYERS },
    map_version: MapRoomVersion.V3,
  });

  // Randomly select from available worlds
  const shuffledWorlds = availableWorlds.sort(() => Math.random() - 0.5);

  if (shuffledWorlds.length > 0) {
    world = shuffledWorlds[0];
    logger.info(`User ${user.username} assigned to existing world: ${world.name}`);
  } else {
    world = em.create(World, {});
    world.name = "New World";
    world.map_version = MapRoomVersion.V3;
    logger.info("All worlds full, created new world.");
  }

  if (save.worldid === world.uuid) return;

  world.playerCount += 1;
  save.usemap = 1;
  save.worldid = world.uuid;

  // Find an available cell for the user's main yard
  const { x, y, terrainHeight } = await findFreeSector(world, em);

  const homeCell = new WorldMapCell(world, x, y, terrainHeight);
  homeCell.uid = user.userid;
  homeCell.base_type = EnumYardType.PLAYER;
  homeCell.baseid = save.baseid;
  homeCell.map_version = MapRoomVersion.V3;

  // Link the main yard cell to the user's save
  save.cell = homeCell;
  save.worldid = world.uuid;
  save.homebase = [homeCell.x.toString(), homeCell.y.toString()];

  await em.persistAndFlush([world, homeCell, save]);
};
