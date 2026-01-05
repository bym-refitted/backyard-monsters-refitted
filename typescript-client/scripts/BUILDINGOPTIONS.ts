import DisplayObject from 'openfl/display/DisplayObject';
import MouseEvent from 'openfl/events/MouseEvent';
import { BASE } from './BASE';
import { BFOUNDATION } from './BFOUNDATION';
import { BUILDINGOPTIONSPOPUP } from './BUILDINGOPTIONSPOPUP';
import { GLOBAL } from './GLOBAL';
import { SOUNDS } from './SOUNDS';

/**
 * BUILDINGOPTIONS - Building Options Dialog Management
 * Handles showing and hiding the building options popup
 */
export class BUILDINGOPTIONS {
    public static _do: BUILDINGOPTIONSPOPUP | null = null;
    public static _doBG: DisplayObject | null = null;
    public static _building: BFOUNDATION | null = null;
    public static _open: boolean = false;

    constructor() {}

    public static Show(building: BFOUNDATION, mode: string = "info"): void {
        if (!BUILDINGOPTIONS._open) {
            GLOBAL.BlockerAdd();
            SOUNDS.Play("click1");
            BASE.BuildingDeselect();
            BUILDINGOPTIONS._building = building;
            BUILDINGOPTIONS._open = true;
            BUILDINGOPTIONS._do = GLOBAL._layerWindows.addChild(new BUILDINGOPTIONSPOPUP(mode)) as BUILDINGOPTIONSPOPUP;
            BUILDINGOPTIONS._do.Center();
            BUILDINGOPTIONS._do.ScaleUp();
        }
    }

    public static Hide(event: MouseEvent | null = null): void {
        if (BUILDINGOPTIONS._open) {
            GLOBAL.BlockerRemove();
            SOUNDS.Play("close");
            BUILDINGOPTIONS._open = false;
            GLOBAL._layerWindows.removeChild(BUILDINGOPTIONS._do!);
            BUILDINGOPTIONS._do = null;
        }
    }
}
