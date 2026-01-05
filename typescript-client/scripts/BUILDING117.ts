import Rectangle from 'openfl/geom/Rectangle';
import { BHEAVYTRAP } from './BHEAVYTRAP';
import { ACHIEVEMENTS } from './ACHIEVEMENTS';

/**
 * BUILDING117 - Heavy Trap (Inferno)
 * Extends BHEAVYTRAP for heavy trap building
 */
export class BUILDING117 extends BHEAVYTRAP {
    constructor() {
        super();
        this._type = 117;
        this._footprint = [new Rectangle(0, 0, 20, 20)];
        this.SetProps();
    }

    public override Constructed(): void {
        ++ACHIEVEMENTS._stats["heavytraps"];
        ACHIEVEMENTS.Check();
        super.Constructed();
    }
}
