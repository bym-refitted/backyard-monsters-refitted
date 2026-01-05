import { TRIBES } from './com/monsters/ai/TRIBES';
import { InstanceManager } from './com/monsters/managers/InstanceManager';
import { MapRoomManager } from './com/monsters/maproom_manager/MapRoomManager';
import MouseEvent from 'openfl/events/MouseEvent';
import Point from 'openfl/geom/Point';
import Rectangle from 'openfl/geom/Rectangle';
import { BASE } from './BASE';
import { BFOUNDATION } from './BFOUNDATION';
import { BUILDING15 } from './BUILDING15';
import { CREATURES } from './CREATURES';
import { GLOBAL } from './GLOBAL';
import { GRID } from './GRID';
import { HOUSINGBUNKER } from './HOUSINGBUNKER';
import { MAP } from './MAP';
import { MONSTERBUNKERPOPUP } from './MONSTERBUNKERPOPUP';
import { PersistentMonsterBunker } from './PersistentMonsterBunker';
import { SOUNDS } from './SOUNDS';

/**
 * MONSTERBUNKER - Monster Bunker Controller
 * Manages monster bunker popup and creature storage in defensive bunkers
 */
export class MONSTERBUNKER {
    public static readonly TYPE: number = 22;
    public static _mc: MONSTERBUNKERPOPUP | null = null;
    public static s_PersistantBunker: PersistentMonsterBunker | null = null;
    public static _open: boolean = false;
    public static _bunkerCapacity: number = 0;
    public static _bunkerUsed: number = 0;
    public static _bunkerSpace: number = 0;
    public static _housingBuildingUpgrading: boolean = false;
    public static _creatures: Record<string, number> = {};

    constructor() {}

    public static Data(data: Record<string, number>): void {
        MONSTERBUNKER._creatures = data;
        if (MONSTERBUNKER._creatures["C100"]) {
            MONSTERBUNKER._creatures["C12"] = MONSTERBUNKER._creatures["C100"];
            delete MONSTERBUNKER._creatures["C100"];
        }
    }

    public static Show(event: MouseEvent | null = null): void {
        MONSTERBUNKER.Hide(event);
        MONSTERBUNKER._open = true;
        GLOBAL.BlockerAdd();
        if (MapRoomManager.instance.isInMapRoom3) {
            MONSTERBUNKER.s_PersistantBunker = GLOBAL._layerWindows.addChild(new PersistentMonsterBunker()) as PersistentMonsterBunker;
            (MONSTERBUNKER.s_PersistantBunker as any).Center();
            (MONSTERBUNKER.s_PersistantBunker as any).ScaleUp();
        } else {
            MONSTERBUNKER._mc = GLOBAL._layerWindows.addChild(new MONSTERBUNKERPOPUP()) as MONSTERBUNKERPOPUP;
            MONSTERBUNKER._mc.Center();
            MONSTERBUNKER._mc.ScaleUp();
        }
    }

    public static Hide(event: MouseEvent | null = null): void {
        if (MONSTERBUNKER._open) {
            GLOBAL.BlockerRemove();
            SOUNDS.Play("close");
            if (MONSTERBUNKER._mc) {
                GLOBAL._layerWindows.removeChild(MONSTERBUNKER._mc);
            }
            if (MONSTERBUNKER.s_PersistantBunker) {
                GLOBAL._layerWindows.removeChild(MONSTERBUNKER.s_PersistantBunker as any);
            }
            MONSTERBUNKER._open = false;
            MONSTERBUNKER._mc = null;
            MONSTERBUNKER.s_PersistantBunker = null;
        }
    }

    public static BunkerStore(creatureId: string, bunker: any, skipSpawn: boolean = false): boolean {
        if (creatureId === "C100") creatureId = "C12";
        
        const storage: number = CREATURES.GetProperty(creatureId, "cStorage");
        const isJuiceMode: boolean = (GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK || GLOBAL.mode === GLOBAL.e_BASE_MODE.WMVIEW) && 
                                     TRIBES.TribeForID(BASE._wmID).behaviour === "juice";
        
        if (MONSTERBUNKER._bunkerSpace < storage && !isJuiceMode) return false;
        
        if (!skipSpawn) {
            if (bunker._monsters[creatureId]) {
                bunker._monsters[creatureId] += 1;
            } else {
                bunker._monsters[creatureId] = 1;
            }
            
            if (GLOBAL._render) {
                if (isJuiceMode) {
                    const monster = CREATURES.Spawn(creatureId, MAP._BUILDINGTOPS!, "juice", new Point(bunker.x, bunker.y), 0);
                    if (monster) (monster as any).ModeJuice();
                } else {
                    const houses: any[] = [];
                    const housingClass = BASE.isInfernoMainYardOrOutpost ? HOUSINGBUNKER : BUILDING15;
                    const buildings = InstanceManager.getInstancesByClass(housingClass);
                    
                    for (const building of buildings) {
                        const b = building as BFOUNDATION;
                        if (b._countdownBuild.Get() <= 0 && b.health > 0) {
                            const dx: number = b._mc.x - bunker.x;
                            const dy: number = b._mc.y - bunker.y;
                            const dist: number = Math.sqrt(dx * dx + dy * dy);
                            houses.push({ mc: b, dist: dist });
                        }
                    }
                    if (houses.length === 0) return false;
                    houses.sort((a, b) => a.dist - b.dist);
                    const closest: BFOUNDATION = houses[0].mc;
                    CREATURES.Spawn(creatureId, MAP._BUILDINGTOPS!, "bunkering", new Point(bunker._mc.x, bunker._mc.y), 0, GRID.FromISO(closest._mc.x, closest._mc.y), closest);
                }
            }
        }
        return true;
    }

    public static Cull(): void {
        MONSTERBUNKER._bunkerCapacity = 0;
        MONSTERBUNKER._bunkerUsed = 0;
        MONSTERBUNKER._bunkerSpace = 0;
    }

    public static Populate(): void {
        const houses: BFOUNDATION[] = [];
        const housingClass = BASE.isInfernoMainYardOrOutpost ? HOUSINGBUNKER : BUILDING15;
        const buildings = InstanceManager.getInstancesByClass(housingClass);
        
        for (const building of buildings) {
            const b = building as BFOUNDATION;
            if (b.health > 0) houses.push(b);
        }
        
        if (houses.length > 0) {
            for (const creatureId in MONSTERBUNKER._creatures) {
                let count: number = MONSTERBUNKER._creatures[creatureId];
                if (count > 50) count = 50;
                for (let i = 0; i < count; i++) {
                    const idx: number = Math.floor(Math.random() * houses.length);
                    const house: BFOUNDATION = houses[idx];
                    const housePos: Point = GRID.FromISO(house.x, house.y);
                    CREATURES.Spawn(creatureId, MAP._BUILDINGTOPS!, "pen", MONSTERBUNKER.PointInBunker(housePos), Math.random() * 360, housePos, house);
                }
            }
        }
    }

    public static PointInBunker(bunkerPos: Point): Point {
        const rect: Rectangle = new Rectangle(30, 40, 110, 80);
        return GRID.ToISO(bunkerPos.x + (rect.x + Math.random() * rect.width), bunkerPos.y + (rect.y + Math.random() * rect.height), 0);
    }

    public static Tick(): void {
        // Tick logic - currently empty in original
    }

    public static isBunkerBuilding(buildingType: number): boolean {
        return buildingType === 22 || buildingType === 128;
    }
}
