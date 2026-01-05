import { BYMConfig } from './com/monsters/configs/BYMConfig';
import { CreepEvent } from './com/monsters/events/CreepEvent';
import { MonsterBase } from './com/monsters/monsters/MonsterBase';
import { ChampionBase } from './com/monsters/monsters/champions/ChampionBase';
import { CreepBase } from './com/monsters/monsters/creeps/CreepBase';
import Point from 'openfl/geom/Point';
import { BFOUNDATION } from './BFOUNDATION';
import { CHAMPIONCAGE } from './CHAMPIONCAGE';
import { CREATURELOCKER } from './CREATURELOCKER';
import { GLOBAL } from './GLOBAL';
import { MAP } from './MAP';
import { SPECIALEVENT } from './SPECIALEVENT';

/**
 * CREATURES - Defending Monster Management System
 * Handles spawning and management of defending creatures
 */
export class CREATURES {
    public static _creatures: Record<string, MonsterBase> = {};
    public static _creatureID: number = 0;
    public static _creatureCount: number = 0;
    public static _ticks: number = 0;
    public static _guardianList: ChampionBase[] = [];

    constructor() {
        CREATURES._creatures = {};
        CREATURES._creatureID = 0;
        CREATURES._creatureCount = 0;
        CREATURES._ticks = 0;
        CREATURES._guardianList.length = 0;
    }

    public static GetProperty(monsterID: string, statID: string, level: number = 0, friendly: boolean = true): number {
        if (!monsterID || monsterID.substr(0, 1) === "G") {
            return 0;
        }
        try {
            if (monsterID === "C100") {
                monsterID = "C12";
            }
            if (!GLOBAL.player.m_upgrades[monsterID]) {
                GLOBAL.player.m_upgrades[monsterID] = { level: 1 };
            }
            const stat: number[] = CREATURELOCKER._creatures[monsterID].props[statID];
            if (!stat) {
                return 0;
            }
            let checkID: string = monsterID;
            if (CREATURELOCKER._creatures[checkID].dependent) {
                checkID = CREATURELOCKER._creatures[checkID].dependent;
            }
            if (GLOBAL.mode === GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK || !friendly) {
                if (level === 0) {
                    if (!friendly && GLOBAL.attackingPlayer) {
                        if (GLOBAL.attackingPlayer.m_upgrades[checkID] != null) {
                            level = GLOBAL.attackingPlayer.m_upgrades[checkID].level;
                        }
                    } else if (GLOBAL.player.m_upgrades[checkID] != null) {
                        level = GLOBAL.player.m_upgrades[checkID].level;
                    }
                }
            } else if (level === 0 && GLOBAL.player.m_upgrades[checkID] != null) {
                const activeEvent = SPECIALEVENT.getActiveSpecialEvent();
                if (activeEvent.active && !friendly) {
                    level = GLOBAL._wmCreatureLevels[monsterID];
                }
                level = GLOBAL.player.m_upgrades[checkID].level;
            }
            if (stat.length < level) {
                level = stat.length;
            }
            return stat[level - 1];
        } catch (e) {
            return 0;
        }
    }

    public static Tick(): void {
        for (const key in CREATURES._creatures) {
            const creature: MonsterBase = CREATURES._creatures[key];
            if (creature.tick()) {
                if (!creature.dying || creature.juiceReady) {
                    creature.die();
                    if (!creature.isDisposable && GLOBAL.player.monsterListByID(creature._creatureID)) {
                        GLOBAL.player.monsterListByID(creature._creatureID).unlinkCreepFromData(creature);
                    }
                }
                if (creature.dead) {
                    if (!BYMConfig.instance.RENDERER_ON) {
                        MAP._BUILDINGTOPS.removeChild(creature.graphic);
                    }
                    --CREATURES._creatureCount;
                    delete CREATURES._creatures[key];
                }
            }
        }
        if (CREATURES._creatureCount <= 0) {
            CREATURES._creatureCount = 0;
        }
    }

    public static Spawn(creatureId: string, parent: any, behaviour: string, pos: Point, rotation: number, 
                        targetPos: Point | null = null, targetBuilding: BFOUNDATION | null = null, 
                        level: number = 0, health: number = Number.MAX_SAFE_INTEGER): MonsterBase | null {
        if (!CREATURELOCKER._creatures[creatureId]) {
            return null;
        }
        ++CREATURES._creatureID;
        ++CREATURES._creatureCount;
        let CreatureClass = CREATURELOCKER._creatures[creatureId].classType;
        if (!CreatureClass) {
            CreatureClass = CreepBase;
        }
        const creature: MonsterBase = new CreatureClass(creatureId, behaviour, pos, rotation, level, health, targetPos, true, targetBuilding, 1, false, null);
        if (!BYMConfig.instance.RENDERER_ON) {
            parent.addChild(creature.graphic);
        }
        CREATURES._creatures[CREATURES._creatureID] = creature;
        if (GLOBAL._render) {
            creature._spawned = true;
        }
        GLOBAL.eventDispatcher.dispatchEvent(new CreepEvent(CreepEvent.DEFENDING_CREEP_SPAWNED, creature));
        return creature;
    }

    public static Clear(): void {
        for (const key in CREATURES._creatures) {
            const creature: MonsterBase = CREATURES._creatures[key];
            creature.clear();
            if (!BYMConfig.instance.RENDERER_ON) {
                MAP._BUILDINGTOPS.removeChild(creature.graphic);
            }
        }
        CREATURES._creatures = {};
        CREATURES._creatureCount = 0;
        for (let i = 0; i < CREATURES._guardianList.length; i++) {
            if (!BYMConfig.instance.RENDERER_ON) {
                MAP._BUILDINGTOPS.removeChild(CREATURES._guardianList[i].graphic);
            }
            CREATURES._guardianList[i] = null as any;
        }
        CREATURES._guardianList.length = 0;
    }

    public static get _hasLivingGuardian(): boolean {
        for (let i = 0; i < CREATURES._guardianList.length; i++) {
            if (CREATURES._guardianList[i] && CREATURES._guardianList[i].health > 0) {
                return true;
            }
        }
        return false;
    }

    public static get _guardian(): ChampionBase | null {
        for (let i = 0; i < CREATURES._guardianList.length; i++) {
            if (CREATURES._guardianList[i] && CHAMPIONCAGE.isBasicGuardian(CREATURES._guardianList[i]._creatureID)) {
                return CREATURES._guardianList[i];
            }
        }
        return null;
    }

    public static get _krallen(): ChampionBase | null {
        for (let i = 0; i < CREATURES._guardianList.length; i++) {
            if (CREATURES._guardianList[i] && CREATURES._guardianList[i]._creatureID === "G5") {
                return CREATURES._guardianList[i];
            }
        }
        return null;
    }

    public static getGuardian(guardianType: number): ChampionBase | null {
        for (let i = 0; i < CREATURES._guardianList.length; i++) {
            if (parseInt(CREATURES._guardianList[i]._creatureID.substr(1)) === guardianType) {
                return CREATURES._guardianList[i];
            }
        }
        return null;
    }

    public static getGuardianIndex(guardianType: number): number {
        for (let i = 0; i < CREATURES._guardianList.length; i++) {
            if (parseInt(CREATURES._guardianList[i]._creatureID.substr(1)) === guardianType) {
                return i;
            }
        }
        return -1;
    }

    public static set _guardian(guardian: ChampionBase | null) {
        let foundIndex = -1;
        for (let i = 0; i < CREATURES._guardianList.length; i++) {
            if (CREATURES._guardianList[i] && CHAMPIONCAGE.isBasicGuardian(CREATURES._guardianList[i]._creatureID)) {
                foundIndex = i;
            }
        }
        if (foundIndex === -1) {
            if (guardian) {
                CREATURES._guardianList.unshift(guardian);
            }
        } else if (!guardian) {
            CREATURES._guardianList.splice(foundIndex, 1);
        } else {
            CREATURES._guardianList[foundIndex] = guardian;
        }
    }

    public static addGuardian(guardian: ChampionBase): boolean {
        let foundIndex = -1;
        for (let i = 0; i < CREATURES._guardianList.length; i++) {
            if (CREATURES._guardianList[i]._creatureID === guardian._creatureID) {
                foundIndex = i;
            }
        }
        if (foundIndex === -1) {
            if (guardian) {
                CREATURES._guardianList.push(guardian);
                return true;
            }
        }
        return false;
    }

    public static removeGuardianType(guardianType: number): void {
        let i = 0;
        while (i < CREATURES._guardianList.length) {
            if (parseInt(CREATURES._guardianList[i]._creatureID.substr(1)) === guardianType) {
                break;
            }
            i++;
        }
        if (i < CREATURES._guardianList.length) {
            if (!BYMConfig.instance.RENDERER_ON) {
                MAP._BUILDINGTOPS.removeChild(CREATURES._guardianList[i].graphic);
            }
            if (CREATURES._guardianList[i] === CREATURES._guardian) {
                CREATURES._guardian = null;
            } else {
                CREATURES._guardianList.splice(i, 1);
            }
        }
    }

    public static removeAllGuardians(): void {
        const count = CREATURES._guardianList.length;
        for (let i = 0; i < count; i++) {
            if (!BYMConfig.instance.RENDERER_ON) {
                MAP._BUILDINGTOPS.removeChild(CREATURES._guardianList[i].graphic);
            }
        }
        CREATURES._guardianList.length = 0;
    }
}
