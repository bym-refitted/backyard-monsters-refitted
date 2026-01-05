import { SecNum } from './com/cc/utils/SecNum';
import { EnumYardType } from './com/monsters/enums/EnumYardType';
import { MapRoomManager } from './com/monsters/maproom_manager/MapRoomManager';
import { SiegeFactory } from './com/monsters/siege/SiegeFactory';
import { SiegeLab } from './com/monsters/siege/SiegeLab';
import MouseEvent from 'openfl/events/MouseEvent';
import Point from 'openfl/geom/Point';
import Rectangle from 'openfl/geom/Rectangle';
import { BASE } from './BASE';
import { BFOUNDATION } from './BFOUNDATION';
import { CREATURES } from './CREATURES';
import { GLOBAL } from './GLOBAL';
import { GRIDKEYS } from './KEYS';
import { LOGGER } from './LOGGER';
import { MAPROOM_DESCENT } from './MAPROOM_DESCENT';
import { PLEASEWAIT } from './PLEASEWAIT';
import { SOUNDS } from './SOUNDS';
import { URLLoaderApi } from './URLLoaderApi';
import { KEYS } from './KEYS';

/**
 * INFERNOPORTAL - Inferno Portal Building
 * Portal between overworld and Inferno dimension
 */
export class INFERNOPORTAL extends BFOUNDATION {
    public static readonly ENTER_BUTTON: string = "btn_entercavern";
    public static readonly ASCENSION_BUTTON: string = "btn_ascendmonsters";
    public static readonly EXIT_BUTTON: string = "btn_exitcavern";

    private static _ascensionMc: any = null;
    public static building: INFERNOPORTAL | null = null;
    public static _descentPassed: boolean = false;
    public static _ascensionData: Record<string, SecNum> | null = null;
    private static _ogInfernoData: any = null;
    private static _ogAscensionData: Record<string, number> | null = null;

    private _popup: any = null;

    constructor() {
        super();
        this._type = 127;
        this._footprint = [new Rectangle(0, 0, 190, 160)];
        this._gridCost = [[new Rectangle(0, 0, 190, 160), 200]];
        this.SetProps();
    }

    public static GetMaxLevel(): number {
        if (!INFERNOPORTAL.building) {
            throw new Error("No portal building");
        }
        return INFERNOPORTAL.building._buildingProps.costs.length;
    }

    public static EnterPortal(force: boolean = false): void {
        if (GLOBAL._flags.inferno !== 1) {
            GLOBAL.Message(KEYS.Get("inferno_msg_disabled"));
        } else if (MAPROOM_DESCENT.DescentPassed) {
            if (GLOBAL._flags.inferno !== 1) {
                GLOBAL.Message(KEYS.Get("inferno_msg_disabled"));
                return;
            }
            INFERNOPORTAL.ToggleYard();
        } else {
            INFERNOPORTAL.EnterDescent();
        }
    }

    public static AscendMonsters(): void {
        const onLoad = (serverData: any): void => {
            PLEASEWAIT.Hide();
            INFERNOPORTAL._ogInfernoData = serverData.imonsters;
            INFERNOPORTAL._ascensionData = {};
            INFERNOPORTAL._ogAscensionData = {};
            for (const monster in serverData.imonsters) {
                if (monster.substr(0, 2) === "IC") {
                    const val = serverData.imonsters[monster] instanceof Number 
                        ? serverData.imonsters[monster] 
                        : INFERNOPORTAL.numHealthyCreeps(monster, serverData.imonsters[monster]);
                    INFERNOPORTAL._ascensionData![monster] = new SecNum(val);
                    INFERNOPORTAL._ogAscensionData![monster] = INFERNOPORTAL._ascensionData![monster].Get();
                }
            }
            INFERNOPORTAL.ShowAscendMonstersDialog();
        };
        const onError = (): void => {
            LOGGER.Log("err", "INFERNOPORTAL.AscendMonsters No inferno monster data");
            GLOBAL.ErrorMessage("INFERNOPORTAL.AscendMonsters No inferno monster data");
        };

        if (!BASE.isMainYard) return;
        PLEASEWAIT.Show(KEYS.Get("msg_loading"));
        const loader = new URLLoaderApi();
        loader.load(GLOBAL._infBaseURL + "infernomonsters", [["type", "get"]], onLoad, onError);
    }

    private static numHealthyCreeps(creatureId: string, creeps: any[]): number {
        let count = creeps.length;
        const maxHealth = CREATURES.GetProperty(creatureId, "health");
        for (let i = count - 1; i >= 0; i--) {
            if (creeps[i].health < maxHealth) count--;
        }
        return count;
    }

    public static PageAscensionData(): void {
        const onLoad = (response: any): void => {
            PLEASEWAIT.Hide();
            BASE.Save();
        };
        const onError = (): void => {
            LOGGER.Log("err", "INFERNOPORTAL.PageAscensionData Could not save inferno monster changes");
            GLOBAL.ErrorMessage("INFERNOPORTAL.PageAscensionData Could not save inferno monster changes");
        };

        PLEASEWAIT.Show(KEYS.Get("msg_loading"));
        let result: any = {};
        
        if (MapRoomManager.instance.isInMapRoom3) {
            for (const s in INFERNOPORTAL._ascensionData) {
                if (s.substr(0, 2) === "IC") {
                    INFERNOPORTAL.destroyCreep(s, INFERNOPORTAL._ogAscensionData![s] - INFERNOPORTAL._ascensionData![s].Get());
                }
            }
            result = INFERNOPORTAL._ogInfernoData;
        } else {
            for (const s in INFERNOPORTAL._ascensionData) {
                if (s.substr(0, 2) === "IC" && INFERNOPORTAL._ascensionData![s].Get() > 0) {
                    result[s] = INFERNOPORTAL._ascensionData![s].Get();
                }
            }
        }
        INFERNOPORTAL._ascensionData = null;
        
        const loader = new URLLoaderApi();
        loader.load(GLOBAL._infBaseURL + "infernomonsters", [["type", "set"], ["imonsters", JSON.stringify(result)]], onLoad, onError);
    }

    private static destroyCreep(creatureId: string, count: number): void {
        const maxHealth = CREATURES.GetProperty(creatureId, "health");
        for (let i = 0; i < count; i++) {
            for (let j = INFERNOPORTAL._ogInfernoData[creatureId].length - 1; j >= 0; j--) {
                if (INFERNOPORTAL._ogInfernoData[creatureId][j].health === maxHealth) {
                    INFERNOPORTAL._ogInfernoData[creatureId].splice(j, 1);
                    break;
                }
            }
        }
    }

    public static ShowAscendMonstersDialog(): void {
        GLOBAL.BlockerAdd();
        INFERNOPORTAL._ascensionMc = new (GLOBAL as any).INFERNO_ASCENSION_POPUP();
        GLOBAL._layerWindows.addChild(INFERNOPORTAL._ascensionMc);
        INFERNOPORTAL._ascensionMc.Center();
        INFERNOPORTAL._ascensionMc.ScaleUp();
    }

    public static HideAscendMonstersDialog(): void {
        if (INFERNOPORTAL._ascensionMc) {
            GLOBAL.BlockerRemove();
            SOUNDS.Play("close");
            GLOBAL._layerWindows.removeChild(INFERNOPORTAL._ascensionMc);
            INFERNOPORTAL._ascensionMc = null;
        }
    }

    public static EnterDescent(): void {
        MAPROOM_DESCENT.Setup(true);
    }

    public static ToggleYard(): void {
        if (BASE._saving || BASE._loading || BASE._saveCounterA !== BASE._saveCounterB) {
            GLOBAL._toggleYardWaiting = 1;
            return;
        }
        MapRoomManager.instance.mapRoomVersion = MapRoomManager.MAP_ROOM_VERSION_1;
        if (BASE.isInfernoMainYardOrOutpost) {
            const yardType = MapRoomManager.instance.isInMapRoom3 ? EnumYardType.PLAYER : EnumYardType.MAIN_YARD;
            BASE.LoadBase(null, 0, 0, GLOBAL.e_BASE_MODE.BUILD, false, yardType);
        } else {
            BASE.LoadBase(GLOBAL._infBaseURL, 0, 0, "ibuild", false, EnumYardType.INFERNO_YARD);
        }
    }

    public static AddPortal(level: number = 0): INFERNOPORTAL {
        const gridPos = new Point(-1200, -150);
        const isoPos = (GLOBAL as any).GRID.ToISO(gridPos.x, gridPos.y, 0);
        const portal = BASE.addBuildingC(127) as INFERNOPORTAL;
        INFERNOPORTAL.building = portal;
        ++BASE._buildingCount;
        portal.Setup({
            X: gridPos.x,
            Y: gridPos.y,
            t: 127,
            id: BASE._buildingCount,
            l: level
        });
        portal.SetLevel(level);
        return portal;
    }

    public static isAboveMaxLevel(): boolean {
        return Boolean(INFERNOPORTAL.building) && INFERNOPORTAL.building!._lvl.Get() >= INFERNOPORTAL.GetMaxLevel();
    }

    public override Click(event: MouseEvent | null = null): void {
        if (INFERNOPORTAL.isAboveMaxLevel() && (BASE.isInfernoMainYardOrOutpost || GLOBAL.townHall && GLOBAL.townHall._lvl.Get() >= (GLOBAL as any).INFERNO_EMERGENCE_EVENT.TOWN_HALL_LEVEL_REQUIREMENT)) {
            super.Click(event);
        } else if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD && !(GLOBAL as any).INFERNO_EMERGENCE_EVENT.isAttackActive) {
            (GLOBAL as any).INFERNO_EMERGENCE_POPUPS.ShowRSVP(INFERNOPORTAL.building!._lvl.Get());
        }
    }

    public SetLevel(level: number): void {
        level = Math.min(level, this._buildingProps.costs.length);
        const oldLevel = this._lvl.Get();
        const maxLevel = this._buildingProps.costs.length;
        this.checkBuildingUnlocks();
        if (level === oldLevel) return;
        
        const diff = level - oldLevel;
        for (let i = 0; i < diff; i++) {
            this.Upgraded();
        }
        this.RenderClear();
        this.Update(true);
        this.Render();
    }

    private checkBuildingUnlocks(): void {
        if (INFERNOPORTAL.isAboveMaxLevel() && BASE.isMainYard) {
            GLOBAL._buildingProps[(GLOBAL as any).INFERNO_MAGMA_TOWER.ID - 1].block = false;
            GLOBAL._buildingProps[(GLOBAL as any).INFERNOQUAKETOWER.TYPE - 1].block = false;
            GLOBAL._buildingProps[SiegeFactory.ID - 1].block = false;
            GLOBAL._buildingProps[SiegeLab.ID - 1].block = false;
        }
    }

    public Hide(): void {
        this._mc.visible = false;
        this._mcBase.visible = false;
    }

    public Show(): void {
        this._mc.visible = true;
        this._mcBase.visible = true;
    }

    public override Export(): any {
        return false;
    }
}
