import { ImageCache } from './com/monsters/display/ImageCache';
import { InventoryManager } from './com/monsters/inventory/InventoryManager';
import { InstanceManager } from './com/monsters/managers/InstanceManager';
import Bitmap from 'openfl/display/Bitmap';
import BitmapData from 'openfl/display/BitmapData';
import MovieClip from 'openfl/display/MovieClip';
import MouseEvent from 'openfl/events/MouseEvent';
import { BASE } from './BASE';
import { BFOUNDATION } from './BFOUNDATION';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { SOUNDS } from './SOUNDS';
import { STORE } from './STORE';

/**
 * BUILDINGBUTTON - Building Selection Button in Store
 * Displays a building option in the construction menu
 */
export class BUILDINGBUTTON extends MovieClip {
    private static s_LockedCallbacks: Map<number, Function> = new Map();

    public _buildingProps: any;
    public _id: number = 0;

    // MovieClip child references
    public tName: any;
    public mcSale: any;
    public mcNew: any;
    public tQuantity: any;
    public mcShroud: any;
    public mcCheck: any;
    public mcBG: any;

    constructor() {
        super();
    }

    public static setOnClickedWhenLockedCallback(id: number, callback: Function): void {
        BUILDINGBUTTON.s_LockedCallbacks.set(id, callback);
    }

    public Setup(buildingId: number, interactive: boolean = true): void {
        this._id = buildingId;
        this._buildingProps = GLOBAL._buildingProps[this._id - 1];
        this.mouseChildren = false;

        if (interactive) {
            if (this.isLocked) {
                this.addEventListener(MouseEvent.CLICK, this.ShowLockedInfo.bind(this));
            } else {
                this.addEventListener(MouseEvent.CLICK, this.ShowInfo.bind(this));
            }
            this.buttonMode = true;
        }

        this.tName.htmlText = "<b>" + KEYS.Get(this._buildingProps.name) + "</b>";
        this.mcSale.visible = this._buildingProps.sale === 1;
        this.mcSale.t.htmlText = "<b>" + KEYS.Get("ui_sale_on") + "</b>";
        this.mcNew.t.htmlText = "<b>" + KEYS.Get("str_new_caps") + "</b>";

        const thLevel: number = GLOBAL.GetBuildingTownHallLevel(this._buildingProps);
        const maxQuantity: number = thLevel < this._buildingProps.quantity.length 
            ? this._buildingProps.quantity[thLevel] 
            : this._buildingProps.quantity[this._buildingProps.quantity.length - 1];
        
        let currentCount: number = 0;
        const instances = InstanceManager.getInstancesByClass(this._buildingProps.cls || BFOUNDATION);
        for (const building of instances) {
            if ((building as BFOUNDATION)._type === this._id) {
                currentCount++;
            }
        }

        if (this.isLocked) {
            this.tQuantity.htmlText = "";
        } else if (this._buildingProps.type === "decoration") {
            const storageCount = InventoryManager.buildingStorageCount(this._id);
            if (storageCount > 0) {
                this.tQuantity.htmlText = '<font color="#0000CC"><b>' + KEYS.Get("bdg_numinstorage", { v1: storageCount }) + '</b></font>';
            } else {
                this.tQuantity.htmlText = '<font color="#333333"><b>' + STORE._storeItems["BUILDING" + this._id].c[0] + " " + KEYS.Get("#r_shiny#") + '</b></font>';
            }
        } else if (currentCount >= maxQuantity) {
            this.tQuantity.htmlText = '<b><font color="#CC0000">' + currentCount + " / " + maxQuantity + '</font></b>';
        } else {
            this.tQuantity.htmlText = "<b>" + currentCount + " / " + maxQuantity + "</b>";
        }

        let imgUrl: string | null = null;
        if (currentCount <= 0 && this._buildingProps.upgradeImgData) {
            let minLevel = Number.MAX_VALUE;
            for (const key in this._buildingProps.upgradeImgData) {
                if (!isNaN(Number(key))) {
                    minLevel = Math.min(minLevel, Number(key));
                }
            }
            if (minLevel !== Number.MAX_VALUE && this._buildingProps.upgradeImgData[minLevel].silhouette_img && 
                !BASE.HasRequirements(this._buildingProps.costs[0]) && !this._buildingProps.rewarded) {
                imgUrl = this._buildingProps.upgradeImgData.baseurl + this._buildingProps.upgradeImgData[minLevel].silhouette_img;
            }
        }

        if (!imgUrl) {
            if (this._buildingProps.buildingbuttons && BASE._buildingsStored["bl" + this._id] &&
                this._buildingProps.buildingbuttons.length >= BASE._buildingsStored["bl" + this._id].Get()) {
                imgUrl = "buildingbuttons/" + this._buildingProps.buildingbuttons[BASE._buildingsStored["bl" + this._id].Get() - 1] + ".jpg";
            } else if (this._buildingProps.buildingbuttons && this._buildingProps.buildingbuttons.length > 0) {
                imgUrl = "buildingbuttons/" + this._buildingProps.buildingbuttons[0] + ".jpg";
            } else {
                imgUrl = "buildingbuttons/" + this._id + ".jpg";
            }
        }

        const maxTotal: number = Math.max(...this._buildingProps.quantity);
        this.mcShroud.visible = currentCount >= maxQuantity && maxQuantity > 0;
        this.mcCheck.visible = currentCount >= maxTotal && maxTotal > 0;
        this.mcNew.visible = false;

        if (GLOBAL._newThings && this._buildingProps.isNew) {
            this.mcNew.visible = true;
        }

        ImageCache.GetImageWithCallBack(imgUrl, this.ImageLoaded.bind(this));

        if (this.isLocked) {
            this.mcShroud.visible = true;
            if (this._buildingProps.lockedButtonOverlay) {
                ImageCache.GetImageWithCallBack(this._buildingProps.lockedButtonOverlay, this.OnLockedOverlayLoaded.bind(this));
            }
        }
    }

    public ImageLoaded(key: string, bitmapData: BitmapData): void {
        this.mcBG.addChild(new Bitmap(bitmapData));
    }

    private OnLockedOverlayLoaded(key: string, bitmapData: BitmapData): void {
        this.mcShroud.addChild(new Bitmap(bitmapData));
    }

    public ShowInfo(event: MouseEvent): void {
        SOUNDS.Play("click1");
        (this.parent!.parent as any).ShowInfo(this._id);
    }

    private ShowLockedInfo(event: MouseEvent): void {
        const callback = BUILDINGBUTTON.s_LockedCallbacks.get(this._id);
        if (!callback) return;
        SOUNDS.Play("click1");
        callback();
    }

    private get isLocked(): boolean {
        return Boolean(this._buildingProps) && Boolean(this._buildingProps.locked);
    }

    public Update(): void {
        // Empty implementation
    }
}
