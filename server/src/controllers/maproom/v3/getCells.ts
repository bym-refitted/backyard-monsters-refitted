import { User } from "../../../models/user.model";
import { Status } from "../../../enums/StatusCodes";
import { KoaController } from "../../../utils/KoaController";
import { MapRoom3, MapRoomVersion } from "../../../enums/MapRoom";
import { generateCells } from "../../../services/maproom/v3/generateCells";
import { getRelatedCellPositions } from "../../../services/maproom/v3/getRelatedCells";
import { createCellData } from "../../../services/maproom/v3/createCellData";
import { CellSchema } from "../../../zod/CellSchema";
import { errorLog } from "../../../utils/logger";
import { loadFailureErr } from "../../../errors/errors";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { Save } from "../../../models/save.model";
import { FilterQuery } from "@mikro-orm/core";
import { mapByCoordinates } from "../../../services/maproom/v3/utils/mapByCoordinates";
import { CellData } from "../../../types/CellData";
import { postgres } from "../../../server";
import { getHexNeighborOffsets } from "../../../services/maproom/v3/getDefenderOutposts";
import { EnumYardType } from "../../../enums/EnumYardType";

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
        // Check if this position should be a defender around a player yard
        // Must check BEFORE using genCell to override tribe outposts
        const offsets = getHexNeighborOffsets(x, y);
        let isDefender = false;

        for (const [dx, dy] of offsets) {
          const neighborKey = `${x + dx},${y + dy}`;

          // check merged map (includes both db and generated cells)
          const neighborInMap = allCellsByCoord.get(neighborKey);
          if (neighborInMap?.t === EnumYardType.PLAYER) {
            isDefender = true;
            break;
          }
        }

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
    errorLog("Error in getMapRoomCells:", error);
    throw loadFailureErr();
  }
};
