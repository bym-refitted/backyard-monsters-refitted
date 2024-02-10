import { KoaController } from "../../../utils/KoaController";
import { wildMonsterCell } from "./cells/wildMonsterCell";
import { homeCell } from "./cells/homeCell";
import { outpostCell } from "./cells/outpostCell";

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

  const x = requestBody.x;
  const y = requestBody.y;

  // Creates {maxX} x {maxY} grid from point 0 x 0
  const maxX = 100;
  const maxY = 100;

  let cells = {};

  for (let x = 0; x < maxX; x++) {
    cells[x] = {};

    for (let y = 0; y < maxY; y++) {
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

  ctx.status = 200;
  ctx.body = {
    error: 0,
    x,
    y,
    data: cells,
    // resources
    // alliancedata
  };
};
