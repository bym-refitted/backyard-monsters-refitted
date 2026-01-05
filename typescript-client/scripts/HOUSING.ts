import { SecNum } from './com/cc/utils/SecNum';
import { TRIBES } from './com/monsters/ai/TRIBES';
import { InstanceManager } from './com/monsters/managers/InstanceManager';
import { MapRoomManager } from './com/monsters/maproom_manager/MapRoomManager';
import { MonsterBase } from './com/monsters/monsters/MonsterBase';
import { MonsterData } from './com/monsters/player/MonsterData';
import MovieClip from 'openfl/display/MovieClip';
import MouseEvent from 'openfl/events/MouseEvent';
import Point from 'openfl/geom/Point';
import Rectangle from 'openfl/geom/Rectangle';
import { BASE } from './BASE';
import { BFOUNDATION } from './BFOUNDATION';
import { BUILDING15 } from './BUILDING15';
import { CREATURELOCKER } from './CREATURELOCKER';
import { CREATURES } from './CREATURES';
import { GLOBAL } from './GLOBAL';
import { GRID } from './GRID';
import { HOUSINGBUNKER } from './HOUSINGBUNKER';
import { HOUSINGPOPUP } from './HOUSINGPOPUP';
import { HousingPersistentPopup } from './HousingPersistentPopup';
import { MAP } from './MAP';
import { MAPROOM_DESCENT } from './MAPROOM_DESCENT';
import { SOUNDS } from './SOUNDS';

/**
 * HOUSING - Monster Housing System
 * Manages housing buildings and monster storage
 */
export class HOUSING {
    public static _housingPopup: MovieClip | null = null;
    public static _open: boolean = false;
    public static _housingCapacity: SecNum = new SecNum(0);
    public static _housingUsed: SecNum = new SecNum(0);
    public static _housingSpace: SecNum = new SecNum(0);
    public static _housingBuildingUpgrading: boolean = false;

    constructor() {}

    public static Show(event: MouseEvent | null = null): void {
        HOUSING._open = true;
        GLOBAL.BlockerAdd();
        if (MapRoomManager.instance.isInMapRoom3) {
            HOUSING._housingPopup = new HousingPersistentPopup() as any;
        } else {
            HOUSING._housingPopup = new HOUSINGPOPUP() as any;
        }
        GLOBAL._layerWindows.addChild(HOUSING._housingPopup!);
        (HOUSING._housingPopup as any).Center();
        (HOUSING._housingPopup as any).ScaleUp();
    }

    public static Hide(event: MouseEvent | null = null): void {
        if (HOUSING._open) {
            GLOBAL.BlockerRemove();
            SOUNDS.Play("close");
            GLOBAL._layerWindows.removeChild(HOUSING._housingPopup!);
            HOUSING._open = false;
            HOUSING._housingPopup = null;
        }
    }

    public static HousingSpace(): void {
        HOUSING._housingCapacity = new SecNum(0);
        HOUSING._housingUsed = new SecNum(0);
        HOUSING._housingSpace = new SecNum(0);
        HOUSING._housingBuildingUpgrading = false;
        
        const housingClass = BASE.isInfernoMainYardOrOutpost ? HOUSINGBUNKER : BUILDING15;
        const buildings = InstanceManager.getInstancesByClass(housingClass);
        
        for (const building of buildings) {
            const b = building as BFOUNDATION;
            if (b._countdownBuild.Get() <= 0 && (b.health > 10 || MapRoomManager.instance.isInMapRoom3)) {
                let capacity: number = b._buildingProps.capacity[b._lvl.Get() - 1];
                if (GLOBAL._extraHousing >= GLOBAL.Timestamp() && GLOBAL._extraHousingPower.Get() > 0) {
                    capacity = HOUSING.addHousingCapacityMultiplier(capacity);
                }
                HOUSING._housingCapacity.Add(capacity);
            }
            if (b._countdownBuild.Get() + b._countdownUpgrade.Get() > 0) {
                HOUSING._housingBuildingUpgrading = true;
            }
        }

        const monsterCount: number = GLOBAL.player.monsterList.length;
        for (let i = 0; i < monsterCount; i++) {
            const monster = GLOBAL.player.monsterList[i];
            HOUSING._housingUsed.Add(CREATURES.GetProperty(monster.m_creatureID, "cStorage", 0, true) * monster.numCreeps);
        }
        HOUSING._housingSpace.Set(HOUSING._housingCapacity.Get() - HOUSING._housingUsed.Get());
    }

    private static addHousingCapacityMultiplier(capacity: number): number {
        return capacity * GLOBAL._extraHousingPower.Get();
    }

    public static HousingStore(creatureId: string, position: Point, skipSpawn: boolean = false, instantTime: number = 0): boolean {
        if (instantTime > 0) {
            GLOBAL.ErrorMessage("HOUSING insta monster hack");
            return false;
        }
        if (creatureId === "C100") creatureId = "C12";
        
        const storage: number = CREATURES.GetProperty(creatureId, "cStorage", 0, true);
        const isJuiceMode: boolean = (GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK || GLOBAL.mode === GLOBAL.e_BASE_MODE.WMVIEW) && 
                                     TRIBES.TribeForBaseID(BASE._wmID).behaviour === "juice";
        HOUSING.HousingSpace();
        
        if (HOUSING._housingSpace.Get() < storage && !isJuiceMode) return false;
        
        if (!skipSpawn) {
            if (isJuiceMode) {
                const monster = CREATURES.Spawn(creatureId, MAP._BUILDINGTOPS!, "juice", position, 0);
                if (monster) monster.changeModeJuice();
            } else {
                const monster = HOUSING.createAndHouseCreep(creatureId, position);
                if (!monster) return false;
                GLOBAL.player.addMonster(creatureId, monster);
            }
        }
        return true;
    }

    public static createAndHouseCreep(creatureId: string, position: Point): MonsterBase | null {
        const house: BFOUNDATION | null = HOUSING.getClosestHouseToPoint(position);
        if (!house) return null;
        return CREATURES.Spawn(creatureId, MAP._BUILDINGTOPS!, "housing", position, 0, GRID.FromISO(house._mc.x, house._mc.y), house);
    }

    public static getClosestHouseToPoint(position: Point): BFOUNDATION | null {
        const houses: any[] = [];
        const housingClass = BASE.isInfernoMainYardOrOutpost ? HOUSINGBUNKER : BUILDING15;
        const buildings = InstanceManager.getInstancesByClass(housingClass);
        
        for (const building of buildings) {
            const b = building as BFOUNDATION;
            if (b._countdownBuild.Get() <= 0 && (b.health > 0 || MapRoomManager.instance.isInMapRoom3)) {
                const creatureCount: number = b._creatures.length;
                houses.push({ mc: b, dist: creatureCount });
            }
        }
        if (houses.length === 0) return null;
        houses.sort((a, b) => a.dist - b.dist);
        return houses[0].mc;
    }

    public static Cull(force: boolean = false): void {
        HOUSING._housingCapacity = new SecNum(0);
        HOUSING._housingUsed = new SecNum(0);
        HOUSING._housingSpace = new SecNum(0);
        
        const housingClass = BASE.isInfernoMainYardOrOutpost ? HOUSINGBUNKER : BUILDING15;
        const buildings = InstanceManager.getInstancesByClass(housingClass);
        
        for (const building of buildings) {
            const b = building as BFOUNDATION;
            if (b._countdownBuild.Get() <= 0 && (b.health > 0 || MapRoomManager.instance.isInMapRoom3)) {
                let capacity: number = b._buildingProps.capacity[b._lvl.Get() - 1];
                if (GLOBAL._extraHousing >= GLOBAL.Timestamp() && GLOBAL._extraHousingPower.Get() > 0) {
                    capacity = HOUSING.addHousingCapacityMultiplier(capacity);
                }
                HOUSING._housingCapacity.Add(capacity);
            }
        }

        const monsterCount: number = GLOBAL.player.monsterList.length;
        for (let i = 0; i < monsterCount; i++) {
            const monster = GLOBAL.player.monsterList[i];
            if (monster.numCreeps) {
                HOUSING._housingUsed.Add(CREATURES.GetProperty(monster.m_creatureID, "cStorage", 0, true) * monster.numCreeps);
            }
        }

        while (HOUSING._housingUsed.Get() > HOUSING._housingCapacity.Get()) {
            HOUSING._housingUsed.Set(0);
            for (let i = 0; i < monsterCount; i++) {
                const monster = GLOBAL.player.monsterList[i];
                if (monster.numCreeps > 0) {
                    monster.add(-1, null, true);
                    HOUSING._housingUsed.Add(CREATURES.GetProperty(monster.m_creatureID, "cStorage", 0, true) * monster.numCreeps);
                }
            }
        }
        HOUSING.HousingSpace();
    }

    public static Populate(): void {
        const houses: BFOUNDATION[] = [];
        const housingClass = BASE.isInfernoMainYardOrOutpost ? HOUSINGBUNKER : BUILDING15;
        const buildings = InstanceManager.getInstancesByClass(housingClass);
        
        for (const building of buildings) {
            const b = building as BFOUNDATION;
            if (b.health > 0 || MapRoomManager.instance.isInMapRoom3) {
                houses.push(b);
            }
        }

        if (houses.length > 0) {
            const monsterCount: number = GLOBAL.player.monsterList.length;
            for (let i = 0; i < monsterCount; i++) {
                const monsterData = GLOBAL.player.monsterList[i];
                const creepCount: number = monsterData.numCreeps;
                for (let j = 0; j < creepCount; j++) {
                    if (!monsterData.m_creeps[j].ownerID) {
                        const houseIdx: number = Math.floor(Math.random() * houses.length);
                        const house: BFOUNDATION = houses[houseIdx];
                        const housePos: Point = GRID.FromISO(house.x, house.y);
                        monsterData.m_creeps[j].self = CREATURES.Spawn(
                            monsterData.m_creatureID, MAP._BUILDINGTOPS!, MonsterBase.k_sBHVR_PEN,
                            HOUSING.PointInHouse(housePos), Math.random() * 360, housePos, house,
                            monsterData.level, monsterData.m_creeps[j].health
                        );
                    }
                }
            }
        }
    }

    public static PointInHouse(housePos: Point): Point {
        const rect: Rectangle = new Rectangle(40, 40, 80, 80);
        return GRID.ToISO(housePos.x + (rect.x + Math.random() * rect.width), housePos.y + (rect.y + Math.random() * rect.height), 0);
    }

    public static Update(): void {
        if (HOUSING._open && HOUSING._housingPopup) {
            (HOUSING._housingPopup as any).Update();
        }
    }

    public static catchupTick(deltaTime: number): void {
        GLOBAL.player.tickHeal(deltaTime);
    }

    public static isHousingBuilding(buildingType: number): boolean {
        return buildingType === 15 || buildingType === 128;
    }

    public static AddHouse(building: BFOUNDATION): void {
        HOUSING.HousingSpace();
        GLOBAL._bHousing = building;
    }

    public static RemoveHouse(building: BFOUNDATION): void {
        GLOBAL._bHousing = null;
        HOUSING.HousingSpace();
    }

    public static GetHousingCreatures(): any[] {
        const aboveCreatures: any[] = [];
        const infernoCreatures: any[] = [];
        const allCreatures: any[] = [];
        
        const aboveUnlocked = CREATURELOCKER.GetCreatures("above");
        if (!BASE.isInfernoMainYardOrOutpost) {
            for (const id in aboveUnlocked) {
                const creature = CREATURELOCKER._creatures[id];
                if (!creature.blocked) {
                    creature.id = id;
                    aboveCreatures.push(creature);
                }
            }
            aboveCreatures.sort((a, b) => a.index - b.index);
        }

        const infernoUnlocked = CREATURELOCKER.GetCreatures("inferno");
        if (MAPROOM_DESCENT.DescentPassed) {
            for (const id in infernoUnlocked) {
                const creature = CREATURELOCKER._creatures[id];
                if (!creature.blocked) {
                    creature.id = id;
                    infernoCreatures.push(creature);
                }
            }
            infernoCreatures.sort((a, b) => a.index - b.index);
        }

        if (aboveCreatures.length > 0) allCreatures.push(...aboveCreatures);
        if (infernoCreatures.length > 0) allCreatures.push(...infernoCreatures);

        const result: any[] = [];
        for (let i = 0; i < allCreatures.length; i++) {
            const monsterCount: number = GLOBAL.player.monsterList.length;
            for (let j = 0; j < monsterCount; j++) {
                const monsterData: MonsterData = GLOBAL.player.monsterList[j];
                if (monsterData.m_creatureID === allCreatures[i].id && monsterData.numCreeps > 0) {
                    const creatureInfo = allCreatures[i];
                    creatureInfo.quantity = monsterData.numHousedCreeps;
                    result.push(creatureInfo);
                }
            }
        }
        return result;
    }
}
