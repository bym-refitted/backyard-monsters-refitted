import MouseEvent from 'openfl/events/MouseEvent';
import Point from 'openfl/geom/Point';
import Rectangle from 'openfl/geom/Rectangle';
import { WMBASE } from './com/monsters/ai/WMBASE';
import { ICoreBuilding } from './com/monsters/interfaces/ICoreBuilding';
import { MapRoomManager } from './com/monsters/maproom_manager/MapRoomManager';
import { BSTORAGE } from './BSTORAGE';
import { ACHIEVEMENTS } from './ACHIEVEMENTS';
import { BASE } from './BASE';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { LOGGER } from './LOGGER';
import { MAP } from './MAP';
import { POPUPS } from './POPUPS';
import { UI2 } from './UI2';

/**
 * BUILDING14 - Town Hall (Core Building)
 * Extends BSTORAGE for the main town hall building
 */
export class BUILDING14 extends BSTORAGE implements ICoreBuilding {
    public static readonly k_TYPE: number = 14;
    public static readonly UNDERHALL_LEVEL: string = "underhalLevel";

    constructor() {
        super();
        this._type = 14;
        this._footprint = BASE.isInfernoMainYardOrOutpost ? [new Rectangle(0, 0, 160, 160)] : [new Rectangle(0, 0, 130, 130)];
        this._gridCost = BASE.isInfernoMainYardOrOutpost 
            ? [[new Rectangle(0, 0, 160, 160), 10], [new Rectangle(10, 10, 140, 140), 200]]
            : [[new Rectangle(0, 0, 130, 130), 10], [new Rectangle(10, 10, 110, 110), 200]];
        this._spoutPoint = new Point(1, -67);
        this._spoutHeight = 135;
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
        GLOBAL.Message(KEYS.Get("msg_cantrecycleth", { v1: GLOBAL.townHall._buildingProps.name }));
    }

    public override RecycleB(event: MouseEvent | null = null): void {
        GLOBAL.Message(KEYS.Get("msg_cantrecycleth", { v1: GLOBAL.townHall._buildingProps.name }));
    }

    public override RecycleC(): void {
        GLOBAL.Message(KEYS.Get("msg_cantrecycleth", { v1: GLOBAL.townHall._buildingProps.name }));
    }

    public override Destroyed(byAttacker: boolean = true): void {
        super.Destroyed(byAttacker);
        if (!MapRoomManager.instance.isInMapRoom2or3 && GLOBAL.mode === "wmattack") {
            WMBASE._destroyed = true;
        }
    }

    public override Description(): void {
        super.Description();
        this._buildingDescription = KEYS.Get("th_upgradedesc");
        if (this._lvl.Get() === 1) {
            this._recycleDescription = KEYS.Get("th_recycledesc");
        }
        if (this._lvl.Get() > 0 && this._lvl.Get() < this._buildingProps.costs.length) {
            const newBuildings: any[] = [];
            const moreBuildings: any[] = [];
            const upgradeBuildings: any[] = [];
            
            for (const buildingProps of GLOBAL._buildingProps) {
                if (buildingProps.id !== 14) {
                    const maxIdx: number = buildingProps.quantity.length - 1;
                    const currentLevel: number = this._lvl.Get();
                    const currentQuantity: number = buildingProps.quantity[Math.min(currentLevel, maxIdx)];
                    const nextQuantity: number = buildingProps.quantity[Math.min(currentLevel + 1, maxIdx)];
                    const diff: number = nextQuantity - currentQuantity;
                    
                    if (currentQuantity === 0 && nextQuantity > 0 && !buildingProps.block) {
                        newBuildings.push([0, KEYS.Get(buildingProps.name)]);
                    } else if (diff > 0 && !buildingProps.block) {
                        moreBuildings.push([0, KEYS.Get(buildingProps.name) + "s"]);
                    }
                }
            }
            
            if (newBuildings.length > 0) {
                this._upgradeDescription += KEYS.Get("th_willunlockthe", { v1: GLOBAL.Array2StringB(newBuildings) }) + "<br><br>";
            }
            if (moreBuildings.length > 0) {
                this._upgradeDescription += `<b>${KEYS.Get("th_willbuildmore")}</b><br>${GLOBAL.Array2StringB(moreBuildings)}<br><br>`;
            }
            if (upgradeBuildings.length > 0) {
                this._upgradeDescription += `<b>${KEYS.Get("th_willupgrade")}</b><br>${GLOBAL.Array2StringB(upgradeBuildings)}`;
            }
            if (GLOBAL._buildingProps[this._type - 1].additionalUpgradeInfo?.[this._lvl.Get() - 1]) {
                this._upgradeDescription += `<br><br><b>${KEYS.Get(GLOBAL._buildingProps[this._type - 1].additionalUpgradeInfo[this._lvl.Get() - 1])}</b>`;
            }
        }
    }

    public override Update(force: boolean = false): void {
        super.Update(force);
    }

    public override Constructed(): void {
        GLOBAL.setTownHall(this);
        ACHIEVEMENTS.Check("thlevel", this._lvl.Get());
        ACHIEVEMENTS.Check(ACHIEVEMENTS.UNDERHALL_LEVEL, this._lvl.Get());
        super.Constructed();
    }

    public override UpgradeB(): void {
        super.UpgradeB();
        if (this._lvl.Get() >= 2 && this._countdownUpgrade.Get() > 0 && 
            this._countdownUpgrade.Get() * (20 / 60 / 60) > BASE._credits.Get()) {
            POPUPS.DisplayPleaseBuy("TH");
        }
    }

    public override Upgraded(): void {
        LOGGER.KongStat([2, this._lvl.Get()]);
        ACHIEVEMENTS.Check("thlevel", this._lvl.Get());
        ACHIEVEMENTS.Check(ACHIEVEMENTS.UNDERHALL_LEVEL, this._lvl.Get());
        super.Upgraded();
        this.UnlockBuildings();
    }

    private UnlockBuildings(): void {
        if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD) {
            const level: number = this._lvl.Get();
            if (BASE.isInfernoMainYardOrOutpost) {
                GLOBAL.StatSet(BUILDING14.UNDERHALL_LEVEL, level);
            } else {
                GLOBAL.attackingPlayer.townHallLevel = level;
            }
        }
    }

    public override Setup(building: any): void {
        super.Setup(building);
        GLOBAL.setTownHall(this);
        if (this._destroyed && UI2._top) {
            UI2._top.validateSiegeWeapon();
        }
        this.UnlockBuildings();
        ACHIEVEMENTS.Check("thlevel", this._lvl.Get());
        ACHIEVEMENTS.Check(ACHIEVEMENTS.UNDERHALL_LEVEL, this._lvl.Get());
    }
}
