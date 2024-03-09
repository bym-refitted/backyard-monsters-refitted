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

interface Terrain {
  terrain: TerrainType;
  threshold: number;
  probability?: number;
}

const terrains: Terrain[] = [
  { terrain: TerrainType.SAND1, threshold: 105 },
  { terrain: TerrainType.SAND2, threshold: 110 },
  { terrain: TerrainType.LAND1, threshold: 120 },
  { terrain: TerrainType.LAND2, threshold: 140 },
  { terrain: TerrainType.LAND3, threshold: 160 },
  { terrain: TerrainType.LAND4, threshold: 170 },
  { terrain: TerrainType.ROCK, threshold: 175 },
  { terrain: TerrainType.LAND6, threshold: Infinity },
];

const waterTerrains: Terrain[] = [
  { terrain: TerrainType.WATER1, threshold: 80, probability: 0.05 },
  { terrain: TerrainType.WATER2, threshold: 90 },
  { terrain: TerrainType.WATER3, threshold: 100 },
];

export const generateMapTerrain = (
  width: number,
  height: number
): TerrainType[][] => {
  const map: TerrainType[][] = [];

  // Generates random heights for each cell
  for (let rowIndex = 0; rowIndex < height; rowIndex++) {
    const row: TerrainType[] = [];
    for (let colIndex = 0; colIndex < width; colIndex++) {
      const cellHeight = Math.floor(Math.random() * 200); // Heights (0-200)
      row.push(generateTerrain(cellHeight));
    }
    map.push(row);
  }

  return map;
};

const generateTerrain = (height: number): TerrainType => {
  const randomNumber = Math.random();

  // Check if the random number falls within the water probability range
  // If within water probability range, select water terrain
  if (randomNumber < waterTerrains[0].probability) {
    for (const { terrain, threshold } of waterTerrains) {
      if (height < threshold) return terrain;
    }
    return TerrainType.WATER3;
  } else {
    // Select other terrains
    for (const { terrain, threshold } of terrains) {
      if (height < threshold) return terrain;
    }
    return TerrainType.LAND6;
  }
};
