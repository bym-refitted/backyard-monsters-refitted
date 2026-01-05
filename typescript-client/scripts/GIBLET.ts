import MovieClip from 'openfl/display/MovieClip';
import Point from 'openfl/geom/Point';
import { GIBLETS } from './GIBLETS';
import { SOUNDS } from './SOUNDS';
import { TweenLite, Sine } from './gs/TweenLite';

/**
 * GIBLET - Individual Giblet Particle
 * Represents a flying meat particle from monster deaths
 */
export class GIBLET {
    private _frame: number = 0;
    private _id: number = 0;
    private _targetPoint: Point | null = null;
    private _target: MovieClip | null = null;
    public _cleared: boolean = false;
    private xd: number = 0;
    private yd: number = 0;
    private _targetRotation: number = 0;
    private _speed: number = 0;
    public x: number = 0;
    public y: number = 0;
    public scaleX: number = 1;
    public scaleY: number = 1;
    public visible: boolean = true;
    public cacheAsBitmap: boolean = false;
    public parent: any = null;
    public mcDot: any = { y: 0 };

    constructor() {}

    public init(id: number, startPos: Point, targetPos: Point, distance: number, delay: number, scale: number): void {
        this._id = id;
        this.visible = false;
        this._cleared = false;
        this.x = startPos.x;
        this.y = startPos.y;
        this.scaleX = this.scaleY = scale;
        let duration: number = Math.sqrt(distance * 0.3) * 0.2;
        if (duration < 0.3) {
            duration = 0.3;
        }
        TweenLite.to(this, duration, {
            x: targetPos.x,
            y: targetPos.y,
            visible: true,
            ease: Sine.easeInOut,
            delay: delay,
            onComplete: this.Arrived.bind(this),
            overwrite: false
        });
        TweenLite.to(this.mcDot, duration / 2, {
            y: -(duration * 50),
            ease: Sine.easeOut,
            delay: delay,
            overwrite: 0
        });
        TweenLite.to(this.mcDot, duration / 2, {
            y: 0,
            ease: Sine.easeIn,
            delay: duration / 2 + delay,
            overwrite: 0
        });
        this.cacheAsBitmap = true;
    }

    private Arrived(): void {
        if (!this._cleared) {
            SOUNDS.Play("splat5");
            GIBLETS.Remove(this._id);
        }
    }

    public Clear(): void {
        this._cleared = true;
    }
}
