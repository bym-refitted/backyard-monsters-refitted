import { SWFProfiler } from './com/flashdynamix/utils/SWFProfiler';
import { ALLIANCES } from './com/monsters/alliances/ALLIANCES';
import { Console } from './com/monsters/debug/Console';
import { EnumYardType } from './com/monsters/enums/EnumYardType';
import { MapRoomManager } from './com/monsters/maproom_manager/MapRoomManager';
import { MarketingRecapture } from './com/monsters/marketing/MarketingRecapture';
import { RADIO } from './com/monsters/radio/RADIO';
import MovieClip from 'openfl/display/MovieClip';
import Sprite from 'openfl/display/Sprite';
import Stage from 'openfl/display/Stage';
import StageScaleMode from 'openfl/display/StageScaleMode';
import Event from 'openfl/events/Event';
import MouseEvent from 'openfl/events/MouseEvent';
import Rectangle from 'openfl/geom/Rectangle';
import { BASE } from './BASE';
import { BFOUNDATION } from './BFOUNDATION';
import { BUY } from './BUY';
import { GLOBAL } from './GLOBAL';
import { LOGGER } from './LOGGER';
import { LOGIN } from './LOGIN';
import { POPUPS } from './POPUPS';
import { STORE } from './STORE';

/**
 * GAME - Main Game Entry Point
 * Initializes the game, sets up layers, and handles external callbacks
 */
export class GAME extends Sprite {
    public static _instance: GAME | null = null;
    public static _isSmallSize: boolean = true;
    public static _firstLoadComplete: boolean = false;
    public static sharedObj: any = null;
    public static token: string = "";
    public static language: string = "";

    private _checkScreenSize: boolean = true;
    private _previousDistance: number = 0;
    private _scaleFactor: number = 1;

    constructor() {
        super();
        GAME._instance = this;
        GLOBAL._local = typeof window === 'undefined';
        
        const serverUrl: string = GLOBAL.serverUrl;
        const apiVersionSuffix: string = GLOBAL.apiVersionSuffix + "/";
        const cdnUrl: string = GLOBAL.cdnUrl;

        const urls: any = {
            _baseURL: serverUrl + "base/",
            _apiURL: serverUrl + "api/" + apiVersionSuffix,
            infbaseurl: serverUrl + "api/" + apiVersionSuffix + "bm/base/",
            _statsURL: serverUrl + "recordstats.php",
            _mapURL: serverUrl + "worldmapv2/",
            map3url: serverUrl + "worldmapv3/",
            _allianceURL: serverUrl + "alliance/",
            languageurl: cdnUrl + "gamestage/assets/",
            _storageURL: cdnUrl + "assets/",
            _soundPathURL: cdnUrl + "assets/sounds/",
            _gameURL: serverUrl,
            _appid: serverUrl,
            _tpid: serverUrl,
            _currencyURL: serverUrl,
            _countryCode: "us"
        };

        this.Data(urls, {});
    }

    public static disableWindowScroll(event: Event | null = null): void {
        GLOBAL.CallJS("cc.disableMouseWheel");
    }

    public static enableWindowScroll(event: Event | null = null): void {
        GLOBAL.CallJS("cc.enableMouseWheel");
    }

    public setLauncherVars(params: any): void {
        try {
            GAME.sharedObj = localStorage;
            if (params?.language) {
                GAME.language = params.language;
                localStorage.setItem('bymr_language', GAME.language);
            }
            if (params?.token) {
                GAME.token = params.token;
                localStorage.setItem('bymr_token', GAME.token);
            }
        } catch (e: any) {
            LOGGER.Log("err", "Error setting token from loader: " + e.message);
        }
    }

    public Data(urls: any, loaderParams: any): void {
        this.setLauncherVars(loaderParams);
        GLOBAL.init();
        GLOBAL._baseURL = urls._baseURL;
        GLOBAL._infBaseURL = urls.infbaseurl;
        GLOBAL._apiURL = urls._apiURL;
        GLOBAL._gameURL = urls._gameURL;
        GLOBAL._storageURL = urls._storageURL;
        GLOBAL.languageUrl = urls.languageurl;
        GLOBAL._allianceURL = urls._allianceURL;
        GLOBAL._soundPathURL = urls._soundPathURL;
        GLOBAL._statsURL = urls._statsURL;
        GLOBAL._mapURL = urls._mapURL;
        MapRoomManager.instance.mapRoom3URL = urls.map3url;
        GLOBAL._appid = urls.app_id;
        GLOBAL._tpid = urls.tpid;
        GLOBAL._countryCode = urls._countryCode;
        GLOBAL._currencyURL = urls.currency_url;
        GLOBAL._fbdata = urls;
        GLOBAL._monetized = urls.monetized;
        MarketingRecapture.instance.importData(urls.urlparams);

        // Create display layers
        GLOBAL._ROOT = new MovieClip();
        this.addChild(GLOBAL._ROOT);
        GLOBAL._layerMap = GLOBAL._ROOT.addChild(new Sprite()) as Sprite;
        GLOBAL._layerUI = GLOBAL._ROOT.addChild(new Sprite()) as Sprite;
        GLOBAL._layerWindows = GLOBAL._ROOT.addChild(new Sprite()) as Sprite;
        GLOBAL._layerMessages = GLOBAL._ROOT.addChild(new Sprite()) as Sprite;
        GLOBAL._layerTop = GLOBAL._ROOT.addChild(new Sprite()) as Sprite;
        GLOBAL._layerMap.mouseEnabled = false;
        GLOBAL._layerUI.mouseEnabled = false;
        GLOBAL._layerWindows.mouseEnabled = false;
        GLOBAL._layerMessages.mouseEnabled = false;
        GLOBAL._layerTop.mouseEnabled = false;
        GLOBAL.RefreshScreen();

        if (urls.openbase) {
            GLOBAL._openBase = JSON.parse(urls.openbase);
        } else {
            GLOBAL._openBase = null;
        }

        // Start game loop
        this.addEventListener(Event.ENTER_FRAME, GLOBAL.TickFast);
        LOGIN.Login();

        // Set up external interface callbacks (for web)
        this.setupExternalCallbacks();

        if (this._checkScreenSize) {
            GLOBAL._SCREENINIT = GAME._isSmallSize 
                ? new Rectangle(0, 0, 760, 670) 
                : new Rectangle(0, 0, 760, 750);
        }
    }

    private setupExternalCallbacks(): void {
        // External interface callbacks would be set up here for browser integration
        // These handle communication between the game and external JavaScript
        if (typeof window !== 'undefined') {
            (window as any).openbase = (data: string) => {
                if (BASE._saveCounterA === BASE._saveCounterB && !BASE._saving && !BASE._loading) {
                    GLOBAL._currentCell = null;
                    const parsed = JSON.parse(data);
                    const yardType = MapRoomManager.instance.isInMapRoom3 ? EnumYardType.PLAYER : EnumYardType.MAIN_YARD;
                    if (parsed.viewleader) {
                        BASE.LoadBase(parsed.url, parsed.userid, Number(parsed.baseid), GLOBAL.e_BASE_MODE.VIEW, true, yardType);
                    } else if (parsed.infurl && BASE.isInfernoMainYardOrOutpost) {
                        BASE.LoadBase(parsed.infurl, 0, Number(parsed.infbaseid), GLOBAL.e_BASE_MODE.IVIEW, true, EnumYardType.INFERNO_YARD);
                    } else {
                        BASE.LoadBase(parsed.url, parsed.userid, Number(parsed.baseid), GLOBAL.e_BASE_MODE.HELP, true, yardType);
                    }
                }
            };
            (window as any).fbcBuyItem = (data: string) => STORE.FacebookCreditPurchaseB(data);
            (window as any).callbackgift = (data: string) => POPUPS.CallbackGift(data);
            (window as any).callbackshiny = (data: string) => POPUPS.CallbackShiny(data);
            (window as any).twitteraccount = (data: string) => RADIO.TwitterCallback(data);
            (window as any).updateCredits = (data: string) => STORE.updateCredits(data);
            (window as any).fbcAdd = (data: string) => BUY.FBCAdd(data);
            (window as any).fbcOfferDaily = (data: string) => BUY.FBCOfferDaily(data);
            (window as any).fbcOfferEarn = (data: string) => BUY.FBCOfferEarn(data);
            (window as any).fbcNcp = (data: string) => BUY.FBCNcp(data);
            (window as any).fbcNcpConfirm = (data: string) => BUY.FBCNcpConfirm(data);
            (window as any).purchaseReceive = (data: string) => BUY.purchaseReceive(data);
            (window as any).purchaseComplete = (data: string) => BUY.purchaseComplete(data);
            (window as any).receivePurchase = (data: string) => BUY.purchaseReceive(data);
            (window as any).startPromoTimer = (data: string) => BUY.startPromo(data);
            (window as any).alliancesupdate = (data: string) => ALLIANCES.AlliancesServerUpdate(data);
            (window as any).alliancesViewLeader = (data: string) => ALLIANCES.AlliancesViewLeader(data);
            (window as any).openmap = () => GLOBAL.ShowMap();
        }
    }

    public onStageRollOver(event: MouseEvent | null = null): void {
        GAME.disableWindowScroll();
    }

    public onStageRollOut(event: MouseEvent | null = null): void {
        GAME.enableWindowScroll();
    }
}
