import { SecNum } from './com/cc/utils/SecNum';
import { IAttackable } from './com/monsters/interfaces/IAttackable';
import { Vacuum } from './com/monsters/siege/weapons/Vacuum';
import Bitmap from 'openfl/display/Bitmap';
import BitmapData from 'openfl/display/BitmapData';
import MovieClip from 'openfl/display/MovieClip';
import MouseEvent from 'openfl/events/MouseEvent';
import Point from 'openfl/geom/Point';
import Rectangle from 'openfl/geom/Rectangle';
import { BTOWER } from './BTOWER';
import { ATTACK } from './ATTACK';
import { BASE } from './BASE';
import { EFFECTS } from './EFFECTS';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { POPUPS } from './POPUPS';
import { SOUNDS } from './SOUNDS';

/**
 * BUILDING23 - Laser Tower
 * Extends BTOWER for laser defense tower
 */
export class BUILDING23 extends BTOWER {
    public static readonly TYPE: number = 23;
    public _animMC: MovieClip | null = null;
    public _animFrame: number = 0;
    public _field: BitmapData | null = null;
    public _fieldBMP: Bitmap | null = null;
    public _animBitmap: BitmapData | null = null;
    public _blend: number = 0;
    public _blending: boolean = false;
    public _bank: SecNum | null = null;

    constructor() {
        super();
        this._type = 23;
        this._frameNumber = 0;
        this._footprint = [new Rectangle(0, 0, 70, 70)];
        this._gridCost = [[new Rectangle(0, 0, 70, 70), 10], [new Rectangle(10, 10, 50, 50), 200]];
        this._spoutPoint = new Point(0, 0);
        this._spoutHeight = 30;
        this._top = -30;
        this.SetProps();
    }

    public override Fire(target: IAttackable): void {
        super.Fire(target);
        SOUNDS.Play("laser", !this.isJard ? 0.8 : 0.4);
        const healthRatio: number = 0.5 + 0.5 / this.maxHealth * this.health;
        let overdrive: number = 1;
        if (GLOBAL._towerOverdrive && GLOBAL._towerOverdrive.Get() >= GLOBAL.Timestamp()) {
            overdrive = 1.25;
        }
        if (this.isJard) {
            this._jarHealth!.Add(-Math.floor(this.damage * 25 * healthRatio * overdrive));
            ATTACK.Damage(this._mc!.x, this._mc!.y + this._top, this.damage * 25 * healthRatio * overdrive);
            if (this._jarHealth!.Get() <= 0) {
                this.KillJar();
            }
        } else if (this._targetVacuum) {
            EFFECTS.Laser(this.x, this.y + 35, GLOBAL.townHall.x, GLOBAL.townHall.y - GLOBAL.townHall._mc!.height * 2, 60, Math.floor(this.damage * 25 * healthRatio * overdrive), 0);
            ATTACK.Damage(this._mc!.x, this._mc!.y + this._top, this.damage * 25 * healthRatio * overdrive);
            Vacuum.getHose().modifyHealth(-Math.floor(this.damage * 25 * healthRatio * overdrive));
        } else {
            EFFECTS.Laser(this.x, this.y + 35, target.x, target.y, 60, Math.floor(this.damage * healthRatio * overdrive), this._splash, this.Track.bind(this));
        }
    }

    public Track(angle: number): void {
        if (angle < 0) {
            angle = 360 + angle;
        }
        angle /= 6.66;
        this._animTick = angle;
        this.AnimFrame();
    }

    public override AnimFrame(advance: boolean = true): void {
        if (this._animLoaded && !GLOBAL._catchup) {
            this._animRect!.x = this._animRect!.width * this._animTick;
            this._animContainerBMD!.copyPixels(this._animBMD!, this._animRect!, this._nullPoint!);
        }
        ++this._frameNumber;
    }

    public override Constructed(): void {
        super.Constructed();
    }
}
