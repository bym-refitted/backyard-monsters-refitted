import Bitmap from 'openfl/display/Bitmap';
import BitmapData from 'openfl/display/BitmapData';
import Event from 'openfl/events/Event';
import MouseEvent from 'openfl/events/MouseEvent';
import Point from 'openfl/geom/Point';
import Rectangle from 'openfl/geom/Rectangle';
import { BEXPIRABLE } from './BEXPIRABLE';
import { CREEPS } from './CREEPS';
import { GLOBAL } from './GLOBAL';
import { SIGNS } from './SIGNS';

/**
 * BUILDING52 - Expirable Animated Building
 * Extends BEXPIRABLE for expirable animated decoration
 */
export class BUILDING52 extends BEXPIRABLE {
    public _field: BitmapData | null = null;
    public _fieldBMP: Bitmap | null = null;
    public _frameNumber: number = 0;
    public _animBitmap: BitmapData | null = null;

    constructor() {
        super();
        this._type = 52;
        this._footprint = [new Rectangle(0, 0, 40, 40)];
        this._gridCost = [[new Rectangle(0, 0, 40, 40), 20]];
        this.imageData = GLOBAL._buildingProps[this._type - 1].imageData;
        this.SetProps();
    }

    public override Place(event: MouseEvent | null = null): void {
        super.Place(event);
        if (this._placing === false) {
            SIGNS.CreateForBuilding(this);
        }
    }

    public override TickFast(event: Event | null = null): void {
        super.TickFast(event);
        if (GLOBAL._render && this._frameNumber % 2 === 0 && CREEPS._creepCount === 0) {
            this.AnimFrame();
        }
        ++this._frameNumber;
    }

    public override AnimFrame(advance: boolean = true): void {
        if (this._animContainerBMD && this._animBMD) {
            this._animContainerBMD.copyPixels(this._animBMD, new Rectangle(24 * this._animTick, 0, 24, 30), new Point(0, 0));
        }
        ++this._animTick;
        if (this._animTick === 22) {
            this._animTick = 0;
        }
    }
}
