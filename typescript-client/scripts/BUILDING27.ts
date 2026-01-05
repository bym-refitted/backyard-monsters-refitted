import MovieClip from 'openfl/display/MovieClip';
import Event from 'openfl/events/Event';
import MouseEvent from 'openfl/events/MouseEvent';
import Point from 'openfl/geom/Point';
import Rectangle from 'openfl/geom/Rectangle';
import { BFOUNDATION } from './BFOUNDATION';
import { BASE } from './BASE';
import { CREEPS } from './CREEPS';
import { CUSTOMATTACKS } from './CUSTOMATTACKS';
import { GLOBAL } from './GLOBAL';
import { INFERNO_EMERGENCE_EVENT } from './INFERNO_EMERGENCE_EVENT';
import { KEYS } from './KEYS';
import { LOGIN } from './LOGIN';
import { MAP } from './MAP';
import { POPUPS } from './POPUPS';
import { SOUNDS } from './SOUNDS';
import { SPECIALEVENT } from './SPECIALEVENT';
import { UI2 } from './UI2';
import { WMATTACK } from './WMATTACK';

/**
 * BUILDING27 - Trojan Horse
 * Extends BFOUNDATION for the special trojan horse attack building
 */
export class BUILDING27 extends BFOUNDATION {
    public static _exists: boolean = false;
    
    public _spewNumber: number = 0;
    public _stage: number = 0;
    public _spewed: boolean = false;
    public _clicked: boolean = false;

    constructor() {
        super();
        this._type = 27;
        this._footprint = [new Rectangle(0, 0, 140, 140)];
        this._gridCost = [[new Rectangle(0, 0, 140, 140), 200]];
        BUILDING27._exists = true;
        this.SetProps();
        if (GLOBAL.mode !== "wmattack" && GLOBAL.mode !== "wmview") {
            this.Render();
        }
    }

    protected popupRemoveFromStage(event: Event): void {
        if (this._spewed === true) {
            return;
        }
        this._clicked = false;
    }

    public Spew(event: Event | null = null): void {
        ++this._spewNumber;
        const baseValue: number = BASE._basePoints + BASE._baseValue;
        let scale: number = 0.4;
        if (baseValue > 3000000) {
            scale = 0.6;
        }
        if (baseValue > 5000000) {
            scale = 0.8;
        }
        if (baseValue > 8000000) {
            scale = 1;
        }
        if (this._spewNumber === 1 || this._spewNumber % 20 === 0) {
            const creatureLevel: number = Math.ceil(this._spewNumber / 100);
            if (creatureLevel === 5 || creatureLevel > 11) {
                return;
            }
            this._animTick = 1;
            this.AnimFrame();
            SOUNDS.Play("bankland");
            CREEPS.Spawn("C" + creatureLevel, MAP._BUILDINGTOPS, "bounce", new Point(this._mc!.x - 80, this._mc!.y + 108), Math.random() * 360, scale);
        } else if (this._spewNumber % 10 === 0) {
            this._animTick = 0;
            this.AnimFrame();
        }
        if (this._spewNumber >= 1110) {
            this._mc!.removeEventListener(Event.ENTER_FRAME, this.Spew);
        }
    }

    public StartAttack(event: MouseEvent | null = null): void {
        if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD) {
            if (!this._spewed) {
                if (BASE.isInfernoMainYardOrOutpost) {
                    SOUNDS.PlayMusic("musicipanic");
                } else {
                    SOUNDS.PlayMusic("musicpanic");
                }
                this._spewed = true;
                POPUPS.Next();
                UI2.Show("warning");
                UI2._warning.Update(KEYS.Get("ai_trojan_trap"));
                this._mc!.addEventListener(Event.ENTER_FRAME, this.Spew.bind(this));
                this.Spew();
                CUSTOMATTACKS._started = true;
                WMATTACK._isAI = false;
                WMATTACK._inProgress = true;
                WMATTACK.AttackB();
                WMATTACK.AttackC();
                WMATTACK.ResetWait();
            }
        }
    }

    public override Click(event: MouseEvent | null = null): void {
        if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD) {
            const activeEvent: any = SPECIALEVENT.getActiveSpecialEvent();
            if (activeEvent.active) {
                return;
            }
            if (INFERNO_EMERGENCE_EVENT.isAttackActive) {
                return;
            }
            if (!this._clicked) {
                CUSTOMATTACKS._started = true;
                this._clicked = true;
                const mc: MovieClip = new (GLOBAL as any).popup_horse();
                mc.tA.htmlText = `<b>${KEYS.Get("ai_trojan_headline")}</b>`;
                mc.tName.htmlText = KEYS.Get("ai_trojan_letter", { v1: LOGIN._playerName });
                mc.bA.SetupKey("ai_trojan_sendback_btn");
                mc.bA.addEventListener(MouseEvent.CLICK, this.StartAttack.bind(this), false, 0, true);
                mc.bB.SetupKey("ai_trojan_accept_btn");
                mc.bB.addEventListener(MouseEvent.CLICK, this.StartAttack.bind(this), false, 0, true);
                mc.addEventListener(Event.REMOVED_FROM_STAGE, this.popupRemoveFromStage.bind(this), false, 0, true);
                POPUPS.Push(mc);
            }
        }
    }

    public override get tickLimit(): number {
        return Number.MAX_SAFE_INTEGER;
    }

    public override Tick(seconds: number): void {
        // Empty override - trojan horse doesn't tick
    }

    public override Update(force: boolean = false): void {
        // Empty override - trojan horse doesn't update normally
    }

    public override Export(): any {
        const data: any = super.Export();
        if (!this._spewed) {
            return data;
        }
        return false;
    }
}
