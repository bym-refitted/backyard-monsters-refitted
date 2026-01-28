import { MapRoom3, MapRoomVersion } from "../../../enums/MapRoom.js";
import { World } from "../../../models/world.model.js";
import { WorldMapCell } from "../../../models/worldmapcell.model.js";
import { EntityManager, PostgreSqlDriver } from "@mikro-orm/postgresql";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import { getHexNeighborOffsets } from "./getDefenderOutposts.js";
import { generateCells } from "./generateCells.js";
import { mapByCoordinates } from "./utils/mapByCoordinates.js";
import { setTimeout } from "timers/promises";

interface Cell {
  x: number | null;
  y: number | null;
  terrainHeight: number | null;
}

interface GeneratedCell {
  x: number;
  y: number;
  i?: number;
  t?: number;
}

// TODO: clean this file up its shitty
// 1. We need to check if a cell exists in the database first at that spot
// 2. If no, check if the terrain generation has taken that space
// 3. If no, all good we can place the yard (and override that generated terrain)

// Potential issues:
// 1. What happens if a tribe outpost is already in the database? It will block the placement of a main yard

/**
 * Checks if a position can be overridden by a player yard or defender.
 * Checks database cell first, then generated cell if no database cell exists.
 *
 * Can override: terrain (no cell) or tribe outposts (OUTPOST).
 * Cannot override: strongholds, resources, fortifications, or other player bases.
 *
 * Note: Tribe outposts are stored as OUTPOST (1) but sent to client as EMPTY (100).
 */
const canOverride = (dbCell: WorldMapCell | null, genCell: GeneratedCell | undefined): boolean => {
  // Check database cell first
  if (dbCell) return dbCell.base_type === EnumYardType.OUTPOST;

  // No database cell, check generated cell
  if (genCell?.t !== undefined) return genCell.t === EnumYardType.OUTPOST;

  // No database cell, no generated structure = terrain/empty, can override
  return true;
};

/**
 * Finds a free cell in Map Room 3 for placing a player's main yard.
 *
 * In Map Room 3, cells are pre-generated with strongholds, resources, and defenders.
 * A valid player position must have:
 * 1. Center cell can override: terrain, EMPTY cells, or tribe outposts (OUTPOST)
 * 2. All 6 surrounding defender positions can override: terrain, EMPTY cells, or tribe outposts
 * 3. Cannot override: strongholds, resources, or other player bases
 *
 * @param {World} world - The world in which to find a free cell
 * @param {EntityManager<PostgreSqlDriver>} em - The entity manager for database operations
 * @returns {Promise<Cell>} The coordinates and terrain height of the free cell
 * @throws {Error} If no free cell is found after several attempts
 */
export const findFreeSector = async (world: World, em: EntityManager<PostgreSqlDriver>) => {
  let cell: Cell = { x: null, y: null, terrainHeight: null };
  const maxAttempts = 100;

  // Generate procedural cells (cached, so this is efficient)
  const genCells = generateCells();
  const genCellsByCoord = mapByCoordinates(genCells);

  // Define safe zone boundaries (avoid edges to ensure defender positions fit)
  const EDGE_MARGIN = 3;
  const MIN_X = EDGE_MARGIN;
  const MAX_X = MapRoom3.WIDTH - EDGE_MARGIN;
  const MIN_Y = EDGE_MARGIN;
  const MAX_Y = MapRoom3.HEIGHT - EDGE_MARGIN;

  for (let attempt = 0; attempt < maxAttempts; attempt++) {
    // Generate random position within safe boundaries
    const x = MIN_X + Math.floor(Math.random() * (MAX_X - MIN_X));
    const y = MIN_Y + Math.floor(Math.random() * (MAX_Y - MIN_Y));

    // Check if the center cell can be overridden (database first, then generated)
    const existingCell = await em.findOne(WorldMapCell, {
      world,
      x,
      y,
      map_version: MapRoomVersion.V3,
    });

    const centerGenCell = genCellsByCoord.get(`${x},${y}`);

    // Center position must be overridable (terrain, EMPTY, or OUTPOST)
    if (!canOverride(existingCell, centerGenCell)) continue;

    // Check all 6 surrounding defender positions can be overridden
    const offsets = getHexNeighborOffsets(x, y);
    let allDefenderPositionsFree = true;

    for (const [dx, dy] of offsets) {
      const defenderX = x + dx;
      const defenderY = y + dy;

      // Check database first, then generated cells
      const existingDefender = await em.findOne(WorldMapCell, {
        world,
        x: defenderX,
        y: defenderY,
        map_version: MapRoomVersion.V3,
      });

      const defenderGenCell = genCellsByCoord.get(`${defenderX},${defenderY}`);

      // Defender position must be overridable (terrain, EMPTY, or OUTPOST)
      if (!canOverride(existingDefender, defenderGenCell)) {
        allDefenderPositionsFree = false;
        break;
      }
    }

    // Only accept this position if all defender slots are overridable
    if (!allDefenderPositionsFree) {
      await setTimeout(200);
      continue;
    }

    cell = { x, y, terrainHeight: 10 };
    break;
  }

  if (cell.x === null || cell.y === null) {
    throw new Error(
      `Failed to find a free position for player yard after ${maxAttempts} attempts. World may be full.`
    );
  }

  return cell;
};
