import Bitmap from 'openfl/display/Bitmap';
import BitmapData from 'openfl/display/BitmapData';
import BitmapDataChannel from 'openfl/display/BitmapDataChannel';
import Point from 'openfl/geom/Point';
import Rectangle from 'openfl/geom/Rectangle';
import { BASE } from './BASE';
import { LOGGER } from './LOGGER';

/**
 * MAPBG - Map Background Generator
 * Creates procedurally generated terrain tiles for the game map
 */
export class MAPBG {
    constructor() {}

    public static MakeTile(texture: string = "grass"): BitmapData {
        let groundCompiled: BitmapData = new BitmapData(1000, 500, true, 0);
        try {
            const ti: number = Date.now();
            let tileCount: number = 0;
            let g: Record<string, BitmapData> = {};
            const t: Record<string, BitmapData> = {
                t1: new BitmapData(1000, 500, true, 0),
                t2: new BitmapData(1000, 500, true, 0),
                t3: new BitmapData(1000, 500, true, 0),
                t4: new BitmapData(1000, 500, true, 0),
                t5: new BitmapData(1000, 500, true, 0),
                t6: new BitmapData(1000, 500, true, 0),
                t7: new BitmapData(1000, 500, true, 0)
            };

            // Initialize tile textures based on terrain type
            if (texture === "lava") {
                g = {
                    g1: new BitmapData(200, 100, true, 0xFF330000),
                    g2: new BitmapData(200, 100, true, 0xFF440000),
                    g3: new BitmapData(200, 100, true, 0xFF550000),
                    g4: new BitmapData(200, 100, true, 0xFF660000)
                };
                tileCount = 4;
            } else if (texture === "rock") {
                g = {
                    g1: new BitmapData(200, 100, true, 0xFF555555),
                    g2: new BitmapData(200, 100, true, 0xFF666666),
                    g3: new BitmapData(200, 100, true, 0xFF777777),
                    g4: new BitmapData(200, 100, true, 0xFF888888),
                    g5: new BitmapData(200, 100, true, 0xFF999999)
                };
                tileCount = 5;
            } else if (texture === "sand") {
                g = {
                    g1: new BitmapData(200, 100, true, 0xFFCCBB99),
                    g2: new BitmapData(200, 100, true, 0xFFDDCC99),
                    g3: new BitmapData(200, 100, true, 0xFFEEDDAA),
                    g4: new BitmapData(200, 100, true, 0xFFFFEEBB)
                };
                tileCount = 4;
            } else if (texture === "grass") {
                g = {
                    g1: new BitmapData(200, 100, true, 0xFF228822),
                    g2: new BitmapData(200, 100, true, 0xFF339933),
                    g3: new BitmapData(200, 100, true, 0xFF44AA44),
                    g4: new BitmapData(200, 100, true, 0xFF55BB55),
                    g5: new BitmapData(200, 100, true, 0xFF66CC66),
                    g6: new BitmapData(200, 100, true, 0xFF77DD77),
                    g7: new BitmapData(200, 100, true, 0xFF88EE88)
                };
                tileCount = 7;
            } else if (texture === "crater") {
                g = { g1: new BitmapData(200, 100, true, 0xFF443322) };
                tileCount = 1;
            }

            // Create tiled textures
            for (let h = 0; h < 5; h++) {
                for (let v = 0; v < 5; v++) {
                    for (let i = 1; i <= tileCount; i++) {
                        t["t" + i].copyPixels(g["g" + i], new Rectangle(0, 0, 200, 100), new Point(h * 200, v * 100), null, null, true);
                    }
                }
            }

            // Composite tiles with perlin noise masks
            groundCompiled.draw(t.t1);
            for (let tile = 2; tile <= tileCount; tile++) {
                const groundMask: BitmapData = new BitmapData(1000, 500, true, 0);
                groundMask.perlinNoise(50 * tile, 25 * tile, 2, BASE._baseSeed + 1 + tile, true, false, BitmapDataChannel.ALPHA, true, null);
                groundCompiled.copyPixels(t["t" + tile], new Rectangle(0, 0, 1000, 500), new Point(0, 0), groundMask, null, true);
            }

            // Cleanup
            for (let i = 1; i < tileCount; i++) {
                g["g" + i]?.dispose();
                t["t" + i]?.dispose();
            }
        } catch (e: any) {
            LOGGER.Log("err", "MAPBG.MakeTile: " + e.message + " | " + (e.stack || ""));
        }
        return groundCompiled;
    }
}
