import alea from "alea";
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
  RESOURCE_GRID_SIZE,
  RESOURCE_JITTER,
  TRIBE_OUTPOST_SEED,
  MIN_RESOURCE_STRONGHOLD_DISTANCE,
} from "../../../config/WorldGenSettings";
import { createNoise2D } from "simplex-noise";
import { MapRoom3 } from "../../../enums/MapRoom";
import { EnumYardType } from "../../../enums/EnumYardType";
import { getDefenderOutposts } from "./getDefenderOutposts";
import { isValidPosition } from "./utils/isValidPosition";

interface Cell {
  i?: number;
  x: number;
  y: number;
  t?: number;
}

let cachedCells: Cell[] | null = null;

export const generateCells = (): Cell[] => {
  if (cachedCells) return cachedCells;

  const cells: Cell[] = [];
  const occupiedCells = new Set<string>();
  const strongholdPositions: Array<{ x: number; y: number }> = [];

  const { WIDTH, HEIGHT } = MapRoom3;

  // ============================================================================
  // PHASE 1: Place Strongholds
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

      if (!isValidPosition(x, y) || occupiedCells.has(`${x},${y}`)) continue;

      cells.push({ x, y, t: EnumYardType.STRONGHOLD });

      occupiedCells.add(`${x},${y}`);
      strongholdPositions.push({ x, y });

      const defenders = getDefenderOutposts(x, y);

      for (const [fortX, fortY] of defenders) {
        if (!occupiedCells.has(`${fortX},${fortY}`)) {
          cells.push({ x: fortX, y: fortY, t: EnumYardType.FORTIFICATION });
          occupiedCells.add(`${fortX},${fortY}`);
        }
      }
    }
  }

  // ============================================================================
  // PHASE 2: Place Resource Outposts
  // ============================================================================
  const resourceRng = alea(RESOURCE_SEED);

  for (
    let gridY = CELL_EDGE;
    gridY < HEIGHT - CELL_EDGE;
    gridY += RESOURCE_GRID_SIZE
  ) {
    for (
      let gridX = CELL_EDGE;
      gridX < WIDTH - CELL_EDGE;
      gridX += RESOURCE_GRID_SIZE
    ) {
      // Calculate center of grid cell
      const centerX = gridX + Math.floor(RESOURCE_GRID_SIZE / 2);
      const centerY = gridY + Math.floor(RESOURCE_GRID_SIZE / 2);

      // Apply random jitter
      const jitterX = Math.floor((resourceRng() - 0.5) * 2 * RESOURCE_JITTER);
      const jitterY = Math.floor((resourceRng() - 0.5) * 2 * RESOURCE_JITTER);

      const x = centerX + jitterX;
      const y = centerY + jitterY;

      // Validate position
      if (!isValidPosition(x, y) || occupiedCells.has(`${x},${y}`)) continue;

      // Check distance from all strongholds to avoid defender overlap
      let tooCloseToStronghold = false;
      for (const stronghold of strongholdPositions) {
        const distance = Math.sqrt(
          (x - stronghold.x) ** 2 + (y - stronghold.y) ** 2
        );
        if (distance < MIN_RESOURCE_STRONGHOLD_DISTANCE) {
          tooCloseToStronghold = true;
          break;
        }
      }
      if (tooCloseToStronghold) continue;

      // Check if ALL defender positions are available before placing resource
      const defenders = getDefenderOutposts(x, y);
      let allDefenderSlotsAvailable = true;
      for (const [fortX, fortY] of defenders) {
        if (
          !isValidPosition(fortX, fortY) ||
          occupiedCells.has(`${fortX},${fortY}`)
        ) {
          allDefenderSlotsAvailable = false;
          break;
        }
      }

      // Skip this resource if any defender slot is blocked
      if (!allDefenderSlotsAvailable) continue;

      // Place resource outpost
      cells.push({
        x,
        y,
        t: EnumYardType.RESOURCE,
      });
      occupiedCells.add(`${x},${y}`);

      // Place defenders around resource outpost
      for (const [fortX, fortY] of defenders) {
        cells.push({
          x: fortX,
          y: fortY,
          t: EnumYardType.FORTIFICATION,
        });
        occupiedCells.add(`${fortX},${fortY}`);
      }
    }
  }

  // ============================================================================
  // PHASE 3: Place Tribe Outposts
  // ============================================================================
  const tribeRng = alea(TRIBE_OUTPOST_SEED);
  const maxAttempts = (WIDTH - 2 * CELL_EDGE) * (HEIGHT - 2 * CELL_EDGE) * 0.12;

  for (let attempt = 0; attempt < maxAttempts; attempt++) {
    const x = CELL_EDGE + Math.floor(tribeRng() * (WIDTH - 2 * CELL_EDGE));
    const y = CELL_EDGE + Math.floor(tribeRng() * (HEIGHT - 2 * CELL_EDGE));

    if (!occupiedCells.has(`${x},${y}`)) {
      cells.push({ x, y, t: EnumYardType.OUTPOST });
      occupiedCells.add(`${x},${y}`);
    }
  }

  // ============================================================================
  // PHASE 4: Place Bushes/Clover
  // ============================================================================
  const noise = createNoise2D(alea(CELL_SEED));
  const cloverRng = alea(CELL_SEED + "-clover");

  for (let y = CELL_EDGE; y < MapRoom3.HEIGHT - CELL_EDGE; y++) {
    for (let x = CELL_EDGE; x < MapRoom3.WIDTH - CELL_EDGE; x++) {
      if (occupiedCells.has(`${x},${y}`)) continue;

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
