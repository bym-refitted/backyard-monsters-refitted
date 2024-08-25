import { ORMContext } from "../../../server";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { EntityManager } from "@mikro-orm/mariadb";
import { logging } from "../../../utils/logger";
import { MapRoom } from "../../../enums/MapRoom";

interface FreeXY {
  x: number;
  y: number;
}

// TODO: This file is not in use, and should be removed after review.
export const getFreeCell = async (
  world_id: string,
  migrate = false
): Promise<WorldMapCell> => {
  const coordinates = migrate
    ? await generateRandomCoordinates(world_id)
    : await getRandomXY(world_id);
  const cell = new WorldMapCell();
  cell.world_id = world_id;
  cell.x = coordinates.x;
  cell.y = coordinates.y;

  return cell;
};

/**
 * Generate a random x and y
 * @param world_id
 */
const generateRandomCoordinates = async (world_id: string): Promise<FreeXY> => {
  const fork = ORMContext.em.fork() as EntityManager;
  const minX = 0; // Define your map's min X value
  const maxX = MapRoom.WIDTH - 1; // Define your map's max X value
  const minY = 0; // Define your map's min Y value
  const maxY = MapRoom.HEIGHT - 1; // Define your map's max Y value

  // Generate random x and y within the map's range
  const randomX = Math.floor(Math.random() * (maxX - minX + 1)) + minX;
  const randomY = Math.floor(Math.random() * (maxY - minY + 1)) + minY;

  // Check if the random coordinates are available in the database
  const cell = await fork.findOne(WorldMapCell, {
    x: {
      $gte: randomX - 1,
      $lte: randomX + 1,
    },
    y: {
      $gte: randomY - 1,
      $lte: randomY + 1,
    },
    world_id: world_id,
  });

  if (!cell) {
    // The random coordinates are available
    return { x: randomX, y: randomY };
  } else {
    // Coordinates are already taken or within the range of an existing cell
    // You can retry or handle this case according to your requirements
    return generateRandomCoordinates(world_id); // Retry
  }
};

/**
 * Generate random x and based on last coordinates
 * @param world_id
 * @param max_retry
 */
const getRandomXY = async (
  world_id: string,
  max_retry: number = 10
): Promise<FreeXY> => {
  const fork = ORMContext.em.fork() as EntityManager;

  const latestCell = await fork.findOne(
    WorldMapCell,
    {
      world_id: world_id,
      base_type: {
        $ne: 1,
      },
    },
    {
      orderBy: {
        cell_id: "desc",
      },
    }
  );

  if (!latestCell) {
    return { x: 0, y: 0 };
  }

  const minX = Math.max(0, latestCell.x - Math.floor(Math.random() * 8) - 3);
  const minY = Math.max(0, latestCell.y - Math.floor(Math.random() * 8) - 3);
  const maxX = Math.min(499, latestCell.x + Math.floor(Math.random() * 8) + 3);
  const maxY = Math.min(499, latestCell.y + Math.floor(Math.random() * 8) + 3);

  let retryCount = 0;
  while (retryCount < max_retry) {
    // Generate random x and y coordinates within the range
    const x = Math.floor(Math.random() * (maxX - minX + 1)) + minX;
    const y = Math.floor(Math.random() * (maxY - minY + 1)) + minY;
    const cell = await fork.findOne(WorldMapCell, {
      x: {
        $gte: x - 1,
        $lte: x + 1,
      },
      y: {
        $gte: y - 1,
        $lte: y + 1,
      },
      world_id: world_id,
      base_type: {
        $ne: 1,
      },
    });

    if (!cell) {
      // Coordinate is available
      return { x, y };
    }

    // Coordinate is taken, retry
    retryCount++;
  }

  throw new Error(
    `Failed to generate a random coordinate after ${max_retry} retries`
  );
};

const generateNewWorld = async (): Promise<string> => {
  logging("Generating new world...");
  const fork = ORMContext.em.fork();
  const latestWorld = await fork.findOne(WorldMapCell, null, {
    orderBy: {
      world_id: "desc",
    },
  });

  let world_id = "1";
  if (latestWorld) {
    world_id = (parseInt(latestWorld.world_id) + 1).toString(10);
  }

  const maxX = 800;
  const maxY = 800;

  const cells: WorldMapCell[] = [];

  for (let x = 0; x < maxX; x++) {
    for (let y = 0; y < maxY; y++) {
      const cell = new WorldMapCell();
      cell.world_id = world_id;
      cell.x = x;
      cell.y = y;
      cell.uid = 0;
      cell.base_type = 1;
      cell.base_id = 0;
      cells.push(cell);
    }
  }

  await fork.persistAndFlush(cells);
  return world_id;
};

export const getBounds = (x: number, y: number, width: number = 10) => {
  const mapSize = 800;
  const halfWidth = Math.floor(width / 2);
  let minX = x - halfWidth;
  let minY = y - halfWidth;
  let maxX = x + halfWidth;
  let maxY = y + halfWidth;

  // Adjust minX and minY if they go beyond 0
  if (minX < 0) minX = 0;
  if (minY < 0) minY = 0;

  // Adjust maxX and maxY if they exceed mapSize
  if (maxX >= mapSize) maxX = mapSize;
  if (maxY >= mapSize) maxY = mapSize;

  return { minX, minY, maxX, maxY };
};

export const generateBaseID = (worldID: number, x: number, y: number) => {
  return (worldID + 1) * 1000000 + (y + 1) * 1000 + (x + 1);
};

export const getWorldID = (cellID: number) => {
  return Math.floor(cellID / 1000000);
};

export const getXPosition = (cellID: number) => {
  return Math.floor((cellID % 1000000) % 1000);
};

export const getYPosition = (cellID: number) => {
  return Math.floor((cellID % 1000000) / 1000);
};
