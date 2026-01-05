import { SecNum } from './com/cc/utils/SecNum';
import { InstanceManager } from './com/monsters/managers/InstanceManager';
import MovieClip from 'openfl/display/MovieClip';
import MouseEvent from 'openfl/events/MouseEvent';
import Point from 'openfl/geom/Point';
import { HatcheryBase } from './HatcheryBase';
import { BASE } from './BASE';
import { BUILDING13 } from './BUILDING13';
import { CREATURES } from './CREATURES';
import { GLOBAL } from './GLOBAL';
import { HATCHERYCC } from './HATCHERYCC';
import { HOUSING } from './HOUSING';
import { KEYS } from './KEYS';
import { POPUPS } from './POPUPS';
import { ResourcePackages } from './ResourcePackages';
import { STORE } from './STORE';

/**
 * BUILDING16 - Hatchery Control Center
 * Extends HatcheryBase for centralized monster queue management
 */
export class BUILDING16 extends HatcheryBase {
    constructor() {
        super();
        this._type = 16;
        this._spoutPoint = new Point(0, -5);
        this._spoutHeight = 55;
        this.SetProps();
    }

    public override PlaceB(): void {
        super.PlaceB();
    }

    public override Destroyed(byAttacker: boolean = true): void {
        const resourceRefunds: SecNum[] = [new SecNum(0), new SecNum(0)];
        
        if (this._monsterQueue.length > 0) {
            for (const queueItem of this._monsterQueue) {
                if (BASE.isInfernoCreep(queueItem[0])) {
                    resourceRefunds[1].Add(CREATURES.GetProperty(queueItem[0], "cResource") * queueItem[1]);
                } else {
                    resourceRefunds[0].Add(CREATURES.GetProperty(queueItem[0], "cResource") * queueItem[1]);
                }
            }
            this._monsterQueue = [];
        }
        
        for (let i = 0; i < resourceRefunds.length; i++) {
            BASE.Fund(4, Math.ceil(resourceRefunds[i].Get() * 0.75), false, this, !!i);
            let packageCount: number = 0;
            const amount = resourceRefunds[i].Get();
            if (amount > 20000) packageCount = 12;
            else if (amount > 10000) packageCount = 9;
            else if (amount > 5000) packageCount = 7;
            else if (amount > 1000) packageCount = 5;
            else if (amount > 400) packageCount = 4;
            else if (amount > 200) packageCount = 3;
            else if (amount > 100) packageCount = 2;
            else if (amount > 0) packageCount = 1;
            
            for (let j = 0; j < packageCount; j++) {
                ResourcePackages.Spawn(this, GLOBAL.townHall, BASE.isInfernoMainYardOrOutpost || !!i ? 8 : 4, j);
            }
        }
        super.Destroyed(byAttacker);
    }

    public ResetProduction(): void {
        if (this._inProduction === "") {
            this._productionStage.Set(0);
        } else {
            this._productionStage.Set(3);
            this._countdownProduce.Set(0);
            this._hpCountdownProduce = 0;
        }
    }

    public override Tick(seconds: number): void {
        super.Tick(seconds);
        let housingSpace: number = HOUSING._housingSpace.Get();
        let totalTime: number = 0;
        this._finishQueue = {};
        this._finishAll = true;
        
        if (this._countdownBuild.Get() === 0 && this.health > 10) {
            this._canFunction = true;
            const hatcheries: any[] = InstanceManager.getInstancesByClass(BUILDING13);
            
            for (const hatchery of hatcheries) {
                if (hatchery._canFunction) {
                    if (hatchery._inProduction !== "" && housingSpace >= CREATURES.GetProperty(hatchery._inProduction, "cStorage")) {
                        housingSpace -= CREATURES.GetProperty(hatchery._inProduction, "cStorage");
                        if (this._finishQueue[hatchery._inProduction]) {
                            ++this._finishQueue[hatchery._inProduction];
                        } else {
                            this._finishQueue[hatchery._inProduction] = 1;
                        }
                        totalTime += hatchery._countdownProduce.Get();
                    } else if (this._monsterQueue.length > 0) {
                        if (hatchery._canFunction && hatchery._inProduction === "") {
                            hatchery._inProduction = this._monsterQueue[0][0];
                            --this._monsterQueue[0][1];
                            if (this._monsterQueue[0][1] <= 0) {
                                this._monsterQueue.splice(0, 1);
                            }
                            hatchery._productionStage.Set(3);
                            hatchery.Tick(1);
                            HATCHERYCC.Tick();
                            if (this._monsterQueue.length === 0) return;
                        }
                    }
                }
            }
            
            if (this._monsterQueue.length > 0 && housingSpace >= 10) {
                for (const queueItem of this._monsterQueue) {
                    const creatureId: string = queueItem[0];
                    const storage: number = CREATURES.GetProperty(creatureId, "cStorage");
                    if (housingSpace >= storage * queueItem[1]) {
                        totalTime += CREATURES.GetProperty(creatureId, "cTime") * queueItem[1];
                        housingSpace -= storage * queueItem[1];
                        if (this._finishQueue[creatureId]) {
                            this._finishQueue[creatureId] += queueItem[1];
                        } else {
                            this._finishQueue[creatureId] = queueItem[1];
                        }
                    } else if (housingSpace >= storage) {
                        totalTime += CREATURES.GetProperty(creatureId, "cTime") * Math.floor(housingSpace / storage);
                        if (this._finishQueue[creatureId]) {
                            this._finishQueue[creatureId] += Math.floor(housingSpace / storage);
                        } else {
                            this._finishQueue[creatureId] = Math.floor(housingSpace / storage);
                        }
                        this._finishAll = false;
                        break;
                    }
                }
            }
        } else {
            this._canFunction = false;
        }
        
        if (this._canFunction && totalTime > 0) {
            this._finishCost.Set(STORE.GetTimeCost(totalTime, false) * 4);
        } else {
            this._finishCost.Set(0);
        }
    }

    public FinishNow(): void {
        if (!this._canFunction) {
            GLOBAL.Message(KEYS.Get("building_hcc_cantfunction"));
            return;
        }
        if (BASE._credits.Get() >= this._finishCost.Get()) {
            const hatcheryList: any[] = [];
            let housingSpace: number = HOUSING._housingSpace.Get();
            const hatcheries: any[] = InstanceManager.getInstancesByClass(BUILDING13);
            
            for (const hatchery of hatcheries) {
                if (hatchery._canFunction) {
                    hatcheryList.push(hatchery);
                    if (hatchery._inProduction !== "" && housingSpace >= CREATURES.GetProperty(hatchery._inProduction, "cStorage")) {
                        const pos: Point = new Point(hatchery._mc.x - 10 + Math.random() * 20, hatchery._mc.y - 10 + Math.random() * 20);
                        HOUSING.HousingStore(hatchery._inProduction, pos);
                        housingSpace -= CREATURES.GetProperty(hatchery._inProduction, "cStorage");
                        hatchery._inProduction = "";
                        hatchery._productionStage.Set(0);
                    }
                }
            }
            
            while (this._monsterQueue.length > 0 && housingSpace > 0) {
                const creatureId: string = this._monsterQueue[0][0];
                const storage: number = CREATURES.GetProperty(creatureId, "cStorage");
                while (this._monsterQueue[0][1] > 0 && housingSpace >= storage) {
                    const idx: number = Math.floor(Math.random() * hatcheryList.length);
                    const pos: Point = new Point(hatcheryList[idx]._mc.x - 10 + Math.random() * 20, hatcheryList[idx]._mc.y - 10 + Math.random() * 20);
                    --this._monsterQueue[0][1];
                    housingSpace -= storage;
                    HOUSING.HousingStore(creatureId, pos);
                }
                if (this._monsterQueue[0][1] <= 0) {
                    this._monsterQueue.shift();
                } else if (housingSpace < storage) {
                    break;
                }
            }
            BASE.Purchase("FQ", this._finishCost.Get(), "BUILDING16.FinishNow");
        } else {
            POPUPS.DisplayGetShiny();
        }
    }

    public override Constructed(): void {
        super.Constructed();
        GLOBAL._bHatcheryCC = this;
        const hatcheries: any[] = InstanceManager.getInstancesByClass(BUILDING13);
        for (const hatchery of hatcheries) {
            for (const queueItem of hatchery._monsterQueue) {
                BASE.Fund(4, queueItem[1] * CREATURES.GetProperty(queueItem[0], "cResource"));
            }
            hatchery._monsterQueue = [];
        }
    }

    public override RecycleC(): void {
        GLOBAL._bHatcheryCC = null;
        super.RecycleC();
    }

    public override Upgraded(): void {
        super.Upgraded();
    }

    public override Setup(building: any): void {
        this._monsterQueue = [];
        if (building.mq) {
            this._monsterQueue = building.mq;
        }
        for (const queueItem of this._monsterQueue) {
            if (queueItem[0] === "C100") {
                queueItem[0] = "C12";
            }
        }
        super.Setup(building);
        if (this._countdownBuild.Get() === 0) {
            GLOBAL._bHatcheryCC = this;
        }
    }

    public override Export(): any {
        const data: any = super.Export();
        if (this._monsterQueue.length > 0) {
            data.mq = this._monsterQueue;
        }
        return data;
    }
}
