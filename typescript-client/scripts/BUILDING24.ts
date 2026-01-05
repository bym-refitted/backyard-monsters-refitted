import Rectangle from 'openfl/geom/Rectangle';
import { BTRAP } from './BTRAP';

/**
 * BUILDING24 - Booby Trap
 * Extends BTRAP for basic trap building
 */
export class BUILDING24 extends BTRAP {
    constructor() {
        super();
        this._type = 24;
        this._footprint = [new Rectangle(0, 0, 20, 20)];
        this.SetProps();
    }
}
