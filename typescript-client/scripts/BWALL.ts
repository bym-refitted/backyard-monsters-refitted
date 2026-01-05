import Rectangle from 'openfl/geom/Rectangle';
import { PATHING } from './com/monsters/pathing/PATHING';
import { BFOUNDATION } from './BFOUNDATION';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';

/**
 * BWALL - Wall building class
 * Extends BFOUNDATION for wall defense buildings
 */
export class BWALL extends BFOUNDATION {
    constructor() {
        super();
    }

    public override GridCost(add: boolean = true): void {
        super.GridCost(add);
        PATHING.RegisterBuilding(new Rectangle(this._mc!.x, this._mc!.y, 20, 20), this, add);
    }

    public override Description(): void {
        super.Description();
        if (this._lvl.Get() < this._buildingProps.hp.length) {
            const currentHp: number = this._buildingProps.hp[this._lvl.Get() - 1];
            const nextHp: number = this._buildingProps.hp[this._lvl.Get()];
            this._upgradeDescription = KEYS.Get("building_wall_upgrade", {
                v1: GLOBAL.FormatNumber(currentHp),
                v2: GLOBAL.FormatNumber(nextHp),
                v3: Math.floor(100 / currentHp * nextHp) - 100
            });
        }
    }

    public override RecycleC(): void {
        PATHING.RegisterBuilding(new Rectangle(this._mc!.x, this._mc!.y, 20, 20), this, false);
        super.RecycleC();
    }
}
