import { BFOUNDATION } from './BFOUNDATION';

/**
 * Bunker - Base Bunker Class
 * Extends BFOUNDATION as base for monster bunker buildings
 */
export class Bunker extends BFOUNDATION {
    public _used: number = 0;
    public _monstersDispatched: Record<string, number> = {};
    public _monstersDispatchedTotal: number = 0;

    constructor() {
        super();
    }
}
