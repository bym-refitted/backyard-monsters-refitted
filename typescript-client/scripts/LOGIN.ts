import { AuthForm } from './com/auth/AuthForm';
import { SecNum } from './com/cc/utils/SecNum';
import { BYMDevConfig } from './com/monsters/configs/BYMDevConfig';
import { EnumYardType } from './com/monsters/enums/EnumYardType';
import { MapRoomManager } from './com/monsters/maproom_manager/MapRoomManager';
import { Player } from './com/monsters/player/Player';
import { RADIO } from './com/monsters/radio/RADIO';
import Event from 'openfl/events/Event';
import IOErrorEvent from 'openfl/events/IOErrorEvent';
import { BASE } from './BASE';
import { GAME } from './GAME';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { LOGGER } from './LOGGER';
import { md5 } from './md5';
import { PLEASEWAIT } from './PLEASEWAIT';
import { POPUPS } from './POPUPS';
import { URLLoaderApi } from './URLLoaderApi';

/**
 * LOGIN - User Authentication System
 * Handles login flow, authentication, and session initialization
 */
export class LOGIN {
    public static _playerID: number = 0;
    public static _playerName: string = "";
    public static _playerLastName: string = "";
    public static _playerPic: string = "";
    public static _timePlayed: number = 0;
    public static _playerLevel: number = 0;
    public static _email: string = "";
    public static _proxymail: string = "";
    public static _settings: Record<string, any> | null = null;
    public static _digits: number[] = [];
    public static _sumdigit: number = 0;
    public static _inferno: number = 0;
    public static authForm: AuthForm | null = null;
    public static token: string = "";

    constructor() {}

    public static Login(): void {
        if (GAME.token) {
            PLEASEWAIT.Show("Logging in...");
            GLOBAL.eventDispatcher.addEventListener(KEYS.LANGUAGE_FILE_LOADED, LOGIN.onLanguageLoaded);
            GLOBAL.LanguageSetup();
        } else {
            LOGIN.authForm = new AuthForm();
            GLOBAL._layerTop.addChild(LOGIN.authForm);
        }
    }

    private static onLanguageLoaded(event: Event): void {
        GLOBAL.eventDispatcher.removeEventListener(KEYS.LANGUAGE_FILE_LOADED, LOGIN.onLanguageLoaded);
        new URLLoaderApi().load(GLOBAL._apiURL + "bm/getnewmap", null,
            (serverData: any): void => {
                LOGIN.OnGetNewMap(serverData, [["token", GAME.sharedObj.data.token]]);
            });
    }

    public static OnGetNewMap(serverData: any, authInfo: [string, string][]): void {
        LOGIN._Login(serverData.newmap, serverData.mapheaderurl, authInfo);
    }

    private static _Login(newmap: boolean, mapheaderurl: string, authInfo: [string, string][]): void {
        MapRoomManager.instance.init(newmap, mapheaderurl);
        if (GLOBAL._local) {
            const handleLoadSuccessful = (serverData: any): void => {
                if (serverData.hasOwnProperty("error") && serverData.error !== 0) {
                    GLOBAL.Message(serverData.error);
                    return;
                }
                if (serverData.error === 0) {
                    if (GLOBAL._local) {
                        LOGIN.token = serverData.token;
                        LOGIN.Process(serverData);
                    }
                }
            };
            const handleLoadError = (error: IOErrorEvent): void => {
                GLOBAL._layerTop.addChild(GLOBAL.Message("An error occurred during login on the server."));
            };
            new URLLoaderApi().load(GLOBAL._apiURL + "player/getinfo", 
                [["version", GLOBAL._version.Get()], ...authInfo], handleLoadSuccessful, handleLoadError);
        } else {
            // Browser mode with ExternalInterface - not implemented for local version
            if (BYMDevConfig.instance.USE_CLIENT_WITH_CALLBACK) {
                GLOBAL.CallJSWithClient("cc.initApplication", "loginsuccessful", [GLOBAL._version.Get()]);
            } else {
                GLOBAL.CallJS("cc.initApplication", [GLOBAL._version.Get(), "loginsuccessful"]);
            }
            LOGIN.logFlashCapabilities();
        }
    }

    public static Process(serverData: any): void {
        if (serverData.version !== GLOBAL._version.Get()) {
            LOGIN.handleVersionMismatch(serverData);
        } else {
            LOGIN.handleUserLogin(serverData);
        }
    }

    private static handleUserLogin(serverData: any): void {
        if (LOGIN.authForm) {
            LOGIN.authForm.disposeUI();
        }
        if (serverData) {
            GLOBAL.player = new Player();
            GLOBAL.player.ID = serverData.userid;
            GLOBAL.player.name = serverData.username;
            GLOBAL.player.lastName = serverData.last_name;
            GLOBAL.player.picture = serverData.pic_square;
            GLOBAL.player.timePlayed = serverData.timeplayed;
            GLOBAL.player.email = serverData.email;
            LOGIN._playerID = serverData.userid;
            LOGIN._playerName = serverData.username;
            LOGIN._playerLastName = serverData.last_name;
            LOGIN._playerPic = serverData.pic_square;
            LOGIN._timePlayed = serverData.timeplayed;
            LOGIN._email = serverData.email;
            if (serverData.stats) {
                if (serverData.stats.inferno !== undefined) {
                    LOGIN._inferno = serverData.stats.inferno;
                }
            }
            GLOBAL._friendCount = serverData.friendcount;
            GLOBAL._sessionCount = serverData.sessioncount;
            GLOBAL._addTime = serverData.addtime;
            GLOBAL._mapVersion = serverData.mapversion;
            GLOBAL._mailVersion = serverData.mailversion;
            GLOBAL._soundVersion = serverData.soundversion;
            GLOBAL._languageVersion = serverData.languageversion;
            GLOBAL._appid = serverData.app_id;
            GLOBAL._tpid = serverData.tpid;
            GLOBAL._currencyURL = serverData.currency_url;
            if (serverData.bookmarks) {
                MapRoomManager.instance.bookmarkData = serverData.bookmarks;
            } else {
                MapRoomManager.instance.bookmarkData = {};
            }
            if (serverData.settings) {
                LOGIN._settings = serverData.settings;
                RADIO.Setup(LOGIN._settings);
            }
            if (serverData.proxy_email) {
                LOGIN._proxymail = serverData.proxy_email;
            }
            if (!serverData.languageversion) {
                GLOBAL._languageVersion = 8;
            }
            if (serverData.sendgift === 1) {
                GLOBAL._canGift = true;
            }
            if (serverData.sendinvite === 1) {
                GLOBAL._canInvite = true;
            }
            BASE._isFan = serverData.isfan;
            if (serverData.ncpCandidate === 1) {
                GLOBAL._fbcncp = serverData.ncpCandidate;
            }
            POPUPS.Setup();
            LOGIN.Digits(LOGIN._playerID);
            LOGIN.Done();
        }
    }

    private static handleVersionMismatch(serverData: any): void {
        const eventData: any = {
            tag: "userload",
            version_mismatch_h: 1,
            vh2: serverData.version,
            vh1: GLOBAL._version.Get()
        };
        GLOBAL.CallJS("cc.logGenericEvent", [eventData]);
        GLOBAL.ErrorMessage(KEYS.Get("msg_updatedgame"), GLOBAL.ERROR_ORANGE_BOX_ONLY);
    }

    public static Digits(playerId: number): void {
        const str: string = playerId.toString();
        LOGIN._digits = [];
        for (let i = 0; i < str.length; i++) {
            LOGIN._digits.push(parseInt(str.charAt(i)));
        }
        LOGIN._sumdigit = 0;
        if (LOGIN._digits.length >= 3) {
            const sum: number = LOGIN._digits[LOGIN._digits.length - 1] + 
                                LOGIN._digits[LOGIN._digits.length - 2] + 
                                LOGIN._digits[LOGIN._digits.length - 3];
            const sumStr: string = sum.toString();
            LOGIN._sumdigit = parseInt(sumStr.substr(sumStr.length - 1, 1));
        }
    }

    public static Done(): void {
        GLOBAL.Setup();
        if (GLOBAL._openBase && GLOBAL._openBase.url && 
            (GLOBAL._openBase.userid || GLOBAL._openBase.baseid) && 
            GLOBAL._openBase.userid !== LOGIN._playerID) {
            BASE.yardType = MapRoomManager.instance.isInMapRoom3 ? EnumYardType.PLAYER : EnumYardType.MAIN_YARD;
            if (!GLOBAL._openBase.userid) GLOBAL._openBase.userid = 0;
            if (!GLOBAL._openBase.baseid) GLOBAL._openBase.baseid = 0;
            GLOBAL._currentCell = null;
            GLOBAL.setMode(GLOBAL.e_BASE_MODE.HELP);
            for (let i = 1; i < 5; i++) {
                GLOBAL._resources["r" + i] = new SecNum(0);
                GLOBAL._hpResources["r" + i] = 0;
            }
            BASE.Load(GLOBAL._openBase.url, GLOBAL._openBase.userid, GLOBAL._openBase.baseid);
        } else if (LOGIN._inferno !== 0) {
            MapRoomManager.instance.mapRoomVersion = MapRoomManager.MAP_ROOM_VERSION_1;
            BASE.yardType = EnumYardType.INFERNO_YARD;
            BASE.LoadBase(GLOBAL._infBaseURL, 0, 0, "ibuild", false, EnumYardType.INFERNO_YARD);
        } else {
            BASE.yardType = MapRoomManager.instance.isInMapRoom3 ? EnumYardType.PLAYER : EnumYardType.MAIN_YARD;
            BASE.Load();
        }
    }

    private static logFlashCapabilities(): void {
        const capabilities: any = {
            flash_version: "HTML5",
            screen_resolution: window.screen.width + "x" + window.screen.height,
            screen_dpi: window.devicePixelRatio * 96
        };
        GLOBAL.CallJS("cc.logFlashCapabilities", [capabilities]);
    }

    public static checkHash(data: string): boolean {
        const parts: string[] = data.split(",\"h\":");
        data = parts[0] + "}";
        const hashPart: string = "{\"h\":" + parts[1];
        const decoded = JSON.parse(data);
        const hashDecoded = JSON.parse(hashPart);
        const hash: string = md5(LOGIN.getSalt() + data + LOGIN.getNum(hashDecoded.hn));
        if (hash !== hashDecoded.h) {
            return false;
        }
        return true;
    }

    public static getNum(n: number): number {
        return n * (n % 11);
    }

    public static getSalt(): string {
        return LOGIN.decodeSalt("84V37530976X4W7175W9Z02U3483Y6VW");
    }

    public static decodeSalt(input: string): string {
        let result: string = "";
        for (let i = 0; i < input.length; i++) {
            const char: string = input.substring(i, i + 1);
            const charMap: Record<string, string> = {
                "a": "Z", "b": "Y", "c": "X", "d": "W", "e": "V", "f": "U", "g": "T", "h": "S", "i": "R",
                "j": "Q", "k": "P", "l": "O", "m": "N", "n": "M", "o": "L", "p": "K", "q": "J", "r": "I",
                "s": "H", "t": "G", "u": "F", "v": "E", "w": "D", "x": "C", "y": "B", "z": "A",
                "A": "z", "B": "y", "C": "x", "D": "w", "E": "v", "F": "u", "G": "t", "H": "s", "I": "r",
                "J": "q", "K": "p", "L": "o", "M": "n", "N": "m", "O": "l", "P": "k", "Q": "j", "R": "i",
                "S": "h", "T": "g", "U": "f", "V": "e", "W": "d", "X": "c", "Y": "b", "Z": "a",
                "0": "9", "1": "8", "2": "7", "3": "6", "4": "5", "5": "4", "6": "3", "7": "2", "8": "1", "9": "0"
            };
            result += charMap[char] || char;
        }
        return result;
    }
}
