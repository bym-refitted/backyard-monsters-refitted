import Bitmap from 'openfl/display/Bitmap';
import BitmapData from 'openfl/display/BitmapData';
import MovieClip from 'openfl/display/MovieClip';
import Event from 'openfl/events/Event';
import MouseEvent from 'openfl/events/MouseEvent';
import Point from 'openfl/geom/Point';
import Rectangle from 'openfl/geom/Rectangle';
import { BSTORAGE } from './BSTORAGE';
import { BASE } from './BASE';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { POPUPS } from './POPUPS';

/**
 * BUILDING6 - Resource Silo (Storage Building)
 * Extends BSTORAGE for resource storage
 */
export class BUILDING6 extends BSTORAGE {
    public _field: BitmapData | null = null;
    public _fieldBMP: Bitmap | null = null;
    public _frameNumber: number = 0;
    public _animTickTarget: number = 0;
    public _animBitmap: BitmapData | null = null;

    constructor() {
        super();
        this._frameNumber = 0;
        this._type = 6;
        this._footprint = [new Rectangle(0, 0, 80, 80)];
        this._gridCost = [[new Rectangle(0, 0, 80, 80), 10], [new Rectangle(10, 10, 60, 60), 200]];
        this._spoutPoint = new Point(0, -48);
        this._spoutHeight = 82;
        this.SetProps();
    }

    public override Update(force: boolean = false): void {
        if (GLOBAL._render || force) {
            let totalMax: number = 0;
            let totalCurrent: number = 0;
            for (let i = 1; i < 5; i++) {
                totalMax += BASE._resources["r" + i + "max"];
                totalCurrent += BASE._resources["r" + i].Get();
            }
            this._animTickTarget = Math.floor(26 / totalMax * totalCurrent);
        }
        super.Update(force);
    }

    public override TickFast(event: Event | null = null): void {
        super.TickFast(event);
        if (this._animLoaded && this._countdownBuild.Get() === 0 && this._frameNumber % 3 === 0) {
            if (this._animTick !== this._animTickTarget) {
                this._animTick = this._animTickTarget;
                this.AnimFrame();
            }
        }
        ++this._frameNumber;
    }

    public override AnimFrame(advance: boolean = true): void {
        if (this._animContainerBMD) {
            this._animContainerBMD.copyPixels(this._animBMD!, new Rectangle(74 * this._animTick, 0, 74, 121), new Point(0, 0));
        }
    }

    public override Upgraded(): void {
        super.Upgraded();
    }

    public override Constructed(): void {
        super.Constructed();
    }

    public override Click(event: MouseEvent | null = null): void {
        super.Click(event);
    }

    public override Description(): void {
        super.Description();
        this._specialDescription = KEYS.Get("building_silo_upgrade_desc1", { v1: GLOBAL.FormatNumber(this._buildingProps.capacity[this._lvl.Get() - 1]) });
        this._buildingDescription = this._specialDescription;
        if (this._upgradeCosts !== "") {
            this._upgradeDescription = KEYS.Get("building_silo_upgrade_desc2", { 
                v1: GLOBAL.FormatNumber(this._buildingProps.capacity[this._lvl.Get()] - this._buildingProps.capacity[this._lvl.Get() - 1]) 
            });
        }
    }
}
