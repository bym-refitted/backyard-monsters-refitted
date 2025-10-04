import alea from "alea";
import { createNoise2D } from "simplex-noise";
import { MapRoom3 } from "../../../enums/MapRoom";
import {
  CELL_SEED,
  CELL_EDGE,
  PLACEMENT_NOISE_SCALE,
  PLACEMENT_THRESHOLD,
  TYPE_NOISE_SCALE,
  MAX_CELL_ALTITUDE,
  MIN_CELL_ALTITUDE,
} from "../../../config/WorldGenSettings";

interface Cell {
  i: number;
  x: number;
  y: number;
}

let cachedCells: Cell[] | null = null;

export const generateCells = (): Cell[] => {
  if (cachedCells) return cachedCells;

  const cells: Cell[] = [];

  const placementNoise = createNoise2D(alea(CELL_SEED + "-placement"));
  const cloverNoise = createNoise2D(alea(CELL_SEED + "-clover"));
  const typeNoise = createNoise2D(alea(CELL_SEED + "-type"));

  for (let y = CELL_EDGE; y < MapRoom3.HEIGHT - CELL_EDGE; y++) {
    for (let x = CELL_EDGE; x < MapRoom3.WIDTH - CELL_EDGE; x++) {
      // Use placement noise to determine where main cells appear
      const noiseValue = placementNoise(
        x / PLACEMENT_NOISE_SCALE,
        y / PLACEMENT_NOISE_SCALE
      );

      let altitude: number | null = null;

      // Main cell clusters (all types including spiky, green, brown, clovers)
      if (noiseValue > PLACEMENT_THRESHOLD) {
        // Use type noise to determine which cell type (altitude)
        const typeValue = typeNoise(x / TYPE_NOISE_SCALE, y / TYPE_NOISE_SCALE);

        // Map type noise (-1 to 1) to altitude range
        // This creates smooth transitions between cell types
        const normalizedType = (typeValue + 1) / 2; // Convert to 0-1 range
        const altitudeRange = MAX_CELL_ALTITUDE - MIN_CELL_ALTITUDE;
        altitude = Math.floor(
          MIN_CELL_ALTITUDE + normalizedType * altitudeRange
        );
      } else {
        // If no main cells, use clover layer to fill gaps and break up islands
        // Clover layer with smaller scale breaks up the island pattern
        const cloverValue = cloverNoise(x / 3, y / 3);

        if (cloverValue > 0.5) {
          // Reuse cloverValue for variant selection
          const cloverVariant = Math.abs(cloverValue);
          altitude = Math.floor(32 + cloverVariant * 17); // 32-49 range
        }
      }

      if (altitude !== null) {
        cells.push({
          i: altitude,
          x,
          y,
        });
      }
    }
  }

  cachedCells = cells;
  return cells;
};
