import { KoaController } from "../../../utils/KoaController";
import { wildMonsterCell } from "./cells/wildMonsterCell";
import { homeCell } from "./cells/homeCell";
import { User } from "../../../models/user.model";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { ORMContext } from "../../../server";
import { calculateBaseLevel } from "../../../services/base/calculateBaseLevel";
import { Terrain } from "./terrain/Terrain";
import { devConfig } from "../../../config/DevSettings";
import { generateBaseID } from "../../../services/maproom/v2/world";
import { ValueNoise } from "value-noise-js";
import { World } from "../../../models/world.model";
import { MAPROOM } from "../../../enums/MapRoom";

interface Cell {
  x?: number;
  y?: number;
  width?: number;
  height?: number;
  sendresources?: number;
}

// We ignore whats requested by the client as the fronend is hardcoded to 10x10
const width = 10;
const height = 10;

export const generateZone = (
  seed: string,
  currentX: number,
  currentY: number
) => {
  const cells = {};
  for (let x = 0; x < width; x++) {
    const cellX = currentX + x;
    cells[cellX] = {};

    for (let y = 0; y < height; y++) {
      const cellY = currentY + y;
      const noise = new ValueNoise(seed, undefined, "perlin");
      const noiseScale = 3;
      const terrainScale = 83;

      /**
       * The noise function is used to generate the terrain height.
       * +1 is added to get rid of the negative values.
       * We multiply by the terrain scale to get the desired height.
       *
       * Higher terrain: increase the terrain scale.
       * Lower terrain: decrease the terrain scale.
       *
       * Smoother terrain over a larger area, increase the noise scale.
       * Rougher terrain, decrease the noise scale.
       */
      const terrainHeight = Math.round(
        (noise.evalXY(cellX / noiseScale, cellY / noiseScale) + 1) *
          terrainScale
      );

      // if (terrainHeight <= Terrain.WATER3) {
      cells[cellX][cellY] = { i: terrainHeight };
      //   continue;
      // }

      // // await homeCell(ctx, cell)

      // const tribe = (cellX + cellY) % tribes.length;
      // const tribeName = tribes[tribe];

      // const monsterCell = {
      //   uid: Math.round(
      //     ((1 / 2) * (cellX + cellY) * (cellX + cellY + 1) + cellY) * 10000
      //   ), // This is shit code fix me
      //   b: 1,
      //   fbid: "facebook",
      //   pi: 0,
      //   bid: generateBaseID(parseInt(seed), cellX, cellY),
      //   aid: 0,
      //   i: terrainHeight,
      //   mine: 0,
      //   f: save?.flinger || 0,
      //   c: save?.catapult || 0,
      //   t: 0,
      //   n: tribeName,
      //   fr: 0,
      //   on: 0,
      //   p: 0,
      //   r: save?.resources || 0,
      //   m: save?.monsters || 0,
      //   l: terrainHeight,
      //   d: save?.destroyed || 0,
      //   lo: save?.locked || 0,
      //   dm: save?.damage || 0,
      //   pic_square: "",
      //   im: "",
      // };
      // cells[cellX][cellY] = monsterCell;
    }
  }
  return cells;
};

/**
 * Generates a zone id based on the x and y coordinates
 * The x is multiplied by 100000 to ensure that the zone id is unique per world
 */
const getZoneId = (x: number, y: number) => {
  return x * 100000 + y;
};

export const generateFullMap = async (
  world: World,
  context: typeof ORMContext
) => {
  // Creates a function to get the cell from the noise, uses alea for generation based on a seed
  // const getCellFromNoise: NoiseFunction2D = createNoise2D(Alea(seed));
  const cells = {};
  const tribes = ["Legionnaire", "Kozu", "Abunakki", "Dreadnaut"];

  for (let x = 0; x < MAPROOM.WIDTH; x++) {
    const cellX = x;
    cells[cellX] = {};

    for (let y = 0; y < MAPROOM.HEIGHT; y++) {
      const cellY = y;
      const noise = new ValueNoise(world.uuid, undefined, "perlin"); // Use the uuid as the seed

      const noiseScale = 3;
      const terrainScale = 83;

      /**
       * The noise function is used to generate the terrain height.
       * +1 is added to get rid of the negative values.
       * We multiply by the terrain scale to get the desired height.
       *
       * Higher terrain: increase the terrain scale.
       * Lower terrain: decrease the terrain scale.
       *
       * Smoother terrain over a larger area, increase the noise scale.
       * Rougher terrain, decrease the noise scale.
       */
      const terrainHeight = Math.round(
        (noise.evalXY(cellX / noiseScale, cellY / noiseScale) + 1) *
          terrainScale
      );

      world.cells.add(new WorldMapCell(world, cellX, cellY, terrainHeight));

      // if (terrainHeight <= Terrain.WATER3) {
      //   cells[cellX][cellY] = { i: terrainHeight };
      //   continue;
      // }

      // // await homeCell(ctx, cell)

      // const tribe = (cellX + cellY) % tribes.length;
      // const tribeName = tribes[tribe];

      // const monsterCell = {
      //   b: 1,
      //   bid: generateBaseID(parseInt(seed), cellX, cellY),
      //   i: terrainHeight,
      //   n: tribeName,
      //   l: terrainHeight,
      //   // These are only needed once a cell is attacked.
      //   dm: 0,
      //   d: 0,
      // };
      // cells[cellX][cellY] = monsterCell;
    }
    if (x % 100 === 0) {
      console.log(`Seeding world: ${world.uuid} into database.`);
      await context.em.persistAndFlush(world);
    }
  }

  return world;
};

export const getArea: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const requestBody: Cell = ctx.request.body;
  await ORMContext.em.populate(user, ["save"]);

  const save = user.save;
  // const seed = save.worldid;

  // TODO: Use zod to sort this out
  for (const key in requestBody) {
    requestBody[key] = parseInt(requestBody[key], 10) || 0;
  }

  const currentX = requestBody.x;
  const currentY = requestBody.y;
  // The max world size is 999x999 because the zone id cant handle more than 6 digits. This is hardcoded in the frontend
  // const zoneId = getZoneId(currentX, currentY);

  // Check if the zone exists in the database
  // Otherwise generate the mosnters

  const sendresources = requestBody.sendresources || 0;

  // Creates a function to get the cell from the noise, uses alea for generation based on a seed
  // const getCellFromNoise: NoiseFunction2D = createNoise2D(Alea(seed));
  const cells = {};
  const tribes = ["Legionnaire", "Kozu", "Abunakki", "Dreadnaut"];

  const dbCells = await ORMContext.em.find(WorldMapCell, {
    x: {
      $gte: currentX,
      $lte: currentX + width,
    },
    y: {
      $gte: currentY,
      $lte: currentY + height,
    },
    world_id: save.worldid,
  });

  for (const cell of dbCells) {
    if (!cells[cell.x]) cells[cell.x] = {};
    if (cell.terrainHeight <= Terrain.WATER3) {
      cells[cell.x][cell.y] = { i: cell.terrainHeight };
      continue;
    }

    // If it's a homebase cell or outpost
    if (cell.base_type >= 2) {
      const base = await homeCell(ctx, cell);
      cells[cell.x][cell.y] = base;
      continue;
    }

    const tribe = (cell.x + cell.y) % tribes.length;
    const tribeName = tribes[tribe];
    cells[cell.x][cell.y] = {
      uid: parseInt(`${cell.x}${cell.y}`),
      b: 1,
      i: cell.terrainHeight,
      bid: parseInt(`${cell.x}${cell.y}`),
      n: tribeName,
      l: 40,
      dm: 0,
      d: 0,
    };
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
