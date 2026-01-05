import MovieClip from 'openfl/display/MovieClip';
import Point from 'openfl/geom/Point';
import { BASE } from './BASE';
import { BFOUNDATION } from './BFOUNDATION';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { MAP } from './MAP';
import { QUESTS } from './QUESTS';
import { TUTORIAL } from './TUTORIAL';
import { WORKER } from './WORKER';
import { TweenLite } from './gs/TweenLite';

/**
 * WORKERS - Worker Management System
 * Handles worker spawning, assignment, and task management
 */
export class WORKERS {
    public static _workers: any[] = [];
    public static _sayings: Record<string, string[]> = {};

    constructor() {}

    public static Setup(): void {
        WORKERS._workers = [];
        if (BASE.isInfernoMainYardOrOutpost) {
            WORKERS._sayings = {
                assign: [KEYS.Get("ai_worker_comment1"), KEYS.Get("ai_worker_comment2"), KEYS.Get("ai_worker_comment3"), KEYS.Get("ai_worker_comment5"), KEYS.Get("ai_worker_comment6"), KEYS.Get("ai_worker_comment7")],
                remove: [KEYS.Get("ai_worker_cancel1"), KEYS.Get("ai_worker_cancel2"), KEYS.Get("ai_worker_cancel3"), KEYS.Get("ai_worker_cancel4")],
                doneConstruct: [KEYS.Get("ai_worker_doneconstruct1"), KEYS.Get("ai_worker_doneconstruct2"), KEYS.Get("ai_worker_doneconstruct3"), KEYS.Get("ai_worker_doneconstruct4")],
                doneRepair: [KEYS.Get("ai_worker_donerepair1"), KEYS.Get("ai_worker_donerepair2"), KEYS.Get("ai_worker_donerepair3"), KEYS.Get("ai_worker_donerepair4")],
                doneUpgrade: [KEYS.Get("ai_worker_doneupgrade1"), KEYS.Get("ai_worker_doneupgrade2"), KEYS.Get("ai_worker_doneupgrade3"), KEYS.Get("ai_worker_doneupgrade4")]
            };
        } else {
            WORKERS._sayings = {
                assign: [KEYS.Get("ui_worker_assign1"), KEYS.Get("ui_worker_assign2"), KEYS.Get("ui_worker_assign3"), KEYS.Get("ui_worker_assign4"), KEYS.Get("ui_worker_assign5"), KEYS.Get("ui_worker_assign6")],
                remove: [KEYS.Get("ui_worker_remove1"), KEYS.Get("ui_worker_remove2"), KEYS.Get("ui_worker_remove3"), KEYS.Get("ui_worker_remove4")],
                doneConstruct: [KEYS.Get("ui_worker_doneconstruct1"), KEYS.Get("ui_worker_doneconstruct2"), KEYS.Get("ui_worker_doneconstruct3"), KEYS.Get("ui_worker_doneconstruct4"), KEYS.Get("ui_worker_doneconstruct5"), KEYS.Get("ui_worker_doneconstruct6"), KEYS.Get("ui_worker_doneconstruct7"), KEYS.Get("ui_worker_doneconstruct8")],
                doneRepair: [KEYS.Get("ui_worker_donerepair1"), KEYS.Get("ui_worker_donerepair2")],
                doneUpgrade: [KEYS.Get("ui_worker_doneupgrade1"), KEYS.Get("ui_worker_doneupgrade2"), KEYS.Get("ui_worker_doneupgrade3"), KEYS.Get("ui_worker_doneupgrade4"), KEYS.Get("ui_worker_doneupgrade5")]
            };
        }
    }

    public static Spawn(): Record<string, any> {
        let spawnPoint: Point;
        if (TUTORIAL._stage < 10) {
            spawnPoint = new Point(0, 0);
        } else {
            spawnPoint = new Point(GLOBAL._mapWidth / 2 - Math.random() * GLOBAL._mapWidth, GLOBAL._mapHeight / 2 - Math.random() * GLOBAL._mapHeight);
        }
        const worker: WORKER = MAP._BUILDINGTOPS.addChild(new WORKER(MAP._BUILDINGTOPS, spawnPoint, Math.random() * 360)) as WORKER;
        WORKERS._workers.push({
            mc: worker,
            task: null
        });
        QUESTS._global.worder_count = WORKERS._workers.length;
        return { mc: worker };
    }

    public static Tick(): void {
        if (GLOBAL._render) {
            for (const key in WORKERS._workers) {
                const workerData = WORKERS._workers[key];
                workerData.mc.Tick();
            }
        }
    }

    public static Assign(building: BFOUNDATION): Record<string, any> | null {
        let minDist: number = 3000;
        let closestWorker: any = null;
        for (const key in WORKERS._workers) {
            const workerData = WORKERS._workers[key];
            if (!workerData.task) {
                const dist: number = Point.distance(new Point(workerData.mc.x, workerData.mc.y), new Point(building._mc!.x, building._mc!.y));
                if (dist < minDist) {
                    minDist = dist;
                    closestWorker = workerData;
                }
            }
        }
        if (closestWorker) {
            closestWorker.task = building;
            closestWorker.mc.Target(new Point(building._mc!.x, building._mc!.y + building._mcFootprint!.height / 2), building);
            closestWorker.mc._targetTask = building;
            let saying: string = "";
            if (!GLOBAL._catchup) {
                saying = WORKERS._sayings.assign[Math.floor(Math.random() * WORKERS._sayings.assign.length)];
                WORKERS.Say(saying, closestWorker.mc);
            } else {
                closestWorker.mc.x = building._mc!.x;
                closestWorker.mc.y = building._mc!.y;
                closestWorker.mc._targetPosition = new Point(building._mc!.x, building._mc!.y + building._mcFootprint!.height / 2 - 5);
                closestWorker.mc._waypoints = [new Point(building._mc!.x, building._mc!.y + building._mcFootprint!.height / 2 - 5)];
                building._hasWorker = true;
            }
            return { mc: closestWorker.mc, say: saying };
        }
        return null;
    }

    public static Remove(building: BFOUNDATION, success: boolean = true, taskType: string = "Construct"): MovieClip | null {
        for (const key in WORKERS._workers) {
            const workerData = WORKERS._workers[key];
            if (workerData.task === building) {
                workerData.task = null;
                workerData.mc._targetTask = null;
                building._hasWorker = false;
                if (GLOBAL._render) {
                    workerData.mc.Wander();
                    if (success) {
                        const sayings: string[] = WORKERS._sayings["done" + taskType];
                        WORKERS.Say(sayings[Math.floor(Math.random() * sayings.length)], workerData.mc);
                    } else {
                        WORKERS.Say(WORKERS._sayings.remove[Math.floor(Math.random() * WORKERS._sayings.remove.length)], workerData.mc);
                    }
                } else {
                    const newPos: Point = new Point(building._mc!.x + 20, building._mc!.y + 80);
                    workerData.mc._targetPosition = newPos;
                    workerData.mc._waypoints = [];
                    workerData.mc.x = newPos.x;
                    workerData.mc.y = newPos.y;
                }
                return workerData.mc;
            }
        }
        return null;
    }

    public static Say(message: string, workerMC: MovieClip | null = null, duration: number = 2000): void {
        if (!workerMC) {
            workerMC = WORKERS._workers[0].mc;
            (workerMC as any).Target(new Point((workerMC as any).x + 20, (workerMC as any).y + 150));
            (workerMC as any).Move();
            (workerMC as any).Update();
        }
        (workerMC as any).Say(message, duration);
    }
}
