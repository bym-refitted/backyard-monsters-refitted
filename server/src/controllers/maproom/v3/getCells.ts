import { User } from "../../../models/user.model.js";
import { Status } from "../../../enums/StatusCodes.js";
import { CellSchema } from "../../../zod/CellSchema.js";
import { postgres } from "../../../server.js";
import { Save } from "../../../models/save.model.js";
import { MapRoom3, MapRoomVersion } from "../../../enums/MapRoom.js";
import { WorldMapCell } from "../../../models/worldmapcell.model.js";
import { mapByCoordinates } from "../../../services/maproom/v3/utils/mapByCoordinates.js";
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

// TODO: this entire controller is a bit of a mess, but it's on the right track
// just needs to be more explicit about what we're doing and cleaned up
export const getMapRoomCells: KoaController = async (ctx) => {
  try {
    const { cellids } = CellSchema.parse(ctx.request.body);

    const user: User = ctx.authUser;
    await postgres.em.populate(user, ["save"]);

    const save: Save = user.save;
    const worldid = save.worldid;

    if (!cellids?.length) {
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
        x: { $gte: minX, $lte: maxX },
        y: { $gte: minY, $lte: maxY },
      },
      { populate: ["save"] },
    );

    const requestedSet = new Set(coordsList.map(cell => `${cell.x},${cell.y}`));

    const dbCellsByCoord = mapByCoordinates(
      dbCells.filter((cell) => requestedSet.has(`${cell.x},${cell.y}`)),
    );

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
          if (!coords.has(relKey)) {
            coords.set(relKey, { x: relX, y: relY });
          }
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

      // TODO: this shit is horrible, sort it out
      if (dbCell) {
        cell = dbCell;
      } else {
        const isBorder = x < 0 || x >= MapRoom3.WIDTH || y < 0 || y >= MapRoom3.HEIGHT;

        if (isBorder) {
          cell = new WorldMapCell(undefined, x, y, 100);
          cell.base_type = EnumYardType.BORDER;
        } else {
          const isDefender = defenderPositions.has(key);

          if (isDefender) {
            cell = new WorldMapCell(undefined, x, y, 0);
            cell.base_type = EnumYardType.FORTIFICATION;
          } else if (genCell) {
            cell = new WorldMapCell(undefined, genCell.x, genCell.y, genCell.altitude);
            cell.base_type = genCell.type || 0;
          } else {
            cell = new WorldMapCell(undefined, x, y, 0);
          }
        }
      }

      const cellData = await createCellData(cell, worldid, ctx, cellOwners);
      
      // Override defender levels: player-owned take priority, then generated
      if (playerDefenderLevels.has(key)) {
        cellData.l = playerDefenderLevels.get(key);
      } else if (genCell?.level) {
        cellData.l = genCell.level;
      }

      cellsToReturn.set(key, cellData);
    }

    ctx.status = Status.OK;
    ctx.body = { celldata: [...cellsToReturn.values()] };
  } catch (error) {
    logger.error("Error in getMapRoomCells:", error);
    throw loadFailureErr();
  }
};
