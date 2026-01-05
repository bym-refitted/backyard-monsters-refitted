import { MailBox } from './com/monsters/mailbox/MailBox';
import Loader from 'openfl/display/Loader';
import MouseEvent from 'openfl/events/MouseEvent';
import { GLOBAL } from './GLOBAL';
import { SOUNDS } from './SOUNDS';

/**
 * MAILBOX - Mail System Controller
 * Manages the in-game mailbox for player messages
 */
export class MAILBOX {
    public static _loader: Loader | null = null;
    public static _open: boolean = false;
    private static loaded: boolean = false;
    public static _handleTruceRequests: boolean = true;
    public static _threadidToOpen: number = -1;
    public static _mc: MailBox | null = null;

    constructor() {}

    public static Setup(): void {
        MAILBOX._mc = null;
    }

    public static Show(): void {
        SOUNDS.Play("click1");
        MAILBOX._mc = new MailBox();
        GLOBAL.BlockerAdd();
        GLOBAL._layerWindows.addChild(MAILBOX._mc as any);
        MAILBOX._mc.Setup();
    }

    public static Tick(): void {
        if (MAILBOX._mc && GLOBAL.Timestamp() % 15 === 0) {
            MAILBOX._mc.Tick();
        }
    }

    public static Hide(event: MouseEvent | null = null): void {
        try {
            SOUNDS.Play("close");
            GLOBAL.BlockerRemove();
            GLOBAL._layerWindows.removeChild(MAILBOX._mc as any);
            MAILBOX._mc = null;
        } catch (e) {
            // Ignore errors
        }
    }

    public static ShowWithThreadId(threadId: number): void {
        MAILBOX._threadidToOpen = threadId;
        MAILBOX.Show();
    }
}
