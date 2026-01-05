import { ImageCache } from './com/monsters/display/ImageCache';
import { SpriteData } from './com/monsters/display/SpriteData';
import { ResurrectProjectile } from './com/monsters/projectiles/ResurrectProjectile';
import { Decoy } from './com/monsters/siege/weapons/Decoy';
import { Jars } from './com/monsters/siege/weapons/Jars';
import BitmapData from 'openfl/display/BitmapData';
import { BASE } from './BASE';
import { GLOBAL } from './GLOBAL';
import { SpurtzCannon } from './SpurtzCannon';
import { STORE } from './STORE';

/**
 * SPRITES - Sprite Data and Animation System
 * Manages sprite sheets, frame extraction, and animation data
 */
export class SPRITES {
    public static _sprites: Record<string, SpriteData> = {};

    constructor() {}

    public static Setup(): void {
        SPRITES._sprites = {};
        if (!BASE.isInfernoMainYardOrOutpost) {
            SPRITES._sprites.worker = new SpriteData("monsters/worker.png", 27, 27, 9, 19);
        } else {
            SPRITES._sprites.worker = new SpriteData("monsters/inferno_worker.v2.png", 64, 55, 32, 36);
        }
        SPRITES._sprites.C1 = new SpriteData("monsters/sprite.1.v1.png", 24, 21, 8, 14);
        SPRITES._sprites.C2 = new SpriteData("monsters/octoooze.png", 39, 28, 19, 15);
        SPRITES._sprites.C3 = new SpriteData("monsters/sprite.3.v2.png", 30, 28, 7, 20);
        SPRITES._sprites.C4 = new SpriteData("monsters/fink.png", 34, 32, 15, 21);
        SPRITES._sprites.C5 = new SpriteData("monsters/eyera.png", 26, 23, 11, 15);
        SPRITES._sprites.C6 = new SpriteData("monsters/ichi.png", 27, 26, 11, 17);
        SPRITES._sprites.C7 = new SpriteData("monsters/bandito.png", 29, 28, 11, 17);
        SPRITES._sprites.C8 = new SpriteData("monsters/fang.png", 34, 31, 16, 19);
        SPRITES._sprites.C9 = new SpriteData("monsters/brain.v2.png", 34, 24, 16, 13);
        SPRITES._sprites.C10 = new SpriteData("monsters/crabatron.png", 37, 27, 15, 18);
        SPRITES._sprites.C11 = new SpriteData("monsters/sprite.11.v2.png", 48, 35, 24, 22);
        SPRITES._sprites.C12 = new SpriteData("monsters/sprite.12.v2.png", 53, 46, 21, 27);
        SPRITES._sprites.C12Gold = new SpriteData("monsters/sprite.12.gold.png", 53, 46, 21, 27);
        SPRITES._sprites.C13 = new SpriteData("monsters/13.png", 40, 26, 19, 17);
        SPRITES._sprites.C14 = new SpriteData("monsters/14.v1.png", 28, 28, 15, 14);
        SPRITES._sprites.C15 = new SpriteData("monsters/zafreeti.v2.png", 56, 70, 28, 35);
        SPRITES._sprites.C16 = new SpriteData("monsters/vorg_anim.png", 40, 40, SpriteData.FUBAR_X, SpriteData.FUBAR_Y);
        SPRITES._sprites.C17 = new SpriteData("monsters/slimeattikus_anim.png", 48, 31, SpriteData.FUBAR_X, SpriteData.FUBAR_Y - 21);
        SPRITES._sprites.C18 = new SpriteData("monsters/slimeattikusmini_anim.png", 30, 20, SpriteData.FUBAR_X - 11, SpriteData.FUBAR_Y - 25);
        SPRITES._sprites.C19 = new SpriteData("monsters/rezghul.png", 48, 43, SpriteData.FUBAR_X, SpriteData.FUBAR_Y);
        SPRITES._sprites.IC1 = new SpriteData("monsters/spurtz.png", 24, 28, 12, 14);
        SPRITES._sprites.IC2 = new SpriteData("monsters/zagnoid.png", 64.4, 46, 26, 28);
        SPRITES._sprites.IC3 = new SpriteData("monsters/malphus.png", 51, 35, 25, 17);
        SPRITES._sprites.IC4 = new SpriteData("monsters/valgos.png", 55, 32, 11, 15);
        SPRITES._sprites.IC5 = new SpriteData("monsters/balthazar.png", 56, 37, 33, 18.5);
        SPRITES._sprites.IC6 = new SpriteData("monsters/grokus.v2.png", 57, 39, 28, 20);
        SPRITES._sprites.IC7 = new SpriteData("monsters/sabnox.png", 42, 34, 21, 17);
        SPRITES._sprites.IC8 = new SpriteData("monsters/wormzer.png", 58, 42, 29, 21);
        SPRITES._sprites.G1_1 = new SpriteData("monsters/ape_1.png", 96, 69, 26, 36);
        SPRITES._sprites.G1_2 = new SpriteData("monsters/ape_2.png", 89, 73, 26, 36);
        SPRITES._sprites.G1_3 = new SpriteData("monsters/ape_3.png", 103, 88, 26, 36);
        SPRITES._sprites.G1_4 = new SpriteData("monsters/ape_4.png", 148, 127, 26, 36);
        SPRITES._sprites.G1_5 = new SpriteData("monsters/ape_5.png", 160, 137, 26, 36);
        SPRITES._sprites.G1_6 = new SpriteData("monsters/ape_6.png", 140, 120, 26, 36);
        SPRITES._sprites.G2_1 = new SpriteData("monsters/dragon_1.png", 64, 41, 26, 36);
        SPRITES._sprites.G2_2 = new SpriteData("monsters/dragon_2.png", 87, 58, 26, 36);
        SPRITES._sprites.G2_3 = new SpriteData("monsters/dragon_3.png", 114, 85, 26, 36);
        SPRITES._sprites.G2_4 = new SpriteData("monsters/dragon_4.png", 131, 93, 26, 36);
        SPRITES._sprites.G2_5 = new SpriteData("monsters/dragon_5.png", 156, 117, 26, 36);
        SPRITES._sprites.G2_6 = new SpriteData("monsters/dragon_6.png", 171, 125, 26, 36);
        SPRITES._sprites.G3_1 = new SpriteData("monsters/fly_1.png", 53, 40, 26, 36);
        SPRITES._sprites.G3_2 = new SpriteData("monsters/fly_2.png", 63, 46, 26, 36);
        SPRITES._sprites.G3_3 = new SpriteData("monsters/fly_3.png", 98, 81, 26, 36);
        SPRITES._sprites.G3_4 = new SpriteData("monsters/fly_4.png", 120, 92, 26, 36);
        SPRITES._sprites.G3_5 = new SpriteData("monsters/fly_5.png", 133, 105, 26, 36);
        SPRITES._sprites.G3_6 = new SpriteData("monsters/fly_6.png", 124, 105, 26, 36);
        SPRITES._sprites.G4_1 = new SpriteData("monsters/korath_1.png", 72, 49, 26, 36);
        SPRITES._sprites.G4_2 = new SpriteData("monsters/korath_2.png", 119, 81, 26, 36);
        SPRITES._sprites.G4_3 = new SpriteData("monsters/korath_3.png", 128, 102, 26, 36);
        SPRITES._sprites.G4_4 = new SpriteData("monsters/korath_4.png", 153, 123, 26, 36);
        SPRITES._sprites.G4_5 = new SpriteData("monsters/korath_5.png", 199, 162, 26, 36);
        SPRITES._sprites.G4_6 = new SpriteData("monsters/korath_6.png", 202, 167, SpriteData.FUBAR_X, SpriteData.FUBAR_Y);
        SPRITES._sprites.G5_1 = new SpriteData("monsters/krallen_1_rev_65.png", 130, 80, SpriteData.FUBAR_X, SpriteData.FUBAR_Y);
        SPRITES._sprites.G5_2 = new SpriteData("monsters/krallen_2_rev_65.png", 131, 90, SpriteData.FUBAR_X, SpriteData.FUBAR_Y);
        SPRITES._sprites.G5_3 = new SpriteData("monsters/krallen_3_rev_65.png", 142, 100, SpriteData.FUBAR_X, SpriteData.FUBAR_Y);
        SPRITES._sprites.C200 = new SpriteData("monsters/looter.png", 51, 47, 7, 33);
        SPRITES._sprites.shadow = new SpriteData("monsters/flyingshadow.png", 31, 20, 15, 10);
        SPRITES._sprites.bigshadow = new SpriteData("monsters/zafreeti-shadow.png", 48, 32, 24, 16);
        SPRITES._sprites.rocket = new SpriteData("monsters/daverocket.png", 16, 16, 26, 36);
        SPRITES._sprites.vacuum_pipe = new SpriteData("siegeimages/vacuum-pipe.png", 26, 97, 26, 36);
        SPRITES._sprites.vacuum_end = new SpriteData("siegeimages/vacuum-end.png", 52, 52, 26, 36);
        SPRITES._sprites.heart = new SpriteData("effects/heart_icon.v2.png", 12, 12, SpriteData.FUBAR_X, SpriteData.FUBAR_Y);
        SPRITES._sprites.flame = new SpriteData("effects/flame_icon.png", 16, 25, SpriteData.FUBAR_X, SpriteData.FUBAR_Y);
        SPRITES._sprites.venom = new SpriteData("effects/venom_icon.v2.png", 16, 26, SpriteData.FUBAR_X, SpriteData.FUBAR_Y);
        SPRITES._sprites.venomBal = new SpriteData("effects/venomBal_icon.png", 420, 332, SpriteData.FUBAR_X, SpriteData.FUBAR_Y);
        SPRITES._sprites[SpurtzCannon.SPURTZ_PROJECTILE] = new SpriteData("buildings/ispurtz_cannon/spurtz_projectile.png", 34, 27, SpriteData.FUBAR_X, SpriteData.FUBAR_Y);
        SPRITES._sprites[Jars.JAR_GRAPHIC] = new SpriteData(Jars.JAR_GRAPHIC_URL, Jars.JAR_GRAPHIC_WIDTH, Jars.JAR_GRAPHIC_HEIGHT, SpriteData.FUBAR_X, SpriteData.FUBAR_Y);
        SPRITES._sprites[Decoy.DECOY_WAVE] = new SpriteData("siegeimages/decoy_wave_anim.png", 61, 70, SpriteData.FUBAR_X, SpriteData.FUBAR_Y);
        SPRITES._sprites[Decoy.DECOY_FUSE] = new SpriteData("siegeimages/decoy_fuse_anim.png", 44, 49, SpriteData.FUBAR_X, SpriteData.FUBAR_Y);
        SPRITES._sprites[Decoy.DECOY_EXPLOSION] = new SpriteData("siegeimages/decoy_explosion_anim.png", 184, 195, SpriteData.FUBAR_X, SpriteData.FUBAR_Y);
        SPRITES._sprites[ResurrectProjectile.k_resurecctProjectile] = new SpriteData(ResurrectProjectile.k_projectileImageURL, 20, 20, 0, 0);
    }

    public static Clear(): void {
        SPRITES._sprites = {};
    }

    public static SetupSprite(spriteId: string): void {
        ImageCache.GetImageWithCallBack(SPRITES._sprites[spriteId].key, SPRITES.onAssetLoaded);
    }

    public static GetSpriteDescriptor(spriteId: string): SpriteData {
        return SPRITES._sprites[spriteId];
    }

    private static onAssetLoaded(key: string, bitmapData: BitmapData): void {
        for (const spriteKey in SPRITES._sprites) {
            const sprite: SpriteData = SPRITES._sprites[spriteKey];
            if (sprite.key === key) {
                sprite.image = bitmapData;
            }
        }
    }

    public static GetSprite(canvas: BitmapData, spriteId: string, state: string, angle: number, frame: number = 0, lastFrame: number = -1): number {
        if (!GLOBAL._render) return -1;
        if (angle < 0) angle = 360 + angle;

        if (spriteId === "worker") {
            if (STORE._storeData.BST) {
                if (lastFrame !== Math.floor(angle / 12)) {
                    SPRITES.GetFrame(canvas, SPRITES._sprites.worker, Math.floor(angle / 12), 1);
                }
                return Math.floor(angle / 12) + 30;
            }
            if (lastFrame !== Math.floor(angle / 12)) {
                SPRITES.GetFrame(canvas, SPRITES._sprites.worker, Math.floor(angle / 12), 0);
            }
            return Math.floor(angle / 12);
        }

        if (spriteId === "C9") {
            if (state === "invisible") {
                if (lastFrame !== Math.floor(angle / 12) + 30) {
                    SPRITES.GetFrame(canvas, SPRITES._sprites.C9, Math.floor(angle / 12), 1);
                }
                return Math.floor(angle / 12) + 30;
            }
            if (lastFrame !== Math.floor(angle / 12)) {
                SPRITES.GetFrame(canvas, SPRITES._sprites.C9, Math.floor(angle / 12), 0);
            }
            return Math.floor(angle / 12);
        }

        if (spriteId === "C12") {
            if (lastFrame !== angle * 0.083333333) {
                SPRITES.GetFrame(canvas, SPRITES._sprites.C12, Math.floor(angle * 0.083333333));
            }
            return Math.floor(angle * 0.083333333);
        }

        if (spriteId === "C13") {
            if (state === "walking") {
                if (lastFrame !== Math.floor(angle / 12)) {
                    SPRITES.GetFrame(canvas, SPRITES._sprites.C13, Math.floor(angle / 12));
                }
                return Math.floor(angle / 12);
            }
            if (state === "burrowed") {
                if (lastFrame !== 33) {
                    SPRITES.GetFrame(canvas, SPRITES._sprites.C13, Math.floor(angle / 12), 4);
                }
                return 33;
            }
            if (state === "transition") {
                if (lastFrame !== 34) {
                    SPRITES.GetFrame(canvas, SPRITES._sprites.C13, Math.floor(angle / 12), frame);
                }
                return 34;
            }
        }

        if (spriteId === "C14") {
            if (lastFrame !== Math.floor(angle / 11.25) + Math.floor(frame % 9 / 3) * 32) {
                SPRITES.GetFrame(canvas, SPRITES._sprites.C14, Math.floor(angle / 11.25), Math.floor(frame % 9 / 3));
            }
            return Math.floor(angle / 11.25) + Math.floor(frame % 9 / 3) * 32;
        }

        if (spriteId === "C15") {
            if (lastFrame !== Math.floor(angle / 11.25)) {
                SPRITES.GetFrame(canvas, SPRITES._sprites.C15, Math.floor(angle / 11.25));
            }
            return Math.floor(angle / 11.25);
        }

        if (spriteId === "shadow") {
            SPRITES.GetFrame(canvas, SPRITES._sprites.shadow, 0);
            return 0;
        }

        if (spriteId === "bigshadow") {
            SPRITES.GetFrame(canvas, SPRITES._sprites.bigshadow, 0);
            return 0;
        }

        if (spriteId === "C200") {
            if (state === "empty") {
                SPRITES.GetFrame(canvas, SPRITES._sprites.C200, Math.floor(angle / 12));
            } else {
                SPRITES.GetFrame(canvas, SPRITES._sprites.C200, Math.floor(angle / 12), 1);
            }
            return Math.floor(angle / 12);
        }

        if (spriteId === "rocket") {
            if (lastFrame !== Math.floor(angle / 11.25)) {
                SPRITES.GetFrame(canvas, SPRITES._sprites.rocket, Math.floor(angle / 11.25));
            }
            return Math.floor(angle / 11.25);
        }

        // Handle G1, G2, G3, G4, G5 champion sprites
        const prefix = spriteId.substr(0, 2);
        if ((prefix === "G1" || prefix === "G2" || prefix === "G3" || prefix === "G4" || prefix === "G5") && SPRITES._sprites[spriteId]) {
            if (state === "idle") {
                SPRITES.GetFrame(canvas, SPRITES._sprites[spriteId], Math.floor(angle / 22.5));
            } else if (state === "walking") {
                const level = parseInt(spriteId.substr(3, 1));
                let frames = 8;
                if (level === 3) frames = 9;
                else if (level > 3) frames = 10;
                SPRITES.GetFrame(canvas, SPRITES._sprites[spriteId], Math.floor(angle / 22.5), Math.floor(frame / 8) % frames);
            } else if (state === GLOBAL.e_BASE_MODE.ATTACK) {
                const level = parseInt(spriteId.substr(3, 1));
                SPRITES.GetFrame(canvas, SPRITES._sprites[spriteId], Math.floor(angle / 22.5), Math.floor(frame / 8) % 9 + 8);
            }
            return Math.floor(angle / 22.5);
        }

        // Handle generic sprites
        if (SPRITES._sprites[spriteId]) {
            if (lastFrame !== Math.floor(angle / 12)) {
                SPRITES.GetFrame(canvas, SPRITES._sprites[spriteId], Math.floor(angle / 12));
            }
            return Math.floor(angle / 12);
        }

        console.log("could not get frame " + spriteId);
        return 0;
    }

    public static GetFrame(canvas: BitmapData, sprite: SpriteData, frameX: number, frameY: number = 0): void {
        if (sprite && sprite.image) {
            sprite.rect.x = sprite.rect.width * frameX;
            sprite.rect.y = sprite.rect.height * frameY;
            if (canvas) {
                canvas.copyPixels(sprite.image, sprite.rect, sprite.offset);
            } else {
                console.log("passed in a null canvas");
            }
        }
    }

    public static GetFrameById(canvas: BitmapData, spriteId: string, frameX: number, frameY: number = 0): void {
        SPRITES.GetFrame(canvas, SPRITES._sprites[spriteId], frameX, frameY);
    }
}
