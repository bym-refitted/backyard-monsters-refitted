// import { Terrain } from "./Terrain";

// // 10 x 10
// export const generateTerrain = (width: number, height: number) => {
//   const terrain: Terrain[][] = [];
//   const waterTerrain: boolean[][] = [];

//   // Create a default terrain
//   for (let rowIndex = 0; rowIndex < height; rowIndex++) {
//     // row: [[terrain],[terrain]]
//     //      [[terrain],[terrain]]
//     const row: Terrain[] = [];
//     const waterRow: boolean[] = [];
//     for (let colIndex = 0; colIndex < width; colIndex++) {
//       row.push(Terrain.LAND6);
//       waterRow.push(false);
//     }
//     terrain.push(row);
//     waterTerrain.push(waterRow);
//   }

//   // Water grid: [w: 2-6] [h: 2-5]
//   const waterGridWidth = Math.floor(Math.random() * 5) + 2;
//   const waterGridHeight = Math.floor(Math.random() * 4) + 2;

//   const waterStartX = Math.floor(Math.random() * (width - waterGridWidth + 1));
//   const waterStartY = Math.floor(
//     Math.random() * (height - waterGridHeight + 1)
//   );

//   // Generate water grid
//   for (let y = waterStartY; y < waterStartY + waterGridHeight; y++) {
//     for (let x = waterStartX; x < waterStartX + waterGridWidth; x++) {
//       const isWatersEdge =
//         y === waterStartY ||
//         y === waterStartY + waterGridHeight - 1 ||
//         x === waterStartX ||
//         x === waterStartX + waterGridWidth - 1;

//       terrain[y][x] = getRandomWaterTerrain(isWatersEdge);
//       waterTerrain[y][x] = true;
//     }
//   }

//   // Fill the rest of the map with non-water terrains
//   for (let rowIndex = 0; rowIndex < height; rowIndex++) {
//     for (let colIndex = 0; colIndex < width; colIndex++) {
//       if (!waterTerrain[rowIndex][colIndex]) {
//         const terrainBesideWater = isAdjacentToWater(waterTerrain, rowIndex, colIndex);
//         terrain[rowIndex][colIndex] = getNextTerrain(terrainBesideWater);
//       }
//     }
//   }
//   return terrain;
// };

// const getRandomWaterTerrain = (isWatersEdge: boolean): Terrain => {
//   if (isWatersEdge) {
//     const randomIndex = Math.random();
//     return randomIndex < 0.5 ? Terrain.WATER3 : Terrain.WATER2;
//   }

//   const randomIndex = Math.floor(Math.random() * 2);
//   switch (randomIndex) {
//     case 0:
//       return Terrain.WATER1;
//     default:
//       return Terrain.WATER2;
//   }
// };

// const getNextTerrain = (isAdjacentToWater: boolean): Terrain => {
//   if (isAdjacentToWater) {
//     const randomIndex = Math.floor(Math.random() * 4);
//     switch (randomIndex) {
//       case 0:
//         return Terrain.SAND1;
//       case 1:
//         return Terrain.SAND2;
//       case 2:
//         return Terrain.LAND1;
//       default:
//         return Terrain.LAND2;
//     }
//   } else {
//     const randomIndex = Math.floor(Math.random() * 8);
//     switch (randomIndex) {
//       case 0:
//         return Terrain.SAND1;
//       case 1:
//         return Terrain.SAND2;
//       case 2:
//         return Terrain.LAND1;
//       case 3:
//         return Terrain.LAND2;
//       case 4:
//         return Terrain.LAND3;
//       // case 5:
//       //   return Terrain.LAND4; // Leave these commented out for now until we figure out basics
//       // case 6:
//       //   return Terrain.ROCK;
//       default:
//         return Terrain.LAND2; // should be LAND6
//     }
//   }
// };

// // This doesn't work 100% fuck
// const isAdjacentToWater = (waterTerrain: boolean[][], rowIndex: number, colIndex: number) => {
//   const neighborOffsets = [
//     [-1, 0],   // Up
//     [1, 0],    // Down
//     [0, -1],   // Left
//     [0, 1],    // Right
//   ];

//   for (const [rowOffset, colOffset] of neighborOffsets) {
//     const neighborRow = rowIndex + rowOffset;
//     const neighborCol = colIndex + colOffset;
    
//     if (neighborRow >= 0 && neighborRow < waterTerrain.length && 
//         neighborCol >= 0 && neighborCol < waterTerrain[0].length) {
//       if (waterTerrain[neighborRow][neighborCol]) {
//         return true;
//       }
//     }
//   }
//   return false;
// };
