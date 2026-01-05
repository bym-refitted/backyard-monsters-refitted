import Bitmap from 'openfl/display/Bitmap';
import BitmapData from 'openfl/display/BitmapData';
import MovieClip from 'openfl/display/MovieClip';
import Rectangle from 'openfl/geom/Rectangle';
import { BWALL } from './BWALL';
import { MAP } from './MAP';

/**
 * BUILDING18 - Heavy Block/Wall
 * Extends BWALL for heavy wall defense
 */
export class BUILDING18 extends BWALL {
    constructor() {
        super();
        this._type = 18;
        this._footprint = [new Rectangle(0, 0, 20, 20)];
        this._gridCost = [[new Rectangle(-10, -10, 40, 40), 20], [new Rectangle(0, 0, 20, 20), 200]];
        this._mcBase = MAP._BUILDINGBASES.addChild(new MovieClip()) as MovieClip;
        this.SetProps();
    }

    private onAssetLoaded(url: string, bitmapData: BitmapData): void {
        if (url === this.imageData.shadowURL) {
            const bitmap: Bitmap = this._mcBase!.addChild(new Bitmap(bitmapData)) as Bitmap;
            bitmap.x = this.imageData.shadowX;
            bitmap.y = this.imageData.shadowY;
            bitmap.blendMode = "multiply";
        } else if (url === this.imageData.topURL) {
            (this.topContainer as MovieClip).addChild(new Bitmap(bitmapData));
        }
    }
}
