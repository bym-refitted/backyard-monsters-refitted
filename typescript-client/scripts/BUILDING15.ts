import MovieClip from 'openfl/display/MovieClip';
import MouseEvent from 'openfl/events/MouseEvent';
import Rectangle from 'openfl/geom/Rectangle';
import { MapRoomManager } from './com/monsters/maproom_manager/MapRoomManager';
import { CreepBase } from './com/monsters/monsters/creeps/CreepBase';
import { BFOUNDATION } from './BFOUNDATION';
import { BASE } from './BASE';
import { GLOBAL } from './GLOBAL';
import { HOUSING } from './HOUSING';
import { KEYS } from './KEYS';
import { POPUPS } from './POPUPS';

/**
 * BUILDING15 - Monster Housing
 * Extends BFOUNDATION for creature storage building
 */
export class BUILDING15 extends BFOUNDATION {
    public _capacity: number = 0;
    public _space: number = 0;
    public _housing: Record<string, any> = {};

    constructor() {
        super();
        this._type = 15;
        this._capacity = 0;
        this._housing = {};
        this._footprint = [new Rectangle(0, 0, 160, 160)];
        this._gridCost = [
            [new Rectangle(10, 10, 140, 20), 400],
            [new Rectangle(130, 30, 20, 120), 400],
            [new Rectangle(10, 30, 20, 120), 400],
            [new Rectangle(30, 130, 30, 20), 400],
            [new Rectangle(100, 130, 30, 20), 400]
        ];
        this.SetProps();
    }

    public override StopMoveB(): void {
        super.StopMoveB();
        this.UpdateHousedCreatureTargets();
    }

    public override Description(): void {
        super.Description();
        this._upgradeDescription = KEYS.Get("bdg_housing_capacitydesc", {
            v1: GLOBAL.FormatNumber(this._buildingProps.capacity[this._lvl.Get() - 1]),
            v2: GLOBAL.FormatNumber(this._buildingProps.capacity[this._lvl.Get()])
        });
        if (this._recycleCosts !== null) {
            this._recycleDescription = `<b>${KEYS.Get("bdg_housing_recycledesc")}</b><br>${this._recycleCosts}`;
        }
        HOUSING.HousingSpace();
        if (BASE.isMainYardOrInfernoMainYard) {
            this._blockRecycle = false;
        }
        if (HOUSING._housingSpace.Get() - this._buildingProps.capacity[this._lvl.Get() - 1] < 0) {
            this._recycleDescription = `<font color="#CC0000">${KEYS.Get("bdg_housing_recyclewarning")}</font>`;
            this._blockRecycle = true;
        }
    }

    public override Constructed(): void {
        super.Constructed();
        HOUSING.AddHouse(this);
    }

    public override Upgraded(): void {
        super.Upgraded();
        HOUSING.HousingSpace();
    }

    public override Tick(seconds: number): void {
        super.Tick(seconds);
    }

    public override Update(force: boolean = false): void {
        super.Update(force);
    }

    public override RecycleC(): void {
        super.RecycleC();
        HOUSING.HousingSpace();
        HOUSING.RemoveHouse(this);
        this.RelocateHousedCreatures();
    }

    public override Destroyed(byAttacker: boolean = true): void {
        super.Destroyed(byAttacker);
        const isMapRoom3: boolean = MapRoomManager.instance.isInMapRoom3;
        for (const creature of this._creatures) {
            (creature as CreepBase).setHealth(isMapRoom3 ? (creature as CreepBase).health * 0.5 : 0);
        }
        if (!MapRoomManager.instance.isInMapRoom3) {
            HOUSING.Cull();
            HOUSING.RemoveHouse(this);
        }
    }

    public override Setup(building: any): void {
        super.Setup(building);
        if (this.m_isCleared) return;
        if (this.health > 10 && this.health < this.maxHealth && this.health % 1000 === 0) {
            this.setHealth(this.maxHealth);
        }
        if (this._countdownBuild.Get() === 0) {
            HOUSING.AddHouse(this);
        }
    }
}
