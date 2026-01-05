import MovieClip from 'openfl/display/MovieClip';
import MouseEvent from 'openfl/events/MouseEvent';
import TextField from 'openfl/text/TextField';
import TextFormat from 'openfl/text/TextFormat';
import TextFormatAlign from 'openfl/text/TextFormatAlign';
import { KEYS } from './KEYS';

/**
 * Button - Standard Interactive Button
 * Base class for clickable buttons with highlight and selection states
 */
export class Button extends MovieClip {
    public _highlight: boolean = false;
    public _enabled: boolean = true;
    public _selected: boolean = false;
    public _counter: number = 0;
    public _txt: TextField;
    public _format: TextFormat;
    public _startY: number = 0;
    public _tab: boolean = false;
    public label: string = "";
    public labelKey: string = "";

    constructor() {
        super();
        this._startY = this.y;
        this.addEventListener(MouseEvent.MOUSE_OVER, this.Over.bind(this));
        this.addEventListener(MouseEvent.MOUSE_OUT, this.Out.bind(this));
        this.mouseChildren = false;
        this.buttonMode = true;
        
        this._format = new TextFormat();
        this._format.font = "Verdana";
        this._format.size = 9;
        this._format.align = TextFormatAlign.CENTER;
        this._format.color = 0x333333;
        
        this._txt = new TextField();
        this._txt.selectable = false;
        this._txt.defaultTextFormat = this._format;
        this._txt.text = "xxxx";
        this._txt.width = 64;
        this._txt.height = 20;
        this.addChild(this._txt);
        this._txt.y = Math.floor(this.height / 2 - this._txt.height / 2 + 2);
        this._txt.x = 1;
        this.cacheAsBitmap = true;
    }

    public Setup(label: string = "", isTab: boolean = false, width: number = 0, height: number = 0): void {
        this._tab = isTab;
        if (width > 0) this.width = width;
        if (height > 0) this.height = height;
        if (label) {
            this._txt.htmlText = '<b><font color="#333333">' + label + '</font></b>';
            this.label = label;
        }
        if (this._tab) this._txt.y = 2;
        this.Update();
    }

    public SetupKey(key: string = "", isTab: boolean = false, width: number = 0, height: number = 0): void {
        this.labelKey = key;
        this.Setup(KEYS.Get(this.labelKey), isTab, width, height);
    }

    public Update(): void {
        if (this._highlight) {
            this.gotoAndStop(4);
        } else if (this._enabled) {
            if (this._selected) {
                this.gotoAndStop(2);
            } else {
                this.gotoAndStop(1);
            }
        } else {
            this.gotoAndStop(3);
        }
    }

    public Over(event: MouseEvent): void {
        if (this._highlight) {
            this.gotoAndStop(5);
        } else if (this._enabled) {
            this.gotoAndStop(2);
        }
    }

    public Out(event: MouseEvent): void {
        if (this._highlight) {
            this.gotoAndStop(4);
        } else if (this._enabled) {
            if (this._selected) {
                this.gotoAndStop(2);
            } else {
                this.gotoAndStop(1);
            }
        }
    }

    public get Enabled(): boolean {
        return this._enabled;
    }

    public set Enabled(value: boolean) {
        if (this._enabled !== value) {
            this._enabled = value;
            if (value) {
                this._txt.alpha = 1;
                this.buttonMode = true;
            } else {
                this._txt.alpha = 0.5;
                this.buttonMode = false;
            }
            this.Update();
        }
    }

    public get Highlight(): boolean {
        return this._highlight;
    }

    public set Highlight(value: boolean) {
        if (this._highlight !== value) {
            this._highlight = value;
            this.Update();
        }
    }

    public get Selected(): boolean {
        return this._selected;
    }

    public set Selected(value: boolean) {
        if (this._selected !== value) {
            this._selected = value;
            this.Update();
        }
    }

    public get Counter(): number {
        return this._counter;
    }

    public set Counter(value: number) {
        if (this._counter !== value) {
            this._counter = value;
            this.Update();
        }
    }
}
