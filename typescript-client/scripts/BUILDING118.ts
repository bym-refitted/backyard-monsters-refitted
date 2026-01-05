import { IAttackable } from './com/monsters/interfaces/IAttackable';
import { MonsterBase } from './com/monsters/monsters/MonsterBase';
import { PATHING } from './com/monsters/pathing/PATHING';
import { Vacuum } from './com/monsters/siege/weapons/Vacuum';
import BitmapData from 'openfl/display/BitmapData';
import MovieClip from 'openfl/display/MovieClip';
import Shape from 'openfl/display/Shape';
import Event from 'openfl/events/Event';
import MouseEvent from 'openfl/events/MouseEvent';
import GlowFilter from 'openfl/filters/GlowFilter';
import Point from 'openfl/geom/Point';
import Rectangle from 'openfl/geom/Rectangle';
import { BTOWER } from './BTOWER';
import { ATTACK } from './ATTACK';
import { BASE } from './BASE';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { MAP } from './MAP';
import { POPUPS } from './POPUPS';
import { SOUNDS } from './SOUNDS';
import { Targeting } from './Targeting';

/**
 * BUILDING118 - Railgun Tower (Inferno)
 * Extends BTOWER for railgun defense tower with piercing projectiles
 */
export class BUILDING118 extends BTOWER {
    public _animMC: MovieClip | null = null;
    public _animBitmap: BitmapData | null = null;
    private _gunballs: any[] = [];
    private _trail: any[] = [];
    private _spawnCount: number = 0;
    private _segment: Point | null = null;
    private _spot: Point | null = null;
    private _fireCount: number = 0;

    constructor() {
        super();
        this._frameNumber = 0;
        this._type = 118;
        this._top = 15;
        this._footprint = [new Rectangle(0, 0, 70, 70)];
        this._gridCost = [[new Rectangle(0, 0, 70, 70), 10], [new Rectangle(10, 10, 50, 50), 200]];
        this.SetProps();
        this.Props();
        this.attackFlags = Targeting.getOldStyleTargets(-1);
    }

    public override TickAttack(): void {
        super.TickAttack();
        if (this._hasTargets) {
            const targetCreep: MonsterBase = this._targetCreeps[0].creep;
            const targetPos: Point = PATHING.FromISO(targetCreep._tmpPoint);
            let myPos: Point = PATHING.FromISO(new Point(this._mc!.x, this._mc!.y));
            myPos = myPos.add(new Point(35, 35));
            const dx: number = targetPos.x - myPos.x;
            const dy: number = targetPos.y - myPos.y;
            let angle: number = Math.atan2(dy, dx) * 57.2957795 + 30;
            if (angle < 0) {
                angle = 360 + angle;
            }
            if (angle > 360) {
                angle -= 360;
            }
            angle /= 12;
            this._animTick = Math.floor(angle);
            this.AnimFrame();
            ++this._frameNumber;
        }
    }

    public override TickFast(event: Event | null = null): void {
        super.TickFast();
        if (this._gunballs.length > 0) {
            ++this._fireCount;
            if (this._fireCount > 10) {
                const count = this._gunballs.length;
                for (let i = 0; i < count; i++) {
                    if (this._fireCount > 15) {
                        if (this._gunballs[0] && this._gunballs[0].parent) {
                            MAP._PROJECTILES.removeChild(this._gunballs[0]);
                        }
                        if (this._trail[0] && this._trail[0].parent) {
                            MAP._PROJECTILES.removeChild(this._trail[0]);
                        }
                    } else {
                        const alpha = 1 - (this._fireCount - 10) * 0.2;
                        if (this._gunballs[0] && this._gunballs[0].parent) {
                            this._gunballs[i].alpha = alpha;
                        }
                        if (this._trail[0] && this._trail[0].parent) {
                            this._trail[i].alpha = alpha;
                        }
                    }
                }
            }
        }
        if (this._fireCount > 15) {
            this._gunballs = [];
            this._trail = [];
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
        SOUNDS.Play("railgun1", !this.isJard ? 0.8 : 0.4);
        const healthRatio: number = 0.5 + 0.5 / this.maxHealth * this.health;
        let overdrive: number = 1;
        if (GLOBAL._towerOverdrive && GLOBAL._towerOverdrive.Get() >= GLOBAL.Timestamp()) {
            overdrive = 1.25;
        }
        if (this.isJard) {
            this._jarHealth!.Add(-Math.floor(this.damage * 3 * healthRatio * overdrive));
            ATTACK.Damage(this._mc!.x, this._mc!.y + this._top, this.damage * 3 * healthRatio * overdrive);
            if (this._jarHealth!.Get() <= 0) {
                this.KillJar();
            }
        } else {
            const startPos: Point = new Point(this._mc!.x, this._mc!.y + this._top);
            this._spot = new Point(startPos.x, startPos.y);
            let dy: number, dx: number;
            if (this._targetVacuum) {
                dx = GLOBAL.townHall._mc!.x - startPos.x;
                dy = GLOBAL.townHall._mc!.y - GLOBAL.townHall._mc!.height - startPos.y;
                Vacuum.getHose().modifyHealth(-Math.floor(this.damage * 3 * healthRatio * overdrive));
            } else {
                dy = target.y - startPos.y;
                dx = target.x - startPos.x;
            }
            this._segment = new Point(Math.cos(Math.atan2(dy, dx)) * 32, Math.sin(Math.atan2(dy, dx)) * 32);
            
            // Clear existing projectiles
            while (this._gunballs.length > 0) {
                if (this._gunballs[0] && this._gunballs[0].parent) {
                    MAP._PROJECTILES.removeChild(this._gunballs[0]);
                }
                if (this._trail[0] && this._trail[0].parent) {
                    MAP._PROJECTILES.removeChild(this._trail[0]);
                }
                this._gunballs.shift();
                this._trail.shift();
            }
            this._spawnCount = 0;
            this._fireCount = 0;
            
            // Create railgun projectile visuals
            for (let i = 0; i < 50; i++) {
                this._gunballs[i] = new (GLOBAL as any).RAILGUNPROJECTILE_CLIP();
                this._gunballs[i].x = this._spot.x + this._segment.x;
                this._gunballs[i].y = this._spot.y + this._segment.y;
                this._trail[i] = new Shape();
                this._trail[i].graphics.lineStyle(1, 0xFFFFFF, 1);
                this._trail[i].graphics.moveTo(this._spot.x, this._spot.y);
                this._trail[i].graphics.lineTo(this._spot.x + this._segment.x, this._spot.y + this._segment.y);
                this._trail[i].filters = [new GlowFilter(0x0088AB, 1, 5 + Math.random() * 2, 5 + Math.random() * 2, 4, 1, false, false)];
                this._spot = this._spot.add(this._segment);
                MAP._PROJECTILES.addChild(this._trail[i]);
                MAP._PROJECTILES.addChild(this._gunballs[i]);
                ++this._spawnCount;
            }
            
            // Deal damage to creatures in line
            if (!this._targetVacuum) {
                const targets = Targeting.getCreepsInRange(1600, startPos, this.attackFlags);
                let totalDamage = 0;
                const endPos: Point = startPos.add(new Point(this._segment.x * 50, this._segment.y * 50));
                for (const targetData of targets) {
                    const creep = targetData.creep;
                    if (this.lineIntersectCircle(startPos, endPos, creep._tmpPoint)) {
                        totalDamage += this.damage * overdrive * healthRatio * creep._damageMult;
                        creep.modifyHealth(-(this.damage * overdrive * healthRatio * creep._damageMult));
                    }
                }
                ATTACK.Damage(this._mc!.x, this._mc!.y + this._top, totalDamage);
            }
        }
    }

    private lineIntersectCircle(lineStart: Point, lineEnd: Point, circleCenter: Point, radius: number = 20): boolean {
        const a: number = (lineEnd.x - lineStart.x) * (lineEnd.x - lineStart.x) + (lineEnd.y - lineStart.y) * (lineEnd.y - lineStart.y);
        const b: number = 2 * ((lineEnd.x - lineStart.x) * (lineStart.x - circleCenter.x) + (lineEnd.y - lineStart.y) * (lineStart.y - circleCenter.y));
        const c: number = circleCenter.x * circleCenter.x + circleCenter.y * circleCenter.y + lineStart.x * lineStart.x + lineStart.y * lineStart.y - 
                         2 * (circleCenter.x * lineStart.x + circleCenter.y * lineStart.y) - radius * radius;
        const discriminant: number = b * b - 4 * a * c;
        if (discriminant <= 0) {
            return false;
        }
        const sqrtD: number = Math.sqrt(discriminant);
        const t1: number = (-b + sqrtD) / (2 * a);
        const t2: number = (-b - sqrtD) / (2 * a);
        if ((t1 < 0 || t1 > 1) && (t2 < 0 || t2 > 1)) {
            return false;
        }
        return true;
    }

    public override Props(): void {
        super.Props();
    }

    public override Upgraded(): void {
        super.Upgraded();
    }

    public override Destroyed(byAttacker: boolean = true): void {
        super.Destroyed(byAttacker);
        while (this._gunballs.length > 0) {
            if (this._gunballs[0] && this._gunballs[0].parent) {
                MAP._PROJECTILES.removeChild(this._gunballs[0]);
            }
            if (this._trail[0] && this._trail[0].parent) {
                MAP._PROJECTILES.removeChild(this._trail[0]);
            }
            this._gunballs.shift();
            this._trail.shift();
        }
        this._spawnCount = 0;
        this._fireCount = 0;
    }

    public override Constructed(): void {
        super.Constructed();
    }
}
