import { EnumYardType } from './com/monsters/enums/EnumYardType';
import IOErrorEvent from 'openfl/events/IOErrorEvent';
import { BASE } from './BASE';
import { CHAMPIONCAGE } from './CHAMPIONCAGE';
import { CREATURELOCKER } from './CREATURELOCKER';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { URLLoaderApi } from './URLLoaderApi';

/**
 * LOGGER - Logging and Statistics System
 * Handles debug logging, game statistics, and analytics
 */
export class LOGGER {
    public static _logged: Record<string, number> = {};
    public static _statQueue: any[] = [];
    public static _statUpdated: number = 0;
    public static readonly STAT_MEM: number = 99;

    constructor() {}

    public static Log(logType: string, message: string, force: boolean = false): void {
        if (message.search("recorddebugdata") !== -1) {
            return;
        }
        if (force || !GLOBAL._flags || (GLOBAL._flags && GLOBAL._flags.gamedebug === 1)) {
            if (!LOGGER._logged[logType + message]) {
                if (logType === "hak" || logType === "err" || logType === "log") {
                    LOGGER._logged[logType + message] = 1;
                }
                message = "" + "[v" + GLOBAL._version.Get() + "" + "r" + GLOBAL._softversion + "] " + message + " [mode: " + GLOBAL._loadmode + " baseid:" + BASE._baseID + "]";
                const data: [string, string | number][] = [["key", logType], ["value", message], ["saveid", BASE._lastSaveID]];
                console.log(data.toString());
                new URLLoaderApi().load(GLOBAL._apiURL + "player/recorddebugdata", data, LOGGER.handleLoadSuccessful, LOGGER.handleLoadError);
            }
        }
    }

    public static info(message: string): void {
        LOGGER.Log("info", message);
    }

    public static Stat(data: any[]): void {
        if (!GLOBAL._flags.gamestatsb) {
            return;
        }
        try {
            let st1: string | null = null;
            let st2: string | null = null;
            let st3: string | null = null;
            let name: string = "";
            let val: number = 0;
            let n2: number = 0;
            let monsterID: string;
            let yardType: string;

            // Building and monster stats
            if (data[0] >= 1 && data[0] <= 4 || data[0] === 26 || data[0] === 51) {
                if (data[0] === 1 || data[0] === 2 || data[0] === 26 || data[0] === 67) {
                    st1 = "buildings";
                }
                if (data[0] === 1) st2 = GLOBAL.e_BASE_MODE.BUILD;
                if (data[0] === 2) st2 = "upgrade";
                if (data[0] === 26) st2 = "repairing";
                if (data[0] === 67) st2 = "fortifying";
                if (data[0] === 3 || data[0] === 4 || data[0] === 51) {
                    st1 = "monsters";
                }
                if (data[0] === 3) st2 = "unlocking";
                if (data[0] === 4) st2 = "training";
                if (data[0] === 51) st2 = "powerup";
                if (data[0] === 1 || data[0] === 2 || data[0] === 26 || data[0] === 67) {
                    st3 = KEYS.Get(GLOBAL._buildingProps[data[1] - 1].name);
                } else {
                    monsterID = BASE.isInfernoMainYardOrOutpost ? "IC" : "C";
                    st3 = KEYS.Get(CREATURELOCKER._creatures[monsterID + data[1]].name);
                }
                name = "speedup";
                val = data[4] as number;
            } else if (data[0] === 5) {
                st1 = "buildings"; st2 = GLOBAL.e_BASE_MODE.BUILD;
                st3 = KEYS.Get(GLOBAL._buildingProps[data[1] - 1].name);
                name = "build_start";
            } else if (data[0] === 6) {
                st1 = "buildings"; st2 = GLOBAL.e_BASE_MODE.BUILD;
                st3 = KEYS.Get(GLOBAL._buildingProps[data[1] - 1].name);
                name = "build_finish";
            } else if (data[0] === 7) {
                st1 = "buildings"; st2 = "upgrade";
                st3 = KEYS.Get(GLOBAL._buildingProps[data[1] - 1].name);
                name = "upgrade_start"; val = data[2] as number;
            } else if (data[0] === 8) {
                st1 = "buildings"; st2 = "upgrade";
                st3 = KEYS.Get(GLOBAL._buildingProps[data[1] - 1].name);
                name = "upgrade_finish"; val = data[2] as number;
            } else if (data[0] === 9) {
                st1 = "monsters"; st2 = "unlock";
                monsterID = BASE.isInfernoMainYardOrOutpost ? "IC" : "C";
                st3 = KEYS.Get(CREATURELOCKER._creatures[monsterID + data[1]].name);
                name = "start";
            } else if (data[0] === 10) {
                st1 = "monsters"; st2 = "unlock";
                monsterID = BASE.isInfernoMainYardOrOutpost ? "IC" : "C";
                st3 = KEYS.Get(CREATURELOCKER._creatures[monsterID + data[1]].name);
                name = "finish";
            } else if (data[0] === 11) {
                st1 = "monsters"; st2 = "train";
                monsterID = BASE.isInfernoMainYardOrOutpost ? "IC" : "C";
                st3 = KEYS.Get(CREATURELOCKER._creatures[monsterID + data[1]].name);
                name = "start"; val = data[2] as number;
            } else if (data[0] === 12) {
                st1 = "monsters"; st2 = "train";
                monsterID = BASE.isInfernoMainYardOrOutpost ? "IC" : "C";
                st3 = KEYS.Get(CREATURELOCKER._creatures[monsterID + data[1]].name);
                name = "finish"; val = data[2] as number;
            } else if (data[0] === 13) {
                st1 = "store"; st2 = String(data[1]);
                name = "cost"; val = data[2] as number;
            } else if (data[0] === 14 || data[0] === 15 || data[0] === 66) {
                st1 = "helping"; st2 = "buildings";
                name = String(data[1]); val = data[4] as number;
            } else if (data[0] === 17) {
                st1 = "looting"; st2 = KEYS.Get(GLOBAL._resourceNames[data[1] - 1]);
                name = "quantity"; val = data[2] as number;
            } else if (data[0] === 18) {
                st1 = "looting"; st2 = KEYS.Get(GLOBAL._resourceNames[data[1] - 1]);
                name = "percent"; val = data[2] as number;
            } else if (data[0] === 27) {
                st1 = "catapult";
                if (data[1] === 1) st2 = "twig";
                if (data[1] === 2) st2 = "pebble";
                if (data[1] === 3) st2 = "putty";
                if (data[2] === 0) name = "small";
                if (data[2] === 1) name = "medium";
                if (data[2] === 2) name = "large";
                if (data[2] === 3) name = "huge";
                val = data[3] as number;
                if (data.length > 4) n2 = data[4] as number;
            } else if (data[0] === 28) {
                st1 = "flinger"; name = String(data[1]); val = data[2] as number;
                if (data.length > 3) n2 = data[3] as number;
            } else if (data[0] === 29) {
                st1 = "load"; name = String(data[1]);
            } else if (data[0] === 30) {
                st1 = "tutorial"; name = "start";
            } else if (data[0] === 31) {
                st1 = "tutorial"; name = "finish";
            } else if (data[0] === 32) {
                st1 = "banking"; name = KEYS.Get(GLOBAL._resourceNames[data[1] - 1]); val = data[2] as number;
            } else if (data[0] === 33) {
                st1 = "levelup"; name = "level" + data[1];
            } else if (data[0] === 34) {
                st1 = "mushrooms"; name = "pick"; val = data[1] as number;
            } else if (data[0] === 35) {
                st1 = "mushrooms"; name = "spawn"; val = data[1] as number;
            } else if (data[0] === 36) {
                st1 = "marketing"; name = String(data[1]); val = 1;
            } else if (data[0] === 37) {
                st1 = "takeover"; name = data[1] === 1 ? "wildmonster" : "player"; val = 1;
            } else if (data[0] === 38) {
                st1 = "starterkit"; name = String(data[1]); val = data[2] as number;
            } else if (data[0] === 39) {
                st1 = "mushrooms"; name = "prompt";
            } else if (data[0] === 40) {
                st1 = "buildings"; st2 = "recycle";
                st3 = KEYS.Get(GLOBAL._buildingProps[data[1] - 1].name);
                name = "level"; val = data[2] as number;
            } else if (data[0] === 41) {
                st1 = "starterkit"; name = String(data[1]); val = data[2] as number;
            } else if (data[0] === 42) {
                st1 = "dailybonus"; name = "drop";
                LOGGER.Log("log", "db:drop", true);
            } else if (data[0] === 43) {
                st1 = "dailybonus"; name = "win"; val = data[1] as number;
                LOGGER.Log("log", "db:win " + data[1], true);
            } else if (data[0] === 44) {
                st1 = "dailybonus"; name = "buy"; val = data[1] as number;
                LOGGER.Log("log", "db:buy " + data[1], true);
            } else if (data[0] === 45) {
                st1 = "mapv2relocate"; name = "mine"; val = data[1] as number;
            } else if (data[0] === 46) {
                st1 = "monsters"; st2 = "unlock";
                monsterID = BASE.isInfernoMainYardOrOutpost ? "IC" : "C";
                st3 = KEYS.Get(CREATURELOCKER._creatures[monsterID + data[1]].name);
                name = "instant";
            } else if (data[0] === 47) {
                st1 = "monsters"; st2 = "train";
                st3 = KEYS.Get(CREATURELOCKER._creatures[data[1]].name);
                name = "instant"; val = data[2] as number;
            } else if (data[0] === 48) {
                st1 = "monsters"; st2 = "powerup";
                monsterID = BASE.isInfernoMainYardOrOutpost ? "IC" : "C";
                st3 = KEYS.Get(CREATURELOCKER._creatures[monsterID + data[1]].name);
                name = "shiny"; val = data[2] as number;
            } else if (data[0] === 49) {
                st1 = "monsters"; st2 = "powerup";
                monsterID = BASE.isInfernoMainYardOrOutpost ? "IC" : "C";
                st3 = KEYS.Get(CREATURELOCKER._creatures[monsterID + data[1]].name);
                name = "start"; val = data[2] as number;
            } else if (data[0] === 50) {
                st1 = "monsters"; st2 = "powerup";
                monsterID = BASE.isInfernoMainYardOrOutpost ? "IC" : "C";
                st3 = KEYS.Get(CREATURELOCKER._creatures[monsterID + data[1]].name);
                name = "finish"; val = data[2] as number;
            } else if (data[0] === 59) {
                st1 = "champion"; st2 = "heal";
                name = "level" + data[3];
                st3 = String(CHAMPIONCAGE._guardians[data[1]].name);
                val = data[2] as number;
            } else if (data[0] === 52) {
                st1 = "champion"; st2 = "select";
                name = "level1";
                st3 = String(CHAMPIONCAGE._guardians[data[1]].name);
                val = data[2] as number;
            } else if (data[0] === 53) {
                st1 = "champion"; st2 = "attack_win";
                name = "level" + data[3];
                st3 = String(CHAMPIONCAGE._guardians[data[1]].name);
                val = data[2] as number;
            } else if (data[0] === 54) {
                st1 = "champion"; st2 = "attack_lose";
                name = "level" + data[3];
                st3 = String(CHAMPIONCAGE._guardians[data[1]].name);
                val = data[2] as number;
            } else if (data[0] === 55) {
                st1 = "champion"; st2 = "defense_win";
                name = "level" + data[3];
                st3 = String(CHAMPIONCAGE._guardians[data[1]].name);
                val = data[2] as number;
            } else if (data[0] === 56) {
                st1 = "champion"; st2 = "defense_lose";
                name = "level" + data[3];
                st3 = String(CHAMPIONCAGE._guardians[data[1]].name);
                val = data[2] as number;
            } else if (data[0] === 57) {
                st1 = "champion"; st2 = "evolve";
                name = "level" + data[3];
                st3 = String(CHAMPIONCAGE._guardians[data[1]].name);
                val = data[2] as number;
            } else if (data[0] === 58) {
                st1 = "champion"; st2 = "feed";
                name = "level" + data[3];
                st3 = String(CHAMPIONCAGE._guardians[data[1]].name);
                val = data[2] as number;
            } else if (data[0] === 60) {
                st1 = "champion"; st2 = "feed";
                name = "buff" + data[3];
                st3 = String(CHAMPIONCAGE._guardians[data[1]].name);
                val = data[2] as number;
            } else if (data[0] === 61) {
                st1 = BASE.isInfernoMainYardOrOutpost ? "storeinf" : "store";
                st2 = String(data[1]);
                name = "cost-var"; val = data[2] as number;
            } else if (data[0] === 62) {
                st1 = "zazzle"; name = "view"; val = data[1] as number;
            } else if (data[0] === 63) {
                st1 = "zazzle"; name = "click"; val = data[1] as number;
            } else if (data[0] === 64) {
                st1 = "buildings"; st2 = "fortify" + data[2];
                st3 = KEYS.Get(GLOBAL._buildingProps[data[1] - 1].name);
                name = "fortify_start"; val = 1;
            } else if (data[0] === 65) {
                st1 = "buildings"; st2 = "fortify" + data[2];
                st3 = KEYS.Get(GLOBAL._buildingProps[data[1] - 1].name);
                name = "fortify_finish"; val = 1;
            } else if (data[0] === 68) {
                st1 = "chat"; name = String(data[1]); val = 1;
            } else if (data[0] === 69) {
                st1 = "champion"; st2 = "freeze";
                st3 = String(CHAMPIONCAGE._guardians["G" + data[1]].name);
                name = "Level" + data[2]; val = 1;
            } else if (data[0] === 70) {
                st1 = "champion"; st2 = "thaw";
                st3 = String(CHAMPIONCAGE._guardians["G" + data[1]].name);
                name = "Level" + data[2]; val = 1;
            } else if (data[0] === 71) {
                st1 = "buildings"; st2 = GLOBAL.e_BASE_MODE.BUILD;
                st3 = KEYS.Get(GLOBAL._buildingProps[data[2] - 1].name);
                name = "build_instant"; val = data[1] as number;
            } else if (data[0] === 72) {
                st1 = "buildings"; st2 = "upgrade";
                st3 = KEYS.Get(GLOBAL._buildingProps[data[2] - 1].name) + "_level" + data[3];
                name = "upgrade_instant"; val = data[1] as number;
            } else if (data[0] >= 74 && data[0] <= 78) {
                st1 = "711promo";
                const promoNames: Record<number, string> = {74: "popup", 75: "goldenbiggulp", 76: "overdriveused", 77: "tutorial", 78: "redemption"};
                name = promoNames[data[0]]; val = data[1] as number;
            } else if (data[0] >= 79 && data[0] <= 86) {
                const wmiPrefix = data[0] <= 82 ? "WMI" : "WMI2";
                st1 = wmiPrefix;
                const wmiNames: Record<number, string> = {79: "attempted", 80: "success", 81: "failed", 82: "totem_placed"};
                if (data[0] <= 82) {
                    name = wmiNames[data[0]]; val = data[1] as number;
                } else {
                    const wmi2Names: Record<number, string> = {83: "attempted", 84: "success", 85: "failed", 86: "totem_placed"};
                    st2 = wmi2Names[data[0]]; name = String(data[1]);
                }
            } else if (data[0] === 87) {
                st1 = "Inferno"; st2 = "Descent";
                st3 = String(data[1]); name = String(data[2]);
            } else if (data[0] === 88) {
                st1 = "loadmode"; name = String(data[1]);
                const yardTypes: Record<number, string> = {
                    [EnumYardType.MAIN_YARD]: "main_yard",
                    [EnumYardType.OUTPOST]: "outpost",
                    [EnumYardType.INFERNO_YARD]: "inferno_yard",
                    [EnumYardType.INFERNO_OUTPOST]: "outpost"
                };
                st2 = yardTypes[data[2]] || "none";
            } else if (data[0] === 89) {
                st1 = "attackpref"; st2 = "inferno"; name = String(data[1]);
            } else if (data[0] >= 90 && data[0] <= 94) {
                st1 = "siege-weapon";
                const siegeNames: Record<number, string> = {90: "unlock", 91: "upgrade", 92: GLOBAL.e_BASE_MODE.BUILD, 93: "used_in_battle", 94: "vacuumloot"};
                st2 = siegeNames[data[0]];
                if (data[0] <= 92) {
                    st3 = String(data[1] + data[2]); name = String(data[3]);
                    if (data[4]) val = data[4] as number;
                } else if (data[0] === 93) {
                    name = String(data[1] + data[2]);
                } else {
                    st3 = "defender"; name = String(data[1] + data[2]);
                }
            } else if (data[0] === 95) {
                st1 = "video"; val = 1; name = "showed";
            } else if (data[0] === 96) {
                st1 = "banking"; st2 = "autobank";
                const bankNames: Record<number, string> = {1: "Twigs", 2: "Pebbles", 3: "Putty", 4: "Goo"};
                name = bankNames[data[1]] || ""; val = data[2] as number;
            } else if (data[0] === 97) {
                st1 = "Monster_Madness"; val = data[1] as number; name = "EV_current";
            } else if (data[0] === 98) {
                st1 = "video"; val = data[1] as number; name = "EV_taken";
            } else if (data[0] === LOGGER.STAT_MEM) {
                st1 = "performance"; st2 = "mem";
                name = String(data[1]); val = data[2] as number; n2 = data[3] as number;
            }

            if (st1) {
                const o: Record<string, any> = {};
                o.st1 = st1.toLowerCase().replace(" ", "_");
                if (BASE.isOutpost) o.st1 = "outpost-" + o.st1;
                if (BASE.isMainYardInfernoOnly) o.st1 = "inferno-" + o.st1;
                if (st2) o.st2 = st2.toLowerCase().replace(" ", "_");
                if (st3) o.st3 = st3.toLowerCase().replace(" ", "_");
                if (val) o.value = val;
                if (n2) o.n2 = n2;
                LOGGER.StatB(o, name);
            }
        } catch (e: any) {
            LOGGER.Log("log", "LOGGER.Stat " + data);
        }
    }

    public static StatB(stats: Record<string, any>, name: any): void {
        if (!GLOBAL._flags || !GLOBAL._flags.gamestatsb) {
            return;
        }
        stats.level = BASE.BaseLevel().level;
        GLOBAL.CallJS("cc.recordEvent", [name, stats], false);
    }

    public static KongStat(data: any[]): void {
        if (!GLOBAL._flags.kongregate) {
            return;
        }
        try {
            const monsternames: string[] = ["pokey", "octo", "bolt", "fink", "eyera", "ichi", "bandito", "fang", "brain", "crabatron", "projectx", "dave", "wormzer", "teratorn", "zafreeti"];
            let arg: Record<string, any> | null = null;
            switch (data[0]) {
                case 1:
                    arg = {}; arg["unlock_" + monsternames[data[1] - 1]] = 1;
                    break;
                case 2:
                    arg = { Townhall: data[1] };
                    break;
                case 3:
                    arg = { looted: data[1] };
                    break;
                case 4:
                    arg = { defense: data[1] };
                    break;
                case 5:
                    arg = {}; arg["train_" + monsternames[data[1] - 1]] = 1;
                    break;
            }
            if (arg) {
                GLOBAL.CallJS("cc.kg_statsUpdate", [arg], false);
            }
        } catch (e: any) {
            LOGGER.Log("err", "LOGGER.KongStat " + data);
        }
    }

    public static Tick(): void {
        // Periodic tick for stats processing
    }

    public static handleLoadSuccessful(response: any): void {
        if (response.error === 0) {
            // Success
        }
    }

    public static handleLoadError(event: IOErrorEvent): void {
        // Error handling
    }
}
