import alea from "alea";
import { createNoise2D } from "simplex-noise";
import { MapRoom3 } from "../../../enums/MapRoom";
import {
  CELL_SEED,
  CELL_EDGE,
  PLACEMENT_NOISE_SCALE,
  PLACEMENT_THRESHOLD,
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

  const noise = createNoise2D(alea(CELL_SEED));

  // Simple RNG for clover distribution
  const cloverRng = alea(CELL_SEED + "-clover");

  for (let y = CELL_EDGE; y < MapRoom3.HEIGHT - CELL_EDGE; y++) {
    for (let x = CELL_EDGE; x < MapRoom3.WIDTH - CELL_EDGE; x++) {
      let altitude: number | null = null;

      const noiseValue = noise(
        x / PLACEMENT_NOISE_SCALE,
        y / PLACEMENT_NOISE_SCALE
      );

      if (noiseValue > PLACEMENT_THRESHOLD) {
        // Map noise value to altitude, excluding clover range (32-49)
        const normalizedValue =
          (noiseValue - PLACEMENT_THRESHOLD) / (1 - PLACEMENT_THRESHOLD);

        const lowerRange = 31 - MIN_CELL_ALTITUDE + 1;
        const upperRange = MAX_CELL_ALTITUDE - 50 + 1;
        const totalRange = lowerRange + upperRange;

        const scaledValue = normalizedValue * totalRange;

        if (scaledValue < lowerRange) {
          altitude = Math.floor(MIN_CELL_ALTITUDE + scaledValue);
        } else {
          altitude = Math.floor(50 + (scaledValue - lowerRange));
        }
      } else {
        const cloverChance = cloverRng();

        if (cloverChance > 0.7) {
          // 30% chance for clover
          const cloverVariant = cloverRng();
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
