import { ImageCache } from './com/monsters/display/ImageCache';
import MovieClip from 'openfl/display/MovieClip';
import MouseEvent from 'openfl/events/MouseEvent';
import Rectangle from 'openfl/geom/Rectangle';
import { BASE } from './BASE';
import { BFOUNDATION } from './BFOUNDATION';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { POPUPS } from './POPUPS';

/**
 * BUILDING51 - Catapult Building
 * Extends BFOUNDATION for the monster flinging catapult
 */
export class BUILDING51 extends BFOUNDATION {
    constructor() {
        super();
        this._type = 51;
        this._footprint = [new Rectangle(0, 0, 90, 90)];
        this._gridCost = [[new Rectangle(0, 0, 90, 90), 10], [new Rectangle(10, 10, 70, 70), 200]];
        this.SetProps();
    }

    public override Tick(seconds: number): void {
        if (this._countdownBuild.Get() > 0 || this.health < this.maxHealth * 0.5) {
            this._canFunction = false;
        } else {
            this._canFunction = true;
        }
        super.Tick(seconds);
    }

    public Fund(): void {
        // Funding logic
    }

    public override Place(event: MouseEvent | null = null): void {
        super.Place(event);
    }

    public override Cancel(): void {
        GLOBAL._bCatapult = null;
        if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD) {
            GLOBAL._playerCatapultLevel.Set(0);
        }
        super.Cancel();
    }

    public override RecycleC(): void {
        GLOBAL._bCatapult = null;
        if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD) {
            GLOBAL._playerCatapultLevel.Set(0);
        }
        super.RecycleC();
    }

    public override Description(): void {
        super.Description();
        this._upgradeDescription = KEYS.Get("bdg_catapult_upgrade");
    }

    public override Update(force: boolean = false): void {
        super.Update(force);
    }

    public override Constructed(): void {
        super.Constructed();
        GLOBAL._bCatapult = this;
        if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard) {
            const Brag = (event: MouseEvent): void => {
                GLOBAL.CallJS("sendFeed", ["build-cat", KEYS.Get("pop_catapultbuilt_streamtitle"), KEYS.Get("pop_catapultbuilt_streambody"), "build-catapult.png"]);
                POPUPS.Next();
            };
            this.LoadEffects();
            const mc: MovieClip = new (GLOBAL as any).popup_building();
            (mc as any).tA.htmlText = "<b>" + KEYS.Get("pop_catapultbuilt_title") + "</b>";
            (mc as any).tB.htmlText = KEYS.Get("pop_catapultbuilt_body");
            (mc as any).bPost.SetupKey("btn_brag");
            (mc as any).bPost.addEventListener(MouseEvent.CLICK, Brag);
            (mc as any).bPost.Highlight = true;
            POPUPS.Push(mc, null, null, null, "build.v2.png");
            if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD) {
                GLOBAL._playerCatapultLevel.Set(this._lvl.Get());
            }
        }
    }

    public override Upgraded(): void {
        super.Upgraded();
        if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD) {
            const Brag = (event: MouseEvent): void => {
                GLOBAL.CallJS("sendFeed", ["upgrade-cat-" + this._lvl.Get(), KEYS.Get("pop_catapultupgraded" + this._lvl.Get() + "_streamtitle"), KEYS.Get("pop_catapultupgraded" + this._lvl.Get() + "_streambody"), "upgrade-catapult.png"]);
                POPUPS.Next();
            };
            const mc: MovieClip = new (GLOBAL as any).popup_building();
            (mc as any).tA.htmlText = "<b>" + KEYS.Get("pop_catapultupgraded_title") + "</b>";
            (mc as any).tB.htmlText = KEYS.Get("pop_catapultupgraded_body", { v1: this._lvl.Get() });
            (mc as any).bPost.SetupKey("btn_brag");
            (mc as any).bPost.addEventListener(MouseEvent.CLICK, Brag);
            (mc as any).bPost.Highlight = true;
            POPUPS.Push(mc, null, null, null, "build.v2.png");
            GLOBAL._playerCatapultLevel.Set(this._lvl.Get());
        }
    }

    public LoadEffects(): void {
        ImageCache.GetImageWithCallBack("effects/pebble.png", null, true, 6);
        ImageCache.GetImageWithCallBack("effects/pebblehit.png", null, true, 6);
        ImageCache.GetImageWithCallBack("effects/twigs.png", null, true, 6);
    }

    public override Setup(building: any): void {
        super.Setup(building);
        if (this._countdownBuild.Get() <= 0) {
            this.LoadEffects();
            if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD) {
                GLOBAL._playerCatapultLevel.Set(this._lvl.Get());
            }
            GLOBAL._bCatapult = this;
        }
    }
}
