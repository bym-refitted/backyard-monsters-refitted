import { Terrain } from "./Terrain";

export const generateTerrain = (width: number, height: number) => {
  const terrain: Terrain[][] = [];
  const waterTerrain: boolean[][] = [];

  // Create a default terrain
  for (let rowIndex = 0; rowIndex < height; rowIndex++) {
    const row: Terrain[] = [];
    const waterRow: boolean[] = [];
    for (let colIndex = 0; colIndex < width; colIndex++) {
      row.push(Terrain.LAND6);
      waterRow.push(false);
    }
    terrain.push(row);
    waterTerrain.push(waterRow);
  }

  // Water grid: [w: 2-6] [h: 2-5]
  const waterGridWidth = Math.floor(Math.random() * 5) + 2;
  const waterGridHeight = Math.floor(Math.random() * 4) + 2;

  const waterStartX = Math.floor(Math.random() * (width - waterGridWidth + 1));
  const waterStartY = Math.floor(
    Math.random() * (height - waterGridHeight + 1)
  );

  // Generate water grid
  for (let y = waterStartY; y < waterStartY + waterGridHeight; y++) {
    for (let x = waterStartX; x < waterStartX + waterGridWidth; x++) {
      const isWatersEdge =
        y === waterStartY ||
        y === waterStartY + waterGridHeight - 1 ||
        x === waterStartX ||
        x === waterStartX + waterGridWidth - 1;

      terrain[y][x] = getRandomWaterTerrain(isWatersEdge);
      waterTerrain[y][x] = true;
    }
  }

  // Fill the rest of the map with non-water terrains
  for (let rowIndex = 0; rowIndex < height; rowIndex++) {
    for (let colIndex = 0; colIndex < width; colIndex++) {
      if (!waterTerrain[rowIndex][colIndex]) {
        terrain[rowIndex][colIndex] = getRandomLandTerrain();
      }
    }
  }
  return terrain;
};

const getRandomWaterTerrain = (isWatersEdge: boolean): Terrain => {
  if (isWatersEdge) {
    const randomIndex = Math.random();
    return randomIndex < 0.5 ? Terrain.WATER3 : Terrain.WATER2;
  }

  const randomIndex = Math.floor(Math.random() * 2);
  switch (randomIndex) {
    case 0:
      return Terrain.WATER1;
    default:
      return Terrain.WATER2;
  }
};

const getRandomLandTerrain = (): Terrain => {
  const randomIndex = Math.floor(Math.random() * 8);
  switch (randomIndex) {
    case 0:
      return Terrain.SAND1;
    case 1:
      return Terrain.SAND2;
    case 2:
      return Terrain.LAND1;
    case 3:
      return Terrain.LAND2;
    case 4:
      return Terrain.LAND3;
    case 5:
      return Terrain.LAND4;
    case 6:
      return Terrain.ROCK;
    default:
      return Terrain.LAND6;
  }
};
