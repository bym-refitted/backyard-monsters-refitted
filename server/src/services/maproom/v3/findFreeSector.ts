import { MapRoom3, MapRoomVersion } from "../../../enums/MapRoom.js";
import { World } from "../../../database/models/world.model.js";
import { WorldMapCell } from "../../../database/models/worldmapcell.model.js";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import { getDefenderCoords } from "./getDefenderCoords.js";
import { getGeneratedCells, cellKey, type GeneratedCell } from "./generateCells.js";
import { getHexDistance, type HexCoord } from "./getHexNeighborOffsets.js";
import { MIN_PLAYER_DISTANCE } from "../../../config/MapRoom3Config.js";
import { loadFailureErr } from "../../../errors/errors.js";
import { logger } from "../../../utils/logger.js";
import { setTimeout } from "timers/promises";
import type { PostgresEM } from "../../../types/PostgresEM.js";

interface Cell {
  x: number | null;
  y: number | null;
  terrainHeight: number | null;
}

/** Keeps a yard clear of the map edge so its six defender cells still fit. */
const EDGE_MARGIN = 3;

/**
 * Checks if a yard at this position keeps its whole defender ring inside the map.
 *
 * @param {number} x - Cell x coordinate.
 * @param {number} y - Cell y coordinate.
 * @returns {boolean} True when the yard and its six defenders all fit on the map.
 */
const withinMap = (x: number, y: number) =>
  x >= EDGE_MARGIN && x <= MapRoom3.WIDTH - EDGE_MARGIN
  && y >= EDGE_MARGIN && y <= MapRoom3.HEIGHT - EDGE_MARGIN;

/**
 * Checks if a position can be overridden by a player yard or defender.
 * Checks database cell first, then generated cell if no database cell exists.
 *
 * Can override: terrain (no cell) or tribe outposts (OUTPOST).
 * Cannot override: strongholds, resources, fortifications, or other player bases.
 *
 * Note: Tribe outposts are stored as OUTPOST (1) but sent to client as EMPTY (100).
 *
 * @param {WorldMapCell | null} dbCell - The stored cell at this position, if one exists.
 * @param {GeneratedCell | undefined} genCell - The generated cell at this position, if one exists.
 * @returns {boolean} True when a yard or defender may take the position.
 */
const canOverride = (dbCell: WorldMapCell | null, genCell: GeneratedCell | undefined) => {
  if (dbCell) return dbCell.base_type === EnumYardType.OUTPOST;

  if (genCell?.type !== undefined) return genCell.type === EnumYardType.OUTPOST;

  return true;
};

/**
 * Finds the closest free cell to a position, for relocating next to a friend.
 *
 * Searches outward ring by ring, so the player lands as near their friend as the spacing
 * rules allow - which is never adjacent, since yards must stay MIN_PLAYER_DISTANCE apart.
 *
 * @param {World} world - The world the friend is in.
 * @param {PostgresEM} em - The entity manager for database operations.
 * @param {number} originX - The friend's x.
 * @param {number} originY - The friend's y.
 * @returns {Promise<Cell>} The nearest free cell.
 * @throws {ClientSafeError} If nothing is free within the search radius.
 */
export const findFreeSectorNear = async (world: World, em: PostgresEM, originX: number, originY: number) => {
  const maxRadius = MIN_PLAYER_DISTANCE * 4;
  const genCellsByCoord = getGeneratedCells();

  const searchMargin = maxRadius + MIN_PLAYER_DISTANCE;

  const searched = await em.find(WorldMapCell, {
    world,
    map_version: MapRoomVersion.V3,
    x: { $gte: originX - searchMargin, $lte: originX + searchMargin },
    y: { $gte: originY - searchMargin, $lte: originY + searchMargin },
  });

  const dbCells = new Map(searched.map((cell) => [cellKey(cell.x, cell.y), cell]));
  const playerCells = searched.filter((cell) => cell.base_type === EnumYardType.PLAYER);

  const isFree = (x: number, y: number) => {
    const key = cellKey(x, y);
    const dbCell = dbCells.get(key) ?? null;

    return canOverride(dbCell, genCellsByCoord.get(key));
  };

  const fits = (x: number, y: number) => {
    const centreFree = isFree(x, y);
    const defendersFree = getDefenderCoords(x, y).every(([defenderX, defenderY]) => isFree(defenderX, defenderY));
    const farFromPlayers = !playerCells.some((cell) => getHexDistance(x, y, cell.x, cell.y) < MIN_PLAYER_DISTANCE);

    return centreFree && defendersFree && farFromPlayers;
  };

  for (let radius = MIN_PLAYER_DISTANCE; radius <= maxRadius; radius++) {
    for (const [x, y] of cellsAtDistance(originX, originY, radius)) {
      const canPlaceYard = withinMap(x, y) && fits(x, y);

      if (canPlaceYard) return { x, y, terrainHeight: 10 };
    }
  }

  logger.warn(`No free position within ${maxRadius} of (${originX}, ${originY}) in world ${world.uuid}.`);
  throw loadFailureErr();
};

/**
 * Every cell exactly `radius` steps away from a point, which together form a hexagon
 * outline around it - six cells per step out, so a radius of 7 returns 42 cells.
 *
 * Found by walking the square that encloses that hexagon and keeping only the cells at
 * the exact distance, so a radius of 7 tests 225 positions to return 42. Walking the
 * hexagon's six edges directly would avoid the waste, but the caller stops at the first
 * cell it can use, which makes the discarded work too small to measure.
 *
 * Coordinates are not clamped to the map, so they can fall outside it. The caller is
 * responsible for that check.
 *
 * @param {number} centreX - X coordinate of the centre cell.
 * @param {number} centreY - Y coordinate of the centre cell.
 * @param {number} radius - How many steps out from the centre to collect.
 * @returns {HexCoord[]} The [x, y] coordinates of every cell at that exact distance.
 */
const cellsAtDistance = (centreX: number, centreY: number, radius: number): HexCoord[] => {
  const ring: HexCoord[] = [];

  for (let x = centreX - radius; x <= centreX + radius; x++) {
    for (let y = centreY - radius; y <= centreY + radius; y++) {
      const onRing = getHexDistance(centreX, centreY, x, y) === radius;

      if (onRing) ring.push([x, y]);
    }
  }

  return ring;
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
 * @param {PostgresEM} em - The entity manager for database operations
 * @returns {Promise<Cell>} The coordinates and terrain height of the free cell
 * @throws {Error} If no free cell is found after several attempts
 */
export const findFreeSector = async (world: World, em: PostgresEM) => {
  let cell: Cell = { x: null, y: null, terrainHeight: null };
  const maxAttempts = 100;

  // Get procedurally generated cells
  const genCellsByCoord = getGeneratedCells();

  // Define safe zone boundaries (avoid edges to ensure defender positions fit)
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

    const centerGenCell = genCellsByCoord.get(cellKey(x, y));

    // Center position must be overridable (terrain, EMPTY, or OUTPOST)
    if (!canOverride(existingCell, centerGenCell)) continue;

    // Check all 6 surrounding defender positions can be overridden
    let allDefenderPositionsFree = true;

    for (const [defenderX, defenderY] of getDefenderCoords(x, y)) {
      // Check database first, then generated cells
      const existingDefender = await em.findOne(WorldMapCell, {
        world,
        x: defenderX,
        y: defenderY,
        map_version: MapRoomVersion.V3,
      });

      const defenderGenCell = genCellsByCoord.get(cellKey(defenderX, defenderY));

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

    // Ensure minimum distance from all existing player yards
    const nearbyPlayerCells = await em.find(WorldMapCell, {
      world,
      map_version: MapRoomVersion.V3,
      base_type: EnumYardType.PLAYER,
      x: { $gte: x - MIN_PLAYER_DISTANCE, $lte: x + MIN_PLAYER_DISTANCE },
      y: { $gte: y - MIN_PLAYER_DISTANCE, $lte: y + MIN_PLAYER_DISTANCE },
    });

    const playerCell = nearbyPlayerCells.some(
      (cell) => getHexDistance(x, y, cell.x, cell.y) < MIN_PLAYER_DISTANCE
    );

    if (playerCell) continue;

    cell = { x, y, terrainHeight: 10 };
    break;
  }

  if (cell.x === null || cell.y === null) {
    throw new Error(
      `Failed to find a free position for player yard after ${maxAttempts} attempts. World may be full.`
    );
  }

  return cell as { x: number; y: number; terrainHeight: number };
};
