import MovieClip from 'openfl/display/MovieClip';
import MouseEvent from 'openfl/events/MouseEvent';
import { SecNum } from './com/cc/utils/SecNum';
import { ILootable } from './com/monsters/interfaces/ILootable';
import { IMapRoomCell } from './com/monsters/maproom_manager/IMapRoomCell';
import { MapRoomManager } from './com/monsters/maproom_manager/MapRoomManager';
import { CModifiableProperty } from './com/monsters/monsters/components/CModifiableProperty';
import { BFOUNDATION } from './BFOUNDATION';
import { ATTACK } from './ATTACK';
import { BASE } from './BASE';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { LOGGER } from './LOGGER';
import { POPUPS } from './POPUPS';
import { QUESTS } from './QUESTS';
import { ResourcePackages } from './ResourcePackages';
import { TUTORIAL } from './TUTORIAL';

/**
 * BRESOURCE - Resource harvester building class
 * Extends BFOUNDATION for resource production buildings
 */
export class BRESOURCE extends BFOUNDATION implements ILootable {
    public static readonly RESOURCE_TWIGS: number = 1;
    public static readonly RESOURCE_PEBBLES: number = 2;
    public static readonly RESOURCE_PUTTY: number = 3;
    public static readonly RESOURCE_GOO: number = 4;
    public static readonly RESOURCE_BONE: number = 5;
    public static readonly RESOURCE_COAL: number = 6;
    public static readonly RESOURCE_SULFUR: number = 7;
    public static readonly RESOURCE_MAGMA: number = 8;
    private static readonly _RESOURCE_BONUS: number = 1.5;
    private static readonly _RESOURCE_ALLIANCE_BONUS: number = 1.15;

    public productionRateProperty: CModifiableProperty = new CModifiableProperty();
    public productionCapacityProperty: CModifiableProperty = new CModifiableProperty();

    constructor() {
        super();
    }

    public static AdjustProduction(cell: IMapRoomCell | null, value: number): number {
        if (MapRoomManager.instance.isInMapRoom2 && BASE.isOutpostMapRoom2Only && 
            cell && cell.cellHeight && cell.cellHeight >= 100) {
            return Math.max(Math.floor(value * GLOBAL._averageAltitude.Get() / cell.cellHeight), 1);
        }
        return value;
    }

    public static GetResourceNameKey(resourceType: number): string | null {
        if (resourceType <= 3 && BASE.isInfernoMainYardOrOutpost) {
            resourceType += 4;
        }
        switch (resourceType) {
            case 0: return "#r_twigs#";
            case 1: return "#r_pebbles#";
            case 2: return "#r_putty#";
            case 3: return "#r_goo#";
            case 4: return "#r_bone#";
            case 5: return "#r_coal#";
            case 6: return "#r_sulfur#";
            case 7: return "#r_magma#";
            case 8: return "#r_shiny#";
            default: return null;
        }
    }

    public override SetProps(): void {
        super.SetProps();
        this.productionRateProperty = new CModifiableProperty();
        this.productionCapacityProperty = new CModifiableProperty();
    }

    public override PlaceB(): void {
        super.PlaceB();
    }

    public override Click(event: MouseEvent | null = null): void {
        super.Click(event);
    }

    public override Loot(amount: number): number {
        let looted: number = 0;
        if (this._stored.Get() >= amount) {
            looted = amount;
        } else {
            looted = this._stored.Get();
        }
        if (looted > 0) {
            this._stored.Add(-looted);
            ATTACK.Loot(this._type, looted, this._mc!.x, this._mc!.y, 0, this);
            if (BASE.isOutpost && looted > 0) {
                BASE._resources["r" + this._type].Add(-looted);
                BASE._hpResources["r" + this._type] -= looted;
                if (BASE._deltaResources["r" + this._type]) {
                    BASE._deltaResources["r" + this._type].Add(-looted);
                    BASE._hpDeltaResources["r" + this._type] -= looted;
                } else {
                    BASE._deltaResources["r" + this._type] = new SecNum(-looted);
                    BASE._hpDeltaResources["r" + this._type] = -looted;
                }
                BASE._deltaResources.dirty = true;
                BASE._hpDeltaResources.dirty = true;
            }
        }
        if (this._stored.Get() <= 0) {
            this._looted = true;
            this._canFunction = false;
            this._producing = 0;
        }
        return super.Loot(looted);
    }

    public override Destroyed(byAttacker: boolean = true): void {
        if (byAttacker) {
            this.Loot(this._stored.Get());
        }
        super.Destroyed(byAttacker);
    }

    public override Constructed(): void {
        super.Constructed();
        if (!this._producing) {
            this.StartProduction();
        }
    }

    public override Upgraded(): void {
        super.Upgraded();
        if (!this._producing) {
            this.StartProduction();
        }
    }

    public override Description(): void {
        super.Description();
        // Production rate calculation per hour
        let ratePerHour: number = this._buildingProps.produce[this._lvl.Get() - 1] / 
            this._buildingProps.cycleTime[this._lvl.Get() - 1] * 60 * 60;
        if (BASE.isOutpost) {
            ratePerHour = BRESOURCE.AdjustProduction(GLOBAL._currentCell, ratePerHour);
        }
        // Additional description logic would go here
    }

    public override get tickLimit(): number {
        if (BASE.isOutpost || !this._canFunction) {
            return super.tickLimit;
        }
        const remaining: number = this.productionCapacity - this._stored.Get();
        if (remaining > 0) {
            if (!this._repairing) {
                return Math.min(Math.floor(this.productionCapacity / this.productionValue) * this.productionTimeout, super.tickLimit);
            }
            return Math.min(this.productionValue * this.productionTimeout, super.tickLimit);
        }
        return super.tickLimit;
    }

    public override Tick(seconds: number): void {
        let secondsRemaining: number = seconds;
        super.Tick(seconds);
        if (BASE.isOutpost) {
            this._canFunction = this.health >= 0;
            if (!GLOBAL._catchup) {
                if (this._countdownProduce.Add(-1) <= 0 && this._canFunction) {
                    if (this.health > 0) {
                        ResourcePackages.Create(BASE.isInfernoMainYardOrOutpost ? this._type + 4 : this._type, this, 1);
                    }
                    this._countdownProduce.Set(10 + Math.random() * 10);
                }
            }
        } else if (this._countdownBuild.Get() + this._countdownUpgrade.Get() + this._countdownFortify.Get() === 0) {
            this._canFunction = this.health >= this.maxHealth * 0.5;
            if (this._canFunction && this._producing) {
                while (secondsRemaining > 0 && this._producing) {
                    if (this._countdownProduce.Get() <= secondsRemaining) {
                        secondsRemaining -= this._countdownProduce.Get();
                        this._countdownProduce.Set(0);
                        this.Produce();
                    } else {
                        this._countdownProduce.Add(-secondsRemaining);
                        secondsRemaining = 0;
                    }
                }
            }
        }
    }

    public override Update(force: boolean = false): void {
        super.Update(force);
    }

    public override StartProduction(): void {
        if (this.health > 0) {
            if (this._stored.Get() >= this.productionCapacity) {
                this._producing = 0;
            } else {
                this._producing = 1;
                this._countdownProduce.Set(this.productionTimeout);
            }
        }
    }

    public get productionTimeout(): number {
        return this._buildingProps.cycleTime[this._lvl.Get() - 1] + 
            Math.ceil(this._buildingProps.cycleTime[this._lvl.Get() - 1] * (4 - 4 / this.maxHealth * this.health));
    }

    private ApplyTerrainBonus(value: number): number {
        const bonusKey: string = "r" + this._type + "bonus";
        if (BASE.isMainYardInfernoOnly && BASE._resources[bonusKey] === 1) {
            value *= BRESOURCE._RESOURCE_BONUS;
        }
        return value;
    }

    public Produce(totalIterations: number = 1): void {
        if (this._prefab || this.health <= 0 || this._lvl.Get() <= 0) {
            this._producing = 0;
            return;
        }
        if (Math.max(this._countdownProduce.Get(), 0)) {
            LOGGER.Log("hak", "BRESOURCE.Produce hack");
            return;
        }
        if (this._producing) {
            this._stored.Set(Math.min(this._stored.Get() + (this.productionValue * totalIterations), this.productionCapacity));
            if (this._stored.Get() >= this.productionCapacity) {
                this._producing = 0;
            }
        }
        if (this._producing) {
            this.StartProduction();
        }
    }

    public get productionValue(): number {
        let value: number = this._buildingProps.produce[this._lvl.Get() - 1];
        if (BASE.isOutpost) {
            value = BRESOURCE.AdjustProduction(GLOBAL._currentCell, value);
        }
        if (GLOBAL._harvesterOverdrive >= GLOBAL.Timestamp() && GLOBAL._harvesterOverdrivePower.Get() > 0) {
            value *= GLOBAL._harvesterOverdrivePower.Get();
        }
        value = this.ApplyTerrainBonus(value);
        this.productionRateProperty.value = value;
        return this.productionRateProperty.value;
    }

    public get productionCapacity(): number {
        return this.productionCapacityProperty.value;
    }

    public override Bank(): void {
        const stored: SecNum = new SecNum(this._stored.Get());
        const capacity: SecNum = new SecNum(this._buildingProps.capacity[this._lvl.Get() - 1]);
        if (stored.Get() > capacity.Get()) {
            stored.Set(capacity.Get());
        }
        if (stored.Get() > 0) {
            const funded: SecNum = new SecNum(BASE.Fund(this._type, stored.Get(), false, this));
            if (funded.Get() > 0) {
                ResourcePackages.Create(BASE.isInfernoMainYardOrOutpost ? this._type + 4 : this._type, this, stored.Get());
                if (TUTORIAL._stage < 200) {
                    BASE.PointsAdd(funded.Get());
                } else {
                    BASE.PointsAdd(Math.ceil(funded.Get() * 0.5));
                }
            }
            BASE.CalcResources();
            if (stored.Get() > QUESTS._global.singleclickbank) {
                QUESTS._global.singleclickbank = stored.Get();
            }
            if (!GLOBAL._catchup) {
                QUESTS.Check();
            }
            LOGGER.Stat([32, this._type, stored.Get()]);
        }
    }

    public override Repair(): void {
        super.Repair();
        if (!this._producing) {
            this.StartProduction();
        }
    }

    public override Repaired(): void {
        super.Repaired();
    }

    public override Export(): any {
        if (BASE.isOutpost) {
            return super.Export();
        }
        const data: any = super.Export();
        data.st = this._stored.Get();
        data.pr = this._producing;
        if (this._countdownProduce.Get() > 0) {
            data.cP = this._countdownProduce.Get();
        }
        return data;
    }

    public override Setup(building: any): void {
        if (building.l && building.l <= Number.MAX_SAFE_INTEGER) {
            this._lvl.Set(building.l);
        } else {
            this._lvl.Set(1);
        }
        this.productionCapacityProperty.value = this._buildingProps.capacity[Math.max(0, this._lvl.Get() - 1)];
        super.Setup(building);
        
        let storedValue: number;
        if (BASE.isOutpost) {
            const healthRatio: number = this.health / this.maxHealth;
            if (healthRatio <= 0) {
                storedValue = 0;
            } else if (healthRatio <= 0.5) {
                storedValue = 0.25 * this.productionCapacity;
            } else {
                storedValue = 0.5 * this.productionCapacity;
            }
            this._producing = 1;
            this._countdownProduce.Set(Math.random() * 10);
        } else {
            storedValue = building.st;
            this._producing = building.pr;
            this._countdownProduce.Set(building.cP);
        }
        
        if (storedValue >= 0) {
            this._stored.Set(storedValue);
        } else {
            this._stored.Set(0);
            LOGGER.Log("err", "Harvester storage < 0 mode: " + GLOBAL.mode);
        }
    }
}
