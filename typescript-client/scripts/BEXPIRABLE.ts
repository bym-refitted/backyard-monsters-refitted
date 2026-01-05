import MouseEvent from 'openfl/events/MouseEvent';
import { BFOUNDATION } from './BFOUNDATION';
import { GLOBAL } from './GLOBAL';

/**
 * BEXPIRABLE - Expirable building class
 * Extends BFOUNDATION for buildings that have a limited lifespan
 */
export class BEXPIRABLE extends BFOUNDATION {
    public _lifeSpan: number = 0;
    public _createTime: number = 0;

    constructor() {
        super();
    }

    public override Tick(seconds: number): void {
        super.Tick(seconds);
        if (this._buildingProps.lifespan !== 0) {
            if (GLOBAL.Timestamp() > this._createTime + this._buildingProps.lifespan) {
                this.RecycleC();
            }
        }
    }

    public override Place(event: MouseEvent | null = null): void {
        if (!this._createTime) {
            this._createTime = GLOBAL.Timestamp();
        }
        super.Place(event);
    }

    public override Export(): any {
        const data: any = super.Export();
        data.cT = this._createTime;
        return data;
    }

    public override Setup(building: any): void {
        super.Setup(building);
        this._createTime = building.cT;
    }
}
