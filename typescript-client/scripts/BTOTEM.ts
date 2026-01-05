import { SecNum } from './com/cc/utils/SecNum';
import { InventoryManager } from './com/monsters/inventory/InventoryManager';
import { InstanceManager } from './com/monsters/managers/InstanceManager';
import { EnumInvasionType } from './com/monsters/enums/EnumInvasionType';
import { BDECORATION } from './BDECORATION';
import { BASE } from './BASE';
import { BFOUNDATION } from './BFOUNDATION';
import { BUILDINGS } from './BUILDINGS';
import { GLOBAL } from './GLOBAL';

/**
 * BTOTEM - Totem decoration building class
 * Extends BDECORATION for World Monster Invasion totem buildings
 */
export class BTOTEM extends BDECORATION {
    public static readonly BTOTEM_WMI1: number = 121;
    public static readonly BTOTEM_WMI2: number = 131;

    constructor(type: number) {
        super(type);
        if (BASE._buildingsStored["b" + this._type] && BASE._buildingsStored["bl" + this._type]) {
            this._lvl = new SecNum(BASE._buildingsStored["bl" + this._type].Get());
            this._hpLvl = this._lvl.Get();
        }
    }

    public static HasTotemPlaced(wmi1: boolean = false, wmi2: boolean = false): boolean {
        const decorations: any[] = InstanceManager.getInstancesByClass(BDECORATION);
        for (const building of decorations) {
            if (wmi1 && building._type === BTOTEM.BTOTEM_WMI1) return true;
            if (wmi2 && building._type === BTOTEM.BTOTEM_WMI2) return true;
        }
        return false;
    }

    public static TotemReward(): void {
        if (GLOBAL._flags.activeInvasion === EnumInvasionType.WMI1) {
            if (BTOTEM.HasTotemPlaced(true, false)) return;
            BTOTEM.RemoveAllFromStorage(true, false);
            BTOTEM.RemoveAllFromYard(true, false);
            InventoryManager.buildingStorageAdd(BTOTEM.BTOTEM_WMI1, 1);
        } else {
            if (BTOTEM.HasTotemPlaced(false, true)) return;
            BTOTEM.RemoveAllFromStorage(false, true);
            BTOTEM.RemoveAllFromYard(false, true);
            InventoryManager.buildingStorageAdd(BTOTEM.BTOTEM_WMI2, 1);
        }
    }

    public static TotemPlace(): void {
        let totemType: number;
        if (GLOBAL._flags.activeInvasion === EnumInvasionType.WMI1) {
            totemType = BTOTEM.BTOTEM_WMI1;
        } else {
            totemType = BTOTEM.BTOTEM_WMI2;
        }
        
        if (!BASE._buildingsStored["b" + totemType] || BASE._buildingsStored["b" + totemType].Get() <= 0) {
            return;
        }
        
        BUILDINGS._buildingID = totemType;
        BUILDINGS.Show();
        BUILDINGS._mc.SwitchB(4, 4, 0);
    }

    public static UpgradeTotem(): void {
        const decorations: any[] = InstanceManager.getInstancesByClass(BDECORATION);
        for (const building of decorations) {
            if (building._type === BTOTEM.BTOTEM_WMI1 || building._type === BTOTEM.BTOTEM_WMI2) {
                (building as BFOUNDATION).Upgraded();
            }
        }
        
        if (GLOBAL._flags.activeInvasion === EnumInvasionType.WMI1) {
            if (BASE._buildingsStored["bl" + BTOTEM.BTOTEM_WMI1]) {
                BASE._buildingsStored["bl" + BTOTEM.BTOTEM_WMI1].Set(BTOTEM.EarnedTotemLevel());
            }
        } else {
            if (BASE._buildingsStored["bl" + BTOTEM.BTOTEM_WMI2]) {
                BASE._buildingsStored["bl" + BTOTEM.BTOTEM_WMI2].Set(BTOTEM.EarnedTotemLevel2());
            }
        }
    }

    public static RemoveAllFromStorage(wmi1: boolean = false, wmi2: boolean = false): void {
        if (wmi1) {
            delete BASE._buildingsStored["b" + BTOTEM.BTOTEM_WMI1];
            delete BASE._buildingsStored["bl" + BTOTEM.BTOTEM_WMI1];
        }
        if (wmi2) {
            delete BASE._buildingsStored["b" + BTOTEM.BTOTEM_WMI2];
            delete BASE._buildingsStored["bl" + BTOTEM.BTOTEM_WMI2];
        }
    }

    public static RemoveAllFromYard(wmi1: boolean = false, wmi2: boolean = false): void {
        const decorations: any[] = InstanceManager.getInstancesByClass(BDECORATION);
        for (const building of decorations) {
            if (wmi1 && building._type === BTOTEM.BTOTEM_WMI1) {
                building.GridCost(false);
                building.clear();
            }
            if (wmi2 && building._type === BTOTEM.BTOTEM_WMI2) {
                building.GridCost(false);
                building.clear();
            }
        }
    }

    public static EarnedTotemLevel(): number {
        const wmi_wave: number = GLOBAL.StatGet("wmi_wave");
        const storedLevel: number = GLOBAL.StatGet("wmi1_totem_level");
        let currentLevel: number;
        
        if (wmi_wave === 0) currentLevel = 0;
        else if (wmi_wave >= 1 && wmi_wave <= 9) currentLevel = 1;
        else if (wmi_wave >= 10 && wmi_wave <= 19) currentLevel = 2;
        else if (wmi_wave >= 20 && wmi_wave <= 29) currentLevel = 3;
        else if (wmi_wave === 30) currentLevel = 4;
        else if (wmi_wave === 31) currentLevel = 5;
        else currentLevel = 6;
        
        if (currentLevel > storedLevel) {
            GLOBAL.StatSet("wmi1_totem_level", currentLevel);
            return currentLevel;
        }
        return storedLevel;
    }

    private static EarnedTotemLevel2(): number {
        const wmi2_wave: number = GLOBAL.StatGet("wmi2_wave");
        const storedLevel: number = GLOBAL.StatGet("wmi2_totem_level");
        let currentLevel: number;
        
        if (wmi2_wave === 100) currentLevel = 0;
        else if (wmi2_wave >= 101 && wmi2_wave <= 109) currentLevel = 1;
        else if (wmi2_wave >= 110 && wmi2_wave <= 119) currentLevel = 2;
        else if (wmi2_wave >= 120 && wmi2_wave <= 129) currentLevel = 3;
        else if (wmi2_wave === 130) currentLevel = 4;
        else if (wmi2_wave === 131) currentLevel = 5;
        else currentLevel = 6;
        
        if (currentLevel > storedLevel) {
            GLOBAL.StatSet("wmi2_totem_level", currentLevel);
            return currentLevel;
        }
        return storedLevel;
    }

    public static IsTotem(type: number): boolean {
        return type === BTOTEM.BTOTEM_WMI1;
    }

    public static IsTotem2(type: number): boolean {
        return type === BTOTEM.BTOTEM_WMI2;
    }

    public override Tick(seconds: number): void {
        super.Tick(seconds);
        
        let earnedLevel: number;
        if (this._type === BTOTEM.BTOTEM_WMI1) {
            earnedLevel = BTOTEM.EarnedTotemLevel();
        } else if (this._type === BTOTEM.BTOTEM_WMI2) {
            earnedLevel = BTOTEM.EarnedTotemLevel2();
        } else {
            return;
        }
        
        if (this._lvl.Get() !== earnedLevel) {
            this._lvl.Set(earnedLevel);
            this._hpLvl = earnedLevel;
        }
    }
}
