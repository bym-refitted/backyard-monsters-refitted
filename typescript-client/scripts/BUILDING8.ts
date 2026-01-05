import Bitmap from 'openfl/display/Bitmap';
import BitmapData from 'openfl/display/BitmapData';
import MovieClip from 'openfl/display/MovieClip';
import Event from 'openfl/events/Event';
import MouseEvent from 'openfl/events/MouseEvent';
import Rectangle from 'openfl/geom/Rectangle';
import { BFOUNDATION } from './BFOUNDATION';
import { BASE } from './BASE';
import { CREATURELOCKER } from './CREATURELOCKER';
import { CREEPS } from './CREEPS';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { POPUPS } from './POPUPS';

/**
 * BUILDING8 - Monster Locker
 * Extends BFOUNDATION for creature unlocking building
 */
export class BUILDING8 extends BFOUNDATION {
    public _animMC: MovieClip | null = null;
    public _field: BitmapData | null = null;
    public _fieldBMP: Bitmap | null = null;
    public _frameNumber: number = 0;
    public _animBitmap: BitmapData | null = null;

    constructor() {
        super();
        this._frameNumber = Math.floor(Math.random() * 5);
        this._type = 8;
        this._footprint = [new Rectangle(0, 0, 100, 100)];
        this._gridCost = [[new Rectangle(0, 0, 100, 100), 10], [new Rectangle(10, 10, 80, 80), 200]];
        this.SetProps();
    }

    public override TickFast(event: Event | null = null): void {
        super.TickFast(event);
        if (GLOBAL._render && this._countdownBuild.Get() + this._countdownUpgrade.Get() === 0 && CREATURELOCKER._unlocking !== null) {
            if ((GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode === "help" || GLOBAL.mode === "view") && 
                this._frameNumber % 3 === 0 && CREEPS._creepCount === 0) {
                this.AnimFrame();
            } else if (this._frameNumber % 10 === 0) {
                this.AnimFrame();
            }
        }
        ++this._frameNumber;
    }

    public override Description(): void {
        super.Description();
        if (GLOBAL._lockerOverdrive > 0) {
            this._buildingTitle += ` <font color="#CC0000">${KEYS.Get("cloc_overdrive", { v1: GLOBAL.ToTime(GLOBAL._lockerOverdrive) })}</font>`;
        }
        if (CREATURELOCKER._unlocking !== null && CREATURELOCKER._lockerData[CREATURELOCKER._unlocking]) {
            this._specialDescription = `Unlocking the ${CREATURELOCKER._creatures[CREATURELOCKER._unlocking].name} ${GLOBAL.ToTime(CREATURELOCKER._lockerData[CREATURELOCKER._unlocking].e - GLOBAL.Timestamp())} remaining<br>`;
        }
    }

    public override Constructed(): void {
        super.Constructed();
        GLOBAL._bLocker = this;
    }

    public override Upgraded(): void {
        super.Upgraded();
    }

    public override Cancel(): void {
        GLOBAL._bLocker = null;
        super.Cancel();
    }

    public override Upgrade(): boolean {
        if (CREATURELOCKER._unlocking !== null) {
            GLOBAL.Message(KEYS.Get("cloc_err_cantupgrade", { v1: KEYS.Get(CREATURELOCKER._creatures[CREATURELOCKER._unlocking].name) }));
            return false;
        }
        return super.Upgrade();
    }

    public override Recycle(): void {
        if (CREATURELOCKER._unlocking !== null) {
            GLOBAL.Message(KEYS.Get("cloc_err_cantrecycle", { v1: CREATURELOCKER._creatures[CREATURELOCKER._unlocking].name }), KEYS.Get("msg_recyclebuilding_btn"), this.RecycleB);
        } else {
            super.Recycle();
        }
    }

    public override RecycleB(event: MouseEvent | null = null): void {
        if (CREATURELOCKER._unlocking !== null) {
            CREATURELOCKER.Cancel();
        }
        super.RecycleB(event);
    }

    public override RecycleC(): void {
        GLOBAL._bLocker = null;
        super.RecycleC();
    }

    public override Setup(building: any): void {
        super.Setup(building);
        if (this._countdownBuild.Get() === 0) {
            GLOBAL._bLocker = this;
        }
    }
}
