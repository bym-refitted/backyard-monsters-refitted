import { IAttackable } from './com/monsters/interfaces/IAttackable';
import { MonsterBase } from './com/monsters/monsters/MonsterBase';
import Point from 'openfl/geom/Point';
import { GLOBAL } from './GLOBAL';
import { ProjectileBase } from './ProjectileBase';
import { PROJECTILES } from './PROJECTILES';
import { Targeting } from './Targeting';

/**
 * PROJECTILE - Individual Projectile
 * Handles projectile movement, collision, and splash damage
 */
export class PROJECTILE extends ProjectileBase {
    public _target: IAttackable | null = null;
    public _splashTargetFlags: number = 0;
    public _rocket: boolean = false;

    constructor() {
        super();
    }

    public Tick(): boolean {
        ++this._frameNumber;
        if (!this._target || this._target.health <= 0) {
            PROJECTILES.Remove(this._id);
            return false;
        }
        const altitude: number = (this._target instanceof MonsterBase && (this._target as MonsterBase)._movement === "fly") 
            ? (this._target as MonsterBase)._altitude : 0;
        this._targetPoint = new Point(this._target.x, this._target.y - altitude);
        this._distance = Point.distance(this._targetPoint, new Point(this._tmpX, this._tmpY));
        if (this.Move()) {
            return true;
        }
        this.Render();
        return false;
    }

    public Move(): boolean {
        const speed: number = this._maxSpeed * 0.5;
        if (this._frameNumber % 5 === 0) {
            this._xd = this._targetPoint!.x - this._tmpX;
            this._yd = this._targetPoint!.y - this._tmpY;
            this._xChange = Math.cos(Math.atan2(this._yd, this._xd)) * speed;
            this._yChange = Math.sin(Math.atan2(this._yd, this._xd)) * speed;
        }
        this._tmpX += this._xChange;
        this._tmpY += this._yChange;
        this._distance -= speed;
        if (this._distance <= this._maxSpeed) {
            if (this._splash > 0) {
                this.Splash();
            } else {
                this._target!.modifyHealth(-this._damage, this);
            }
            PROJECTILES.Remove(this._id);
            return true;
        }
        return false;
    }

    public Render(): void {
        if (GLOBAL._render && this._graphic) {
            this._graphic.x = Math.floor(this._tmpX);
            this._graphic.y = Math.floor(this._tmpY);
        }
    }

    public Splash(): void {
        const pos: Point = new Point(this._tmpX, this._tmpY);
        const targets: IAttackable[] = Targeting.getTargetsInRange(this._splash, pos, this._splashTargetFlags);
        Targeting.DealLinearAEDamage(pos, this._splash, this._damage, targets);
        this._target!.modifyHealth(0, this);
    }
}
