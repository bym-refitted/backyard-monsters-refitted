import Bitmap from 'openfl/display/Bitmap';
import BitmapData from 'openfl/display/BitmapData';
import MovieClip from 'openfl/display/MovieClip';
import MouseEvent from 'openfl/events/MouseEvent';
import Point from 'openfl/geom/Point';
import Rectangle from 'openfl/geom/Rectangle';
import { BFOUNDATION } from './BFOUNDATION';
import { BASE } from './BASE';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { POPUPS } from './POPUPS';

/**
 * BUILDING10 - Yard Planner
 * Extends BFOUNDATION for base layout planning building
 */
export class BUILDING10 extends BFOUNDATION {
    constructor() {
        super();
        this._type = 10;
        this._footprint = [new Rectangle(0, 0, 100, 100)];
        this._gridCost = [[new Rectangle(0, 0, 100, 100), 10], [new Rectangle(10, 10, 80, 80), 200]];
        this._spoutPoint = new Point(0, -28);
        this._spoutHeight = 80;
        this.SetProps();
    }

    private onAssetLoaded(url: string, bitmapData: BitmapData): void {
        if (url === this.imageData.shadowURL) {
            const bitmap: Bitmap = this._mcBase!.addChild(new Bitmap(bitmapData)) as Bitmap;
            bitmap.x = this.imageData.shadowX;
            bitmap.y = this.imageData.shadowY;
            bitmap.blendMode = "multiply";
        } else if (url === this.imageData.topURL) {
            (this.animContainer as MovieClip).addChild(new Bitmap(bitmapData));
        }
    }

    public override PlaceB(): void {
        super.PlaceB();
    }

    public override Description(): void {
        super.Description();
    }

    public override Constructed(): void {
        super.Constructed();
        GLOBAL._bYardPlanner = this;
    }

    public override RecycleC(): void {
        GLOBAL._bYardPlanner = null;
        super.RecycleC();
    }

    public override Upgraded(): void {
        super.Upgraded();
    }

    public override Setup(building: any): void {
        super.Setup(building);
        if (this._countdownBuild.Get() === 0) {
            GLOBAL._bYardPlanner = this;
        }
    }
}
