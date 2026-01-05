import { RADIO } from './com/monsters/radio/RADIO';
import Point from 'openfl/geom/Point';
import Rectangle from 'openfl/geom/Rectangle';
import { BFOUNDATION } from './BFOUNDATION';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';

/**
 * BUILDING113 - Radio Tower
 * Extends BFOUNDATION for the radio communication building
 */
export class BUILDING113 extends BFOUNDATION {
    constructor() {
        super();
        this._type = 113;
        this._footprint = [new Rectangle(0, 0, 80, 80)];
        this._gridCost = [[new Rectangle(0, 0, 80, 80), 200]];
        this._spoutPoint = new Point(0, -80);
        this._spoutHeight = 100;
        this.SetProps();
    }

    public override Description(): void {
        super.Description();
        this._buildingDescription = KEYS.Get("radio_upgradedesc");
        this._recycleDescription = KEYS.Get("radio_recycledesc");
    }

    public override Update(force: boolean = false): void {
        super.Update(force);
    }

    public override Recycle(): void {
        super.Recycle();
    }

    public override RecycleC(): void {
        super.RecycleC();
        RADIO.TwitterRemoveName();
        RADIO.RemoveName();
        GLOBAL._bRadio = null;
    }

    public override Upgraded(): void {
        super.Upgraded();
        GLOBAL._bRadio = this;
    }

    public override Setup(building: any): void {
        super.Setup(building);
        if (this._countdownBuild.Get() === 0) {
            GLOBAL._bRadio = this;
        }
    }
}
