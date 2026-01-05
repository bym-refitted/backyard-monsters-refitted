import Bitmap from 'openfl/display/Bitmap';
import BitmapData from 'openfl/display/BitmapData';
import BlendMode from 'openfl/display/BlendMode';
import MovieClip from 'openfl/display/MovieClip';
import Rectangle from 'openfl/geom/Rectangle';
import { BWALL } from './BWALL';
import { ACHIEVEMENTS } from './ACHIEVEMENTS';
import { GLOBAL } from './GLOBAL';
import { MAP } from './MAP';

/**
 * BUILDING17 - Blocks/Wall Block
 * Extends BWALL for wall defense building
 */
export class BUILDING17 extends BWALL {
    constructor() {
        super();
        this._type = 17;
        this._footprint = [new Rectangle(0, 0, 20, 20)];
        this._gridCost = [[new Rectangle(-10, -10, 40, 40), 20], [new Rectangle(0, 0, 20, 20), 200]];
        this._mcBase = MAP._BUILDINGBASES.addChild(new MovieClip()) as MovieClip;
        this.imageData = GLOBAL._buildingProps[this._type - 1].imageData;
        this.SetProps();
    }

    private onAssetLoaded(url: string, bitmapData: BitmapData): void {
        if (url === this.imageData.shadowURL) {
            const bitmap: Bitmap = this._mcBase!.addChild(new Bitmap(bitmapData)) as Bitmap;
            bitmap.x = this.imageData.shadowX;
            bitmap.y = this.imageData.shadowY;
            bitmap.blendMode = BlendMode.MULTIPLY;
        } else if (url === this.imageData.topURL) {
            (this.topContainer as MovieClip).addChild(new Bitmap(bitmapData));
        }
    }

    public override Constructed(): void {
        ++ACHIEVEMENTS._stats["blocksbuilt"];
        ACHIEVEMENTS.Check();
        super.Constructed();
    }
}
