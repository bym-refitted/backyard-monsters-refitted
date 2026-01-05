import MovieClip from 'openfl/display/MovieClip';
import Event from 'openfl/events/Event';
import MouseEvent from 'openfl/events/MouseEvent';

/**
 * Checkbox - Interactive Checkbox Component
 * Toggle checkbox with visual states for checked/unchecked/hover/disabled
 */
export class Checkbox extends MovieClip {
    private static readonly FRAME_SELECT: number = 2;
    private static readonly FRAME_DESELECT: number = 1;
    public static readonly CHECK_EVENT: string = "cb_checked";

    private checked: boolean = false;
    private _enabled: boolean = true;
    private _over: boolean = false;
    private _down: boolean = false;

    constructor() {
        super();
        this.addEventListener(MouseEvent.MOUSE_DOWN, this.onDown.bind(this));
        this.addEventListener(MouseEvent.MOUSE_UP, this.onUp.bind(this));
        this.addEventListener(MouseEvent.MOUSE_OVER, this.onOver.bind(this));
        this.addEventListener(MouseEvent.MOUSE_OUT, this.onOut.bind(this));
        this.stop();
    }

    public static Replace(mc: MovieClip): Checkbox {
        const checkbox = new Checkbox();
        checkbox.x = mc.x;
        checkbox.y = mc.y;
        checkbox.scaleX = mc.scaleX;
        checkbox.scaleY = mc.scaleY;
        checkbox.gotoAndStop(mc.currentFrame);
        checkbox.name = mc.name;
        if (mc.parent) {
            const index = mc.parent.getChildIndex(mc);
            const parent = mc.parent;
            parent.removeChild(mc);
            parent.addChildAt(checkbox, index - 1);
        }
        return checkbox;
    }

    public onDown(event: MouseEvent): void {
        this._down = true;
        this.Update();
    }

    public onUp(event: MouseEvent): void {
        this._down = false;
        if (this._enabled) {
            this.Checked = !this.checked;
            this.dispatchEvent(new Event(Checkbox.CHECK_EVENT));
        }
        this.Update();
    }

    public onClick(event: MouseEvent): void {
        if (this._enabled) {
            this.Checked = !this.checked;
            this.dispatchEvent(new Event(Checkbox.CHECK_EVENT));
        }
    }

    public onOver(event: MouseEvent): void {
        this._over = true;
        this.Update();
    }

    public onOut(event: MouseEvent): void {
        this._over = false;
        this.Update();
    }

    public Update(): void {
        if (this._enabled) {
            if (this._over) {
                this.gotoAndStop(this.checked ? 4 : 3);
            } else {
                this.gotoAndStop(this.checked ? 2 : 1);
            }
            if (this._down) {
                this.gotoAndStop(this.checked ? 8 : 7);
            }
        } else {
            this.gotoAndStop(this.checked ? 6 : 5);
        }
    }

    public set Checked(value: boolean) {
        this.checked = value;
        this.Update();
    }

    public get Checked(): boolean {
        return this.checked;
    }

    public set Enabled(value: boolean) {
        this._enabled = value;
        this.Update();
    }

    public get Enabled(): boolean {
        return this._enabled;
    }

    public select(): void {
        this.checked = true;
    }

    public deselect(): void {
        this.checked = false;
    }

    public get selected(): boolean {
        return this.checked;
    }

    public toggle(): void {
        if (this.selected) {
            this.deselect();
        } else {
            this.select();
        }
        this.dispatchEvent(new Event(Checkbox.CHECK_EVENT));
    }

    public fromInt(value: number): void {
        if (value) {
            this.select();
        } else {
            this.deselect();
        }
    }

    public toInt(): number {
        return this.selected ? 1 : 0;
    }

    public Remove(): void {
        this.removeEventListener(MouseEvent.MOUSE_DOWN, this.onDown.bind(this));
        this.removeEventListener(MouseEvent.MOUSE_UP, this.onUp.bind(this));
        this.removeEventListener(MouseEvent.MOUSE_OVER, this.onOver.bind(this));
        this.removeEventListener(MouseEvent.MOUSE_OUT, this.onOut.bind(this));
    }
}
