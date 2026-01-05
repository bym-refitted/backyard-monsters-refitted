import Point from 'openfl/geom/Point';
import { EFFECTS } from './EFFECTS';
import { GIBLET } from './GIBLET';
import { GLOBAL } from './GLOBAL';
import { GRID } from './GRID';
import { LOGGER } from './LOGGER';
import { MAP } from './MAP';

/**
 * GIBLETS - Giblet Particle System
 * Manages pools and spawning of flying meat particles
 */
export class GIBLETS {
    public static _giblets: Record<string, any> = {};
    public static _gibletCount: number = 0;
    public static _tmpGibCount: number = 0;
    public static _frame: number = 0;
    private static _pool: GIBLET[] = [];

    constructor() {}

    public static Clear(): void {
        try {
            for (const g in GIBLETS._giblets) {
                const giblet: GIBLET = GIBLETS._giblets[g];
                if (giblet.parent) {
                    giblet.parent.removeChild(giblet);
                }
                giblet.Clear();
                GIBLETS.PoolSet(giblet);
                delete GIBLETS._giblets[g];
            }
            GIBLETS._giblets = {};
            GIBLETS._gibletCount = 0;
            GIBLETS._frame = 0;
        } catch (e: any) {
            LOGGER.Log("err", "Giblets Clear " + e.stack);
        }
    }

    public static PoolGet(id: number, startPos: Point, targetPos: Point, distance: number, delay: number, scale: number): GIBLET {
        let giblet: GIBLET;
        if (GIBLETS._pool.length) {
            giblet = GIBLETS._pool.pop()!;
        } else {
            giblet = new GIBLET();
        }
        giblet.init(id, startPos, targetPos, distance, delay, scale);
        return giblet;
    }

    public static PoolSet(giblet: GIBLET): void {
        GIBLETS._pool.push(giblet);
    }

    public static Create(pos: Point, scale: number, spread: number, count: number, heightOffset: number = 0): void {
        if (!GLOBAL._catchup) {
            if (GIBLETS._tmpGibCount < 20) {
                for (let i = 0; i < count; i++) {
                    ++GIBLETS._tmpGibCount;
                    let distance: number = spread * 0.2 + Math.random() * (spread * 0.8);
                    if (Math.random() <= 0.3) {
                        distance *= 1.5;
                    }
                    GIBLETS.Spawn(pos.add(new Point(-3 + Math.random() * 6, -2 + Math.random() * 4)), scale, distance, i / 100, heightOffset);
                }
            }
        }
    }

    public static Spawn(pos: Point, scale: number, distance: number, delay: number, heightOffset: number): void {
        const angle: number = Math.random() * 360;
        const gridPos: Point = GRID.FromISO(pos.x, pos.y);
        const targetX: number = gridPos.x + Math.cos(angle) * distance;
        const targetY: number = gridPos.y + Math.sin(angle) * distance;
        const targetPos: Point = GRID.ToISO(targetX, targetY, 0).add(new Point(0, heightOffset));
        GIBLETS._giblets[GIBLETS._gibletCount] = MAP._RESOURCES.addChild(GIBLETS.PoolGet(GIBLETS._gibletCount, pos, targetPos, distance, delay, scale));
        ++GIBLETS._gibletCount;
    }

    public static Remove(id: any): void {
        const giblet: GIBLET = GIBLETS._giblets[id];
        --GIBLETS._tmpGibCount;
        try {
            EFFECTS.SplatParticle(20, giblet.x, giblet.y, 0, 0);
            MAP._RESOURCES.removeChild(giblet);
            giblet.Clear();
            GIBLETS.PoolSet(giblet);
            delete GIBLETS._giblets[id];
        } catch (e) {
            // Ignore errors
        }
    }
}
