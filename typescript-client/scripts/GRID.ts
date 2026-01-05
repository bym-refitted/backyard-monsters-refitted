import Point from 'openfl/geom/Point';
import Rectangle from 'openfl/geom/Rectangle';
import { BFOUNDATION } from './BFOUNDATION';
import { GLOBAL } from './GLOBAL';
import { LOGGER } from './LOGGER';

/**
 * GRID - Isometric Grid System
 * Handles coordinate conversions and collision checking for the isometric map
 */
export class GRID {
    public static readonly _mapWidth: number = 2600;
    public static readonly _mapHeight: number = 2600;
    public static readonly _rowOffset: number = Math.ceil(GRID._mapWidth / 5);
    public static _grid: Uint32Array | null = null;

    constructor() {}

    public static CreateGrid(): void {
        GRID.Cleanup();
    }

    public static Block(rect: Rectangle, block: boolean = false): void {
        const gridStart: Point = GRID.FromISO(rect.x, rect.y);
        rect.x = gridStart.x;
        rect.y = gridStart.y;
        for (let x = 0; x < rect.width; x += 5) {
            for (let y = 0; y < rect.height; y += 5) {
                const localPos: Point = GRID.GlobalLocal(new Point(x + rect.x, y + rect.y), 5);
                const index: number = localPos.x + localPos.y * GRID._rowOffset;
                if (index > 0 && index < GRID._grid!.length) {
                    if (block) {
                        GRID._grid![localPos.x + localPos.y * GRID._rowOffset] |= 1;
                    } else {
                        GRID._grid![localPos.x + localPos.y * GRID._rowOffset] &= ~1;
                    }
                }
            }
        }
        GRID.Clear();
    }

    public static FindSpace(building: BFOUNDATION): void {
        const footprint: Rectangle = building._footprint[0];
        for (let x = 0; x < 120; x++) {
            for (let y = 0; y < 100; y++) {
                const isoPos: Point = GRID.ToISO(-(GLOBAL._mapWidth * 0.5) + x * 10, -(GLOBAL._mapHeight * 0.5) + y * 10, 0);
                if (!GRID.FootprintBlocked(building._footprint, isoPos, true)) {
                    LOGGER.Log("err", `GRID.FindSpace ${x}, ${y}, ${isoPos.x}, ${isoPos.y}`);
                    building._mc!.x = isoPos.x;
                    building._mc!.y = isoPos.y;
                    building._mcBase!.x = isoPos.x;
                    building._mcBase!.y = isoPos.y;
                    building._mcFootprint!.x = isoPos.x;
                    building._mcFootprint!.y = isoPos.y;
                    building.GridCost(true);
                    return;
                }
            }
        }
    }

    public static FootprintBlocked(footprint: Rectangle[], pos: Point, checkBounds: boolean = false, ignoreEdge: boolean = false): boolean {
        pos = GRID.FromISO(pos.x, pos.y);
        for (const rect of footprint) {
            for (let x = 0; x < rect.width; x += 5) {
                for (let y = 0; y < rect.height; y += 5) {
                    if (GRID.Blocked(new Point(x + rect.x + pos.x, y + rect.y + pos.y), checkBounds, ignoreEdge) > 0) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    public static Blocked(pos: Point, checkBounds: boolean = false, ignoreEdge: boolean = false): number {
        const localPos: Point = GRID.GlobalLocal(new Point(pos.x, pos.y), 5);
        if (localPos.x < 0 || localPos.y < 0 || localPos.x >= GRID._mapWidth / 5 || localPos.y >= GRID._mapHeight / 5) {
            return 3;
        }
        const halfWidth: number = GLOBAL._mapWidth * 0.5;
        const halfHeight: number = GLOBAL._mapHeight * 0.5;
        if (checkBounds && !ignoreEdge && (pos.x < -halfWidth || pos.x >= halfWidth || pos.y < -halfHeight || pos.y >= halfHeight)) {
            return 2;
        }
        return GRID._grid![localPos.x + localPos.y * GRID._rowOffset] & 1;
    }

    public static Clear(): void {
        // Clear any cached data
    }

    public static Cleanup(): void {
        const gridSize: number = Math.ceil(GRID._mapWidth / 5) * Math.ceil(GRID._mapHeight / 5);
        GRID._grid = new Uint32Array(gridSize);
    }

    public static GlobalLocal(pos: Point, cellSize: number): Point {
        const x: number = Math.floor((pos.x + GRID._mapWidth * 0.5) / cellSize);
        const y: number = Math.floor((pos.y + GRID._mapHeight * 0.5) / cellSize);
        return new Point(x, y);
    }

    public static LocalGlobal(pos: Point, cellSize: number): Point {
        const x: number = Math.floor(pos.x * cellSize - GRID._mapWidth * 0.5) + cellSize * 0.5;
        const y: number = Math.floor(pos.y * cellSize - GRID._mapHeight * 0.5) + cellSize * 0.5;
        return new Point(x, y);
    }

    public static ToISO(x: number, y: number, z: number): Point {
        const isoY: number = (x + y) * 0.5 - z;
        const isoX: number = x - y;
        return new Point(Math.floor(isoX), Math.floor(isoY));
    }

    public static FromISO(isoX: number, isoY: number): Point {
        const x: number = isoY - isoX * 0.5;
        const y: number = isoX * 0.5 + isoY;
        return new Point(Math.ceil(y), Math.ceil(x));
    }
}
