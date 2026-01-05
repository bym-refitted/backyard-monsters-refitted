import MouseEvent from 'openfl/events/MouseEvent';
import { BASE } from './BASE';
import { BUILDING13 } from './BUILDING13';
import { GLOBAL } from './GLOBAL';
import { HATCHERYPOPUP } from './HATCHERYPOPUP';
import { SOUNDS } from './SOUNDS';

/**
 * HATCHERY - Hatchery Building Controller
 * Manages the hatchery popup for creating monsters
 */
export class HATCHERY {
    public static readonly TYPE: number = 13;
    public static _mc: HATCHERYPOPUP | null = null;
    public static _open: boolean = false;

    constructor() {}

    public static Show(building: BUILDING13): void {
        if (!HATCHERY._open) {
            HATCHERY._open = true;
            GLOBAL.BlockerAdd();
            HATCHERY._mc = GLOBAL._layerWindows.addChild(new HATCHERYPOPUP()) as HATCHERYPOPUP;
            HATCHERY._mc.Setup(building);
            HATCHERY._mc.Center();
            HATCHERY._mc.ScaleUp();
        }
    }

    public static Hide(event: MouseEvent | null = null): void {
        if (HATCHERY._open) {
            GLOBAL.BlockerRemove();
            SOUNDS.Play("close");
            BASE.BuildingDeselect();
            HATCHERY._open = false;
            GLOBAL._layerWindows.removeChild(HATCHERY._mc!);
            HATCHERY._mc = null;
        }
    }

    public static Tick(): void {
        if (HATCHERY._mc) {
            HATCHERY._mc.Update();
        }
    }
}
