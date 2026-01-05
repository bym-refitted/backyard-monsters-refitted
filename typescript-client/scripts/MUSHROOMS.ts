import { Rndm } from './com/gskinner/utils/Rndm';
import Rectangle from 'openfl/geom/Rectangle';
import { BASE } from './BASE';
import { BFOUNDATION } from './BFOUNDATION';
import { GLOBAL } from './GLOBAL';
import { GRID } from './GRID';
import { KEYS } from './KEYS';
import { LOGGER } from './LOGGER';
import { POPUPS } from './POPUPS';
import { QUEUE } from './QUEUE';
import { QUESTS } from './QUESTS';
import { WORKERS } from './WORKERS';

/**
 * MUSHROOMS - Mushroom Spawn and Collection System
 * Handles spawning and picking mushrooms on the map
 */
export class MUSHROOMS {
    public static _mushroom: BFOUNDATION | null = null;
    public static _mushroomID: number = 0;

    constructor() {}

    public static Setup(): void {
        let mushroomCount: number = 0;
        if (!GLOBAL._flags.mushrooms && GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD) {
            return;
        }
        if (!BASE.isMainYard) {
            return;
        }
        try {
            if (BASE._lastSpawnedMushroom === 0) {
                BASE._mushroomList = [];
                const twist: number = Math.floor(Math.random() * 360);
                for (let i = 1; i < 6; i++) {
                    const dist: number = i * 100 + 300;
                    const angle: number = i * 60 + twist;
                    const spawn: number = 4;
                    const X: number = Math.sin(angle * 0.0174532925) * dist;
                    const Y: number = Math.cos(angle * 0.0174532925) * dist;
                    const a: number = 100 + Math.random() * 80;
                    const b: number = 100 + Math.random() * 80;
                    for (let s = 0; s < spawn; s++) {
                        const n: number = Math.floor(Math.random() * 5) + 1;
                        let X2: number = X + Math.sin(Math.floor(Math.random() * 360) * 0.0174532925) * a;
                        let Y2: number = Y + Math.cos(Math.floor(Math.random() * 360) * 0.0174532925) * b;
                        X2 = Math.floor(X2 / 10) * 10;
                        Y2 = Math.floor(Y2 / 10) * 10;
                        MUSHROOMS._mushroom = BASE.addBuildingC(7);
                        MUSHROOMS._mushroom.Setup({
                            X: X2,
                            Y: Y2,
                            id: mushroomCount,
                            t: 7,
                            frame: n
                        });
                        mushroomCount++;
                    }
                }
                BASE._lastSpawnedMushroom = GLOBAL.Timestamp();
            } else {
                for (let i = 0; i < Math.min(BASE._mushroomList.length, 20); i++) {
                    const shroom: any = {
                        frame: BASE._mushroomList[i][0],
                        X: BASE._mushroomList[i][1],
                        Y: BASE._mushroomList[i][2],
                        id: mushroomCount,
                        t: 7
                    };
                    let replace: boolean = false;
                    if (shroom.X > GLOBAL._mapWidth * 0.5 || shroom.X < -GLOBAL._mapWidth * 0.5 ||
                        shroom.Y > GLOBAL._mapHeight * 0.5 || shroom.Y < -GLOBAL._mapHeight * 0.5) {
                        replace = true;
                    }
                    if (!replace) {
                        MUSHROOMS._mushroom = BASE.addBuildingC(7);
                        MUSHROOMS._mushroom.Setup(shroom);
                    } else {
                        MUSHROOMS.Spawn(1);
                    }
                    mushroomCount++;
                }
                if (BASE._mushroomList.length > 20) {
                    for (let i = BASE._mushroomList.length - 1; i > 19; i--) {
                        delete BASE._mushroomList[i];
                    }
                }
            }
        } catch (e: any) {
            LOGGER.Log("err", "MUSHROOMS.SetupA: " + e.message + " | " + e.stack);
            GLOBAL.ErrorMessage("");
        }
        try {
            const spawnCount: number = Math.min(10, Math.floor((GLOBAL.Timestamp() - BASE._lastSpawnedMushroom) / 17280));
            if (spawnCount > 0) {
                BASE._lastSpawnedMushroom = GLOBAL.Timestamp();
                const actualSpawnCount: number = Math.min(spawnCount, 10 - mushroomCount);
                if (actualSpawnCount > 0) {
                    MUSHROOMS.Spawn(actualSpawnCount);
                }
            }
        } catch (e: any) {
            LOGGER.Log("err", "MUSHROOMS.SetupB: " + e.message + " | " + e.stack);
            GLOBAL.ErrorMessage("");
        }
    }

    public static Spawn(count: number): void {
        if (!GLOBAL._flags.mushrooms && GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD) {
            return;
        }
        if (!BASE.isMainYard) {
            return;
        }
        BASE._lastSpawnedMushroom = GLOBAL.Timestamp();
        LOGGER.Stat([35, count]);
        for (let i = 0; i < count; i++) {
            const frame: number = Math.floor(Math.random() * 5) + 1;
            let found: boolean = false;
            let X: number = 0;
            let Y: number = 0;
            let attempts: number = 0;
            while (!found && attempts < 5000) {
                attempts++;
                X = 200 + GLOBAL._mapWidth * 0.5 - Math.random() * (GLOBAL._mapWidth + 400);
                Y = 200 + GLOBAL._mapHeight * 0.5 - Math.random() * (GLOBAL._mapHeight + 400);
                if (X > GLOBAL._mapWidth * 0.5 || X < -GLOBAL._mapWidth * 0.5 ||
                    Y > GLOBAL._mapHeight * 0.5 || Y < -GLOBAL._mapHeight * 0.5) {
                    found = true;
                }
                if (!found && !GRID.FootprintBlocked([new Rectangle(0, 0, 30, 30)], GRID.ToISO(X, Y, 0), true)) {
                    found = true;
                }
            }
            if (found) {
                MUSHROOMS._mushroom = BASE.addBuildingC(7);
                ++BASE._buildingCount;
                MUSHROOMS._mushroom.Setup({
                    X: X,
                    Y: Y,
                    id: BASE._buildingCount,
                    t: 7,
                    frame: frame
                });
            }
        }
    }

    public static PickWorker(building: BFOUNDATION): void {
        if (!building._picking) {
            if (QUEUE.Add("mushroom" + building._id, building)) {
                building._mc!.alpha = 0.5;
                building._picking = true;
            } else {
                POPUPS.DisplayWorker(2, building);
            }
        }
    }

    public static Pick(building: BFOUNDATION): boolean {
        const mushroomId: number = building._id;
        let message: string = "";
        if (BASE._pendingPurchase.length > 0) {
            return false;
        }
        const rndm: Rndm = new Rndm(Math.floor(building.x * building.y));
        let shinyAmount: number = 0;
        ++QUESTS._global.mushroomspicked;
        if (Math.floor(rndm.random() * 4) === 0) {
            ++QUESTS._global.goldmushroomspicked;
            GLOBAL.ValidateMushroomPick(building);
            const type: number = Math.floor(Math.random() * 3 + 1);
            const actualType: number = type === 3 ? 1 : type;
            BASE.Purchase("MUSHROOM" + actualType, 1, "MUSHROOMS");
            shinyAmount = actualType === 1 ? 3 : 8;
            message = KEYS.Get("pop_mushroom_msg1", { v1: shinyAmount });
            const popup: any = new (GLOBAL as any).popup_mushroomshiny();
            popup.tTitle.htmlText = "<b>" + KEYS.Get("pop_goldenmushroom_title") + "</b>";
            popup.tMessage.htmlText = KEYS.Get("pop_goldenmushroom_desc", { v1: shinyAmount });
            POPUPS.Push(popup, null, null, "chaching", "goldmushroom.png");
        } else {
            const msgType: number = Math.floor(Math.random() * 3);
            if (msgType === 0) {
                message = KEYS.Get("pop_mushroom_msg2");
            } else if (msgType === 1) {
                message = KEYS.Get("pop_mushroom_msg3");
            } else {
                message = KEYS.Get("pop_mushroom_msg4");
            }
            BASE.Save();
        }
        LOGGER.Stat([34, shinyAmount]);
        QUESTS.Check();
        WORKERS.Say(message, QUEUE.Remove("mushroom" + mushroomId, true), 3000);
        building.RecycleC();
        return true;
    }
}
