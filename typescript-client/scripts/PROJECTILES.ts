import { IAttackable } from './com/monsters/interfaces/IAttackable';
import Point from 'openfl/geom/Point';
import { GLOBAL } from './GLOBAL';
import { MAP } from './MAP';
import { PROJECTILE } from './PROJECTILE';

/**
 * PROJECTILES - Projectile Management System
 * Handles spawning, pooling, and tick processing of all projectiles
 */
export class PROJECTILES {
    public static _projectiles: Record<string, PROJECTILE> = {};
    public static _id: number = 0;
    public static _projectileCount: number = 0;
    public static _pool: PROJECTILE[] = [];

    constructor() {
        PROJECTILES.Clear();
    }

    public static Spawn(start: Point, end: Point, target: IAttackable | null, speed: number, damage: number, 
                        isRocket: boolean = false, splash: number = 0, splashTargetFlags: number = 0): void {
        const projectile: PROJECTILE = PROJECTILES.PoolGet();
        if (!GLOBAL._catchup) {
            projectile._graphic = new (GLOBAL as any).PROJECTILE_CLIP();
            MAP._PROJECTILES.addChild(projectile._graphic);
        }
        projectile._id = PROJECTILES._id;
        projectile._startPoint = start;
        projectile._targetPoint = end;
        projectile._target = target;
        projectile._maxSpeed = speed;
        projectile._damage = damage;
        projectile._rocket = isRocket;
        projectile._splash = splash;
        projectile._splashTargetFlags = splashTargetFlags;
        projectile._tmpX = start.x;
        projectile._tmpY = start.y;
        if (isRocket) {
            projectile._speed = speed / 2;
            projectile._rotationEasing = 25;
            if (projectile._graphic) {
                projectile._graphic.rotation = Math.random() * 360;
            }
        } else {
            projectile._speed = speed;
        }
        projectile._startDistance = 0;
        if (!PROJECTILES._projectiles) {
            PROJECTILES._projectiles = {};
        }
        PROJECTILES._projectiles[PROJECTILES._id] = projectile;
        ++PROJECTILES._id;
        ++PROJECTILES._projectileCount;
    }

    public static Remove(id: number): void {
        const projectile: PROJECTILE = PROJECTILES._projectiles[id];
        try {
            if (projectile._graphic) {
                MAP._PROJECTILES.removeChild(projectile._graphic);
            }
        } catch (e) {
            // Ignore errors
        }
        PROJECTILES.PoolSet(projectile);
        delete PROJECTILES._projectiles[id];
        --PROJECTILES._projectileCount;
    }

    public static Tick(): void {
        for (const key in PROJECTILES._projectiles) {
            const projectile: PROJECTILE = PROJECTILES._projectiles[key];
            projectile.Tick();
        }
    }

    public static Clear(): void {
        for (const key in PROJECTILES._projectiles) {
            const projectile: PROJECTILE = PROJECTILES._projectiles[key];
            try {
                if (projectile._graphic) {
                    MAP._PROJECTILES.removeChild(projectile._graphic);
                }
            } catch (e) {
                // Ignore errors
            }
        }
        PROJECTILES._projectiles = {};
        PROJECTILES._id = 0;
        PROJECTILES._projectileCount = 0;
    }

    public static PoolSet(projectile: PROJECTILE): void {
        PROJECTILES._pool.push(projectile);
    }

    public static PoolGet(): PROJECTILE {
        let projectile: PROJECTILE;
        if (PROJECTILES._pool.length) {
            projectile = PROJECTILES._pool.pop()!;
        } else {
            projectile = new PROJECTILE();
        }
        return projectile;
    }
}
