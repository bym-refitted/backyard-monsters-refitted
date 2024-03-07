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

const terrainThresholds: [TerrainType, number][] = [
  [TerrainType.WATER1, 80],
  [TerrainType.WATER2, 90],
  [TerrainType.WATER3, 100],
  [TerrainType.SAND1, 105],
  [TerrainType.SAND2, 110],
  [TerrainType.LAND1, 120],
  [TerrainType.LAND2, 140],
  [TerrainType.LAND3, 160],
  [TerrainType.LAND4, 170],
  [TerrainType.ROCK, 175],
  [TerrainType.LAND6, Infinity],
];

const generateTerrain = (height: number): TerrainType => {
  for (const [terrainType, threshold] of terrainThresholds) {
    if (height < threshold) return terrainType;
  }
  // Defaults to the highest terrain type if height exceeds all thresholds
  return TerrainType.LAND6;
};

export const generateMapTerrain = (width: number, height: number): TerrainType[][] => {
  const terrainMap: TerrainType[][] = [];

  // Generates random heights for each cell
  for (let rowIndex = 0; rowIndex < height; rowIndex++) {
    const terrainRow: TerrainType[] = [];
    
    for (let colIndex = 0; colIndex < width; colIndex++) {
      const cellHeight = Math.floor(Math.random() * 200); // Heights (0-200)
      terrainRow.push(generateTerrain(cellHeight));
    }
    terrainMap.push(terrainRow);
  }

  return terrainMap;
};
