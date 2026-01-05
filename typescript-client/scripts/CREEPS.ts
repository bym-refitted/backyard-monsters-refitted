import { BYMConfig } from './com/monsters/configs/BYMConfig';
import { CreepEvent } from './com/monsters/events/CreepEvent';
import { MonsterBase } from './com/monsters/monsters/MonsterBase';
import { ChampionBase } from './com/monsters/monsters/champions/ChampionBase';
import { Krallen } from './com/monsters/monsters/champions/Krallen';
import { CreepBase } from './com/monsters/monsters/creeps/CreepBase';
import BitmapData from 'openfl/display/BitmapData';
import Point from 'openfl/geom/Point';
import { ATTACK } from './ATTACK';
import { BASE } from './BASE';
import { CHAMPIONCAGE } from './CHAMPIONCAGE';
import { CREATURELOCKER } from './CREATURELOCKER';
import { GLOBAL } from './GLOBAL';
import { LOGGER } from './LOGGER';
import { MAP } from './MAP';
import { SPRITES } from './SPRITES';
import { Targeting } from './Targeting';

/**
 * CREEPS - Attacking Monster Management System
 * Handles spawning, ticking, and management of attacking creatures
 */
export class CREEPS {
    public static _creeps: Record<string, MonsterBase> = {};
    public static m_attackingCreeps: MonsterBase[] = [];
    public static _creepID: number = 0;
    public static _creepCount: number = 0;
    public static _flungCount: number = 0;
    public static _ticks: number = 0;
    public static _bmdHPbar: BitmapData | null = null; // new bmp_healthbarsmall(0,0)
    private static _creepOverlap: Record<string, number> = {};
    public static _flungGuardian: boolean[] = [];
    public static _guardianList: ChampionBase[] = [];
    private static _overlapKeyCache: Record<string, string> = {};
    private static _cacheHits: number = 0;
    private static _cacheMisses: number = 0;
    private static _lastCacheClear: number = 0;
    
    // Performance optimization: Batch processing arrays
    private static _aliveCreeps: MonsterBase[] = [];
    private static _deadCreeps: string[] = [];
    private static _visibleCreepCount: number = 0;
    private static _overlapProcessingIndex: number = 0;
    private static readonly OVERLAP_BATCH_SIZE: number = 10;

    constructor() {
        CREEPS._creeps = {};
        CREEPS.m_attackingCreeps.length = 0;
        CREEPS._creepID = 0;
        CREEPS._creepCount = CREEPS._flungCount = 0;
        CREEPS._ticks = 0;
        CREEPS._creepOverlap = {};
        CREEPS._flungGuardian = [];
        CREEPS._guardianList.length = 0;
    }

    public static get krallen(): Krallen | null {
        for (const guardian of CREEPS._guardianList) {
            if (guardian._creatureID === "G5") {
                return guardian as Krallen;
            }
        }
        return null;
    }

    private static getOverlapKey(creatureID: string, x: number, y: number): string {
        const gridX: number = Math.floor(x * 0.5);
        const gridY: number = Math.floor(y * 0.5);
        const cacheKey: string = `${creatureID}_${gridX}_${gridY}`;
        const cachedKey: string = CREEPS._overlapKeyCache[cacheKey];
        if (cachedKey) {
            CREEPS._cacheHits++;
            return cachedKey;
        }
        CREEPS._cacheMisses++;
        const overlapKey: string = `${creatureID}x${gridX}y${gridY}`;
        CREEPS._overlapKeyCache[cacheKey] = overlapKey;
        return overlapKey;
    }

    private static clearOverlapCache(): void {
        CREEPS._overlapKeyCache = {};
        CREEPS._cacheHits = CREEPS._cacheMisses = 0;
    }

    public static Tick(): void {
        const currentTime: number = Date.now();
        
        // Clear cache periodically to prevent memory bloat
        if (currentTime - CREEPS._lastCacheClear > 30000) {
            CREEPS.clearOverlapCache();
            CREEPS._lastCacheClear = currentTime;
        }
        
        CREEPS._aliveCreeps.length = 0;
        CREEPS._deadCreeps.length = 0;
        CREEPS._visibleCreepCount = 0;
        
        // Phase 1: Separate alive/dead creeps and tick alive ones
        for (const creepId in CREEPS._creeps) {
            const creep: MonsterBase = CREEPS._creeps[creepId];
            if (!creep) {
                CREEPS._deadCreeps.push(creepId);
                continue;
            }
            
            if (creep.tick(1)) {
                if (!creep.dying) {
                    creep.die();
                }
                if (creep.dead) {
                    CREEPS._deadCreeps.push(creepId);
                    continue;
                }
            }
            
            CREEPS._aliveCreeps.push(creep);
        }
        
        // Phase 2: Clean up dead creeps (batch operation)
        for (const deadId of CREEPS._deadCreeps) {
            const creep: MonsterBase = CREEPS._creeps[deadId];
            if (!creep) {
                delete CREEPS._creeps[deadId];
                continue;
            }
            
            if (!BYMConfig.instance.RENDERER_ON) {
                if (creep.graphic) {
                    MAP._BUILDINGTOPS.removeChild(creep.graphic);
                }
            }
            --CREEPS._creepCount;
            
            if (creep._creatureID && (creep._creatureID.substr(0, 1) === "G" || 
                (GLOBAL.mode === GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK) && !creep.isDisposable)) {
                --CREEPS._flungCount;
                ATTACK._creaturesFlung.Add(-1);
            }
            delete CREEPS._creeps[deadId];
        }
        
        // Phase 3: Process overlap detection in batches
        CREEPS.processOverlapBatch();
        
        if (CREEPS._creepCount <= 0) {
            CREEPS._flungCount = CREEPS._creepCount = 0;
        }
        
        if (GLOBAL.mode === GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK) {
            if (ATTACK._creaturesFlung.Get() < CREEPS._flungCount && ATTACK._creaturesFlung.Get() > 0) {
                LOGGER.Log("log", "More creeps than flung creatures");
                GLOBAL.ErrorMessage();
            }
        }
    }

    private static processOverlapBatch(): void {
        if (CREEPS._aliveCreeps.length === 0) return;
        
        CREEPS._creepOverlap = {};
        let processed: number = 0;
        
        while (processed < CREEPS.OVERLAP_BATCH_SIZE && CREEPS._overlapProcessingIndex < CREEPS._aliveCreeps.length) {
            const creep: MonsterBase = CREEPS._aliveCreeps[CREEPS._overlapProcessingIndex];
            
            if (!creep || !creep._tmpPoint || !creep._creatureID) {
                CREEPS._overlapProcessingIndex++;
                processed++;
                continue;
            }
            
            const overlapKey: string = CREEPS.getOverlapKey(creep._creatureID, creep._tmpPoint.x, creep._tmpPoint.y);
            
            if (!CREEPS._creepOverlap[overlapKey]) {
                CREEPS._creepOverlap[overlapKey] = 1;
                if (creep._mc && !creep._mc.visible) {
                    creep._mc.visible = true;
                }
            } else {
                CREEPS._creepOverlap[overlapKey] += 1;
                if (CREEPS._creepOverlap[overlapKey] > 1) {
                    if (creep._mc && creep._mc.visible) {
                        creep._mc.visible = false;
                    }
                } else if (creep._mc && !creep._mc.visible) {
                    creep._mc.visible = true;
                }
            }
            
            if (creep._mc && creep._mc.visible) {
                CREEPS._visibleCreepCount++;
            }
            
            CREEPS._overlapProcessingIndex++;
            processed++;
        }
        
        if (CREEPS._overlapProcessingIndex >= CREEPS._aliveCreeps.length) {
            CREEPS._overlapProcessingIndex = 0;
        }
    }

    public static Spawn(creatureId: string, parent: any, behaviour: string, pos: Point, rotation: number, 
                        scale: number = 1, isLocal: boolean = false, isDisposable: boolean = false): MonsterBase {
        ++CREEPS._creepID;
        if (!isDisposable) {
            ++CREEPS._flungCount;
        }
        ++CREEPS._creepCount;
        
        let CreatureClass = CREATURELOCKER._creatures[creatureId].classType;
        if (!CreatureClass) {
            CreatureClass = CreepBase;
        }
        
        const creep: MonsterBase = new CreatureClass(creatureId, behaviour, pos, rotation, 0, Number.MAX_SAFE_INTEGER, null, false, null, scale, isLocal);
        if (!BYMConfig.instance.RENDERER_ON) {
            parent.addChild(creep.graphic);
        }
        creep.isDisposable = isDisposable;
        CREEPS._creeps[CREEPS._creepID] = creep;
        CREEPS.m_attackingCreeps.push(creep);
        GLOBAL.eventDispatcher.dispatchEvent(new CreepEvent(CreepEvent.ATTACKING_MONSTER_SPAWNED, creep));
        return creep;
    }

    public static SpawnGuardian(guardianType: number, parent: any, behaviour: string, level: number, 
                                pos: Point, rotation: number, health: number = 20000, 
                                fd: number = 0, ft: number = 0, isEnemy: boolean = false): ChampionBase | null {
        const GuardianClass = CHAMPIONCAGE.getGuardianSpawnClass(guardianType);
        ++CREEPS._creepID;
        ++CREEPS._creepCount;
        ++CREEPS._flungCount;
        
        let guardian: ChampionBase | null = null;
        if (isEnemy) {
            guardian = new GuardianClass(behaviour, pos, 0, null, false, null, level, 0, 0, guardianType, health, fd, ft);
        } else {
            const guardianIndex: number = GLOBAL.getPlayerGuardianIndex(guardianType);
            if (GLOBAL._playerGuardianData[guardianIndex].status === ChampionBase.k_CHAMPION_STATUS_NORMAL) {
                guardian = new GuardianClass(
                    behaviour, pos, 0, null, false, null, level,
                    GLOBAL._playerGuardianData[guardianIndex].fd,
                    GLOBAL._playerGuardianData[guardianIndex].ft,
                    guardianType, health, fd, ft
                );
                if (CHAMPIONCAGE.getGuardianClassType(guardianType) === CHAMPIONCAGE.CLASS_TYPE_BASIC) {
                    CREEPS._guardian = guardian;
                } else if (!CREEPS.addGuardian(guardian)) {
                    guardian = null;
                }
            }
        }
        
        if (guardian) {
            CREEPS._creeps[CREEPS._creepID] = guardian;
            if (!BYMConfig.instance.RENDERER_ON) {
                parent.addChild(guardian.graphic);
            }
        }
        GLOBAL.eventDispatcher.dispatchEvent(new CreepEvent(CreepEvent.ATTACKING_MONSTER_SPAWNED, guardian));
        return guardian;
    }

    public static Retreat(): void {
        for (const key in CREEPS._creeps) {
            CREEPS._creeps[key].changeModeRetreat();
        }
    }

    public static CreepOverlap(pos: Point, radius: number): boolean {
        for (const key in CREEPS._creeps) {
            const creep: MonsterBase = CREEPS._creeps[key];
            let spriteData: any;
            if (creep._creatureID.substr(0, 1) === "G") {
                spriteData = SPRITES._sprites[(creep as ChampionBase)._spriteID];
            } else {
                spriteData = SPRITES._sprites[creep._creatureID];
            }
            const creepCenter: Point = new Point(creep.x + spriteData.middle.x, creep.y + spriteData.middle.y);
            let angle: number = Math.atan2(pos.y - creepCenter.y, pos.x - creepCenter.x);
            const edge1: number = BASE.EllipseEdgeDistance(angle, radius, radius * BASE._angle);
            angle = Math.atan2(creepCenter.y - pos.y, creepCenter.x - pos.x);
            const edge2: number = BASE.EllipseEdgeDistance(angle, spriteData.width * 0.5, spriteData.width * 0.5 * BASE._angle);
            const dx: number = pos.x - creepCenter.x;
            const dy: number = pos.y - creepCenter.y;
            const dist: number = Math.sqrt(dx * dx + dy * dy);
            if (dist < edge1 + edge2) {
                return true;
            }
        }
        return false;
    }

    public static Clear(): void {
        if (CREEPS.m_attackingCreeps) {
            CREEPS.m_attackingCreeps.length = 0;
        }
        for (const key in CREEPS._creeps) {
            const creep: MonsterBase = CREEPS._creeps[key];
            creep.clear();
            if (!BYMConfig.instance.RENDERER_ON) {
                MAP._BUILDINGTOPS.removeChild(creep.graphic);
            }
        }
        CREEPS._creeps = {};
        CREEPS._creepCount = CREEPS._flungCount = 0;
        for (const key in CREEPS._flungGuardian) {
            CREEPS._flungGuardian[key as any] = false;
        }
        for (let i = 0; i < CREEPS._guardianList.length; i++) {
            CREEPS._guardianList[i] = null as any;
        }
        CREEPS._guardianList.length = 0;
        CREEPS.clearOverlapCache();
        Targeting.clearGridCaches();
    }

    public static get _guardian(): ChampionBase | null {
        for (let i = 0; i < CREEPS._guardianList.length; i++) {
            if (CREEPS._guardianList[i] && CHAMPIONCAGE.isBasicGuardian(CREEPS._guardianList[i]._creatureID)) {
                return CREEPS._guardianList[i];
            }
        }
        return null;
    }

    public static set _guardian(guardian: ChampionBase | null) {
        let foundIndex = -1;
        for (let i = 0; i < CREEPS._guardianList.length; i++) {
            if (CHAMPIONCAGE.isBasicGuardian(CREEPS._guardianList[i]._creatureID)) {
                foundIndex = i;
            }
        }
        if (foundIndex === -1) {
            if (guardian) {
                CREEPS._guardianList.unshift(guardian);
            }
        } else if (!guardian) {
            CREEPS._guardianList.splice(foundIndex, 1);
        } else {
            CREEPS._guardianList[foundIndex] = guardian;
        }
    }

    public static addGuardian(guardian: ChampionBase): boolean {
        let foundIndex = -1;
        for (let i = 0; i < CREEPS._guardianList.length; i++) {
            if (CREEPS._guardianList[i]._creatureID === guardian._creatureID) {
                foundIndex = i;
            }
        }
        if (foundIndex === -1) {
            if (guardian) {
                CREEPS._guardianList.push(guardian);
                return true;
            }
        }
        return false;
    }

    public static getGuardianIndex(guardianType: number): number {
        for (let i = 0; i < CREEPS._guardianList.length; i++) {
            if (parseInt(CREEPS._guardianList[i]._creatureID.substr(1)) === guardianType) {
                return i;
            }
        }
        return -1;
    }
}
