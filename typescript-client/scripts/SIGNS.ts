import { SecNum } from './com/cc/utils/SecNum';
import MovieClip from 'openfl/display/MovieClip';
import Event from 'openfl/events/Event';
import IOErrorEvent from 'openfl/events/IOErrorEvent';
import MouseEvent from 'openfl/events/MouseEvent';
import { BASE } from './BASE';
import { BFOUNDATION } from './BFOUNDATION';
import { GLOBAL } from './GLOBAL';
import { LOGIN } from './LOGIN';
import { MAILBOX } from './MAILBOX';
import { SOUNDS } from './SOUNDS';
import { UPDATES } from './UPDATES';

/**
 * SIGNS - Sign and Message System
 * Handles creating and viewing signs/messages on buildings
 */
export class SIGNS {
    public static _mc: any = null; // SIGNPOPUP
    public static _view: MovieClip | null = null;

    constructor() {}

    public static CreateForBuilding(building: BFOUNDATION): void {
        if (SIGNS._mc === null) {
            SOUNDS.Play("click1");
            SIGNS._mc = new (GLOBAL as any).SIGNPOPUP();
            GLOBAL._layerWindows.addChild(SIGNS._mc);
            SIGNS._mc._sign = building;
            SIGNS._mc._senderid = LOGIN._playerID;
            SIGNS._mc._senderName = LOGIN._playerName;
            SIGNS._mc._senderPic = LOGIN._playerPic;
            SIGNS._mc._subject = "Sign";
            SIGNS._mc._mode = "create";
            SIGNS._mc.Setup();
        }
        if (GLOBAL.mode !== GLOBAL.e_BASE_MODE.BUILD) {
            const costs: any = building._buildingProps.costs[0];
            const r5: number = costs.r5 !== undefined ? costs.r5 : 0;
            UPDATES.CreateB(["BE", BASE._loadedBaseID, costs.r1.Get(), costs.r2.Get(), costs.r3.Get(), costs.r4.Get(), r5], 0, -1);
        }
    }

    public static ShowMessage(building: BFOUNDATION): void {
        SOUNDS.Play("click1");
        if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD) {
            MAILBOX.ShowWithThreadId(building._threadid);
        } else {
            SIGNS.ViewForBuilding(building);
        }
    }

    public static ViewForBuilding(building: BFOUNDATION): void {
        const view: any = new (GLOBAL as any).popup_sign_view();
        GLOBAL._layerWindows.addChild(view);
        view.subject_txt.text = building._subject;
        view.name_txt.text = building._senderName;
        view.closeBtn.addEventListener(MouseEvent.MOUSE_DOWN, SIGNS.Hide);
        view.x = GLOBAL._SCREENCENTER.x;
        view.y = GLOBAL._SCREENCENTER.y;
        
        // Load sender picture
        if (building._senderPic) {
            const img = new Image();
            img.onload = () => {
                if (view.placeholder) {
                    // Create canvas or use image element
                    view.placeholder.width = 50;
                    view.placeholder.height = 50;
                }
            };
            img.onerror = () => {};
            try {
                img.src = building._senderPic;
            } catch (e) {}
        }
        SIGNS._view = view;
    }

    public static EditForBuilding(building: BFOUNDATION): void {
        if (SIGNS._mc === null) {
            SIGNS._mc = new (GLOBAL as any).SIGNPOPUP();
            GLOBAL._layerWindows.addChild(SIGNS._mc);
            SIGNS._mc._sign = building;
            SIGNS._mc._senderid = LOGIN._playerID;
            SIGNS._mc._subject = building._subject;
            SIGNS._mc._mode = "edit";
            SIGNS._mc.Setup();
        }
    }

    public static Hide(event: MouseEvent | null = null): void {
        if (SIGNS._mc) {
            try {
                SOUNDS.Play("close");
                if (SIGNS._mc.parent) {
                    SIGNS._mc.parent.removeChild(SIGNS._mc);
                }
            } catch (e) {}
            SIGNS._mc = null;
        }
        if (SIGNS._view) {
            try {
                SOUNDS.Play("close");
                if (SIGNS._view.parent) {
                    SIGNS._view.parent.removeChild(SIGNS._view);
                }
            } catch (e) {}
            SIGNS._view = null;
        }
    }
}
