import MouseEvent from 'openfl/events/MouseEvent';
import Point from 'openfl/geom/Point';
import { BASE } from './BASE';
import { CUSTOMATTACKS } from './CUSTOMATTACKS';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { MAP } from './MAP';
import { MONSTERBAITERPOPUP } from './MONSTERBAITERPOPUP';
import { SOUNDS } from './SOUNDS';
import { UI2 } from './UI2';
import { WMATTACK } from './WMATTACK';

/**
 * MONSTERBAITER - Monster Baiter Controller
 * Attracts wild monsters to attack the base and manages the attack wave
 */
export class MONSTERBAITER {
    public static readonly TYPE: number = 19;
    public static _mc: MONSTERBAITERPOPUP | null = null;
    public static _attacking: number = 0;
    public static _scaredAway: boolean = false;
    public static _musk: number = 0;
    public static _muskLimit: number = 300;
    public static _replenishRate: number = 0;
    public static _currentAttackers: any[] = [];
    public static _attPrep: number = 0;
    public static _attackPt: Point = new Point();
    public static _queue: Record<string, number> = {};
    public static _attackDir: number = 0;
    public static _frameNumber: number = 0;

    constructor() {}

    public static Tick(): void {
        if (GLOBAL._bBaiter) {
            MONSTERBAITER._musk = MONSTERBAITER._muskLimit;
            if (MONSTERBAITER._mc) {
                MONSTERBAITER._mc.Update();
            }
            if (MONSTERBAITER._attPrep > 0) {
                if (MONSTERBAITER._attPrep === 1) {
                    UI2._warning.Update("<font size=\"28\">" + KEYS.Get("msg_dontpanic") + "</font>");
                    MONSTERBAITER._attPrep = 0;
                    const attackers: any[] = [];
                    for (const creatureId in MONSTERBAITER._queue) {
                        if (MONSTERBAITER._queue[creatureId] > 0) {
                            attackers.push([creatureId, "bounce", MONSTERBAITER._queue[creatureId], MONSTERBAITER._attackPt.x, MONSTERBAITER._attackPt.y, 0, 0]);
                        }
                    }
                    WMATTACK._type = WMATTACK.TYPE_DAMAGE;
                    MONSTERBAITER._currentAttackers = CUSTOMATTACKS.CustomAttack(attackers);
                    for (const group of MONSTERBAITER._currentAttackers) {
                        for (const monster of group) {
                            monster._hitLimit = Number.MAX_VALUE;
                        }
                    }
                } else {
                    UI2._warning.Update("<font size=\"28\">" + (MONSTERBAITER._attPrep - 1) + "</font>");
                    SOUNDS.PlayMusic(BASE.isInfernoMainYardOrOutpost ? "musicipanic" : "musicpanic");
                    MONSTERBAITER._attPrep--;
                }
            }
            MONSTERBAITER._frameNumber++;
        }
    }

    public static PrepAttack(): void {
        MONSTERBAITER._scaredAway = true;
        MONSTERBAITER._attPrep = 4;
        MONSTERBAITER._attacking = 1;
        MAP.FocusTo(GLOBAL._bBaiter.x, GLOBAL._bBaiter.y, 2);
        UI2.Show("warning");
        BASE.Save();
        UI2.Hide("top");
        UI2.Hide("bottom");
    }

    public static End(silent: boolean = false): void {
        MONSTERBAITER._scaredAway = true;
        if (!silent) SOUNDS.Play("wmbhorn");
        UI2.Hide("scareAway");
        UI2.Hide("warning");
        SOUNDS.PlayMusic(BASE.isInfernoMainYardOrOutpost ? "musicibuild" : "musicbuild");
        
        for (const group of MONSTERBAITER._currentAttackers) {
            for (let i = 0; i < group.length; i++) {
                group[i].changeModeRetreat();
            }
        }
        MONSTERBAITER._attacking = 0;
        MONSTERBAITER._currentAttackers = [];
    }

    public static Setup(data: any = null): void {
        if (data) {
            if (data.queue) {
                if (data.queue.C100 !== undefined) {
                    data.queue.C12 = data.queue.C100;
                    delete data.queue.C100;
                }
                MONSTERBAITER._queue = data.queue;
            }
            if (data.attackDir !== undefined) {
                MONSTERBAITER._attackDir = data.attackDir;
            }
            if (data.musk !== undefined) {
                MONSTERBAITER._musk = data.musk;
            }
        }
    }

    public static Update(): void {
        try {
            if (GLOBAL._bBaiter !== null) {
                const props = GLOBAL._buildingProps[18];
                MONSTERBAITER._muskLimit = props.capacity[GLOBAL._bBaiter._lvl.Get() - 1];
                MONSTERBAITER._replenishRate = props.produce[GLOBAL._bBaiter._lvl.Get() - 1];
            }
        } catch (e) {
            // Ignore errors
        }
    }

    public static Fill(): void {
        MONSTERBAITER._musk = MONSTERBAITER._muskLimit;
    }

    public static Export(): any {
        return {
            queue: MONSTERBAITER._queue,
            attackDir: MONSTERBAITER._attackDir,
            musk: MONSTERBAITER._musk
        };
    }

    public static Show(): void {
        if (!MONSTERBAITER._mc) {
            SOUNDS.Play("click1");
            GLOBAL.BlockerAdd();
            MONSTERBAITER._mc = GLOBAL._layerWindows.addChild(new MONSTERBAITERPOPUP()) as MONSTERBAITERPOPUP;
            MONSTERBAITER._mc.Setup(MONSTERBAITER._queue, MONSTERBAITER._attackDir);
            MONSTERBAITER._mc.Center();
            MONSTERBAITER._mc.ScaleUp();
        }
    }

    public static Hide(event: MouseEvent | null = null): void {
        SOUNDS.Play("close");
        GLOBAL.BlockerRemove();
        if (MONSTERBAITER._mc) {
            GLOBAL._layerWindows.removeChild(MONSTERBAITER._mc);
            MONSTERBAITER._mc = null;
        }
    }
}
