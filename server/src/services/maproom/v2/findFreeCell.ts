import { MapRoom2, Terrain } from "../../../enums/MapRoom.js";
import { World } from "../../../models/world.model.js";
import { WorldMapCell } from "../../../models/worldmapcell.model.js";
import { EntityManager, PostgreSqlDriver } from "@mikro-orm/postgresql";
import { logger } from "../../../utils/logger.js";
import { generateNoise, getTerrainHeight } from "./generateMap.js";
import { setTimeout } from "timers/promises";

/**
 * Interface representing a single cell
 */
interface Cell {
  x: number | null;
  y: number | null;
  terrainHeight: number | null;
}

/**
 * Finds a free cell in a given world that is not water and not occupied by another player.
 *
 * @param {World} world - The world in which to find a free cell.
 * @param {EntityManager<PostgreSqlDriver>} em - The entity manager for database operations.
 * @returns {Promise<Cell>} - The coordinates and terrain height of the free cell.
 * @throws {Error} - If no free cell is found after several attempts.
 */
export const findFreeCell = async (world: World, em: EntityManager<PostgreSqlDriver>) => {
  let cell: Cell = { x: null, y: null, terrainHeight: null };
  let maxAttempts = 10;

  for (let attempt = 0; attempt < maxAttempts; attempt++) {
    const x = Math.floor(Math.random() * MapRoom2.WIDTH);
    const y = Math.floor(Math.random() * MapRoom2.HEIGHT);

    // Generate noise based on the world's seed
    const noise = generateNoise(world.uuid);
    const terrainHeight = getTerrainHeight(noise, x, y);

    // Skip if the cell is water
    if (terrainHeight <= Terrain.WATER3) {
      logger.info(`Tile (${x}, ${y}) is water. Skipping.`);
      continue;
    }

    // Skip if the cell is already occupied
    const existingCell = await em.findOne(WorldMapCell, { world, x, y });
    if (existingCell) {
      logger.info(`Tile (${x}, ${y}) is occupied by another player. Skipping.`);
      
      // Note: this is a self solving issue (gets better over time we promise, says the Promise)
      await setTimeout(200);
      continue;
    }

    // Valid cell found
    cell = { x, y, terrainHeight };
    break;
  }

  // TODO: Should not fail, put on another world?
  if (cell.x === null || cell.y === null || cell.terrainHeight === null) {
    throw new Error("Failed to find land position after several attempts");
  }

  return cell;
};