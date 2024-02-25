import { KoaController } from "../../../utils/KoaController";
import { wildMonsterCell } from "./cells/wildMonsterCell";
import { homeCell } from "./cells/homeCell";
import { outpostCell } from "./cells/outpostCell";
import { devConfig } from "../../../config/DevSettings";

interface Cell {
  x?: number;
  y?: number;
  width?: number;
  height?: number;
}

export const getArea: KoaController = async (ctx) => {
  const requestBody: Cell = ctx.request.body;

  for (const key in requestBody) {
    requestBody[key] = parseInt(requestBody[key], 10) || 0;
  }

  const currentX = requestBody.x || 0;
  const currentY = requestBody.y || 0;
  const width = requestBody.width || 10;
  const height = requestBody.height || 10;

  // Creates {maxX} x {maxY} grid from point 0 x 0
  const maxX = currentX + width;
  const maxY = currentY + height;

  let cells = {};

  for (let x = currentX; x < maxX; x++) {
    cells[x] = {};

    for (let y = currentY; y < maxY; y++) {
      cells[x][y] = await wildMonsterCell();

      // Testing - Hardcoded co-ordinates to load base types
      if (x === 0 && y === 0) {
        cells[x][y] = await homeCell(ctx);
      }

      if (x === 2 && y === 1) {
        cells[x][y] = await outpostCell(ctx);
      }
    }
  }

  if (devConfig.maproom) {
    ctx.status = 200;
    ctx.body = {
      error: 0,
      x: currentX,
      y: currentY,
      data: cells,
      // resources
      // alliancedata
    };
  } else {
    ctx.status = 404;
    ctx.body = { message: "MapRoom is not enabled on this server", error: 1 };
  }
};
