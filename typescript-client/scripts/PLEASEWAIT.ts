import MovieClip from 'openfl/display/MovieClip';
import { BASE } from './BASE';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { POPUPS } from './POPUPS';
import { POPUPSETTINGS } from './POPUPSETTINGS';

/**
 * PLEASEWAIT - Loading/Processing Dialog
 * Displays a waiting message while processing occurs
 */
export class PLEASEWAIT extends MovieClip {
    public static _mc: any = null;
    public static _mcCount: number = 0;
    public static _mcTips: MovieClip | null = null;
    public static lastTipTime: number = 0;
    public static processDuration: number = 0;
    public static processThreshold: number = 60 * 60 * 12;
    public static tipsAvailable: number = 33;
    public static tipIndex: number = 0;
    public static tipDelay: number = 6;
    public static tips: string[] = [];
    public static tipsInited: boolean = false;
    public static tipsLocalKey: string = "tips_hint";

    constructor() {
        super();
    }

    public static Show(message: string): void {
        if (!PLEASEWAIT._mc) {
            PLEASEWAIT._mc = GLOBAL._layerTop.addChild(new (GLOBAL as any).PLEASEWAITMC());
            PLEASEWAIT._mc.tMessage.htmlText = "<b>" + message + "</b>";
            PLEASEWAIT._mc.mcFrame.Setup(false);
            POPUPSETTINGS.AlignToCenter(PLEASEWAIT._mc);
        }
    }

    public static Update(message: string = "Processing..."): void {
        if (PLEASEWAIT._mc) {
            PLEASEWAIT._mc.tMessage.htmlText = "<b>" + message + "</b>";
            PLEASEWAIT.AddTips();
        }
    }

    public static Hide(): void {
        try {
            if (PLEASEWAIT._mc) {
                GLOBAL._layerTop.removeChild(PLEASEWAIT._mc);
                PLEASEWAIT._mc.mcFrame = null;
                PLEASEWAIT._mc = null;
            }
        } catch (e) {
            // Ignore errors
        }
    }

    public static MessageChange(...args: any[]): void {
        PLEASEWAIT._mc.tMessage.text = args[0];
    }

    public static AddTips(): void {
        if (GLOBAL._giveTips && KEYS._setup && PLEASEWAIT.HasTips()) {
            if (BASE._catchupTime && BASE._catchupTime >= PLEASEWAIT.processThreshold && PLEASEWAIT.lastTipTime === 0 && 
                GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard && GLOBAL._whatsnewid === GLOBAL._lastWhatsNew) {
                if (GLOBAL.StatGet("tipno")) {
                    PLEASEWAIT.tipIndex = GLOBAL.StatGet("tipno");
                }
                if (PLEASEWAIT.tipIndex < PLEASEWAIT.tips.length) {
                    PLEASEWAIT.ShowTips(PLEASEWAIT.tips[PLEASEWAIT.tipIndex]);
                }
                GLOBAL.StatSet("tipno", PLEASEWAIT.tipIndex + 1);
            }
        }
    }

    public static HasTips(): boolean {
        if (PLEASEWAIT.tipsInited) return true;
        
        PLEASEWAIT.tips = [];
        let allLoaded: boolean = true;
        for (let i = 1; i <= PLEASEWAIT.tipsAvailable; i++) {
            const key: string = PLEASEWAIT.tipsLocalKey + i;
            const tip: string = KEYS.Get(key);
            if (tip === "") allLoaded = false;
            PLEASEWAIT.tips.push(tip);
        }
        if (allLoaded) PLEASEWAIT.tipsInited = true;
        return allLoaded;
    }

    public static ShowTips(tip: string): void {
        GLOBAL._proTip = new (GLOBAL as any).PROTIP_CLIP();
        GLOBAL._proTip.tTitle.htmlText = KEYS.Get("tips_title");
        GLOBAL._proTip.tDesc.htmlText = "<b>" + tip + "</b>";
        GLOBAL._proTip.x = 390;
        GLOBAL._proTip.y = 240;
        POPUPS.Push(GLOBAL._proTip, null, null, null, null, true, "tip");
        POPUPS.Show("tip");
        PLEASEWAIT.lastTipTime = 1;
    }

    public static HideTips(): void {
        // Empty implementation
    }
}
