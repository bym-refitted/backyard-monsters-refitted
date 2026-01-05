import { SecNum } from './com/cc/utils/SecNum';
import MovieClip from 'openfl/display/MovieClip';
import Event from 'openfl/events/Event';
import MouseEvent from 'openfl/events/MouseEvent';
import Point from 'openfl/geom/Point';
import { HatcheryBase } from './HatcheryBase';
import { BASE } from './BASE';
import { CREATURES } from './CREATURES';
import { CREATURELOCKER } from './CREATURELOCKER';
import { CREEPS } from './CREEPS';
import { GIBLETS } from './GIBLETS';
import { GLOBAL } from './GLOBAL';
import { HATCHERY } from './HATCHERY';
import { HOUSING } from './HOUSING';
import { KEYS } from './KEYS';
import { POPUPS } from './POPUPS';
import { ResourcePackages } from './ResourcePackages';
import { SOUNDS } from './SOUNDS';
import { STORE } from './STORE';
import { TUTORIAL } from './TUTORIAL';

/**
 * BUILDING13 - Hatchery
 * Extends HatcheryBase for monster production building
 */
export class BUILDING13 extends HatcheryBase {
    public _frameNumber: number = 0;
    public _timeStamp: number = 0;

    constructor() {
        super();
        this._frameNumber = 0;
        this._type = 13;
        this._inProduction = "";
        this._productionStage.Set(0);
        this._spoutPoint = new Point(-28, -58);
        this._spoutHeight = 97;
        this._taken = new SecNum(0);
        if (BASE.isInfernoMainYardOrOutpost) {
            this._animRandomStart = false;
        }
        this.SetProps();
    }

    public override PlaceB(): void {
        super.PlaceB();
    }

    public override TickFast(event: Event | null = null): void {
        if (GLOBAL._render && this._animLoaded && this._countdownBuild.Get() + this._countdownUpgrade.Get() === 0 && 
            this._inProduction !== "" && this._productionStage.Get() === 1 && this._canFunction) {
            if (GLOBAL._render && this._animLoaded && this._countdownBuild.Get() + this._countdownUpgrade.Get() === 0 && this._canFunction) {
                if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD && this._frameNumber % 2 === 0 && CREEPS._creepCount === 0) {
                    this.AnimFrame();
                } else if (this._frameNumber % 7 === 0) {
                    this.AnimFrame();
                }
            }
        } else if (this._animTick !== 0) {
            this._animTick = 0;
            super.AnimFrame(false);
        }
        ++this._frameNumber;
    }

    public override AnimFrame(advance: boolean = true): void {
        super.AnimFrame(advance);
        if (GLOBAL._hatcheryOverdrivePower.Get() === 10) {
            this._animTick += 4;
        } else if (GLOBAL._hatcheryOverdrivePower.Get() === 6) {
            this._animTick += 2;
        } else if (GLOBAL._hatcheryOverdrivePower.Get() === 4) {
            ++this._animTick;
        }
        if (this._animTick >= 30) {
            this._animTick -= 30;
        }
    }

    public override Destroyed(byAttacker: boolean = true): void {
        const resourceRefunds: SecNum[] = [new SecNum(0), new SecNum(0)];
        
        if (this._inProduction !== "") {
            if (BASE.isInfernoCreep(this._inProduction)) {
                resourceRefunds[1].Add(CREATURES.GetProperty(this._inProduction, "cResource"));
            } else {
                resourceRefunds[0].Add(CREATURES.GetProperty(this._inProduction, "cResource"));
            }
            this._inProduction = "";
        }
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
            BASE.Fund(4, Math.ceil(resourceRefunds[i].Get() * 0.75), false, null, !!i);
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

    public override Description(): void {
        super.Description();
        if (GLOBAL._hatcheryOverdrive > 0) {
            this._buildingTitle += ` <font color="#CC0000">${KEYS.Get("building_hatcheryoverdrive_title", {
                v1: GLOBAL._hatcheryOverdrivePower.Get(),
                v2: GLOBAL.ToTime(GLOBAL._hatcheryOverdrive)
            })}</font>`;
        }
        if (this._inProduction === "") {
            this._specialDescription = `<font color="#CC0000">${KEYS.Get("building_hatchery_noprod", { v1: GLOBAL._buildingProps[12].name })}</font>`;
        } else if (this._canFunction) {
            if (CREATURES.GetProperty(this._inProduction, "cResource") < BASE._resources.r3.Get() && this._productionStage.Get() === 3) {
                this._specialDescription = `<font color="#CC0000">${KEYS.Get("building_hatchery_res", { v1: GLOBAL._resourceNames[3] })}</font>`;
            } else if (this._productionStage.Get() === 2 && !HOUSING.HousingStore(this._inProduction, new Point(this._mc!.x, this._mc!.y), true)) {
                this._specialDescription = `<font color="#CC0000">${KEYS.Get("building_hatchery_housing", {
                    v1: GLOBAL._buildingProps[14].name,
                    v2: CREATURELOCKER._creatures[this._inProduction].name
                })}</font>`;
            } else if (this._productionStage.Get() === 1) {
                const totalTime: number = CREATURES.GetProperty(this._inProduction, "cTime");
                let percent: number = Math.floor(100 / totalTime * this._countdownProduce.Get());
                if (percent < 0) percent = 0;
                this._specialDescription = `Producing a ${CREATURELOCKER._creatures[this._inProduction].name}<br>`;
                if (this._productionStage.Get() === 1) {
                    this._specialDescription += `${100 - percent}% `;
                }
            }
        } else {
            this._specialDescription = `<font color="#CC0000">${KEYS.Get("building_hatchery_damaged")}</font>`;
        }
    }

    public ResetProduction(): void {
        if (this._taken.Get() > 0) {
            BASE.Fund(4, this._taken.Get());
        }
        this._taken.Set(0);
        this._hasResources = false;
        this._countdownProduce.Set(0);
        this._hpCountdownProduce = 0;
        if (this._inProduction === "") {
            this._productionStage.Set(0);
        } else {
            this._productionStage.Set(3);
        }
    }

    public override StartProduction(): void {
        this._inProduction = "";
        this._productionStage.Set(0);
        this._taken.Set(0);
        if (this._monsterQueue.length > 0) {
            this._inProduction = this._monsterQueue[0][0];
            if (this._inProduction === "C100") this._inProduction = "C12";
            --this._monsterQueue[0][1];
            if (this._monsterQueue[0][1] <= 0) {
                this._monsterQueue.splice(0, 1);
            }
            HATCHERY.Tick();
            this._productionStage.Set(3);
            this.Tick(1);
        }
    }

    public override get tickLimit(): number {
        let limit: number = super.tickLimit;
        if (this._timeStamp > GLOBAL.Timestamp()) {
            limit = Math.min(limit, this._timeStamp - GLOBAL.Timestamp());
        } else if (this._inProduction !== "" && this._countdownProduce.Get() >= 0 && 
                   HOUSING.HousingStore(this._inProduction, new Point(this._mc!.x, this._mc!.y), true, 0)) {
            limit = Math.min(limit, this._countdownProduce.Get());
        }
        return limit;
    }

    public override Tick(seconds: number): void {
        if (this._inProduction === "C100") this._inProduction = "C12";
        super.Tick(seconds);
        if (this._timeStamp > GLOBAL.Timestamp()) return;
        
        if (this._countdownBuild.Get() > 0 || this.health < this.maxHealth * 0.5) {
            this._canFunction = false;
        } else {
            this._canFunction = true;
        }
        
        if (this._canFunction) {
            if (!GLOBAL._bHatcheryCC && this._countdownBuild.Get() + this._countdownUpgrade.Get() === 0 && this.health > 10) {
                if (this._inProduction !== "" && this._productionStage.Get() === 1) {
                    if (this._countdownProduce.Get() <= 0) {
                        this._productionStage.Set(2);
                        this.Tick(1);
                        return;
                    }
                    this._hasResources = true;
                    if (GLOBAL._hatcheryOverdrive) {
                        this._countdownProduce.Add(-GLOBAL._hatcheryOverdrivePower.Get() * seconds);
                    } else {
                        this._countdownProduce.Add(-seconds);
                    }
                }
                if (this._productionStage.Get() === 2 && this._inProduction) {
                    this._taken.Set(0);
                    if (HOUSING.HousingStore(this._inProduction, new Point(this._mc!.x, this._mc!.y), false, this._countdownProduce.Get())) {
                        this.StartProduction();
                    }
                }
                if (this._productionStage.Get() === 3) {
                    this._productionStage.Set(4);
                    this._hasResources = true;
                }
                if (this._productionStage.Get() === 4 && (this._hasResources || !GLOBAL._render)) {
                    this._hasResources = true;
                    this._countdownProduce.Set(CREATURES.GetProperty(this._inProduction, "cTime"));
                    this._productionStage.Set(1);
                    this.Tick(1);
                    return;
                }
            }
        }
    }

    public FinishNow(): void {
        if (!this._canFunction) {
            GLOBAL.Message(KEYS.Get("building_hcc_cantfunction"));
            return;
        }
        if (BASE._credits.Get() >= this._finishCost.Get()) {
            let housingSpace: number = HOUSING._housingSpace.Get();
            if (this._inProduction !== "" && housingSpace >= CREATURES.GetProperty(this._inProduction, "cStorage")) {
                const pos: Point = new Point(this._mc!.x - 10 + Math.random() * 20, this._mc!.y - 10 + Math.random() * 20);
                HOUSING.HousingStore(this._inProduction, pos);
                housingSpace -= CREATURES.GetProperty(this._inProduction, "cStorage");
                this._inProduction = "";
                this._productionStage.Set(0);
                
                while (this._monsterQueue.length > 0 && housingSpace > 0) {
                    const creatureId: string = this._monsterQueue[0][0];
                    const storage: number = CREATURES.GetProperty(creatureId, "cStorage");
                    while (this._monsterQueue[0][1] > 0 && housingSpace >= storage) {
                        const p = new Point(this._mc!.x - 10 + Math.random() * 20, this._mc!.y - 10 + Math.random() * 20);
                        --this._monsterQueue[0][1];
                        housingSpace -= storage;
                        HOUSING.HousingStore(creatureId, p);
                    }
                    if (this._monsterQueue[0][1] <= 0) {
                        this._monsterQueue.shift();
                    } else if (housingSpace < storage) {
                        break;
                    }
                }
            }
            if (this._monsterQueue.length > 0) {
                this._inProduction = this._monsterQueue[0][0];
                if (this._inProduction === "C100") this._inProduction = "C12";
                --this._monsterQueue[0][1];
                if (this._monsterQueue[0][1] <= 0) {
                    this._monsterQueue.splice(0, 1);
                }
                this._productionStage.Set(3);
            } else {
                this._productionStage.Set(0);
            }
            BASE.Purchase("FQ", this._finishCost.Get(), "BUILDING13.FinishNow");
            HATCHERY.Tick();
            this.Tick(1);
        } else {
            POPUPS.DisplayGetShiny();
        }
    }

    public override Constructed(): void {
        super.Constructed();
        GLOBAL._bHatchery = this;
    }

    public override Cancel(): void {
        GLOBAL._bHatchery = null;
        super.Cancel();
    }

    public override RecycleC(): void {
        GLOBAL._bHatchery = null;
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
        this._timeStamp = building.saved >= 0 ? building.saved : 0;
        
        for (let i = this._monsterQueue.length - 1; i >= 0; i--) {
            if (!this._monsterQueue[i][0]) {
                this._monsterQueue.splice(i);
            } else if (this._monsterQueue[i][0] === "C100") {
                this._monsterQueue[i][0] = "C12";
            }
        }
        super.Setup(building);
        if (this._countdownBuild.Get() === 0 || TUTORIAL._stage < 200) {
            GLOBAL._bHatchery = this;
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
