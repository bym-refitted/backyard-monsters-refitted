import Bitmap from 'openfl/display/Bitmap';
import BitmapData from 'openfl/display/BitmapData';
import MovieClip from 'openfl/display/MovieClip';
import Event from 'openfl/events/Event';
import MouseEvent from 'openfl/events/MouseEvent';
import Rectangle from 'openfl/geom/Rectangle';
import { BFOUNDATION } from './BFOUNDATION';
import { ACADEMY } from './ACADEMY';
import { BASE } from './BASE';
import { CREATURELOCKER } from './CREATURELOCKER';
import { CREEPS } from './CREEPS';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { POPUPS } from './POPUPS';

/**
 * BUILDING26 - Monster Academy
 * Extends BFOUNDATION for monster upgrade/training building
 */
export class BUILDING26 extends BFOUNDATION {
    public _field: BitmapData | null = null;
    public _fieldBMP: Bitmap | null = null;
    public _frameNumber: number = 0;
    public _animBitmap: BitmapData | null = null;

    constructor() {
        super();
        this._type = 26;
        this._footprint = BASE.isInfernoMainYardOrOutpost ? [new Rectangle(0, 0, 80, 80)] : [new Rectangle(0, 0, 100, 100)];
        this._gridCost = [[new Rectangle(0, 0, 100, 100), 10], [new Rectangle(10, 10, 80, 80), 200]];
        this.SetProps();
    }

    public override Click(event: MouseEvent | null = null): void {
        if (this._upgrading && GLOBAL.player.m_upgrades[this._upgrading] && GLOBAL.player.m_upgrades[this._upgrading].time === null) {
            this._upgrading = null;
        }
        ACADEMY._monsterID = this._upgrading;
        super.Click(event);
    }

    public override TickFast(event: Event | null = null): void {
        super.TickFast(event);
        if (this._upgrading && GLOBAL._render && this._countdownBuild.Get() + this._countdownUpgrade.Get() === 0) {
            if (GLOBAL._render && this._animLoaded && this._countdownBuild.Get() + this._countdownUpgrade.Get() === 0) {
                if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD && (this._frameNumber % 3 === 0 || GLOBAL._lockerOverdrive > 0) && CREEPS._creepCount === 0) {
                    this.AnimFrame();
                } else if (this._frameNumber % 10 === 0 || (GLOBAL._lockerOverdrive > 0 && this._frameNumber % 4 === 0)) {
                    this.AnimFrame();
                }
            }
        }
        ++this._frameNumber;
    }

    public override Constructed(): void {
        super.Constructed();
        GLOBAL._bAcademy = this;
    }

    public override Description(): void {
        super.Description();
        if (this._upgrading !== null && GLOBAL.player.m_upgrades[this._upgrading].time) {
            this._specialDescription = KEYS.Get("building_academy_training", {
                v1: CREATURELOCKER._creatures[this._upgrading].name,
                v2: GLOBAL.ToTime(GLOBAL.player.m_upgrades[this._upgrading].time.Get() - GLOBAL.Timestamp())
            });
        }
    }

    public override Upgrade(): boolean {
        if (this._upgrading) {
            GLOBAL.Message(KEYS.Get("acad_err_cantupgrade"));
            return false;
        }
        return super.Upgrade();
    }

    public override Recycle(): void {
        if (this._upgrading) {
            GLOBAL.Message(KEYS.Get("acad_err_cantrecycle"));
        } else {
            GLOBAL._bAcademy = null;
            super.Recycle();
        }
    }

    public override Setup(building: any): void {
        super.Setup(building);
        if (building.upg) {
            this._upgrading = building.upg;
        }
        if (this._upgrading === "C100") {
            this._upgrading = "C12";
        }
        if (this._countdownBuild.Get() <= 0) {
            GLOBAL._bAcademy = this;
        }
    }

    public override Export(): any {
        const data: any = super.Export();
        if (this._upgrading) {
            data.upg = this._upgrading;
        }
        return data;
    }
}
