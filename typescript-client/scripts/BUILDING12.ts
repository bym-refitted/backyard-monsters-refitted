import MouseEvent from 'openfl/events/MouseEvent';
import Rectangle from 'openfl/geom/Rectangle';
import { BFOUNDATION } from './BFOUNDATION';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';

/**
 * BUILDING12 - General Store
 * Extends BFOUNDATION for the store building
 */
export class BUILDING12 extends BFOUNDATION {
    constructor() {
        super();
        this._type = 12;
        this._footprint = [new Rectangle(0, 0, 70, 70)];
        this._gridCost = [[new Rectangle(0, 0, 70, 70), 10], [new Rectangle(10, 10, 50, 50), 200]];
        this.SetProps();
    }

    public override Tick(seconds: number): void {
        if (this._countdownBuild.Get() > 0 || this.health < this.maxHealth * 0.5) {
            this._canFunction = false;
        } else {
            this._canFunction = true;
        }
        super.Tick(seconds);
    }

    public Fund(): void {
        // Empty method
    }

    public override Place(event: MouseEvent | null = null): void {
        super.Place(event);
    }

    public override Cancel(): void {
        GLOBAL._bStore = null;
        super.Cancel();
    }

    public override RecycleC(): void {
        GLOBAL._bStore = null;
        super.RecycleC();
    }

    public override Description(): void {
        super.Description();
        this._buildingTitle = KEYS.Get("#b_generalstore#");
        this._buildingDescription = KEYS.Get("building_generalstore_desc1");
        this._specialDescription = KEYS.Get("building_generalstore_desc2", { v1: GLOBAL._resourceNames[4] });
    }

    public override Update(force: boolean = false): void {
        super.Update(force);
    }

    public override Upgraded(): void {
        super.Upgraded();
    }

    public override Constructed(): void {
        GLOBAL._bStore = this;
        super.Constructed();
    }

    public override Setup(building: any): void {
        super.Setup(building);
        if (this._countdownBuild.Get() <= 0) {
            GLOBAL._bStore = this;
        }
    }
}
