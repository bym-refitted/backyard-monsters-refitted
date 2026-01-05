import { WMBASE } from './com/monsters/ai/WMBASE';
import { ICoreBuilding } from './com/monsters/interfaces/ICoreBuilding';
import { MapRoomManager } from './com/monsters/maproom_manager/MapRoomManager';
import MouseEvent from 'openfl/events/MouseEvent';
import Point from 'openfl/geom/Point';
import Rectangle from 'openfl/geom/Rectangle';
import { BSTORAGE } from './BSTORAGE';
import { BASE } from './BASE';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { MAP } from './MAP';

/**
 * BUILDING112 - Outpost Town Hall (Inferno)
 * Extends BSTORAGE for the outpost core building
 */
export class BUILDING112 extends BSTORAGE implements ICoreBuilding {
    constructor() {
        super();
        this._type = 112;
        this._footprint = [new Rectangle(0, 0, 130, 130)];
        this._gridCost = [[new Rectangle(0, 0, 130, 130), 10], [new Rectangle(10, 10, 110, 110), 200]];
        this._spoutPoint = new Point(0, -55);
        this._spoutHeight = 115;
        this.SetProps();
    }

    public override Repair(): void {
        super.Repair();
    }

    public override Place(event: MouseEvent | null = null): void {
        if (!MAP._dragged) {
            super.Place(event);
            this._hasResources = true;
        }
    }

    public override Cancel(): void {
        GLOBAL.setTownHall(null);
        super.Cancel();
    }

    public override Recycle(): void {
        GLOBAL.Message(KEYS.Get("msg_recycleoutpost"));
    }

    public override RecycleB(event: MouseEvent | null = null): void {
        GLOBAL.Message(KEYS.Get("msg_recycleoutpost"));
    }

    public override RecycleC(): void {
        GLOBAL.Message(KEYS.Get("msg_recycleoutpost"));
    }

    public override Destroyed(byAttacker: boolean = true): void {
        super.Destroyed(byAttacker);
        if ((!MapRoomManager.instance.isInMapRoom2or3 || BASE.isInfernoMainYardOrOutpost) && GLOBAL.mode === "wmattack") {
            WMBASE._destroyed = true;
        }
    }

    public override Description(): void {
        super.Description();
        this._buildingDescription = KEYS.Get("outpost_upgradedesc");
        this._recycleDescription = KEYS.Get("th_recycledesc");
    }

    public override Update(force: boolean = false): void {
        super.Update(force);
    }

    public override Constructed(): void {
        super.Constructed();
        GLOBAL.setTownHall(this);
    }

    public override Setup(building: any): void {
        super.Setup(building);
        GLOBAL.setTownHall(this);
    }
}
