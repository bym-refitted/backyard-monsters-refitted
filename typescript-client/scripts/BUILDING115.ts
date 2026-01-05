import { IAttackable } from './com/monsters/interfaces/IAttackable';
import { MonsterBase } from './com/monsters/monsters/MonsterBase';
import { PATHING } from './com/monsters/pathing/PATHING';
import { Vacuum } from './com/monsters/siege/weapons/Vacuum';
import BitmapData from 'openfl/display/BitmapData';
import MovieClip from 'openfl/display/MovieClip';
import MouseEvent from 'openfl/events/MouseEvent';
import Point from 'openfl/geom/Point';
import Rectangle from 'openfl/geom/Rectangle';
import { BTOWER } from './BTOWER';
import { ATTACK } from './ATTACK';
import { BASE } from './BASE';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { POPUPS } from './POPUPS';
import { PROJECTILES } from './PROJECTILES';
import { SOUNDS } from './SOUNDS';
import { Targeting } from './Targeting';

/**
 * BUILDING115 - Aerial Defense Tower (AA Tower)
 * Extends BTOWER for anti-air defense tower
 */
export class BUILDING115 extends BTOWER {
    public _animMC: MovieClip | null = null;
    public _animBitmap: BitmapData | null = null;
    public _shotsFired: number = 0;
    public _lostCreep: boolean = false;
    public _fireStage: number = 1;
    public _targetArray: number[] = [4, 4, 6, 8, 10, 12, 14, 16];

    constructor() {
        super();
        this._frameNumber = 0;
        this._type = 115;
        this._top = -5;
        this._footprint = [new Rectangle(0, 0, 70, 70)];
        this._gridCost = [[new Rectangle(0, 0, 70, 70), 10], [new Rectangle(10, 10, 50, 50), 200]];
        this._fireStage = 1;
        this.SetProps();
        this.Props();
        this.attackFlags = Targeting.getOldStyleTargets(2);
    }

    public override TickAttack(): void {
        const targetCount: number = this._targetArray[this._lvl.Get() - 1];
        ++this._frameNumber;
        if (this.health > 0 && this._countdownBuild.Get() + this._countdownUpgrade.Get() + this._countdownFortify.Get() === 0) {
            if (this._fireStage === 1) {
                --this._fireTick;
                if (this._fireTick <= 0) {
                    this._fireStage = 2;
                    this._shotsFired = 0;
                    this._fireTick += this._rate * 2;
                }
            }
            if (this._fireStage === 2) {
                if (this.canShootVacuumHose()) {
                    this._targetVacuum = true;
                    this._fireTick = 30;
                } else if (!this._hasTargets || !this.targetInRange()) {
                    this._targetVacuum = false;
                    this.FindTargets(targetCount, this._priority);
                    this._fireTick = 30;
                }
                if (this._targetVacuum || this._hasTargets) {
                    if (this._shotsFired >= targetCount) {
                        this._fireStage = 1;
                    } else if (this._frameNumber % 4 === 0) {
                        let needRetarget = false;
                        let targetIdx = 0;
                        if (this._targetCreeps && this._targetCreeps.length > 0) {
                            targetIdx = this._shotsFired % this._targetCreeps.length;
                        }
                        if (this._targetVacuum) {
                            this.Fire(Vacuum.getHose());
                            ++this._shotsFired;
                        } else if (this._targetCreeps[targetIdx].creep.health > 0) {
                            this.Fire(this._targetCreeps[targetIdx].creep);
                            ++this._shotsFired;
                        } else {
                            needRetarget = true;
                        }
                        if (this._retarget || needRetarget) {
                            this.FindTargets(targetCount, this._priority);
                        }
                    }
                }
            }
        }
        if (this._hasTargets) {
            const targetCreep: MonsterBase = this._targetCreeps[0].creep;
            const targetPos: Point = PATHING.FromISO(targetCreep._tmpPoint);
            let myPos: Point = PATHING.FromISO(new Point(this._mc!.x, this._mc!.y));
            myPos = myPos.add(new Point(35, 35));
            const dx: number = targetPos.x - myPos.x;
            const dy: number = targetPos.y - myPos.y;
            let angle: number = Math.atan2(dy, dx) * 57.2957795;
            if (angle < 0) {
                angle = 360 + angle;
            }
            angle /= 12;
            this._animTick = Math.floor(angle);
            this.AnimFrame();
        }
    }

    public override AnimFrame(advance: boolean = true): void {
        if (this._animLoaded && GLOBAL._render) {
            this._animRect!.x = this._animRect!.width * this._animTick;
            this._animContainerBMD!.copyPixels(this._animBMD!, this._animRect!, this._nullPoint!);
        }
    }

    public override Fire(target: IAttackable): void {
        super.Fire(target);
        SOUNDS.Play("snipe1", !this.isJard ? 0.8 : 0.4);
        const healthRatio: number = 0.5 + 0.5 / this.maxHealth * this.health;
        let overdrive: number = 1;
        if (GLOBAL._towerOverdrive && GLOBAL._towerOverdrive.Get() >= GLOBAL.Timestamp()) {
            overdrive = 1.25;
        }
        if (this.isJard) {
            this._jarHealth!.Add(-Math.floor(this.damage * healthRatio * overdrive));
            ATTACK.Damage(this._mc!.x, this._mc!.y + this._top, this.damage * healthRatio * overdrive);
            if (this._jarHealth!.Get() <= 0) {
                this.KillJar();
            }
        } else {
            PROJECTILES.Spawn(new Point(this._mc!.x, this._mc!.y + this._top), null, target, this._speed, Math.floor(this.damage * healthRatio * overdrive), false, this._splash, this.attackFlags);
        }
    }

    public override Description(): void {
        super.Description();
        this._upgradeDescription = "";
        if (this._lvl.Get() > 0 && this._lvl.Get() < this._buildingProps.costs.length) {
            const currentStats: any = this._buildingProps.stats[this._lvl.Get() - 1];
            const nextStats: any = this._buildingProps.stats[this._lvl.Get()];
            let currentRange: number = currentStats.range;
            let nextRange: number = nextStats.range;
            if (BASE.isOutpost) {
                currentRange = BTOWER.AdjustTowerRange(GLOBAL._currentCell, currentRange);
                nextRange = BTOWER.AdjustTowerRange(GLOBAL._currentCell, nextRange);
            }
            if (currentStats.range < nextStats.range) {
                this._upgradeDescription += KEYS.Get("building_rangeincrease", { v1: currentRange, v2: nextRange }) + "<br>";
            }
            if (currentStats.damage < nextStats.damage) {
                this._upgradeDescription += KEYS.Get("building_dpsincrease", { v1: currentStats.damage, v2: nextStats.damage }) + "<br>";
            }
            if (this._lvl.Get() > 1) {
                this._upgradeDescription += KEYS.Get("building_sfpsincrease", { v1: this._targetArray[this._lvl.Get() - 1], v2: this._targetArray[this._lvl.Get()] }) + "<br>";
            }
        }
    }

    public override Props(): void {
        super.Props();
    }

    public override Upgraded(): void {
        super.Upgraded();
    }

    public override Constructed(): void {
        super.Constructed();
    }
}
