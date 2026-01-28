import { User } from "../../../models/user.model.js";
import { Status } from "../../../enums/StatusCodes.js";
import { CellSchema } from "../../../zod/CellSchema.js";
import { postgres } from "../../../server.js";
import { Save } from "../../../models/save.model.js";
import { MapRoom3, MapRoomVersion } from "../../../enums/MapRoom.js";
import { WorldMapCell } from "../../../models/worldmapcell.model.js";
import { mapByCoordinates } from "../../../services/maproom/v3/utils/mapByCoordinates.js";
import { generateCells } from "../../../services/maproom/v3/generateCells.js";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import { getHexNeighborOffsets } from "../../../services/maproom/v3/getDefenderOutposts.js";
import { createCellData } from "../../../services/maproom/v3/createCellData.js";
import { getRelatedCellPositions } from "../../../services/maproom/v3/getRelatedCells.js";
import { logger } from "../../../utils/logger.js";
import { loadFailureErr } from "../../../errors/errors.js";
import type { KoaController } from "../../../utils/KoaController.js";
import type { CellData } from "../../../types/CellData.js";
import type { FilterQuery } from "@mikro-orm/core";

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

    // Convert IDs to coordinates
    const requestedCoords = cellids.map((id) => ({
      x: id % MapRoom3.WIDTH,
      y: Math.floor(id / MapRoom3.WIDTH),
    }));

    const query: FilterQuery<WorldMapCell> = {
      world_id: worldid,
      map_version: MapRoomVersion.V3,
      $or: requestedCoords.map(({ x, y }) => ({ x, y })),
    };

    // Get persistent cells which have been stored in the database.
    const dbCells = await postgres.em.find(WorldMapCell, query, { populate: ["save"] });
    const dbCellsByCoord = mapByCoordinates(dbCells);

    // Otherwise, we generate all procedural cells
    const genCells = generateCells();
    const genCellsByCoords = mapByCoordinates(genCells);

    // Merge both maps for getRelatedCells (db cells include player yards)
    const allCellsByCoord = new Map(genCellsByCoords);
    for (const [key, dbCell] of dbCellsByCoord) {
      allCellsByCoord.set(key, { x: dbCell.x, y: dbCell.y, t: dbCell.base_type });
    }

    const defenderPositions = new Set<string>();

    for (const [_, dbCell] of dbCellsByCoord) {
      if (dbCell.base_type === EnumYardType.PLAYER) {
        const offsets = getHexNeighborOffsets(dbCell.x, dbCell.y);
        for (const [dx, dy] of offsets) {
          defenderPositions.add(`${dbCell.x + dx},${dbCell.y + dy}`);
        }
      }
    }

    const cellsToReturn = new Map<string, CellData>();

    const fetchOrGenerateCell = async (x: number, y: number) => {
      let cell: WorldMapCell;
      const key = `${x},${y}`;

      if (cellsToReturn.has(key)) return;

      const dbCell = dbCellsByCoord.get(key);
      const genCell = genCellsByCoords.get(key);

      if (dbCell) {
        cell = dbCell;
      } else {
        const isBorder = x < 0 || x >= MapRoom3.WIDTH || y < 0 || y >= MapRoom3.HEIGHT;

        if (isBorder) {
          cell = new WorldMapCell(undefined, x, y, 100);
          cell.base_type = EnumYardType.BORDER;
        } else {
          // Check if this position is a pre-computed defender position
          const isDefender = defenderPositions.has(key);

          if (isDefender) {
            // Create as defender (overrides tribe outposts in genCell)
            cell = new WorldMapCell(undefined, x, y, 0);
            cell.base_type = EnumYardType.FORTIFICATION;
          } else if (genCell) {
            // Use generated cell (stronghold/resource/outpost/terrain)
            cell = new WorldMapCell(undefined, genCell.x, genCell.y, genCell.i);
            cell.base_type = genCell.t || 0;
          } else {
            // Empty terrain
            cell = new WorldMapCell(undefined, x, y, 0);
          }
        }
      }

      const cellData = await createCellData(cell, ctx, worldid);
      cellsToReturn.set(key, cellData);

      // Include related cells (use merged map so defenders can find player yard parents)
      const relatedPositions = getRelatedCellPositions(x, y, dbCell?.base_type ?? genCell?.t, allCellsByCoord);

      for (const [relX, relY] of relatedPositions)
        await fetchOrGenerateCell(relX, relY);
    };

    // Process each requested coordinate
    for (const { x, y } of requestedCoords) await fetchOrGenerateCell(x, y);

    ctx.status = Status.OK;
    ctx.body = { celldata: [...cellsToReturn.values()] };
  } catch (error) {
    logger.error("Error in getMapRoomCells:", error);
    throw loadFailureErr();
  }
};
