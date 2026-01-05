import { SecNum } from './com/cc/utils/SecNum';
import { EnumYardType } from './com/monsters/enums/EnumYardType';
import { ILootable } from './com/monsters/interfaces/ILootable';
import { MapRoomManager } from './com/monsters/maproom_manager/MapRoomManager';
import { BFOUNDATION } from './BFOUNDATION';
import { ATTACK } from './ATTACK';
import { BASE } from './BASE';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';

/**
 * BSTORAGE - Storage building class
 * Extends BFOUNDATION for storage buildings (Town Hall, Silo, etc.)
 */
export class BSTORAGE extends BFOUNDATION implements ILootable {
    private static _LOOT_MAX_TH: number = 10000000;
    private static _LOOT_MAX_OUTPOST: number = 10000000;
    private static _LOOT_MAX_SILO: number = 4000000;
    private static _LOOT_MAX_WM_TH: number = 2000000;
    private static _LOOT_MAX_WM_SILO: number = 500000;
    private static _LOOT_PCT_TH: number = 0.1;
    private static _LOOT_PCT_OUTPOST: number = 0.05;
    private static _LOOT_PCT_BASE: number = 0.04;
    private static _LOOT_GOO_LIMITER: number = 0.5;

    constructor() {
        super();
    }

    public override Loot(amount: number): number {
        let looted: number = 0;
        const resources: any[] = [];
        
        if (BASE._resources.r1.Get() > 0) resources.push({ id: 1, quantity: BASE._resources.r1.Get() });
        if (BASE._resources.r2.Get() > 0) resources.push({ id: 2, quantity: BASE._resources.r2.Get() });
        if (BASE._resources.r3.Get() > 0) resources.push({ id: 3, quantity: BASE._resources.r3.Get() });
        if (BASE._resources.r4.Get() > 0) resources.push({ id: 4, quantity: BASE._resources.r4.Get() });
        
        if (resources.length > 0) {
            const selected: any = resources[Math.floor(Math.random() * resources.length)];
            looted = selected.quantity >= Math.ceil(amount) ? Math.ceil(amount) : selected.quantity;
            
            BASE._resources["r" + selected.id].Add(-looted);
            BASE._hpResources["r" + selected.id] -= looted;
            
            if (BASE._deltaResources["r" + selected.id]) {
                BASE._deltaResources["r" + selected.id].Add(-looted);
                BASE._hpDeltaResources["r" + selected.id] -= looted;
            } else {
                BASE._deltaResources["r" + selected.id] = new SecNum(-looted);
                BASE._hpDeltaResources["r" + selected.id] = -looted;
            }
            BASE._deltaResources.dirty = true;
            BASE._hpDeltaResources.dirty = true;
            
            if (MapRoomManager.instance.isInMapRoom2 && GLOBAL._currentCell?.baseType === EnumYardType.OUTPOST) {
                looted *= 0.5;
            } else {
                looted *= 0.9;
            }
            if (GLOBAL.mode === "wmattack") {
                looted = Math.floor(looted / 5);
            }
            ATTACK.Loot(selected.id, looted, this._mc!.x, this._mc!.y, 9, this);
        }
        return super.Loot(looted);
    }

    public override Destroyed(byAttacker: boolean = true): void {
        if (byAttacker && !this._destroyed) {
            let lootPct: number = BSTORAGE._LOOT_PCT_BASE;
            if (this._type === 14) lootPct = BSTORAGE._LOOT_PCT_TH;
            if (this._type === 112) lootPct = BSTORAGE._LOOT_PCT_OUTPOST;
            
            for (let i = 1; i < 5; i++) {
                let lootAmount: number = Math.floor(BASE._resources["r" + i].Get() * lootPct);
                
                if (this._type === 6) {
                    lootAmount = Math.min(lootAmount, BSTORAGE._LOOT_MAX_SILO);
                    if (MapRoomManager.instance.isInMapRoom2 && GLOBAL._currentCell?.baseType === EnumYardType.OUTPOST) {
                        lootAmount = Math.min(lootAmount, BSTORAGE._LOOT_MAX_WM_SILO);
                    }
                }
                if (this._type === 14) {
                    lootAmount = Math.min(lootAmount, BSTORAGE._LOOT_MAX_TH);
                    if (MapRoomManager.instance.isInMapRoom2 && GLOBAL._currentCell?.baseType === EnumYardType.OUTPOST) {
                        lootAmount = Math.min(lootAmount, BSTORAGE._LOOT_MAX_WM_TH);
                    }
                }
                if (this._type === 112) {
                    lootAmount = Math.min(lootAmount, BSTORAGE._LOOT_MAX_OUTPOST);
                }
                if (i === 4 && !MapRoomManager.instance.isInMapRoom3) {
                    lootAmount = Math.ceil(lootAmount * BSTORAGE._LOOT_GOO_LIMITER);
                }
                
                if (lootAmount > 0) {
                    BASE._resources["r" + i].Add(-lootAmount);
                    BASE._hpResources["r" + i] -= lootAmount;
                    if (BASE._deltaResources["r" + i]) {
                        BASE._deltaResources["r" + i].Add(-lootAmount);
                        BASE._hpDeltaResources["r" + i] -= lootAmount;
                    } else {
                        BASE._deltaResources["r" + i] = new SecNum(-lootAmount);
                        BASE._hpDeltaResources["r" + i] = -lootAmount;
                    }
                    BASE._deltaResources.dirty = true;
                    BASE._hpDeltaResources.dirty = true;
                    ATTACK.Loot(i, lootAmount, this._mc!.x, this._mc!.y + 20 - i * 10, 12);
                }
            }
            ATTACK.Log("b" + this._id, `<font color="#FF0000">${KEYS.Get("attack_log_downedlooted", {
                v1: this._lvl.Get(),
                v2: this._buildingProps.name,
                v3: Math.floor(100 * lootPct)
            })}</font>`);
        } else {
            ATTACK.Log("b" + this._id, `<font color="#FF0000">${KEYS.Get("attack_log_downed", {
                v1: this._lvl.Get(),
                v2: this._buildingProps.name
            })}</font>`);
        }
        super.Destroyed(byAttacker);
    }
}
