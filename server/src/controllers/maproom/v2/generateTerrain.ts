enum TerrainType {
  WATER1 = 79,
  WATER2 = 89,
  WATER3 = 99,
  SAND1 = 104,
  SAND2 = 109,
  LAND1 = 119,
  LAND2 = 139,
  LAND3 = 159,
  LAND4 = 169,
  ROCK = 174,
  LAND6 = 176,
}

export const generateMapTerrain = (width: number, height: number) => {
  const terrain: TerrainType[][] = [];
  const waterTerrain: boolean[][] = [];

  // Create a default terrain
  for (let rowIndex = 0; rowIndex < height; rowIndex++) {
    const row: TerrainType[] = [];
    for (let colIndex = 0; colIndex < width; colIndex++) {
      row.push(TerrainType.LAND6);
    }
    terrain.push(row);
  }

  // Create a water terrain
  for (let rowIndex = 0; rowIndex < height; rowIndex++) {
    const row: boolean[] = [];
    for (let colIndex = 0; colIndex < width; colIndex++) {
      row.push(false);
    }
    waterTerrain.push(row);
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
      terrain[y][x] = getRandomWaterTerrain();
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

const getRandomWaterTerrain = (): TerrainType => {
  const randomIndex = Math.floor(Math.random() * 3);
  switch (randomIndex) {
    case 0:
      return TerrainType.WATER1;
    case 1:
      return TerrainType.WATER2;
    default:
      return TerrainType.WATER3;
  }
};


const getRandomLandTerrain = (): TerrainType => {
  const randomIndex = Math.floor(Math.random() * 8);
  switch (randomIndex) {
    case 0:
      return TerrainType.SAND1;
    case 1:
      return TerrainType.SAND2;
    case 2:
      return TerrainType.LAND1;
    case 3:
      return TerrainType.LAND2;
    case 4:
      return TerrainType.LAND3;
    case 5:
      return TerrainType.LAND4;
    case 6:
      return TerrainType.ROCK;
    default:
      return TerrainType.LAND6;
  }
};
