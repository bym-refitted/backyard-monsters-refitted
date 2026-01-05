import { BYMDevConfig } from './com/monsters/configs/BYMDevConfig';
import { ImageCache } from './com/monsters/display/ImageCache';
import Bitmap from 'openfl/display/Bitmap';
import BitmapData from 'openfl/display/BitmapData';
import DisplayObject from 'openfl/display/DisplayObject';
import MovieClip from 'openfl/display/MovieClip';
import Event from 'openfl/events/Event';
import MouseEvent from 'openfl/events/MouseEvent';
import Point from 'openfl/geom/Point';
import TextFieldAutoSize from 'openfl/text/TextFieldAutoSize';
import { ACADEMY } from './ACADEMY';
import { BASE } from './BASE';
import { BFOUNDATION } from './BFOUNDATION';
import { BUILDINGINFO } from './BUILDINGINFO';
import { BUILDINGOPTIONS } from './BUILDINGOPTIONS';
import { BUILDINGS } from './BUILDINGS';
import { BUY } from './BUY';
import { CREATURELOCKER } from './CREATURELOCKER';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { LOGGER } from './LOGGER';
import { MUSHROOMS } from './MUSHROOMS';
import { NewPopupSystem } from './NewPopupSystem';
import { POPUPSETTINGS } from './POPUPSETTINGS';
import { QUEUE } from './QUEUE';
import { SOUNDS } from './SOUNDS';
import { STORE } from './STORE';
import { TUTORIAL } from './TUTORIAL';
import { UPDATES } from './UPDATES';

/**
 * POPUPS - Popup Management System
 * Handles displaying and queuing popups, dialogs, and overlays
 */
export class POPUPS {
    public static readonly k_TOP_LEFT: number = 1;
    public static readonly k_CENTER: number = 2;

    private static _popups: Record<string, any[]> = {};
    private static _mc: MovieClip | null = null;
    private static _mcBG: MovieClip | null = null;
    private static _lastGroup: string = "alerts";
    public static _open: boolean = false;
    public static _timer: any = null;

    constructor() {}

    public static Setup(): void {
        POPUPS._popups = {
            now: [],
            alerts: [],
            gifts: [],
            wait: [],
            tip: []
        };
        POPUPS._open = false;
    }

    public static Push(popup: any, callback: Function | null = null, args: any[] | null = null, 
                       sound: string = "", image: string = "", immediate: boolean = false, group: string = "now"): void {
        if (image) {
            ImageCache.GetImageWithCallBack("popups/" + image, null, true, 0);
        }
        if (GLOBAL._catchup && group === "now" && !immediate) {
            group = "alerts";
        }
        if (group === "now" && POPUPS._lastGroup !== "now") {
            POPUPS._lastGroup = "now";
        }
        POPUPS._popups[group].push([popup, callback, args, sound, image]);
        if (immediate) {
            POPUPS.Next();
        } else if (!POPUPS._open && !NewPopupSystem.dialogShowing) {
            POPUPS.Show();
        }
    }

    public static Next(event: MouseEvent | null = null): void {
        if (GLOBAL._halt) {
            GLOBAL.CallJS("reloadPage");
        }
        if (!GLOBAL._catchup || POPUPS._lastGroup === "tip") {
            POPUPS.Hide();
        }
    }

    private static Hide(): void {
        if (POPUPS._mc) {
            POPUPS.HideB();
        } else {
            POPUPS.Show("now");
        }
    }

    private static HideB(): void {
        POPUPS._open = false;
        POPUPS.RemoveBG();
        if (POPUPS._mc && POPUPS._mc.parent) {
            POPUPS._mc.parent.removeChild(POPUPS._mc);
        }
        POPUPS._mc = null;
        if (POPUPS._lastGroup === "alerts" || POPUPS._lastGroup === "wait" || POPUPS._lastGroup === "tip") {
            if (POPUPS._lastGroup === "tip") {
                POPUPS._lastGroup = "now";
            }
            POPUPS.NextDelayed();
        } else {
            POPUPS.Show(POPUPS._lastGroup);
        }
    }

    public static hasPopupsOpen(): boolean {
        const isPlacing: boolean = GLOBAL._newBuilding && (GLOBAL._newBuilding as BFOUNDATION)._placing === true;
        return BUILDINGS._open || STORE._open || BUILDINGOPTIONS._open || ACADEMY._open || 
               CREATURELOCKER._open || isPlacing || !!POPUPS._mc || POPUPS._open;
    }

    private static NextDelayed(delay: number = 200): void {
        POPUPS._timer = setTimeout(() => POPUPS.TimerDone(), delay);
    }

    private static TimerDone(): void {
        if (POPUPS._timer) {
            clearTimeout(POPUPS._timer);
            POPUPS._timer = null;
            if (POPUPS.hasPopupsOpen()) {
                POPUPS.NextDelayed(100);
            } else {
                POPUPS.Show(POPUPS._lastGroup);
            }
        }
    }

    public static Add(displayObj: DisplayObject, alignment: number = 0): void {
        GLOBAL._layerTop.addChild(displayObj);
        if (alignment === 1) {
            POPUPS.assignAlignToUpperLeft(displayObj);
        } else if (alignment === 2) {
            POPUPS.assignAlignToCenter(displayObj);
        }
    }

    public static Remove(displayObj: DisplayObject | null = null): void {
        if (displayObj && displayObj.parent) {
            displayObj.removeEventListener(Event.ENTER_FRAME, POPUPS.onResize);
            displayObj.removeEventListener(Event.ENTER_FRAME, POPUPS.onResizeCenter);
            displayObj.parent.removeChild(displayObj);
        }
    }

    public static assignAlignToUpperLeft(displayObj: DisplayObject | null = null): void {
        POPUPSETTINGS.AlignToUpperLeft(displayObj, true);
        displayObj?.addEventListener(Event.ENTER_FRAME, POPUPS.onResize, false);
    }

    public static assignAlignToCenter(displayObj: DisplayObject | null = null): void {
        POPUPSETTINGS.AlignToCenter(displayObj);
        displayObj?.addEventListener(Event.ENTER_FRAME, POPUPS.onResizeCenter, false);
    }

    protected static onResize(event: Event): void {
        const displayObj: DisplayObject = event.currentTarget as DisplayObject;
        POPUPSETTINGS.AlignToUpperLeft(displayObj, true);
    }

    protected static onResizeCenter(event: Event): void {
        const displayObj: DisplayObject = event.currentTarget as DisplayObject;
        POPUPSETTINGS.AlignToCenter(displayObj);
    }

    public static Show(group: string = "now"): void {
        if (!GLOBAL._catchup || group === "tip") {
            POPUPS._lastGroup = group;
            const message: any[] = POPUPS._popups[group].shift();
            if (message && !POPUPS._open) {
                POPUPS._open = true;
                POPUPS.AddBG();
                POPUPS._mc = GLOBAL._layerTop.addChild(message[0]) as MovieClip;
                POPUPSETTINGS.AlignToCenter(POPUPS._mc);
                POPUPSETTINGS.ScaleUp(POPUPS._mc);
                if (message[3]) {
                    SOUNDS.Play(message[3]);
                }
                if (message[1]) {
                    if (message[2]) {
                        message[1](...message[2]);
                    } else {
                        message[1]();
                    }
                }
                if (message[4]) {
                    ImageCache.GetImageWithCallBack("popups/" + message[4], (imagePath: string, bmd: BitmapData) => {
                        try {
                            if (POPUPS._mc && (POPUPS._mc as any).mcImage) {
                                while ((POPUPS._mc as any).mcImage.numChildren) {
                                    (POPUPS._mc as any).mcImage.removeChildAt(0);
                                }
                                (POPUPS._mc as any).mcImage.addChild(new Bitmap(bmd));
                                (POPUPS._mc as any).mcImage.mouseEnabled = false;
                                (POPUPS._mc as any).mcImage.mouseChildren = false;
                            }
                        } catch (e) {}
                    }, true, 0);
                }
            } else if (POPUPS._lastGroup === "now" && POPUPS.QueueCount("now") === 0 && POPUPS.QueueCount("wait") > 0) {
                POPUPS._lastGroup = "wait";
                POPUPS.NextDelayed(500);
            } else {
                if (POPUPS._timer) {
                    clearTimeout(POPUPS._timer);
                    POPUPS._timer = null;
                }
                if (POPUPS.QueueCount("wait") > 0) {
                    POPUPS._lastGroup = "wait";
                    POPUPS.NextDelayed(500);
                }
            }
        } else if (POPUPS.QueueCount("wait") > 0) {
            POPUPS._lastGroup = "wait";
            POPUPS.NextDelayed(500);
        }
    }

    public static QueueCount(group: string = "now"): number {
        return POPUPS._popups[group]?.length || 0;
    }

    public static AddBG(): void {
        POPUPS.RemoveBG();
        GLOBAL.RefreshScreen();
        POPUPS._mcBG = GLOBAL._layerTop.addChild(new (GLOBAL as any).popup_bg()) as MovieClip;
        POPUPS._mcBG.width = GLOBAL._SCREEN.width;
        POPUPS._mcBG.height = GLOBAL._SCREEN.height;
        POPUPS._mcBG.x = GLOBAL._SCREEN.x;
        POPUPS._mcBG.y = GLOBAL._SCREEN.y;
    }

    public static RemoveBG(mc: MovieClip | null = null): void {
        if (POPUPS._mcBG && POPUPS._mcBG.parent) {
            POPUPS._mcBG.parent.removeChild(POPUPS._mcBG);
        }
        POPUPS._mcBG = null;
    }

    public static Resize(): void {
        for (const group in POPUPS._popups) {
            for (let i = 0; i < POPUPS._popups[group].length; i++) {
                POPUPS._popups[group][i].x = GLOBAL._SCREENCENTER.x;
                POPUPS._popups[group][i].y = GLOBAL._SCREENCENTER.y;
            }
        }
    }

    public static NoConnection(): void {
        SOUNDS.StopAll();
        POPUPS._mcBG = GLOBAL._layerTop.addChild(new (GLOBAL as any).popup_bg2()) as MovieClip;
        POPUPS._mcBG.x = GLOBAL._SCREEN.x;
        POPUPS._mcBG.y = GLOBAL._SCREEN.y;
        POPUPS._mcBG.width = GLOBAL._SCREEN.width;
        POPUPS._mcBG.height = GLOBAL._SCREEN.height;
        const movie: any = new (GLOBAL as any).popup_timeout();
        movie.tA.htmlText = "<b>" + KEYS.Get("pop_noconnect_title") + "</b>";
        movie.tB.htmlText = KEYS.Get("pop_noconnect_body");
        movie.bGift.visible = false;
        movie.x = GLOBAL._SCREENCENTER.x;
        movie.y = GLOBAL._SCREENCENTER.y;
        GLOBAL._layerTop.addChild(movie);
        GLOBAL._halt = true;
    }

    public static Timeout(): void {
        SOUNDS.StopAll();
        POPUPS._mcBG = GLOBAL._layerTop.addChild(new (GLOBAL as any).popup_bg2()) as MovieClip;
        POPUPS._mcBG.x = GLOBAL._SCREEN.x;
        POPUPS._mcBG.y = GLOBAL._SCREEN.y;
        POPUPS._mcBG.width = GLOBAL._SCREEN.width;
        POPUPS._mcBG.height = GLOBAL._SCREEN.height;
        const movie: any = new (GLOBAL as any).popup_timeout();
        movie.tA.htmlText = "<b>" + KEYS.Get("pop_timeout_title") + "</b>";
        movie.tB.htmlText = KEYS.Get("pop_timeout_body");
        if (!GLOBAL._flags.kongregate) {
            if (GLOBAL._canGift) {
                movie.bGift.SetupKey("btn_sendfreegifts");
                movie.bGift.addEventListener(MouseEvent.CLICK, POPUPS.DisplayGiftSelect);
            } else {
                movie.bGift.SetupKey("btn_invitefriendstoplay");
                movie.bGift.addEventListener(MouseEvent.CLICK, POPUPS.DisplayInviteSelect);
            }
            movie.bGift.Highlight = true;
        } else {
            movie.bGift.visible = false;
        }
        movie.x = GLOBAL._SCREENCENTER.x;
        movie.y = GLOBAL._SCREENCENTER.y;
        GLOBAL._layerTop.addChild(movie);
        GLOBAL._halt = true;
    }

    public static AFK(): void {
        if (!GLOBAL._promptedAFK && TUTORIAL._stage > 200) {
            if (GLOBAL._canGift || GLOBAL._flags.kongregate) {
                POPUPS.Gift(true);
            } else {
                POPUPS.Invite(true);
            }
        }
        GLOBAL._promptedAFK = true;
    }

    public static Gift(showInGamePopup: boolean = false): void {
        if (GLOBAL._canGift || GLOBAL._flags.kongregate) {
            if (showInGamePopup) {
                const popupMC: any = new (GLOBAL as any).popup_afk_gift();
                popupMC.tA.htmlText = "<b>" + KEYS.Get("pop_afk_title") + "</b>";
                popupMC.tB.htmlText = KEYS.Get("pop_afk_body");
                if (GLOBAL._canGift) {
                    popupMC.bAction.SetupKey("btn_sendfreegifts");
                    popupMC.bAction.addEventListener(MouseEvent.CLICK, (e: MouseEvent) => {
                        POPUPS.Next(e);
                        POPUPS.DisplayGiftSelect();
                    });
                    popupMC.bAction.Highlight = true;
                } else {
                    popupMC.bAction.visible = false;
                }
                POPUPS.Push(popupMC, null, null, "", "resourcetwigs.png");
            } else {
                POPUPS.DisplayGiftSelect();
            }
        } else {
            const popupMC: any = new (GLOBAL as any).popup_invite_friends();
            if (GLOBAL._friendCount > 0) {
                popupMC.tA.htmlText = "<b>" + KEYS.Get("pop_invitefriends_title") + "</b>";
                popupMC.tB.htmlText = KEYS.Get("pop_invitefriends_body");
            } else {
                popupMC.tA.htmlText = "<b>" + KEYS.Get("pop_invitenofriends_title") + "</b>";
                popupMC.tB.htmlText = KEYS.Get("pop_invitenofriends_body");
            }
            popupMC.bAction.SetupKey("btn_invitefriends");
            popupMC.bAction.addEventListener(MouseEvent.CLICK, (e: MouseEvent) => {
                POPUPS.Next(e);
                POPUPS.Invite();
            });
            popupMC.bAction.Highlight = true;
            POPUPS.Push(popupMC);
        }
        GLOBAL.StatSet("pg", GLOBAL.Timestamp());
    }

    public static Invite(showInGamePopup: boolean = false): void {
        if (showInGamePopup) {
            const popupMC: any = new (GLOBAL as any).popup_invite_friends();
            popupMC.tA.htmlText = KEYS.Get("pop_invitefriends_title");
            popupMC.tB.htmlText = KEYS.Get("pop_invitefriends_body");
            popupMC.bAction.SetupKey("btn_invitefriends");
            popupMC.bAction.addEventListener(MouseEvent.CLICK, (e: MouseEvent) => {
                POPUPS.Next(e);
                POPUPS.DisplayInviteSelect();
            });
            popupMC.bAction.Highlight = true;
            POPUPS.Push(popupMC);
        } else {
            POPUPS.DisplayInviteSelect();
        }
        GLOBAL.StatSet("pi", GLOBAL.Timestamp());
    }

    public static Done(): boolean {
        return POPUPS._open === false;
    }

    public static DisplaySR(event: MouseEvent | null = null): void {
        POPUPS.AddBG();
        GLOBAL.CallJS("cc.showSrOverlay", ["callbackshiny"]);
        LOGGER.Stat([20, 1]);
    }

    public static DisplayGiftSelect(event: MouseEvent | null = null): void {
        POPUPS.AddBG();
        if (BYMDevConfig.instance.USE_CLIENT_WITH_CALLBACK) {
            GLOBAL.CallJSWithClient("cc.showFeedDialog", "callbackgift", ["gift"]);
        } else {
            GLOBAL.CallJS("cc.showFeedDialog", ["gift", "callbackgift"]);
        }
        LOGGER.Stat([20, 1]);
    }

    public static DisplayInviteSelect(event: MouseEvent | null = null): void {
        POPUPS.AddBG();
        if (BYMDevConfig.instance.USE_CLIENT_WITH_CALLBACK) {
            GLOBAL.CallJSWithClient("cc.showFeedDialog", "callbackgift", ["invite"]);
        } else {
            GLOBAL.CallJS("cc.showFeedDialog", ["invite", "callbackgift"]);
        }
        LOGGER.Stat([21, 1]);
    }

    public static DisplayGetShiny(event: MouseEvent | null = null): void {
        POPUPS.Push(POPUPS.GetShinyPopup(), null, null, "error1", "aintgotnoshiny.png");
    }

    public static GetShinyPopup(): MovieClip {
        const mc: any = new (GLOBAL as any).popup_noshiny();
        mc.tA.htmlText = "<b>" + KEYS.Get("pop_noshiny_title") + "</b>";
        mc.tB.htmlText = KEYS.Get("pop_noshiny_body");
        mc.bGet.SetupKey("str_getmore_btn");
        mc.bGet.addEventListener(MouseEvent.CLICK, BUY.Show);
        mc.bGet.Highlight = true;
        return mc;
    }

    public static DisplayWorker(actionType: number, building: any): void {
        const workerImage: string = BASE.isInfernoMainYardOrOutpost ? "BYM_WorkerGuy2.png" : "helpinghand.png";
        const mc: any = new (GLOBAL as any).popup_noworker();
        if (!BASE.isMainYard) {
            mc.tA.htmlText = KEYS.Get("worker_busy");
            mc.tB.htmlText = KEYS.Get("worker_speedupoutpost", { v1: QUEUE.GetFinishCost() });
            mc.bGet.SetupKey("btn_speedup");
            mc.bGet.addEventListener(MouseEvent.CLICK, () => {
                POPUPS.DisplayWorkerNext(actionType, building);
            });
            mc.bGet.Highlight = true;
        } else {
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_hireanother_title") + "</b>";
            if (QUEUE.GetBuilding()) {
                mc.tB.htmlText = KEYS.Get("worker_speedup", { v1: QUEUE.GetFinishCost() });
                mc.bGet.SetupKey("btn_speedup");
                mc.bGet.addEventListener(MouseEvent.CLICK, () => {
                    POPUPS.DisplayWorkerNext(actionType, building);
                });
            } else {
                mc.bGet.SetupKey("btn_hireanother");
                mc.tB.htmlText = KEYS.Get("pop_hireanother_body");
                mc.bGet.addEventListener(MouseEvent.CLICK, () => {
                    STORE.ShowB(1, 0, ["BEW"]);
                    POPUPS.Next();
                });
            }
            mc.bGet.Highlight = true;
        }
        POPUPS.Push(mc, null, null, "", workerImage);
    }

    private static DisplayWorkerNext(actionType: number, building: any): void {
        const finishCost: number = QUEUE.GetFinishCost();
        GLOBAL._selectedBuilding = QUEUE.GetBuilding();
        if (finishCost > BASE._credits.Get()) {
            POPUPS.Next();
            POPUPS.DisplayGetShiny();
            return;
        }
        if (GLOBAL._selectedBuilding) {
            STORE._storeItems.SP4.c = [finishCost];
            STORE.BuyB("SP4");
            POPUPS.Next();
        }
        if (actionType === 0) {
            BUILDINGS.Hide();
            BASE.addBuildingB(building as number);
        } else {
            const bldg: BFOUNDATION = building as BFOUNDATION;
            if (actionType === 1 && bldg) {
                if (Math.floor(bldg._buildingProps.costs[bldg._lvl.Get()].time.Get() * GLOBAL._buildTime) > 3600) {
                    UPDATES.Create(["BU", bldg._id]);
                }
                BUILDINGOPTIONS.Hide();
                bldg.UpgradeB();
                BASE.Save();
            } else if (actionType === 2 && bldg) {
                BUILDINGINFO.Hide();
                MUSHROOMS.PickWorker(bldg);
            } else if (actionType === 3 && bldg) {
                if (Math.floor(bldg._buildingProps.fortify_costs[bldg._fortification.Get()].time.Get() * GLOBAL._buildTime) > 3600) {
                    UPDATES.Create(["BF", bldg._id]);
                }
                BUILDINGOPTIONS.Hide();
                bldg.FortifyB();
                BASE.Save();
            }
        }
        POPUPS.Next();
    }

    public static DisplayPleaseBuy(key: string): void {
        const popupMC: any = new (GLOBAL as any).popup_pleasebuy();
        popupMC.bAction.SetupKey("str_getmore_btn");
        popupMC.bAction.addEventListener(MouseEvent.CLICK, () => {
            popupMC.bAction.Enabled = false;
            BUY.Show();
        });
        popupMC.tMessage.htmlText = KEYS.Get("pop_marketing_getshiny");
        POPUPS.Push(popupMC, null, null, "", "purchased.png");
    }

    public static DisplayGeneric(title: string, message: string, buttonText: string, image: string, action: Function): void {
        const mc: any = new (GLOBAL as any).popup_generic();
        mc.tA.autoSize = TextFieldAutoSize.LEFT;
        mc.tB.autoSize = TextFieldAutoSize.LEFT;
        mc.tA.htmlText = "<b>" + title + "</b>";
        mc.tB.htmlText = message;
        mc.bAction.Setup(buttonText);
        mc.bAction.addEventListener(MouseEvent.CLICK, action);
        mc.bAction.Highlight = true;
        mc.tB.y = mc.tA.y + mc.tA.height + 5;
        mc.mcBG.height = 0 - mc.mcBG.y + mc.tB.y + mc.tB.height + 50;
        if (mc.mcBG.height < 190) mc.mcBG.height = 190;
        mc.bAction.y = mc.mcBG.y + mc.mcBG.height - 45;
        mc.mcBG.Setup();
        POPUPS.Push(mc, null, null, "", image);
    }

    public static DisplayDialogue(title: string, message: string, buttonText: string, image: string, 
                                   imageOffset: Point, action: Function): MovieClip {
        const dialogueMC: any = new (GLOBAL as any).popup_dialogue();
        dialogueMC.tTitle.htmlText = "<b>" + title + "</b>";
        dialogueMC.tBody.htmlText = message;
        dialogueMC.bAction.Setup(buttonText);
        if (action) {
            dialogueMC.bAction.addEventListener(MouseEvent.CLICK, action);
            dialogueMC.bAction.Highlight = true;
        }
        dialogueMC.tBody.y = dialogueMC.tTitle.y + dialogueMC.tTitle.height + 5;
        dialogueMC.mcBG.height = 0 - dialogueMC.mcBG.y + dialogueMC.tTitle.y + dialogueMC.tTitle.height + 50;
        if (dialogueMC.mcBG.height < 190) dialogueMC.mcBG.height = 190;
        if (image) {
            ImageCache.GetImageWithCallBack(image, (imgPath: string, bmd: BitmapData) => {
                const bmp: Bitmap = new Bitmap(bmd);
                bmp.x = imageOffset.x;
                bmp.y = -bmp.height + imageOffset.y;
                dialogueMC.mcImage.addChild(bmp);
            }, true, 0);
        }
        return dialogueMC;
    }
}
