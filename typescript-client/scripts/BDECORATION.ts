import Bitmap from 'openfl/display/Bitmap';
import BitmapData from 'openfl/display/BitmapData';
import MovieClip from 'openfl/display/MovieClip';
import Event from 'openfl/events/Event';
import MouseEvent from 'openfl/events/MouseEvent';
import Rectangle from 'openfl/geom/Rectangle';
import { BFOUNDATION } from './BFOUNDATION';
import { GLOBAL } from './GLOBAL';

/**
 * BDECORATION - Decoration building class
 * Extends BFOUNDATION for decorative game objects
 */
export class BDECORATION extends BFOUNDATION {
    public _animMC: MovieClip | null = null;
    public _field: BitmapData | null = null;
    public _fieldBMP: Bitmap | null = null;
    public _frameNumber: number = 0;
    public _animBitmap: BitmapData | null = null;

    constructor(buildingType: number) {
        const size: number = GLOBAL._buildingProps[buildingType - 1].size;
        super();
        this._type = buildingType;
        this._footprint = [new Rectangle(0, 0, size, size)];
        this._gridCost = [[new Rectangle(0, 0, size, size), 2]];
        this.SetProps();
    }

    public override Place(event: MouseEvent | null = null): void {
        super.Place(event);
    }

    public override TickFast(event: Event | null = null): void {
        super.TickFast(event);
        if (GLOBAL._render && this._frameNumber % 2 === 0) {
            this.AnimFrame();
        }
        ++this._frameNumber;
    }
}
