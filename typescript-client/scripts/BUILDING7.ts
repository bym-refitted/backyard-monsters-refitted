import Rectangle from 'openfl/geom/Rectangle';
import { BMUSHROOM } from './BMUSHROOM';

/**
 * BUILDING7 - Mushroom (Pickable Resource)
 * Extends BMUSHROOM for shiny mushroom pickups
 */
export class BUILDING7 extends BMUSHROOM {
    constructor() {
        super();
        this._type = 7;
        this._footprint = [new Rectangle(0, 0, 30, 30)];
        this._gridCost = [[new Rectangle(0, 0, 30, 30), 10]];
        this.SetProps();
    }
}
