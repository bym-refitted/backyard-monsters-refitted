import { BYMDevConfig } from './com/monsters/configs/BYMDevConfig';
import { ImageCache } from './com/monsters/display/ImageCache';
import { InventoryManager } from './com/monsters/inventory/InventoryManager';
import Bitmap from 'openfl/display/Bitmap';
import BitmapData from 'openfl/display/BitmapData';
import MovieClip from 'openfl/display/MovieClip';
import MouseEvent from 'openfl/events/MouseEvent';
import { BASE } from './BASE';
import { BFOUNDATION } from './BFOUNDATION';
import { BUILDINGOPTIONS } from './BUILDINGOPTIONS';
import { GLOBAL } from './GLOBAL';
import { LOGGER } from './LOGGER';
import { LOGIN } from './LOGIN';
import { POPUPS } from './POPUPS';
import { SALESPECIALSPOPUP } from './SALESPECIALSPOPUP';
import { STORE } from './STORE';
import { TUTORIAL } from './TUTORIAL';
import { TweenLite } from './gs/TweenLite';

/**
 * BUY - Purchase and Payment System
 * Handles in-app purchases, offers, and premium currency transactions
 */
export class BUY {
    public static forceNCP: boolean = false;
    public static cacheNCPAvailable: string = "";

    constructor() {}

    public static Show(event: MouseEvent | null = null): void {
        LOGGER.Stat([22]);
        GLOBAL.CallJS("cc.showTopup", [{ type: "fbc", callback: "fbcAdd" }]);
    }

    public static Offers(offerType: string): void {
        switch (offerType) {
            case "daily":
                GLOBAL.CallJS("cc.showTopup", [{ type: "daily", callback: "fbcOfferDaily" }]);
                break;
            case "earn":
                GLOBAL.CallJS("cc.showTopup", [{ type: "offers", callback: "fbcOfferEarn" }]);
                break;
        }
    }

    public static FBCAdd(response: string): void {
        const data: any = JSON.parse(response);
        if (!data.status) {
            LOGGER.Log("err", "FBCAdd " + response);
        }
    }

    public static FBCOfferEarn(response: string): void {
        const data: any = JSON.parse(response);
        if (!data.status) {
            LOGGER.Log("err", "FBCDailyEarn " + response);
        }
    }

    public static FBCOfferDaily(response: string): void {
        const data: any = JSON.parse(response);
        if (!data.status) {
            LOGGER.Log("err", "FBCDailyEarn " + response);
        }
    }

    public static FBCNcpCheckEligibility(): boolean {
        if (GLOBAL._fbcncp > 0 && GLOBAL._flags && GLOBAL._flags.fbcncpshow !== -1) {
            if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard && TUTORIAL._stage > 200 && GLOBAL._sessionCount >= 5) {
                if (!GLOBAL._flags.viximo && !GLOBAL._flags.kongregate) {
                    if (BUY.cacheNCPAvailable) {
                        BUY.FBCNcp(BUY.cacheNCPAvailable);
                    } else {
                        if (BYMDevConfig.instance.USE_CLIENT_WITH_CALLBACK) {
                            GLOBAL.CallJSWithClient("cc.ncp", "fbcNcp", ["checkEligibility"]);
                        } else {
                            GLOBAL.CallJS("cc.ncp", ["checkEligibility", "fbcNcp"]);
                        }
                        BUY.FBCNcpUpgradeTimeout();
                    }
                    return true;
                }
            }
        }
        return false;
    }

    public static FBCNcpUpgradeTimeout(): void {
        TweenLite.killDelayedCallsTo(BUY.FBCNcpCancelled);
        TweenLite.delayedCall(5, BUY.FBCNcpCancelled, ["timeout", false]);
    }

    public static FBCNcp(response: string): void {
        console.log("|BUY| - FBCNCP CallBack");
        TweenLite.killDelayedCallsTo(BUY.FBCNcpCancelled);
        if (response === "1" || response === "2") {
            BUY.cacheNCPAvailable = response;
            const mc: any = new (GLOBAL as any).FACEBOOK_NCP_CLIP();
            mc.bYes.buttonMode = true;
            mc.bYes.useHandCursor = true;
            mc.bYes.mouseChildren = false;
            mc.bYes.alpha = 0;
            mc.bYes.addEventListener(MouseEvent.CLICK, BUY.FBCNcp_Click);
            mc.bNo.buttonMode = true;
            mc.bNo.useHandCursor = true;
            mc.bNo.mouseChildren = false;
            mc.bNo.alpha = 0;
            mc.bNo.addEventListener(MouseEvent.CLICK, BUY.FBCNcpCancelled);
            BUY.FBCNcpRender("upgrade", mc.imageHolder);
            POPUPS.Push(mc, null, null, "", "", false);
        } else {
            if (response === "0") {
                BUY.cacheNCPAvailable = response;
            }
            LOGGER.Log("log", "FBCNcp Not Elligible" + response);
            BUY.FBCNcpUpgradeCB();
        }
    }

    public static FBCNcp_Click(event: MouseEvent): void {
        if (BYMDevConfig.instance.USE_CLIENT_WITH_CALLBACK) {
            GLOBAL.CallJSWithClient("cc.ncp", "fbcNcpConfirm", ["showPaymentDialog"]);
        } else {
            GLOBAL.CallJS("cc.ncp", ["showPaymentDialog", "fbcNcpConfirm"]);
        }
        POPUPS.Next();
    }

    public static FBCNcpConfirm(response: string): void {
        const building: BFOUNDATION = GLOBAL.townHall;
        if (response === "1") {
            const canUpgrade: any = BASE.CanUpgrade(building);
            if (canUpgrade.error && !canUpgrade.needResource) {
                GLOBAL.Message(canUpgrade.errorMessage);
            } else {
                building.Upgraded();
                BASE.Purchase("NCP", 1, "upgrade");
                BUY.cacheNCPAvailable = "";
            }
        }
    }

    public static FBCNcpCancelled(reason: string = "", sendToJS: boolean = true): void {
        if (sendToJS) {
            if (BYMDevConfig.instance.USE_CLIENT_WITH_CALLBACK) {
                GLOBAL.CallJSWithClient("cc.ncp", "fbcNcpConfirm", ["showPaymentDialog"]);
            } else {
                GLOBAL.CallJS("cc.ncp", ["userCancelled"]);
            }
        }
        POPUPS.Next();
        BUY.FBCNcpUpgradeCB();
    }

    public static FBCNcpUpgradeCB(): void {
        if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD && !GLOBAL.isMapOpen()) {
            GLOBAL._selectedBuilding = GLOBAL.townHall;
            BUILDINGOPTIONS.Show(GLOBAL.townHall, "upgrade");
        }
    }

    private static FBCNcpRender(mode: string, imageContainer: MovieClip): string {
        const building: BFOUNDATION = GLOBAL.townHall;
        const buildingProps: any = GLOBAL._buildingProps[building._type - 1];
        let img: string = "";

        if (mode === "fortify") {
            let nextFortifyLevel: number = building._fortification.Get() + 1;
            if (nextFortifyLevel > 4) nextFortifyLevel = 4;
            img = "fortifybuttons/fort" + nextFortifyLevel + ".png";
            ImageCache.GetImageWithCallBack(img, (path: string, bmd: BitmapData) => {
                imageContainer.addChild(new Bitmap(bmd));
            });
        } else if (buildingProps.upgradeImgData) {
            const imageDataA: any = buildingProps.upgradeImgData;
            let imageLevel: number = building._lvl.Get() === 0 ? 1 : building._lvl.Get();
            if (imageDataA[imageLevel + 1]) imageLevel++;
            img = buildingProps.upgradeImgData.baseurl + buildingProps.upgradeImgData[imageLevel].img;
            ImageCache.GetImageWithCallBack(img, (path: string, bmd: BitmapData) => {
                imageContainer.addChild(new Bitmap(bmd));
            });
        } else {
            if (buildingProps.buildingbuttons && buildingProps.buildingbuttons.length >= building._lvl.Get()) {
                img = "buildingbuttons/" + buildingProps.buildingbuttons[building._lvl.Get() - 1] + ".jpg";
            } else {
                img = "buildingbuttons/" + building._type + ".jpg";
            }
            ImageCache.GetImageWithCallBack(img, (path: string, bmd: BitmapData) => {
                imageContainer.addChild(new Bitmap(bmd));
            });
        }
        return img;
    }

    public static MidGameOffers(offerType: string): void {
        switch (offerType) {
            case "text":
                GLOBAL.CallJS("cc.showTopup", [{ type: "fbc", callback: "fbcAdd" }]);
                break;
            case "gift":
                GLOBAL.CallJS("cc.showTopup", [{ special: "gift", callback: "fbcAdd" }]);
                break;
            case "shinydiscount":
                GLOBAL.CallJS("cc.showTopup", [{ special: "discount", callback: "fbcAdd" }]);
                break;
            case "shinybonus":
                GLOBAL.CallJS("cc.showTopup", [{ special: "bonus", callback: "fbcAdd" }]);
                break;
        }
    }

    public static purchaseReceive(response: string): void {
        POPUPS.Next();
        const data: any = JSON.parse(response);
        if (data.error === 0) {
            if (LOGIN.checkHash(response)) {
                BUY.purchaseProcess(data.items);
                BUY.purchaseComplete(response);
                BASE._pendingPromo = 1;
                BASE.Save();
            } else {
                LOGGER.Log("err", "BUY.purchaseReceive " + response);
            }
        }
    }

    public static purchaseComplete(response: string): void {
        if (response === "biggulp") {
            SALESPECIALSPOPUP.Show("biggulp");
        } else {
            SALESPECIALSPOPUP.EndSale();
            SALESPECIALSPOPUP.Show("giftconfirm");
        }
        BASE.Save();
    }

    public static startPromo(response: string): void {
        const data: any = JSON.parse(response);
        if (data.endtime) {
            SALESPECIALSPOPUP.StartSale(data.endtime);
        } else {
            LOGGER.Log("err", "startPromo " + data.endtime);
        }
    }

    public static purchaseProcess(items: any[]): void {
        for (let i = 0; i < items.length; i++) {
            const itemId: string = String(items[i][0]);
            const quantity: number = Number(items[i][1]);
            for (let j = 0; j < quantity; j++) {
                if (itemId === "BIGGULP") {
                    InventoryManager.buildingStorageAdd(120);
                } else {
                    STORE.AddInventory(itemId);
                }
            }
        }
    }

    public static logPromoShown(promo: string | null = null): void {
        LOGGER.Log("pro", "POPUPS.CallbackShiny " + promo);
    }

    public static logFB711PromoShown(data: string | null = null): void {
        LOGGER.Stat([74, "popupshow"]);
    }

    public static logFB711RedeemShown(data: string | null = null): void {
        if (TUTORIAL._stage < 200) {
            LOGGER.Stat([77, TUTORIAL._stage]);
        } else {
            LOGGER.Stat([78, "claimed"]);
        }
    }
}
