import { MapRoomManager } from './com/monsters/maproom_manager/MapRoomManager';
import MouseEvent from 'openfl/events/MouseEvent';
import { BASE } from './BASE';
import { BFOUNDATION } from './BFOUNDATION';
import { BUILDINGSPOPUP } from './BUILDINGSPOPUP';
import { GLOBAL } from './GLOBAL';
import { SOUNDS } from './SOUNDS';

/**
 * BUILDINGS - Buildings Menu Controller
 * Manages the buildings popup for placing new buildings
 */
export class BUILDINGS {
    public static _mc: BUILDINGSPOPUP | null = null;
    public static _open: boolean = false;
    public static _menuA: number = 1;
    public static _menuB: number = 0;
    public static _page: number = 0;
    public static _buildingID: number = 0;

    constructor() {}

    public static Reset(full: boolean = false): void {
        if (full) {
            BUILDINGS._menuA = 1;
            BUILDINGS._menuB = 0;
            BUILDINGS._page = 0;
        }
        BUILDINGS._buildingID = 0;
        BUILDINGS.Hide();
    }

    public static Show(event: MouseEvent | null = null): void {
        if (MapRoomManager.instance.isInMapRoom3 && !BASE.isMainYardOrInfernoMainYard) return;
        GLOBAL.BlockerAdd();
        if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD) {
            if (GLOBAL._newBuilding) {
                (GLOBAL._newBuilding as BFOUNDATION).Cancel();
            }
            if (!BUILDINGS._open) {
                SOUNDS.Play("click1");
                BASE.BuildingDeselect();
                BUILDINGS._open = true;
                BUILDINGS._mc = GLOBAL._layerWindows.addChild(new BUILDINGSPOPUP()) as BUILDINGSPOPUP;
                BUILDINGS._mc.Center();
                BUILDINGS._mc.ScaleUp();
            }
            if (BUILDINGS._buildingID > 0) {
                BUILDINGS._mc!.ShowInfo(BUILDINGS._buildingID);
            }
        }
    }

    public static Hide(event: MouseEvent | null = null): void {
        GLOBAL.BlockerRemove();
        if (BUILDINGS._open) {
            SOUNDS.Play("close");
            BUILDINGS._open = false;
            BUILDINGS._mc!.HideInfo();
            BUILDINGS._mc!._buildingInfoMC = null;
            GLOBAL._layerWindows.removeChild(BUILDINGS._mc!);
            BUILDINGS._mc = null;
        }
    }
}
