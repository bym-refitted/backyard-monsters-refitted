import { LASERS } from './com/monsters/effects/LASERS';
import { ResourceBombs } from './com/monsters/effects/ResourceBombs';
import { Particles } from './com/monsters/effects/particles/Particles';
import BitmapData from 'openfl/display/BitmapData';
import DisplayObject from 'openfl/display/DisplayObject';
import DisplayObjectContainer from 'openfl/display/DisplayObjectContainer';
import Shape from 'openfl/display/Shape';
import GlowFilter from 'openfl/filters/GlowFilter';
import ColorTransform from 'openfl/geom/ColorTransform';
import Matrix from 'openfl/geom/Matrix';
import Point from 'openfl/geom/Point';
import Rectangle from 'openfl/geom/Rectangle';
import { CREATURES } from './CREATURES';
import { GIBLETS } from './GIBLETS';
import { GLOBAL } from './GLOBAL';
import { MAP } from './MAP';

/**
 * EFFECTS - Visual Effects System
 * Handles particle effects, lightning, lasers, scorches, and splatters
 */
export class EFFECTS {
    public static _items: Record<string, any> = {};
    public static _itemCount: number = 0;
    public static _effects: any[] = [];
    public static _effectsJSON: string = "";
    public static _scorches: BitmapData[] = []; // new ParticleScorch1(0,0)
    public static _burns: BitmapData | null = null; // new bmd_burns(0,0)
    public static _splats: any[] = []; // new ParticleSplat()
    public static _switcher: number = 0;
    public static _trash: Record<string, any> = {};
    public static _tmpSplatCount: number = 0;
    public static _effectsLimit: number = 100;
    public static _effectDuration: number = 172800;

    constructor() {}

    public static Setup(effects: any[]): void {
        EFFECTS._items = {};
        EFFECTS._itemCount = 0;
        EFFECTS._effects = effects;
        EFFECTS._effectsLimit = GLOBAL._flags.efl;
        EFFECTS._effectDuration = 172800;
    }

    public static CreepSplat(creatureId: string, x: number, y: number): void {
        let count: number = 0;
        if (creatureId.substr(0, 1) === "G") {
            count = 10;
        } else {
            count = CREATURES.GetProperty(creatureId, "cResource") / 100;
        }
        if (count > 5 && creatureId.substr(0, 1) !== "G") {
            count = 5;
        }
        if (EFFECTS._tmpSplatCount < 2) {
            for (let i = 0; i < count; i++) {
                ++EFFECTS._tmpSplatCount;
                const angle: number = Math.random() * 360 * 0.0174532925;
                const radius: number = Math.random() * 16;
                EFFECTS.SplatParticle(30, x + Math.sin(angle) * radius, y + Math.cos(angle) * radius, angle, Math.random() * 20 / 15);
            }
        }
        GIBLETS.Create(new Point(x, y + 3), 0.8, 75, count);
    }

    public static SplatParticle(size: number, x: number, y: number, angle: number, speed: number): void {
        // Create splat particle
        const splat: any = {}; // new ParticleSplat()
        const frame: number = 1 + Math.floor(Math.random() * 5);
        // splat.gotoAndStop(frame);
        splat.x = x;
        splat.y = y;
        const scale: number = 1 / 32 * size;
        splat.scaleX = splat.scaleY = scale;
        EFFECTS._items["i" + EFFECTS._itemCount] = {
            mc: splat,
            xd: Math.sin(angle),
            yd: Math.cos(angle) * 0.5,
            speed: speed,
            life: 0,
            code: "s" + frame,
            frame: frame
        };
        ++EFFECTS._itemCount;
    }

    public static Scorch(pos: Point, type: number = 0): void {
        EFFECTS.SnapShotB(pos.x, pos.y, "b" + type, 0);
        EFFECTS.Push([pos.x, pos.y, "b" + type, 0]);
    }

    public static Burn(x: number, y: number): void {
        const offset: number = 80 * Math.floor(Math.random() * 4) - 80;
        if (MAP.effectsBMD && EFFECTS._burns) {
            MAP.effectsBMD.copyPixels(EFFECTS._burns, new Rectangle(offset, 0, 80, 40),
                new Point(x + MAP.effectsBMD.width * 0.5 - 40, y + MAP.effectsBMD.height * 0.5 - 20), null, null, true);
        }
    }

    public static Lightning(x1: number, y1: number, x2: number, y2: number, 
                            container: DisplayObjectContainer | null = null, color: number = 0x30C0DA): void {
        if (!container) {
            container = MAP._PROJECTILES;
        }
        const distance: number = Point.distance(new Point(x1, y1), new Point(x2, y2));
        const lightning: Shape = container.addChild(new Shape()) as Shape;
        lightning.graphics.lineStyle(1, color, 1);
        lightning.graphics.moveTo(x1, y1);
        const segments: number = Math.floor(distance / 30);
        for (let i = 0; i < segments; i++) {
            const dx: number = x2 - x1;
            const dy: number = y2 - y1;
            const segX: number = Math.cos(Math.atan2(dy, dx)) * (distance / segments * i);
            const segY: number = Math.sin(Math.atan2(dy, dx)) * (distance / segments * i);
            lightning.graphics.lineTo(segX + x1 - 7 + Math.random() * 15, segY + y1 - 7 + Math.random() * 15);
            lightning.filters = [new GlowFilter(color, 1, 4, 4, 2, 1, false, false)];
        }
        lightning.graphics.lineTo(x2 - 5 + Math.random() * 10, y2 - Math.random() * 10);
        lightning.blendMode = "add";
        EFFECTS._trash["i" + EFFECTS._itemCount] = {
            counter: 0,
            container: container,
            mc: lightning
        };
        ++EFFECTS._itemCount;
    }

    public static Laser(x1: number, y1: number, x2: number, y2: number, 
                        color: number, width: number, alpha: number, callback: Function | null = null): void {
        LASERS.Fire(x1, y1, x2, y2, color, width, alpha, callback);
    }

    public static Tick(): void {
        if (EFFECTS._tmpSplatCount > 0) {
            --EFFECTS._tmpSplatCount;
        }
        for (const key in EFFECTS._items) {
            const item = EFFECTS._items[key];
            if (GLOBAL._render) {
                item.mc.x += item.xd * item.speed;
                item.mc.y += item.yd * item.speed;
                item.mc.scaleX = item.mc.scaleY = item.mc.scaleY + 0.02;
                if (item.speed > 0) {
                    item.speed -= 0.02;
                }
                ++item.life;
                if (item.speed <= 0 && item.life > 10) {
                    EFFECTS.SnapShot(item);
                    EFFECTS.Remove(MAP._EFFECTS, item.mc);
                    delete EFFECTS._items[key];
                }
            } else {
                item.mc.x += item.xd * (item.speed * 20);
                item.mc.y += item.yd * (item.speed * 20);
                item.mc.scaleX = item.mc.scaleY = item.mc.scaleY + 0.4;
                EFFECTS.SnapShot(item);
                EFFECTS.Remove(MAP._EFFECTS, item.mc);
                delete EFFECTS._items[key];
            }
        }
        LASERS.Tick();
        ResourceBombs.Tick();
        for (const key in EFFECTS._trash) {
            const trashItem = EFFECTS._trash[key];
            if (trashItem.counter >= 3) {
                EFFECTS.Remove(trashItem.container, trashItem.mc);
                delete EFFECTS._trash[key];
            } else {
                trashItem.mc.alpha /= 1.75;
            }
            ++trashItem.counter;
        }
    }

    public static Remove(container: DisplayObjectContainer, child: DisplayObject): void {
        container.removeChild(child);
    }

    public static Process(timeDelta: number): void {
        while (EFFECTS._effects.length > EFFECTS._effectsLimit) {
            EFFECTS._effects.shift();
        }
        for (let i = 0; i < EFFECTS._effects.length; i++) {
            const effect = EFFECTS._effects[i];
            if (effect[3] + timeDelta > EFFECTS._effectDuration) {
                EFFECTS._effects.splice(i, 1);
            } else {
                effect[3] += timeDelta;
                EFFECTS.SnapShotB(effect[0], effect[1], effect[2], effect[3]);
            }
        }
        EFFECTS._effectsJSON = JSON.stringify(EFFECTS._effects);
    }

    public static SnapShot(item: any): void {
        EFFECTS.SnapShotB(item.mc.x, item.mc.y, item.code, 0, item.mc.scaleX);
        EFFECTS.Push([Math.floor(item.mc.x), Math.floor(item.mc.y), item.code, 0]);
    }

    public static SnapShotB(x: number, y: number, code: string, age: number, scale: number = 0): void {
        try {
            const matrix: Matrix = new Matrix();
            if (scale === 0) {
                scale = 1 + Math.random() * 10 / 10;
            }
            let bmd: BitmapData;
            let width: number, height: number;
            if (code.substr(0, 1) === "s") {
                width = 100;
                height = 100;
                bmd = new BitmapData(100, 100, true, 0);
                matrix.scale(scale, scale);
                matrix.tx = 50;
                matrix.ty = 50;
                // Draw splat with color transform
            } else if (code.substr(0, 1) === "b") {
                width = 200;
                height = 100;
                bmd = EFFECTS._scorches[parseInt(code.substr(1, 1))];
                matrix.tx = 100;
                matrix.ty = 50;
            }
            if (MAP.effectsBMD) {
                MAP.effectsBMD.copyPixels(bmd!, new Rectangle(0, 0, width!, height!),
                    new Point(x + MAP.effectsBMD.width * 0.5 - width! / 2, y + MAP.effectsBMD.height * 0.5 - height! / 2), null, null, true);
            }
        } catch (e) {
            // Ignore errors
        }
    }

    public static Push(effect: any[]): void {
        if (EFFECTS._switcher % 2 === 0) {
            EFFECTS._effects.push(effect);
            EFFECTS._effectsJSON = JSON.stringify(EFFECTS._effects);
            if (EFFECTS._effects.length > EFFECTS._effectsLimit) {
                EFFECTS._effects.shift();
            }
        }
        ++EFFECTS._switcher;
    }

    public static Dig(x: number, y: number): void {
        Particles.Create(new Point(x, y), 1 + Math.random() * 0.5, 30, 20, 0);
    }

    public static Burrow(x: number, y: number): void {
        Particles.Create(new Point(x, y), 0.5 + Math.random() * 0.5, 10, 3, 0);
    }
}
