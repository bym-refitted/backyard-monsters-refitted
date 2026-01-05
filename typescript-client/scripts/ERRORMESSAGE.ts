import MovieClip from 'openfl/display/MovieClip';
import StageDisplayState from 'openfl/display/StageDisplayState';
import MouseEvent from 'openfl/events/MouseEvent';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { LOGGER } from './LOGGER';
import { TweenLite, Elastic } from './gs/TweenLite';

/**
 * ERRORMESSAGE - Error Display System
 * Handles displaying error messages and oops popups
 */
export class ERRORMESSAGE {
    public _mc: MovieClip | null = null;
    public _blocker: any = null;
    public x: number = 0;
    public y: number = 0;
    public tMessage: any;
    public bg: any;

    constructor() {}

    public Show(message: string, errorType: number = 0): void {
        const Resume = (event: MouseEvent | null = null): void => {
            GLOBAL.CallJS("reloadPage");
        };

        if (GLOBAL._ROOT.stage.displayState === StageDisplayState.FULL_SCREEN) {
            GLOBAL._ROOT.stage.displayState = StageDisplayState.NORMAL;
        }

        if (errorType !== GLOBAL.ERROR_OOPS_ONLY) {
            this._mc = GLOBAL._layerTop.addChild(this as any) as MovieClip;
            this.tMessage.autoSize = "left";
            if (message) {
                this.tMessage.htmlText = message;
            } else {
                this.tMessage.htmlText = "No message???";
            }
            this.bg.height = this.tMessage.height + 20;
            LOGGER.Log("err", "HALT: " + message);
        }

        if (errorType !== GLOBAL.ERROR_ORANGE_BOX_ONLY) {
            console.log(" *** ERRORMESSAGE SHOWING OOPS " + message);
            GLOBAL.RefreshScreen();
            try {
                throw new Error(message);
            } catch (e: any) {
                LOGGER.Log("err", "HALT " + message + " | " + e.stack);
                this._mc = GLOBAL._ROOT.addChild(new (GLOBAL as any).popup_error()) as MovieClip;
                (this._mc as any).mcFrame.Setup(false);
                if (KEYS._setup) {
                    (this._mc as any).tA.htmlText = "<b>" + KEYS.Get("pop_oops_title") + "</b>";
                    (this._mc as any).tB.htmlText = KEYS.Get("pop_oops_body");
                    (this._mc as any).tB.htmlText = KEYS.Get(message);
                }
                this._blocker = (this._mc as any).blocker;
                this._blocker.x = GLOBAL._SCREENCENTER.x - 1400;
                this._blocker.y = GLOBAL._SCREENCENTER.y - 1400;
                this._blocker.width = 2800;
                this._blocker.height = 2800;
                (this._mc as any).bAction.Setup("Reload");
                (this._mc as any).bAction.addEventListener(MouseEvent.CLICK, Resume);
            }
        }

        if (this._mc) {
            this._mc.x -= 50;
            TweenLite.to(this._mc, 0.5, {
                x: this._mc.x + 50,
                ease: Elastic.easeOut
            });
        }
        LOGGER.Log("err", "OOPS");
        GLOBAL._halt = true;
    }

    public Resize(): void {
        GLOBAL.RefreshScreen();
        this.x = GLOBAL._SCREEN.x;
        this.y = GLOBAL._SCREEN.y;
        if (this._blocker) {
            this._blocker.width = GLOBAL._SCREEN.width;
            this._blocker.height = GLOBAL._SCREEN.height;
        }
    }
}
