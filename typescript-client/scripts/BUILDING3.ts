import Bitmap from 'openfl/display/Bitmap';
import BitmapData from 'openfl/display/BitmapData';
import Event from 'openfl/events/Event';
import Point from 'openfl/geom/Point';
import Rectangle from 'openfl/geom/Rectangle';
import { BRESOURCE } from './BRESOURCE';
import { CREEPS } from './CREEPS';
import { GLOBAL } from './GLOBAL';

/**
 * BUILDING3 - Putty Squisher (Resource Gatherer for Putty)
 * Extends BRESOURCE for putty resource production
 */
export class BUILDING3 extends BRESOURCE {
    public _field: BitmapData | null = null;
    public _fieldBMP: Bitmap | null = null;
    public _frameNumber: number = 0;
    public _animBitmap: BitmapData | null = null;

    constructor() {
        super();
        this._frameNumber = Math.floor(Math.random() * 5);
        this._type = 3;
        this._footprint = [new Rectangle(0, 0, 70, 70)];
        this._gridCost = [[new Rectangle(0, 0, 70, 70), 10], [new Rectangle(10, 10, 50, 50), 200]];
        this._spoutPoint = new Point(28, -17);
        this._spoutHeight = 50;
        this.SetProps();
    }

    public override TickFast(event: Event | null = null): void {
        super.TickFast(event);
        if (GLOBAL._render && this._animLoaded && 
            this._countdownBuild.Get() + this._countdownUpgrade.Get() + this._countdownFortify.Get() === 0 && 
            this._producing && this._canFunction) {
            if ((GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode === "help" || GLOBAL.mode === "view") && 
                this._frameNumber % 3 === 0 && CREEPS._creepCount === 0) {
                this.AnimFrame();
            } else if (this._frameNumber % 10 === 0) {
                this.AnimFrame();
            }
        }
        ++this._frameNumber;
    }

    public override Upgraded(): void {
        super.Upgraded();
    }

    public override Constructed(): void {
        super.Constructed();
    }
}
