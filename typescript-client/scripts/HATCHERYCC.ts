import MouseEvent from 'openfl/events/MouseEvent';
import { BASE } from './BASE';
import { GLOBAL } from './GLOBAL';
import { HATCHERYCCPOPUP } from './HATCHERYCCPOPUP';
import { SOUNDS } from './SOUNDS';

/**
 * HATCHERYCC - Hatchery Control Center Controller
 * Manages the hatchery control center popup for batch monster creation
 */
export class HATCHERYCC {
    public static readonly TYPE: number = 16;
    public static readonly DEFAULT_QUEUE_LIMIT: number = 20;
    public static queueLimit: number = HATCHERYCC.DEFAULT_QUEUE_LIMIT;
    public static doesShowInfernoCreeps: boolean = false;
    public static _mc: HATCHERYCCPOPUP | null = null;
    public static _open: boolean = false;

    constructor() {}

    public static Show(): void {
        if (!HATCHERYCC._open) {
            HATCHERYCC._open = true;
            GLOBAL.BlockerAdd();
            HATCHERYCC._mc = GLOBAL._layerWindows.addChild(new HATCHERYCCPOPUP()) as HATCHERYCCPOPUP;
            HATCHERYCC._mc.Setup();
            HATCHERYCC._mc.Center();
            HATCHERYCC._mc.ScaleUp();
        }
    }

    public static Hide(event: MouseEvent | null = null): void {
        if (HATCHERYCC._open) {
            GLOBAL.BlockerRemove();
            SOUNDS.Play("close");
            BASE.BuildingDeselect();
            HATCHERYCC._open = false;
            GLOBAL._layerWindows.removeChild(HATCHERYCC._mc!);
            HATCHERYCC._mc = null;
        }
    }

    public static Tick(): void {
        if (HATCHERYCC._mc) {
            HATCHERYCC._mc.Update();
        }
    }
}
