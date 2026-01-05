import DisplayObject from 'openfl/display/DisplayObject';
import { TweenLite } from './gs/TweenLite';
import { Quad } from './gs/easing/Quad';
import { GAME } from './GAME';
import { GLOBAL } from './GLOBAL';

/**
 * POPUPSETTINGS - Popup Positioning and Animation Utilities
 * Provides utilities for centering and animating popup dialogs
 */
export class POPUPSETTINGS {
    private static readonly _BOTTOM_PADDING: number = 100;

    constructor() {}

    public static AlignToCenter(displayObject: DisplayObject): void {
        displayObject.x = GLOBAL._SCREENCENTER.x;
        displayObject.y = GLOBAL._SCREENCENTER.y - POPUPSETTINGS._BOTTOM_PADDING;
        if (GAME._isSmallSize) {
            displayObject.y = GLOBAL._SCREENCENTER.y - POPUPSETTINGS._BOTTOM_PADDING / 2;
        }
    }

    public static AlignToUpperLeft(displayObject: DisplayObject, centered: boolean = false): void {
        displayObject.x = GLOBAL._SCREENCENTER.x - displayObject.width * 0.5;
        displayObject.y = GLOBAL._SCREENCENTER.y - POPUPSETTINGS._BOTTOM_PADDING - displayObject.height * 0.5;
        if (centered) {
            displayObject.y = GLOBAL._SCREENCENTER.y - displayObject.height * 0.5;
        }
    }

    public static ScaleUp(displayObject: DisplayObject): void {
        displayObject.scaleX = 0.9;
        displayObject.scaleY = 0.9;
        TweenLite.to(displayObject, 0.2, {
            scaleX: 1,
            scaleY: 1,
            ease: Quad.easeOut
        });
    }

    public static ScaleUpFromTopLeft(displayObject: DisplayObject): void {
        displayObject.scaleX = 0.9;
        displayObject.scaleY = 0.9;
        TweenLite.to(displayObject, 0.2, {
            transformAroundCenter: { scale: 1 },
            ease: Quad.easeOut
        });
    }
}
