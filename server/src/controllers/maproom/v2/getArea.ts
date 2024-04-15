import { KoaController } from "../../../utils/KoaController";
import { wildMonsterCell } from "./cells/wildMonsterCell";
import { homeCell } from "./cells/homeCell";
import { User } from "../../../models/user.model";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { ORMContext } from "../../../server";
import { calculateBaseLevel } from "../../../services/base/calculateBaseLevel";
import { generateTerrain } from "./terrain/generateTerrain";
import { Terrain } from "./terrain/Terrain";
import { outpostCell } from "./cells/outpostCell";
import { devConfig } from "../../../config/DevSettings";

interface Cell {
  x?: number;
  y?: number;
  width?: number;
  height?: number;
  sendresources?: number;
}

export const getArea: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const requestBody: Cell = ctx.request.body;
  await ORMContext.em.populate(user, ["save"]);
  const save = user.save;

  for (const key in requestBody) {
    requestBody[key] = parseInt(requestBody[key], 10) || 0;
  }

  const width = requestBody.width || 10;
  const height = requestBody.height || 10;
  const currentX = requestBody.x;
  const currentY = requestBody.y;
  const sendresources = requestBody.sendresources || 0;

  const terrainMap = generateTerrain(height, height);

  // Converts terrain map to a map of terrain types represented as numbers
  const terrainTypeValues: number[][] = terrainMap.map((row) =>
    row.map((cell) => cell)
  );

  // Creates {maxX} x {maxY} grid from point 0 x 0
  const maxX = currentX + width;
  const maxY = currentY + height;

  const wCells = await ORMContext.em.find(WorldMapCell, {
    x: {
      $gte: currentX,
      $lte: maxX,
    },
    y: {
      $gte: currentY,
      $lte: maxY,
    },
    world_id: "1", // ToDo: implement a world table?
  });

  const baseLevel = calculateBaseLevel(save.points, save.basevalue);

  const worldMap = wCells.reduce<{
    [x: number]: { [y: number]: WorldMapCell };
  }>((acc, obj) => {
    const { x, y } = obj;
    if (!acc[x]) {
      acc[x] = {};
    }
    acc[x][y] = obj;
    return acc;
  }, {});

  let cells = {};

  for (let x = currentX; x < maxX; x++) {
    cells[x] = {};

    for (let y = currentY; y < maxY; y++) {
      const terrain = terrainTypeValues[x - currentX][y - currentY];

      if (worldMap.hasOwnProperty(x)) {
        if (worldMap[x].hasOwnProperty(y)) {
          const cell = worldMap[x][y];
          if (cell.base_type != 1) {
            cells[x][y] = await homeCell(ctx, cell);
          }
          continue;
        }
      }

      const cell = new WorldMapCell();
      cell.x = x;
      cell.y = y;
      cell.base_id = 0;
      cell.world_id = save.worldid;
      const s_lvl = baseLevel < 20 ? 10 : baseLevel < 30 ? 20 : 30; // ToDo: add level randomness base on auth save level

      if (
        terrain === Terrain.WATER1 ||
        terrain === Terrain.WATER2 ||
        terrain === Terrain.WATER3
      ) {
        cells[x][y] = { i: terrain };
        continue;
      }

      cells[x][y] = await wildMonsterCell(terrain, cell, s_lvl);
    }
  }

  if (devConfig.maproom) {
    ctx.status = 200;
    ctx.body = {
      error: 0,
      x: currentX,
      y: currentY,
      data: cells,
      // resources: save.resources,
      // alliancedata
    };

    if (sendresources === 1) {
      ctx.body["resources"] = save.resources;
      ctx.body["credits"] = save.credits;
    }
  } else {
    ctx.status = 404;
    ctx.body = { message: "MapRoom is not enabled on this server", error: 1 };
  }
};
