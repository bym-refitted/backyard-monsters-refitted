import { IAttackable } from './com/monsters/interfaces/IAttackable';
import { MonsterBase } from './com/monsters/monsters/MonsterBase';
import { Vacuum } from './com/monsters/siege/weapons/Vacuum';
import Bitmap from 'openfl/display/Bitmap';
import BitmapData from 'openfl/display/BitmapData';
import Event from 'openfl/events/Event';
import Rectangle from 'openfl/geom/Rectangle';
import { BTOWER } from './BTOWER';
import { ATTACK } from './ATTACK';
import { BASE } from './BASE';
import { EFFECTS } from './EFFECTS';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { SOUNDS } from './SOUNDS';

/**
 * BUILDING25 - Tesla Tower (Lightning Tower)
 * Extends BTOWER for tesla/lightning defense tower
 */
export class BUILDING25 extends BTOWER {
    public static readonly TYPE: number = 25;
    
    public _field: BitmapData | null = null;
    public _fieldBMP: Bitmap | null = null;
    public _animBitmap: BitmapData | null = null;
    public _fireStage: number = 0;
    public _shotsFired: number = 0;
    public _laserTarget: IAttackable | null = null;

    constructor() {
        super();
        this._type = 25;
        this._frameNumber = 0;
        this._animTick = 0;
        this._top = -30;
        this._fireStage = 0;
        this._shotsFired = 0;
        this._footprint = [new Rectangle(0, 0, 70, 70)];
        this._gridCost = [[new Rectangle(0, 0, 70, 70), 10], [new Rectangle(10, 10, 50, 50), 200]];
        this.SetProps();
        this.Props();
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
            if (currentStats.rate < nextStats.rate) {
                this._upgradeDescription += KEYS.Get("building_sfpcincrease", { v1: currentStats.rate, v2: nextStats.rate }) + "<br>";
            }
        }
    }

    public override AnimFrame(advance: boolean = true): void {
        if (this._animLoaded && !GLOBAL._catchup) {
            this._animRect!.x = this._animRect!.width * this._animTick;
            this._animContainerBMD!.copyPixels(this._animBMD!, this._animRect!, this._nullPoint!);
        }
    }

    public override Fire(target: IAttackable): void {
        super.Fire(target);
        if (target instanceof MonsterBase) {
            this._laserTarget = target;
        } else {
            this._laserTarget = null;
        }
        if (this._fireStage === 0) {
            this._fireStage = 1;
            SOUNDS.Play("lightningstart", !this.isJard ? 0.8 : 0.4);
        }
    }

    public override TickFast(event: Event | null = null): void {
        super.TickFast(event);
        ++this._frameNumber;
        if (this._frameNumber === 40) {
            this._frameNumber = 4;
        }
        if (!GLOBAL._catchup) {
            if (this._fireStage === 1) {
                ++this._animTick;
                if (this._animTick === 32) {
                    this._fireStage = 2;
                    this._shotsFired = 0;
                }
            } else if (this._fireStage === 2) {
                if (this.health <= 0) {
                    this._fireStage = 3;
                } else {
                    ++this._animTick;
                    if (this._animTick === 41) {
                        this._animTick = 32;
                    }
                    if (this._frameNumber % 4 === 0) {
                        if (this._hasTargets || this._targetVacuum) {
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
                            } else if (this._laserTarget || this._targetVacuum) {
                                if (this._laserTarget) {
                                    if (this._laserTarget instanceof MonsterBase && (this._laserTarget as MonsterBase)._movement === "fly") {
                                        EFFECTS.Lightning(this._mc!.x, this._mc!.y - 50, this._laserTarget.x, this._laserTarget.y - (this._laserTarget as MonsterBase)._altitude);
                                    } else {
                                        EFFECTS.Lightning(this._mc!.x, this._mc!.y - 50, this._laserTarget.x, this._laserTarget.y);
                                    }
                                    this._laserTarget.modifyHealth(-Math.floor(this.damage * healthRatio * overdrive));
                                    ATTACK.Damage(this._mc!.x, this._mc!.y - 50, Math.floor(this.damage * healthRatio * overdrive));
                                } else if (this._targetVacuum && this.canShootVacuumHose()) {
                                    EFFECTS.Lightning(this._mc!.x, this._mc!.y - 50, GLOBAL.townHall._mc!.x, GLOBAL.townHall._mc!.y - GLOBAL.townHall._mc!.height);
                                    Vacuum.getHose().modifyHealth(-Math.floor(this.damage * healthRatio * overdrive));
                                    ATTACK.Damage(this._mc!.x, this._mc!.y - 50, Math.floor(this.damage * healthRatio * overdrive));
                                }
                            }
                        }
                        SOUNDS.Play("lightningfire", !this.isJard ? 0.8 : 0.4);
                        ++this._shotsFired;
                        if (this._shotsFired >= this._rate) {
                            this._fireStage = 3;
                            SOUNDS.Play("lightningend", !this.isJard ? 0.8 : 0.4);
                        } else if (this._targetVacuum) {
                            if (this.canShootVacuumHose()) {
                                this._targetVacuum = true;
                            } else {
                                this._hasTargets = false;
                                this.FindTargets(1, this._priority);
                                if (!this._hasTargets) {
                                    this._fireStage = 3;
                                }
                                SOUNDS.Play("lightningend", !this.isJard ? 0.8 : 0.4);
                            }
                        } else if (this._laserTarget && (this._laserTarget.health <= 0 || 
                                   (this._laserTarget instanceof MonsterBase && !(this._laserTarget as MonsterBase).isTargetable))) {
                            if (this.canShootVacuumHose()) {
                                this._targetVacuum = true;
                            } else {
                                this._hasTargets = false;
                                this.FindTargets(1, this._priority);
                                if (!this._hasTargets) {
                                    this._fireStage = 3;
                                }
                                SOUNDS.Play("lightningend", !this.isJard ? 0.8 : 0.4);
                            }
                        }
                    }
                }
            } else if (this._fireStage === 3) {
                if (this._frameNumber % 2 === 0) {
                    ++this._animTick;
                    if (this._animTick === 55) {
                        this._animTick = 0;
                        this._fireStage = 0;
                    }
                }
            }
            if (GLOBAL._render && this._animTick > 0) {
                this.AnimFrame();
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
