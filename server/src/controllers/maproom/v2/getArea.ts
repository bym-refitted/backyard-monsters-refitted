import { z } from "zod";

import { KoaController } from "../../../utils/KoaController";
import { User } from "../../../models/user.model";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { ORMContext } from "../../../server";
import { devConfig } from "../../../config/DevSettings";
import { Status } from "../../../enums/StatusCodes";
import { createCellData } from "../../../services/maproom/v2/createCellData";
import { Save } from "../../../models/save.model";
import {
  generateNoise,
  getTerrainHeight,
} from "../../../config/WorldGenSettings";

/**
 * Schema for validating the request body when getting area data.
 */
const getAreaSchema = z.object({
  x: z.string().transform(x => parseInt(x, 10)),
  y: z.string().transform(y => parseInt(y, 10)),
  sendresources: z.string().optional().transform(res => parseInt(res, 10) || 0),
});

/**
 * Controller for generating cells on the World Map.
 * 
 * Processes chunks of 10 x 10 cells, retrieving persistent cells (e.g., homebases, outposts) 
 * from the database, while all other cells are stored in-memory.
 * 
 * @param {Koa.Context} ctx - The Koa context object
 * @returns {Promise<void>} A promise that resolves when the area data is retrieved and the response is sent.
 * 
 * @throws {Error} Throws an error if there are issues parsing the request body or retrieving data.
 */
export const getArea: KoaController = async (ctx) => {
  const { x, y, sendresources } = getAreaSchema.parse(ctx.request.body);

  const user: User = ctx.authUser;
  await ORMContext.em.populate(user, ["save"]);

  const save: Save = user.save;
  const worldid = save.worldid;

  // We ignore width & height sent by the client as it's already hardcoded to 10 x 10
  const width = 10;
  const height = 10;

  const currentX = x;
  const currentY = y;

  // First, get persistant cells which have been stored in the database.
  const dbCells = await ORMContext.em.find(
    WorldMapCell,
    {
      x: {
        $gte: currentX,
        $lte: currentX + width,
      },
      y: {
        $gte: currentY,
        $lte: currentY + height,
      },
      world_id: worldid,
    },
    { populate: ["save"] }
  );

  const cells = {};
  for (const cell of dbCells) {
    if (!cells[cell.x]) cells[cell.x] = {};
    cells[cell.x][cell.y] = await createCellData(cell, worldid, ctx);
  }

  // Then, fill the remaining cells in-memory
  const noise = generateNoise(save.worldid);
  for (let cellX = currentX; cellX <= currentX + width; cellX++) {
    // Ensure the cellX object exists in the cells map to append the cellY object to it
    if (!cells[cellX]) cells[cellX] = {};
    for (let cellY = currentY; cellY <= currentY + height; cellY++) {
      // The cell already exists, skip it
      if (cells[cellX][cellY]) continue;
      const terrainHeight = getTerrainHeight(noise, cellX, cellY);
      // Create a cell in-memory, skip the world being defined for memory efficency
      const inMemoryCell = new WorldMapCell(
        undefined,
        cellX,
        cellY,
        terrainHeight
      );
      cells[cellX][cellY] = await createCellData(inMemoryCell, worldid, ctx);
    }
  }

  if (devConfig.maproom) {
    ctx.status = Status.OK;
    ctx.body = {
      error: 0,
      x: currentX,
      y: currentY,
      data: cells,
      ...(sendresources === 1 && {
        resources: save.resources,
        credits: save.credits,
      }),
    };
  } else {
    ctx.status = Status.NOT_FOUND;
    ctx.body = { message: "Map Room is not enabled on this server", error: 1 };
  }
};
