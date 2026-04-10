import { User } from "../../../models/user.model.js";
import { Status } from "../../../enums/StatusCodes.js";
import { CellSchema } from "../../../zod/CellSchema.js";
import { postgres } from "../../../server.js";
import { MapRoom3, MapRoomVersion } from "../../../enums/MapRoom.js";
import { WorldMapCell } from "../../../models/worldmapcell.model.js";
import { getGeneratedCells, cellKey } from "../../../services/maproom/v3/generateCells.js";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import { createCellData } from "../../../services/maproom/v3/createCellData.js";
import { getDefenderCoords, isDefensiveStructure } from "../../../services/maproom/v3/getDefenderCoords.js";
import { logger } from "../../../utils/logger.js";
import { loadFailureErr } from "../../../errors/errors.js";
import type { KoaController } from "../../../utils/KoaController.js";
import type { CellData } from "../../../types/CellData.js";
import { getCellBounds, type Coord } from "../../../services/maproom/v3/utils/getCellBounds.js";
import { getDefenderLevels } from "../../../services/maproom/v3/getDefenderLevels.js";
import { TRIBE_REGEN_TIME } from "../../../config/MapRoom3Config.js";

/**
 * Save fields fetched alongside each WorldMapCell in the DB query.
 * Restricted to only what the cell handlers need to.
 */
const CELL_SAVE_FIELDS = [
  "*",
  "save.basesaveid",
  "save.damage",
  "save.destroyed",
  "save.level",
  "save.protected",
  "save.points",
  "save.basevalue",
] as const;

const MAX_CELLS_PER_REQUEST = 4250;

export const getMapRoomCells: KoaController = async (ctx) => {
  try {
    const { cellids } = CellSchema.parse(ctx.request.body);

    if (cellids && cellids.length > MAX_CELLS_PER_REQUEST) {
      ctx.status = Status.BAD_REQUEST;
      ctx.body = { error: `Maximum ${MAX_CELLS_PER_REQUEST} cells per request` };
      return;
    }

    const user: User = ctx.authUser;
    await postgres.em.populate(user, ["save"]);

    const save = user.save;

    if (!save) {
      ctx.status = Status.OK;
      ctx.body = { celldata: [] };
      return;
    }

    const worldid = save.worldid;

    if (!worldid || !cellids?.length) {
      ctx.status = Status.OK;
      ctx.body = { celldata: [] };
      return;
    }

    // Note: the client uses 1-based cell IDs (MapRoom3.as: CalculateCellId: y * width + x + 1)
    // so that cellId 0 can serve as a "no cell" sentinel for uninitialized AS3 ints.
    // Subtract 1 here to convert back to 0-based grid coordinates.
    const requestedCoords: Coord[] = cellids.map((id) => {
      const zeroBasedId = id - 1;
      return {
        x: zeroBasedId % MapRoom3.WIDTH,
        y: Math.floor(zeroBasedId / MapRoom3.WIDTH),
      };
    });

    const generateCells = getGeneratedCells();

    // =========================================================================
    // PHASE 1: Collect coordinates for requested cells + generated defenders
    // =========================================================================
    const coords = new Map<string, Coord>();

    for (const { x, y } of requestedCoords) {
      const key = `${x},${y}`;
      coords.set(key, { x, y });

      const genCell = generateCells.get(cellKey(x, y));

      // If this is a defender, find and add its parent structure + all siblings
      if (genCell?.type === EnumYardType.FORTIFICATION) {
        for (const [px, py] of getDefenderCoords(x, y)) {
          const parentCell = generateCells.get(cellKey(px, py));
          if (isDefensiveStructure(parentCell?.type)) {
            // Add parent
            coords.set(`${px},${py}`, { x: px, y: py });
            // Add all defenders around the parent (siblings)
            for (const [dx, dy] of getDefenderCoords(px, py)) {
              const dKey = `${dx},${dy}`;
              if (!coords.has(dKey)) {
                coords.set(dKey, { x: dx, y: dy });
              }
            }
            break;
          }
        }
      }

      // Add defender positions for cells that have them (strongholds, resources)
      for (const [relX, relY] of getDefenderCoords(x, y, genCell?.type)) {
        const relKey = `${relX},${relY}`;
        if (!coords.has(relKey)) {
          coords.set(relKey, { x: relX, y: relY });
        }
      }
    }

    // =========================================================================
    // PHASE 2: Single DB query using bounding box
    // =========================================================================
    const coordsList = [...coords.values()];

    const { minX, maxX, minY, maxY } = getCellBounds(coordsList);

    const dbCells = await postgres.em.find(
      WorldMapCell,
      {
        world_id: worldid,
        map_version: MapRoomVersion.V3,
        x: { $gte: minX - 1, $lte: maxX + 1 },
        y: { $gte: minY - 1, $lte: maxY + 1 },
      },
      { populate: ["save"], fields: CELL_SAVE_FIELDS },
    );

    // Player-owned cells take priority over tribe outposts at the same coordinate.
    const dbCellsByCoord = new Map<string, WorldMapCell>();

    for (const cell of dbCells) {
      const key = `${cell.x},${cell.y}`;
      // Cast required: field projection (CELL_SAVE_FIELDS) narrows the MikroORM Loaded
      // type to a partial Save, which doesn't structurally satisfy WorldMapCell.save.
      // At runtime the entity is a full WorldMapCell — all projected fields are accessed below.
      if (!dbCellsByCoord.has(key) || cell.uid > 0) dbCellsByCoord.set(key, cell as unknown as WorldMapCell);
    }

    let hasExpiredCells = false;

    // Lazy-delete expired destroyed outpost cells and remove them from dbCellsByCoord
    // so Phase 5 treats those positions as empty and repopulates from generated data.
    for (const [key, dbCell] of dbCellsByCoord) {
      if (!dbCell.destroyed_at) continue;
      if (Date.now() - dbCell.destroyed_at.getTime() < TRIBE_REGEN_TIME) continue;

      if (dbCell.save) postgres.em.remove(dbCell.save);
      
      postgres.em.remove(dbCell);
      dbCellsByCoord.delete(key);
      hasExpiredCells = true;
    }

    if (hasExpiredCells) await postgres.em.flush();

    // =========================================================================
    // PHASE 3: Process player-owned structures - add defender coords + levels
    // =========================================================================
    const defenderPositions = new Set<string>();
    const playerDefenderLevels = new Map<string, number>();

    for (const dbCell of dbCells) {
      // Handle any player-owned defensive structure (PLAYER, STRONGHOLD, RESOURCE)
      if (dbCell.uid && isDefensiveStructure(dbCell.base_type)) {
        const defenderCoords = getDefenderCoords(dbCell.x, dbCell.y);
        const defenderLevels = getDefenderLevels(dbCell.base_type);

        for (let i = 0; i < defenderCoords.length; i++) {
          const [relX, relY] = defenderCoords[i];
          const relKey = `${relX},${relY}`;
          defenderPositions.add(relKey);

          if (defenderLevels) playerDefenderLevels.set(relKey, defenderLevels[i]);
        }
      }
    }

    // =========================================================================
    // PHASE 4: Batch load all cell owners in a single query
    // =========================================================================
    const ownerIds = [...new Set(dbCells.map((cell) => cell.uid).filter(Boolean))];

    const ownersList = await postgres.em.find(
      User,
      { userid: { $in: ownerIds } },
      { populate: ["save"] },
    );

    const cellOwners = new Map<number, User>(
      ownersList.map((u) => [u.userid, u]),
    );

    // =========================================================================
    // PHASE 5: Build cell data for all coordinates
    // =========================================================================
    const cellsToReturn = new Map<string, CellData>();

    for (const [key, { x, y }] of coords) {
      if (cellsToReturn.has(key)) continue;

      let cell: WorldMapCell;
      const dbCell = dbCellsByCoord.get(key);
      const genCell = generateCells.get(cellKey(x, y));

      const isBorder = x < 0 || x >= MapRoom3.WIDTH || y < 0 || y >= MapRoom3.HEIGHT;

      if (!isBorder && defenderPositions.has(key) && !dbCell?.uid) {
        // Tribe outpost at a fortification position - defender wins
        cell = new WorldMapCell(undefined, x, y, 0);
        cell.base_type = EnumYardType.FORTIFICATION;
      } else if (dbCell) {
        if (dbCell.destroyed_at) {
          cell = new WorldMapCell(undefined, dbCell.x, dbCell.y, dbCell.terrainHeight);
        } else {
          cell = dbCell;
        }
      } else {
        if (isBorder) {
          cell = new WorldMapCell(undefined, x, y, 100);
          cell.base_type = EnumYardType.BORDER;
        } else if (defenderPositions.has(key)) {
          cell = new WorldMapCell(undefined, x, y, 0);
          cell.base_type = EnumYardType.FORTIFICATION;
        } else if (genCell) {
          cell = new WorldMapCell(undefined, genCell.x, genCell.y, genCell.altitude);
          cell.base_type = genCell.type || 0;
        } else {
          cell = new WorldMapCell(undefined, x, y, 0);
        }
      }

      const cellData = await createCellData(cell, worldid, ctx, cellOwners);

      // Override defender levels: player-owned take priority, then generated
      if (playerDefenderLevels.has(key)) {
        cellData.l = playerDefenderLevels.get(key);
      } else if (genCell?.level && !cell.uid) {
        cellData.l = genCell.level;
      }

      cellsToReturn.set(key, cellData);
    }

    ctx.status = Status.OK;
    ctx.body = { celldata: [...cellsToReturn.values()] };
  } catch (error) {
    logger.error(`Error in getMapRoomCells: ${error}`);
    throw loadFailureErr();
  }
};
