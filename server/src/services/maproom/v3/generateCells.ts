import alea from "alea";

import { createNoise2D } from "simplex-noise";
import { MapRoom3 } from "../../../enums/MapRoom.js";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import { getDefenderCoords } from "./getDefenderCoords.js";
import { getDefenderLevels } from "./getDefenderLevels.js";
import { calculateStructureLevel } from "./calculateStructureLevel.js";
import { isValidPosition } from "./utils/isValidPosition.js";

import {
  CELL_SEED,
  CELL_EDGE,
  PLACEMENT_NOISE_SCALE,
  PLACEMENT_THRESHOLD,
  MAX_CELL_ALTITUDE,
  MIN_CELL_ALTITUDE,
  STRONGHOLD_SEED,
  STRONGHOLD_GRID_SIZE,
  STRONGHOLD_JITTER,
  RESOURCE_SEED,
  TRIBE_OUTPOST_SEED,
  STRUCTURE_LEVELS,
} from "../../../config/MapRoom3Config.js";

export interface GeneratedCell {
  x: number;
  y: number;
  altitude?: number;
  type?: number;
  level?: number;
}

let cachedCells: Map<number, GeneratedCell> | null = null;

/** Packs x,y coordinates into a single numeric key for Map lookups. */
export const cellKey = (x: number, y: number): number => (x << 16) | y;

/**
 * Generates all procedural cells for Map Room 3 and returns them as a Map.
 * Results are cached at module level - only generated once per server lifetime.
 *
 * Cells include: strongholds, resources, tribe outposts, defenders, and terrain (bushes/clover).
 */
export const getGeneratedCells = (): Map<number, GeneratedCell> => {
  if (cachedCells) return cachedCells;

  const cells: GeneratedCell[] = [];
  const occupiedCells = new Set<number>();

  const { WIDTH, HEIGHT } = MapRoom3;

  // ============================================================================
  // PHASE 1: Strongholds
  // ============================================================================
  const strongholdRng = alea(STRONGHOLD_SEED);

  for (let gridY = CELL_EDGE; gridY < HEIGHT - CELL_EDGE; gridY += STRONGHOLD_GRID_SIZE) {
    for (let gridX = CELL_EDGE; gridX < WIDTH - CELL_EDGE; gridX += STRONGHOLD_GRID_SIZE) {

      const centerX = gridX + Math.floor(STRONGHOLD_GRID_SIZE / 2);
      const centerY = gridY + Math.floor(STRONGHOLD_GRID_SIZE / 2);

      const jitterX = Math.floor((strongholdRng() - 0.5) * 2 * STRONGHOLD_JITTER);
      const jitterY = Math.floor((strongholdRng() - 0.5) * 2 * STRONGHOLD_JITTER);

      const x = centerX + jitterX;
      const y = centerY + jitterY;

      const key = (x << 16) | y;

      if (!isValidPosition(x, y) || occupiedCells.has(key)) continue;

      cells.push({ x, y, type: EnumYardType.STRONGHOLD });
      occupiedCells.add(key);

      const defenders = getDefenderCoords(x, y);
      
      const strongholdLevel = calculateStructureLevel(x, y, EnumYardType.STRONGHOLD);
      const defenderLevels = getDefenderLevels(EnumYardType.STRONGHOLD, strongholdLevel);

      for (let i = 0; i < defenders.length; i++) {
        const [fortX, fortY] = defenders[i];

        cells.push({ 
          x: fortX, 
          y: fortY, 
          type: EnumYardType.FORTIFICATION, 
          level: defenderLevels[i]
        });

        occupiedCells.add((fortX << 16) | fortY);
      }
    }
  }

  // ============================================================================
  // PHASE 2: Resource Outposts
  // ============================================================================
  const resourceRng = alea(RESOURCE_SEED);
  const maxResourceAttempts = (WIDTH - 2 * CELL_EDGE) * (HEIGHT - 2 * CELL_EDGE) * 0.06;

  for (let attempt = 0; attempt < maxResourceAttempts; attempt++) {
    const x = CELL_EDGE + Math.floor(resourceRng() * (WIDTH - 2 * CELL_EDGE));
    const y = CELL_EDGE + Math.floor(resourceRng() * (HEIGHT - 2 * CELL_EDGE));
    
    const key = (x << 16) | y;
    
    if (occupiedCells.has(key)) continue;

    const defenders = getDefenderCoords(x, y);
    if (defenders.some(([dx, dy]) => occupiedCells.has((dx << 16) | dy  ))) continue;

    cells.push({ x, y, type: EnumYardType.RESOURCE });
    occupiedCells.add(key);

    const resourceLevel = calculateStructureLevel(x, y, EnumYardType.RESOURCE);
    const defenderLevels = getDefenderLevels(EnumYardType.RESOURCE, resourceLevel);

    for (let i = 0; i < defenders.length; i++) {
      const [fortX, fortY] = defenders[i];

      cells.push({
         x: fortX, 
         y: fortY, 
         type: EnumYardType.FORTIFICATION, 
         level: defenderLevels[i]
        });

      occupiedCells.add((fortX << 16) | fortY);
    }
  }

  // ============================================================================
  // PHASE 3: Tribe Outposts
  // ============================================================================
  const tribeRng = alea(TRIBE_OUTPOST_SEED);
  const maxAttempts = (WIDTH - 2 * CELL_EDGE) * (HEIGHT - 2 * CELL_EDGE) * 0.12;

  for (let attempt = 0; attempt < maxAttempts; attempt++) {
    const x = CELL_EDGE + Math.floor(tribeRng() * (WIDTH - 2 * CELL_EDGE));
    const y = CELL_EDGE + Math.floor(tribeRng() * (HEIGHT - 2 * CELL_EDGE));

    const key = (x << 16) | y;
    
    if (!occupiedCells.has(key)) {
      const outpostLevels = STRUCTURE_LEVELS[EnumYardType.OUTPOST];
      const level = outpostLevels[Math.floor(tribeRng() * outpostLevels.length)];

      cells.push({ x, y, type: EnumYardType.OUTPOST, level });
      occupiedCells.add(key);
    }
  }

  // ============================================================================
  // PHASE 4: Bushes/Clover
  // ============================================================================
  const noise = createNoise2D(alea(CELL_SEED));
  const cloverRng = alea(CELL_SEED + "-clover");

  for (let y = CELL_EDGE; y < MapRoom3.HEIGHT - CELL_EDGE; y++) {
    for (let x = CELL_EDGE; x < MapRoom3.WIDTH - CELL_EDGE; x++) {
      const key = (x << 16) | y;

      if (occupiedCells.has(key)) continue;

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
          x,
          y,
          altitude
        });
      }
    }
  }

  cachedCells = new Map(cells.map(cell => [cellKey(cell.x, cell.y), cell]));
  return cachedCells;
};
