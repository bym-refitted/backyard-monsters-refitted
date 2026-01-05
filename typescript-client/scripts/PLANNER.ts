import { BasePlanner } from './com/monsters/baseplanner/BasePlanner';
import MouseEvent from 'openfl/events/MouseEvent';
import StageDisplayState from 'openfl/display/StageDisplayState';
import { BASE } from './BASE';
import { GLOBAL } from './GLOBAL';
import { PLANNERPOPUP } from './PLANNERPOPUP';
import { SOUNDS } from './SOUNDS';
import { STORE } from './STORE';

/**
 * PLANNER - Yard Planner Controller
 * Manages the yard planner popup for organizing base layout
 */
export class PLANNER {
    public static readonly TYPE: number = 10;
    public static _mc: PLANNERPOPUP | null = null;
    public static _open: boolean = false;
    public static _selected: boolean = false;
    public static _useOldPlanner: boolean = true;
    public static basePlanner: BasePlanner | null = null;

    constructor() {
        PLANNER._open = false;
    }

    public static Show(event: MouseEvent | null = null): void {
        if (GLOBAL._selectedBuilding) {
            GLOBAL._selectedBuilding.StopMoveB();
        }
        if (GLOBAL._newBuilding) {
            (GLOBAL._newBuilding as any).Cancel();
        }
        BASE.BuildingDeselect();
        PLANNER._selected = false;
        
        if (GLOBAL._flags?.yp_version !== null) {
            switch (GLOBAL._flags.yp_version) {
                case 0:
                    GLOBAL.Message(">Yard PLANNER has been disabled for this ENVIRONMENT");
                    return;
                case 1:
                    PLANNER._useOldPlanner = true;
                    break;
                case 2:
                    PLANNER._useOldPlanner = false;
                    break;
            }
        }
        
        if (!PLANNER._open) {
            PLANNER._open = true;
            SOUNDS.Play("click1");
            BASE.BuildingDeselect();
            GLOBAL.BlockerAdd();
            
            if (PLANNER._useOldPlanner) {
                if (GLOBAL._ROOT.stage.displayState === StageDisplayState.FULL_SCREEN) {
                    GLOBAL._ROOT.stage.displayState = StageDisplayState.NORMAL;
                }
                PLANNER._mc = GLOBAL._layerWindows.addChild(new PLANNERPOPUP()) as PLANNERPOPUP;
            } else {
                if (PLANNER.basePlanner) {
                    PLANNER.basePlanner.setup();
                } else {
                    PLANNER.basePlanner = new BasePlanner();
                    PLANNER.basePlanner.setup();
                }
            }
        }
    }

    public static Hide(event: MouseEvent | null = null): void {
        GLOBAL.BlockerRemove();
        if (GLOBAL._selectedBuilding && GLOBAL._selectedBuilding._class !== "mushroom") {
            GLOBAL._selectedBuilding.StopMoveB();
        }
        if (GLOBAL._newBuilding) {
            (GLOBAL._newBuilding as any).Cancel();
        }
        BASE.BuildingDeselect();
        
        if (PLANNER._open) {
            SOUNDS.Play("close");
            PLANNER._open = false;
            if (PLANNER._useOldPlanner) {
                PLANNER._mc!.Remove();
                GLOBAL._layerWindows.removeChild(PLANNER._mc!);
                PLANNER._mc = null;
            } else {
                PLANNER.basePlanner?.hide();
            }
        }
    }

    public static isOpen(): boolean {
        return PLANNER._open;
    }

    public static Update(): void {
        if (PLANNER._open) {
            if (PLANNER._useOldPlanner) {
                STORE.Hide();
                PLANNER.Hide();
                PLANNER.Show();
            }
        }
    }
}
