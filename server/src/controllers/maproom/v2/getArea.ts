import { KoaController } from "../../../utils/KoaController";
import { wildMonsterCell } from "./cells/wildMonsterCell";
import { homeCell } from "./cells/homeCell";
import { User } from "../../../models/user.model";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { ORMContext } from "../../../server";
import { calculateBaseLevel } from "../../../services/base/calculateBaseLevel";
import { Terrain } from "./terrain/Terrain";
import { outpostCell } from "./cells/outpostCell";
import { devConfig } from "../../../config/DevSettings";
import Alea from "alea";

import { NoiseFunction2D, createNoise2D } from "simplex-noise";
import { generateBaseID } from "../../../services/maproom/v2/world";
import { ValueNoise } from "value-noise-js";

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
  const seed = "1"; // save.worldid

  // TODO: Use zod to sort this out
  for (const key in requestBody) {
    requestBody[key] = parseInt(requestBody[key], 10) || 0;
  }

  const width = requestBody.width || 10;
  const height = requestBody.height || 10;
  const currentX = requestBody.x;
  const currentY = requestBody.y;
  const sendresources = requestBody.sendresources || 0;

  // Creates a function to get the cell from the noise, uses alea for generation based on a seed
  // const getCellFromNoise: NoiseFunction2D = createNoise2D(Alea(seed));
  const cells = {};
  const tribes = ["Legionnaire", "Kozu", "Abunakki", "Dreadnaut"];

  for (let x = 0; x < width; x++) {
    const cellX = currentX + x;
    cells[cellX] = {};

    for (let y = 0; y < height; y++) {
      const cellY = currentY + y;
      const noise = new ValueNoise(seed, undefined, "perlin");
      // const terrainHeight = Math.round( + 1) * 150);
      const noiseScale = 3;
      const terrainScale = 83;
      /**
       * The noise function is used to generate the terrain height
       * 1 is added to get rid of the negative values
       * We multiply by the terrain scale to get the desired height
       *
       * To get more mountains, increase the terrain scale
       * more water, decrease the terrain scale
       *
       * Smoother terrain over a larger area, increase the noise scale
       * Rougher terrain, decrease the noise scale
       */
      let terrainHeight = Math.round(
        (noise.evalXY(cellX / noiseScale, cellY / noiseScale) + 1) *
          terrainScale
      );
      
      if (terrainHeight <= Terrain.WATER3) {
        cells[cellX][cellY] = { i: terrainHeight };
        continue;
      }

      const tribe = (cellX + cellY) % tribes.length;
      const tribeName = tribes[tribe];

      const monsterCell = {
        uid: Math.round(
          ((1 / 2) * (cellX + cellY) * (cellX + cellY + 1) + cellY) * 10000
        ), // This is shit code fix me
        b: 1,
        fbid: "facebook",
        pi: 0,
        bid: generateBaseID(parseInt(seed), cellX, cellY),
        aid: 0,
        i: terrainHeight,
        mine: 0,
        f: save?.flinger || 0,
        c: save?.catapult || 0,
        t: 0,
        n: tribeName,
        fr: 0,
        on: 0,
        p: 0,
        r: save?.resources || 0,
        m: save?.monsters || 0,
        l: terrainHeight,
        d: save?.destroyed || 0,
        lo: save?.locked || 0,
        dm: save?.damage || 0,
        pic_square: "",
        im: "",
      };
      cells[cellX][cellY] = monsterCell;
    }
  }

  if (devConfig.maproom) {
    ctx.status = 200;
    ctx.body = {
      error: 0,
      x: currentX,
      y: currentY,
      data: cells,
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

// Old implementation
// export const getArea_Old: KoaController = async (ctx) => {
//   const user: User = ctx.authUser;
//   const requestBody: Cell = ctx.request.body;
//   await ORMContext.em.populate(user, ["save"]);
//   const save = user.save;

//   // TODO: Use zod to sort this out
//   for (const key in requestBody) {
//     requestBody[key] = parseInt(requestBody[key], 10) || 0;
//   }

//   const width = requestBody.width || 10;
//   const height = requestBody.height || 10;
//   const currentX = requestBody.x;
//   const currentY = requestBody.y;
//   const sendresources = requestBody.sendresources || 0;

//   // TODO: Check if there is a free map - if not generate a new one
//   const terrainMap = generateTerrain(height, height);

//   // Converts terrain map to a map of terrain types represented as numbers
//   const terrainTypeValues: number[][] = terrainMap.map((row) =>
//     row.map((cell) => cell)
//   );

//   // Creates {maxX} x {maxY} grid from point 0 x 0
//   const maxX = currentX + width;
//   const maxY = currentY + height;

//   const worldCellChunk = await ORMContext.em.find(WorldMapCell, {
//     x: {
//       $gte: currentX,
//       $lte: maxX,
//     },
//     y: {
//       $gte: currentY,
//       $lte: maxY,
//     },
//     world_id: "1", // ToDo: implement a world table?
//   });

//   // TODO: this seems wrong
//   const baseLevel = calculateBaseLevel(save.points, save.basevalue);

//   interface WorldMap {
//     [coordinateX: number]: {
//       [coordinateY: number]: WorldMapCell;
//     };
//   }

//   // Converts the array into a nested object to select cells by coordinates
//   const worldMap = worldCellChunk.reduce<WorldMap>((result, currentCell) => {
//     const { x: coordinateX, y: coordinateY } = currentCell;
//     if (!result[coordinateX]) {
//       result[coordinateX] = {};
//     }
//     result[coordinateX][coordinateY] = currentCell;
//     return result;
//   }, {});

//   let cells = {};

//   //example : currentX = 20, currentY = 20, maxX = 30, maxY = 30
//   for (let x = currentX; x < maxX; x++) {
//     // cell[30] = {}
//     cells[x] = {};

//     for (let y = currentY; y < maxY; y++) {
//       // terrainTypeValues[xIndex][yIndex] = terrainTypeValues[0][0]
//       const terrain = terrainTypeValues[x - currentX][y - currentY];
//       // Map the level to either 10, 20 or 30
//       const enemyBaseLevel = baseLevel < 20 ? 10 : baseLevel < 30 ? 20 : 30; // ToDo: add level randomness base on auth save level

//       // This should be true or the above code is fucked
//       if (worldMap.hasOwnProperty(x)) {
//         if (worldMap[x].hasOwnProperty(y)) {
//           // Check if its a base or a monster base
//           const cell = worldMap[x][y];
//           if (cell.base_type != 1) {
//             cells[x][y] = await homeCell(ctx, cell);
//           } else {
//             cells[x][y] = await wildMonsterCell(terrain, cell, enemyBaseLevel);
//           }
//           continue;
//         }
//       }

//       // ? Recreate the cell for some reason?
//       const cell = new WorldMapCell();
//       cell.x = x;
//       cell.y = y;
//       cell.base_id = 0;
//       cell.world_id = save.worldid;

//       if (
//         terrain === Terrain.WATER1 ||
//         terrain === Terrain.WATER2 ||
//         terrain === Terrain.WATER3
//       ) {
//         cells[x][y] = { i: terrain };
//         continue;
//       }

//       // This should really never be hit - something has gone completely arseways if we hit here
//       cells[x][y] = await wildMonsterCell(terrain, cell, enemyBaseLevel);
//     }
//   }

//   if (devConfig.maproom) {
//     ctx.status = 200;
//     ctx.body = {
//       error: 0,
//       x: currentX,
//       y: currentY,
//       data: cells,
//       // resources: save.resources,
//       // alliancedata
//     };

//     if (sendresources === 1) {
//       ctx.body["resources"] = save.resources;
//       ctx.body["credits"] = save.credits;
//     }
//   } else {
//     ctx.status = 404;
//     ctx.body = { message: "MapRoom is not enabled on this server", error: 1 };
//   }
// };
