import { IAttackable } from './com/monsters/interfaces/IAttackable';
import { MonsterBase } from './com/monsters/monsters/MonsterBase';
import { VacuumHose } from './com/monsters/siege/weapons/VacuumHose';
import Point from 'openfl/geom/Point';
import { FIREBALL } from './FIREBALL';
import { GLOBAL } from './GLOBAL';
import { MAP } from './MAP';

/**
 * FIREBALLS - Fireball Projectile Pool Manager
 * Manages spawning and pooling of fireball projectiles
 */
export class FIREBALLS {
    public static readonly TYPE_FIREBALL: string = "fireball";
    public static readonly TYPE_MISSILE: string = "missile";
    public static readonly TYPE_MAGMA: string = "magma";

    public static _fireballs: Record<number, FIREBALL> = {};
    public static _id: number = 0;
    public static _fireballCount: number = 0;
    public static _type: string = FIREBALL.TYPE_FIREBALL;
    public static _pool: FIREBALL[] = [];

    constructor() {
        FIREBALLS.Clear();
    }

    public static Spawn(startPoint: Point, targetPoint: Point, targetBuilding: any, speed: number, damage: number, splash: number = 0, glaives: number = 0, type: string = "fireball", source: IAttackable | null = null): FIREBALL {
        if (!type) type = FIREBALL.TYPE_FIREBALL;
        FIREBALLS._type = type;
        
        const fireball = FIREBALLS.PoolGet();
        if (type === FIREBALLS.TYPE_FIREBALL || type === FIREBALLS.TYPE_MAGMA) {
            if (damage > 0) {
                fireball._graphic.gotoAndStop(1);
            } else {
                fireball._graphic.gotoAndStop(2);
            }
        }
        
        if (!GLOBAL._catchup) {
            MAP._FIREBALLS.addChild(fireball._graphic);
        }
        
        fireball._id = FIREBALLS._id;
        if (!source) {
            console.warn("you created a fireball with no source");
        }
        fireball._source = source;
        fireball._startPoint = startPoint;
        fireball._targetType = 2;
        fireball._targetBuilding = targetBuilding;
        fireball._maxSpeed = speed;
        fireball._damage = damage;
        fireball._splash = splash;
        fireball._tmpX = startPoint.x;
        fireball._tmpY = startPoint.y;
        fireball._glaves = glaives;
        fireball._speed = speed;
        fireball._startDistance = 0;
        
        if (!FIREBALLS._fireballs) {
            FIREBALLS._fireballs = {};
        }
        FIREBALLS._fireballs[FIREBALLS._id] = fireball;
        ++FIREBALLS._id;
        ++FIREBALLS._fireballCount;
        return fireball;
    }

    public static Spawn2(startPoint: Point, targetPoint: Point, target: IAttackable, speed: number, damage: number, splash: number = 0, type: string = "fireball", targetType: number = 1, source: IAttackable | null = null): FIREBALL {
        if (!type) type = FIREBALL.TYPE_FIREBALL;
        FIREBALLS._type = type;
        
        const fireball = FIREBALLS.PoolGet();
        if (!GLOBAL._catchup) {
            MAP._FIREBALLS.addChild(fireball._graphic);
        }
        
        if (damage > 0) {
            fireball._graphic.gotoAndStop(1);
        } else {
            fireball._graphic.gotoAndStop(2);
        }
        
        fireball._type = type;
        fireball._id = FIREBALLS._id;
        if (!source) {
            console.warn("you created a fireball with no source");
        }
        fireball._source = source;
        fireball._startPoint = startPoint;
        fireball._targetType = target instanceof VacuumHose ? 4 : targetType;
        fireball._targetPoint = targetPoint;
        fireball._targetCreep = target;
        fireball._maxSpeed = speed;
        fireball._damage = damage;
        fireball._glaves = 0;
        
        if (target && target instanceof MonsterBase && (target as MonsterBase)._movement !== "fly") {
            fireball._splash = splash;
        } else {
            fireball._splash = 0;
        }
        
        fireball._tmpX = startPoint.x;
        fireball._tmpY = startPoint.y;
        fireball._speed = speed;
        fireball._startDistance = 0;
        
        if (!FIREBALLS._fireballs) {
            FIREBALLS._fireballs = {};
        }
        FIREBALLS._fireballs[FIREBALLS._id] = fireball;
        ++FIREBALLS._id;
        ++FIREBALLS._fireballCount;
        return fireball;
    }

    public static Remove(id: number): void {
        const fireball = FIREBALLS._fireballs[id];
        try {
            fireball._graphic.filters = [];
            MAP._FIREBALLS.removeChild(fireball._graphic);
        } catch (e) {}
        FIREBALLS.PoolSet(fireball);
        delete FIREBALLS._fireballs[id];
        --FIREBALLS._fireballCount;
    }

    public static Tick(): void {
        for (const id in FIREBALLS._fireballs) {
            FIREBALLS._fireballs[id].Tick();
        }
    }

    public static Clear(): void {
        for (const id in FIREBALLS._fireballs) {
            const fireball = FIREBALLS._fireballs[id];
            try {
                MAP._FIREBALLS.removeChild(fireball._graphic);
            } catch (e) {}
        }
        FIREBALLS._fireballs = {};
        FIREBALLS._id = 0;
        FIREBALLS._fireballCount = 0;
    }

    public static PoolSet(fireball: FIREBALL): void {
        FIREBALLS._pool.push(fireball);
    }

    public static PoolGet(): FIREBALL {
        let fireball: FIREBALL;
        if (FIREBALLS._pool.length) {
            fireball = FIREBALLS._pool.pop()!;
        } else {
            fireball = new FIREBALL();
        }
        fireball.Setup(FIREBALLS._type);
        return fireball;
    }
}
