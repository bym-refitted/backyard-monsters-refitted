import MovieClip from 'openfl/display/MovieClip';
import Event from 'openfl/events/Event';

/**
 * BUILDINGSARROW - Animated Arrow Indicator
 * Displays an animated arrow for highlighting UI elements
 */
export class BUILDINGSARROW extends MovieClip {
    public mcArrow: MovieClip | null = null;
    public offsetX: number = 0;
    public offsetY: number = 0;
    public wobbleCountdown: number = 0;
    public active: boolean = false;

    constructor() {
        super();
        this.addEventListener(Event.ENTER_FRAME, this.Wobble.bind(this));
    }

    public Trigger(isActive: boolean = false): void {
        this.active = isActive;
        if (this.active) {
            this.buttonMode = true;
            this.mcArrow?.gotoAndStop(2);
        } else {
            this.buttonMode = false;
            this.mcArrow?.gotoAndStop(1);
        }
    }

    public Wobble(event: Event): void {
        if (this.active) {
            if (this.wobbleCountdown === 0) {
                this.wobbleCountdown = 80;
            }
            --this.wobbleCountdown;
        }
    }

    private WobbleB(): void {
        // Empty implementation
    }
}
