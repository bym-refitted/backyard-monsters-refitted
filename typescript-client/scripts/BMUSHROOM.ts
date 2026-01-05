import DisplayObject from 'openfl/display/DisplayObject';
import BlendMode from 'openfl/display/BlendMode';
import MouseEvent from 'openfl/events/MouseEvent';
import Point from 'openfl/geom/Point';
import { BYMConfig } from './com/monsters/configs/BYMConfig';
import { RasterData } from './com/monsters/rendering/RasterData';
import { BFOUNDATION } from './BFOUNDATION';
import { BASE } from './BASE';
import { GLOBAL } from './GLOBAL';
import { MAP } from './MAP';
import { MUSHROOMS } from './MUSHROOMS';
import { TUTORIAL } from './TUTORIAL';

/**
 * BMUSHROOM - Mushroom resource building class
 * Extends BFOUNDATION for mushroom pickable resources
 */
export class BMUSHROOM extends BFOUNDATION {
    public _mushroom: DisplayObject | null = null;
    public _mushroomFrame: number = 0;

    constructor() {
        super();
    }

    public override SetProps(): void {
        super.SetProps();
    }

    public override PlaceB(): void {
        super.PlaceB();
        // Note: doodad_mushroom_mc and doodad_mushroom_shadow are Flash MovieClips
        // that need to be created/imported separately
        const mushroomMc: any = {}; // new doodad_mushroom_mc();
        
        if (!BYMConfig.instance.RENDERER_ON) {
            this._mc?.addChild(mushroomMc);
        } else {
            this._rasterData[BFOUNDATION._RASTERDATA_TOP] = this._rasterData[BFOUNDATION._RASTERDATA_TOP] || 
                new RasterData(mushroomMc, this._rasterPt[BFOUNDATION._RASTERDATA_TOP], Number.MAX_VALUE);
        }
        
        if (mushroomMc.mc) {
            mushroomMc.mc.gotoAndStop(this._mushroomFrame);
        }
        mushroomMc.mouseEnabled = false;
        mushroomMc.mouseChildren = false;
        
        const shadowMc: any = {}; // new doodad_mushroom_shadow();
        
        if (!BYMConfig.instance.RENDERER_ON) {
            this._mcBase?.addChild(shadowMc);
        } else {
            this._rasterData[BFOUNDATION._RASTERDATA_SHADOW] = this._rasterData[BFOUNDATION._RASTERDATA_SHADOW] || 
                new RasterData(shadowMc, this._rasterPt[BFOUNDATION._RASTERDATA_SHADOW], MAP.DEPTH_SHADOW, BlendMode.MULTIPLY, true);
        }
        
        shadowMc.gotoAndStop?.(this._mushroomFrame);
        shadowMc.mouseEnabled = false;
        shadowMc.mouseChildren = false;
        shadowMc.blendMode = BlendMode.MULTIPLY;
        
        this._origin = new Point(this.x, this.y);
        this.updateRasterData();
    }

    public override Setup(building: any): void {
        this._mushroomFrame = building.frame;
        super.Setup(building);
        this.setHealth(this.maxHealth);
    }

    public override Export(): any {
        const data: any = super.Export();
        data.frame = this._mushroomFrame;
        return data;
    }

    public override Description(): void {
        // Empty override
    }

    public override HasWorker(): void {
        if (this._shake > 60 && BASE._pendingPurchase.length === 0) {
            this._mc!.x = this._origin!.x;
            this._mc!.y = this._origin!.y;
            this._mcBase!.x = this._origin!.x;
            this._mcBase!.y = this._origin!.y;
            MUSHROOMS.Pick(this);
            return;
        }
        if (this._shake % 2 === 0) {
            this._mc!.x = this._origin!.x - 2 + Math.random() * 4;
            this._mc!.y = this._origin!.y - 2 + Math.random() * 4;
            this._mcBase!.x = this._origin!.x - 1 + Math.random() * 2;
            this._mcBase!.y = this._origin!.y - 1 + Math.random() * 2;
        }
        ++this._shake;
        this.updateRasterData();
    }

    public override Click(event: MouseEvent | null = null): void {
        if (TUTORIAL._stage >= 200 && !this._picking) {
            super.Click(event);
        }
    }

    public override Render(state: string = ""): void {
        if (GLOBAL._catchup || (state === this._renderState && this._lvl.Get() === this._renderLevel)) {
            return;
        }
        this.updateRasterData();
        this._renderState = BFOUNDATION.k_STATE_DEFAULT;
        this._renderLevel = this._lvl.Get();
    }

    public SoundGood(): void {
        // Empty method
    }

    public SoundBad(): void {
        // Empty method
    }
}
