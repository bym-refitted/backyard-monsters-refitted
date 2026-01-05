import { ITargetable } from './com/monsters/interfaces/ITargetable';
import { DummyTarget } from './com/monsters/monsters/DummyTarget';
import { MonsterBase } from './com/monsters/monsters/MonsterBase';
import { PATHING } from './com/monsters/pathing/PATHING';
import Point from 'openfl/geom/Point';
import { ATTACK } from './ATTACK';
import { BASE } from './BASE';
import { BFOUNDATION } from './BFOUNDATION';
import { GLOBAL } from './GLOBAL';
import { GRID } from './GRID';

/**
 * Targeting - Target Acquisition System
 * Handles finding targets within range using spatial grid optimization
 */
export class Targeting {
    public static readonly k_TARGETS_DEFENDERS: number = 1 << 0;
    public static readonly k_TARGETS_ATTACKERS: number = 1 << 1;
    public static readonly k_TARGETS_GROUND: number = 1 << 2;
    public static readonly k_TARGETS_FLYING: number = 1 << 3;
    public static readonly k_TARGETS_INVISIBLE: number = 1 << 4;
    public static readonly k_TARGETS_BUILDINGS: number = 1 << 5;
    public static readonly k_TARGETS_ALL: number = 2147483647;

    public static _creepCells: Record<string, any> = {};
    public static _deadCreepCells: Record<string, any> = {};
    public static readonly _CELLSIZE: number = 100;

    private static _gridKeyCache: Record<string, string> = {};
    private static _cartesianCache: Record<string, Point> = {};
    private static _cacheCleanupCounter: number = 0;
    private static readonly CACHE_CLEANUP_INTERVAL: number = 1800;
    private static _creepCellMoveCallCount: number = 0;
    private static _rangeQueryCache: Record<string, any[]> = {};
    private static _rangeQueryFrameStamp: Record<string, number> = {};
    private static _currentFrame: number = 0;

    constructor() {
        Targeting.init();
    }

    public static init(): void {
        Targeting._creepCells = {};
        Targeting._deadCreepCells = {};
    }

    private static getGridKey(isoPoint: Point): string | null {
        if (!isoPoint) return null;
        const cacheKey: string = Math.floor(isoPoint.x) + "_" + Math.floor(isoPoint.y);
        let cachedGridKey: string = Targeting._gridKeyCache[cacheKey];
        if (cachedGridKey) return cachedGridKey;
        
        let cartesian: Point = Targeting._cartesianCache[cacheKey];
        if (!cartesian) {
            cartesian = GRID.FromISO(isoPoint.x, isoPoint.y);
            if (!cartesian) return null;
            Targeting._cartesianCache[cacheKey] = cartesian;
        }
        const gridKey: string = "node" + Math.floor(cartesian.x / Targeting._CELLSIZE) + "|" + Math.floor(cartesian.y / Targeting._CELLSIZE);
        Targeting._gridKeyCache[cacheKey] = gridKey;
        return gridKey;
    }

    public static clearGridCaches(): void {
        Targeting._gridKeyCache = {};
        Targeting._cartesianCache = {};
    }

    public static resetPerformanceStats(): void {
        Targeting._creepCellMoveCallCount = 0;
    }

    public static CreepCellAdd(pos: Point, id: string, monster: MonsterBase): string | null {
        const gridKey: string | null = Targeting.getGridKey(pos);
        if (!gridKey) return null;
        const cells = monster.dead ? Targeting._deadCreepCells : Targeting._creepCells;
        if (!cells[gridKey]) {
            cells[gridKey] = {};
        }
        cells[gridKey]["creep" + id] = monster;
        return gridKey;
    }

    public static CreepCellMove(pos: Point, id: string, monster: MonsterBase, oldKey: string): string | null {
        Targeting._creepCellMoveCallCount++;
        Targeting._cacheCleanupCounter++;
        if (Targeting._cacheCleanupCounter >= Targeting.CACHE_CLEANUP_INTERVAL) {
            Targeting._cacheCleanupCounter = 0;
            Targeting.clearGridCaches();
        }
        const gridKey: string | null = Targeting.getGridKey(pos);
        if (!gridKey) {
            if (oldKey) Targeting.CreepCellDelete(id, oldKey, monster.dead);
            return null;
        }
        if (gridKey !== oldKey) {
            Targeting.CreepCellDelete(id, oldKey, monster.dead);
            return Targeting.CreepCellAdd(pos, id, monster);
        }
        return "";
    }

    public static CreepCellDelete(id: string, gridKey: string, dead: boolean = false): void {
        const cells = dead ? Targeting._deadCreepCells : Targeting._creepCells;
        if (cells[gridKey]) {
            delete cells[gridKey]["creep" + id];
        }
    }

    public static getTargetsInRange(radius: number, location: Point, targetFlags: number, 
                                     ignoreCreep: MonsterBase | null = null, ignoreBuilding: BFOUNDATION | null = null): any[] {
        let targets: any[] = [];
        if ((targetFlags & Targeting.k_TARGETS_ATTACKERS) || (targetFlags & Targeting.k_TARGETS_DEFENDERS)) {
            targets = targets.concat(Targeting.getCreepsInRange(radius, location, targetFlags, ignoreCreep));
        }
        if (targetFlags & Targeting.k_TARGETS_BUILDINGS) {
            targets = targets.concat(Targeting.getBuildingsInRange(radius, location, ignoreBuilding));
        }
        return targets;
    }

    public static getAllBUTTargetsInRange(radius: number, location: Point, excludeFlags: number = 0): any[] {
        let targets: any[] = Targeting.getCreepsInRange(radius, location, ~excludeFlags);
        if (!(excludeFlags & Targeting.k_TARGETS_BUILDINGS)) {
            targets = targets.concat(Targeting.getBuildingsInRange(radius, location));
        }
        return targets;
    }

    public static getBuildingsInRange(radius: number, location: Point, ignoreBuilding: BFOUNDATION | null = null): any[] {
        const results: any[] = [];
        if (!location) return [];
        const radiusSq: number = radius * radius;
        for (const key in BASE._buildingsAll) {
            const building: BFOUNDATION = BASE._buildingsAll[key];
            if (!building) continue;
            if (building.isTargetable && building !== ignoreBuilding) {
                const distSq: number = GLOBAL.QuickDistanceSquared(location, new Point(building.x, building.y));
                if (distSq < radiusSq) {
                    results.push({ creep: building, dist: Math.sqrt(distSq) });
                }
            }
        }
        return results;
    }

    public static getOldStyleTargets(mode: number): number {
        let flags: number = 0;
        if (mode === -1) flags |= Targeting.k_TARGETS_GROUND | Targeting.k_TARGETS_INVISIBLE;
        else if (mode === 0) flags |= Targeting.k_TARGETS_GROUND;
        else if (mode === 1) flags |= Targeting.k_TARGETS_GROUND | Targeting.k_TARGETS_FLYING;
        else if (mode === 2) flags |= Targeting.k_TARGETS_FLYING;
        return flags | Targeting.k_TARGETS_ATTACKERS;
    }

    public static getCreepsInRange(radius: number, location: Point, targetFlags: number = 0, 
                                    ignoreCreep: MonsterBase | null = null): any[] {
        if (!location) return [];
        Targeting._currentFrame = GLOBAL._frameNumber;
        const cacheKey: string = radius + "_" + Math.floor(location.x) + "_" + Math.floor(location.y) + "_" + targetFlags + "_" + (ignoreCreep ? ignoreCreep._id : "null");
        
        if (Targeting._rangeQueryCache[cacheKey] && Targeting._rangeQueryFrameStamp[cacheKey] === Targeting._currentFrame) {
            return Targeting._rangeQueryCache[cacheKey];
        }

        if (!(targetFlags & Targeting.k_TARGETS_DEFENDERS || targetFlags & Targeting.k_TARGETS_ATTACKERS)) {
            return [];
        }
        
        location = PATHING.FromISO(location);
        if (!location) return [];
        
        const cellX: number = Math.floor(location.x / Targeting._CELLSIZE);
        const cellY: number = Math.floor(location.y / Targeting._CELLSIZE);
        const cellRadius: number = Math.floor(radius / Targeting._CELLSIZE) + 1;
        const results: any[] = [];
        const radiusSq: number = radius * radius;

        for (let cx = cellX - cellRadius; cx <= cellX + cellRadius; cx++) {
            for (let cy = cellY - cellRadius; cy <= cellY + cellRadius; cy++) {
                const gridKey: string = "node" + cx + "|" + cy;
                if (!Targeting._creepCells[gridKey]) continue;
                for (const key in Targeting._creepCells[gridKey]) {
                    const monster: MonsterBase = Targeting._creepCells[gridKey][key];
                    if (!monster || !monster._tmpPoint) continue;
                    if (monster.health > 0 && monster.isTargetable && monster !== ignoreCreep && 
                        Targeting.canHitCreep(targetFlags, monster.defenseFlags)) {
                        const hp: number = monster.health;
                        const pos: Point = PATHING.FromISO(monster._tmpPoint);
                        if (!pos) continue;
                        const distSq: number = GLOBAL.QuickDistanceSquared(location, pos);
                        if (distSq < radiusSq) {
                            results.push({ creep: monster, dist: Math.sqrt(distSq), pos: pos, hp: hp });
                        }
                    }
                }
            }
        }
        Targeting._rangeQueryCache[cacheKey] = results;
        Targeting._rangeQueryFrameStamp[cacheKey] = Targeting._currentFrame;
        
        if (Targeting._currentFrame % 300 === 0) {
            for (const oldKey in Targeting._rangeQueryFrameStamp) {
                if (Targeting._rangeQueryFrameStamp[oldKey] < Targeting._currentFrame - 10) {
                    delete Targeting._rangeQueryCache[oldKey];
                    delete Targeting._rangeQueryFrameStamp[oldKey];
                }
            }
        }
        return results;
    }

    public static getDeadCreeps(location: Point, radius: number, targetFlags: number = 0, 
                                 ignoreCreep: MonsterBase | null = null): any[] {
        if (!location) return [];
        location = PATHING.FromISO(location);
        if (!location) return [];
        
        const cellX: number = Math.floor(location.x / Targeting._CELLSIZE);
        const cellY: number = Math.floor(location.y / Targeting._CELLSIZE);
        const cellRadius: number = Math.floor(radius / Targeting._CELLSIZE) + 1;
        const results: any[] = [];
        const radiusSq: number = radius * radius;

        for (let cx = cellX - cellRadius; cx <= cellX + cellRadius; cx++) {
            for (let cy = cellY - cellRadius; cy <= cellY + cellRadius; cy++) {
                const gridKey: string = "node" + cx + "|" + cy;
                if (!Targeting._deadCreepCells[gridKey]) continue;
                for (const key in Targeting._deadCreepCells[gridKey]) {
                    const monster: MonsterBase = Targeting._deadCreepCells[gridKey][key];
                    if (!monster || !monster._tmpPoint) continue;
                    if (monster.health <= 0 && monster._visible && monster.isTargetable && 
                        monster !== ignoreCreep && Targeting.canHitCreep(targetFlags, monster.defenseFlags)) {
                        const hp: number = monster.health;
                        const pos: Point = PATHING.FromISO(monster._tmpPoint);
                        if (!pos) continue;
                        const distSq: number = GLOBAL.QuickDistanceSquared(location, pos);
                        if (distSq < radiusSq) {
                            results.push({ creep: monster, dist: Math.sqrt(distSq), pos: pos, hp: hp });
                        }
                    }
                }
            }
        }
        return results;
    }

    public static canHitCreep(targetFlags: number, defenseFlags: number): boolean {
        return !(~targetFlags & defenseFlags);
    }

    public static getClosestCreep(radius: number, location: Point, targetFlags: number = 0, 
                                   ignoreCreep: MonsterBase | null = null): MonsterBase | null {
        const targets: any[] = Targeting.getCreepsInRange(radius, location, targetFlags, ignoreCreep);
        if (targets.length <= 0) return null;
        targets.sort((a, b) => a.dist - b.dist);
        if (!targets[0] || !targets[0].creep) return null;
        return targets[0].creep;
    }

    public static DealLinearAEDamage(location: Point, radius: number, damage: number, targets: any[], 
                                      minRadius: number = 0): number {
        if (!location || !targets) return 0;
        if (minRadius > radius) minRadius = radius - 1;
        let totalDamage: number = 0;
        
        for (const target of targets) {
            if (!target) continue;
            let dist: number;
            let entity: any;
            if (target.creep) {
                dist = target.dist;
                entity = target.creep;
            } else {
                dist = GLOBAL.QuickDistance(location, new Point(target.x, target.y));
                entity = target;
            }
            
            if (radius >= dist) {
                let actualDamage: number;
                if (dist < minRadius) {
                    actualDamage = damage;
                } else {
                    actualDamage = damage / radius * (radius - dist);
                }
                if (actualDamage < damage / 5) {
                    actualDamage = damage / 5;
                }
                if (entity instanceof BFOUNDATION) {
                    (entity as BFOUNDATION).modifyHealth(actualDamage, new DummyTarget(location.x, location.y));
                } else {
                    actualDamage *= entity._damageMult;
                    entity.modifyHealth(-actualDamage);
                }
                totalDamage += actualDamage;
            }
        }
        ATTACK.Damage(location.x, location.y, totalDamage);
        return totalDamage;
    }

    public static getFriendlyFlag(monster: MonsterBase): number {
        if (!monster) return Targeting.k_TARGETS_ATTACKERS;
        return monster._friendly ? Targeting.k_TARGETS_DEFENDERS : Targeting.k_TARGETS_ATTACKERS;
    }

    public static getEnemyFlag(monster: MonsterBase): number {
        if (!monster) return Targeting.k_TARGETS_DEFENDERS;
        return monster._friendly ? Targeting.k_TARGETS_ATTACKERS : Targeting.k_TARGETS_DEFENDERS;
    }

    public static getClosestEnemy(radius: number, location: Point, targetFlags: number): ITargetable | null {
        const targets: any[] = Targeting.getTargetsInRange(radius, location, targetFlags);
        if (targets.length <= 0) return null;
        targets.sort((a, b) => a.dist - b.dist);
        if (!targets[0] || !targets[0].creep) return null;
        return targets[0].creep;
    }
}
