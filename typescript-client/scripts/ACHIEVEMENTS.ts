import { BASE } from './BASE';
import { CREATURELOCKER } from './CREATURELOCKER';
import { GLOBAL } from './GLOBAL';
import { LOGGER } from './LOGGER';
import { MAPROOM_DESCENT } from './MAPROOM_DESCENT';
import { QUESTS } from './QUESTS';

/**
 * ACHIEVEMENTS - Achievement System
 * Tracks player progress and unlocked achievements
 */
export class ACHIEVEMENTS {
    public static readonly DESCENT_LEVEL: string = "descentLevel";
    public static readonly UNDERHALL_LEVEL: string = "underhallLevel";
    public static readonly INFERNO_QUESTS_COMPLETED: string = "infernoQuestsCompleted";

    public static _finished: number[] = [];
    public static _stats: Record<string, number> = {
        DESCENT_LEVEL: 0,
        UNDERHALL_LEVEL: 0,
        INFERNO_QUESTS_COMPLETED: 0,
        thlevel: 0,
        map2: 0,
        wmoutpost: 0,
        playeroutpost: 0,
        monstersblended: 0,
        upgrade_champ1: 0,
        upgrade_champ2: 0,
        upgrade_champ3: 0,
        heavytraps: 0,
        hugerage: 0,
        wm2hall: 0,
        blocksbuilt: 0,
        starterkit: 0,
        alliance: 0,
        unlock_monster: 0,
        stockpile: 0
    };

    public static _achievements: any[] = [
        { rules: {}, block: true },
        { rules: { thlevel: 2 } },
        { rules: { thlevel: 5 } },
        { rules: { thlevel: 8 } },
        { rules: { upgrade_champ1: 1, upgrade_champ2: 1, upgrade_champ3: 1 }, ANY: 1 },
        { rules: { upgrade_champ1: 1, upgrade_champ2: 1, upgrade_champ3: 1 } },
        { rules: { map2: 1 } },
        { rules: { wmoutpost: 1 } },
        { rules: { playeroutpost: 5 } },
        { block: true, rules: { hugerage: 1 } },
        { rules: { wm2hall: 1 } },
        { rules: { monstersblended: 5000 } },
        { rules: { blocksbuilt: 200 } },
        { rules: { starterkit: 1 } },
        { rules: { alliance: 1 } },
        { rules: { stockpile: 1 } },
        { rules: { heavytraps: 8 } },
        { rules: { unlock_monster: 1 } },
        { rules: { DESCENT_LEVEL: 1 } },
        { rules: { DESCENT_LEVEL: MAPROOM_DESCENT._descentLvlMax } },
        { rules: { UNDERHALL_LEVEL: 5 } },
        { rules: { INFERNO_QUESTS_COMPLETED: 10 } },
        { rules: { thlevel: 10 } }
    ];

    public static _completed: Record<number, number> = {};

    constructor() {}

    public static Data(data: any): void {
        if (data.s) {
            ACHIEVEMENTS._stats = data.s;
            ACHIEVEMENTS._completed = data.c;
        } else {
            ACHIEVEMENTS._stats = data;
        }
        
        if (!ACHIEVEMENTS._stats.upgrade_champ1 && QUESTS._completed?.UG1) {
            ACHIEVEMENTS._stats.upgrade_champ1 = 1;
        }
        if (!ACHIEVEMENTS._stats.upgrade_champ2 && QUESTS._completed?.UG2) {
            ACHIEVEMENTS._stats.upgrade_champ2 = 1;
        }
        if (!ACHIEVEMENTS._stats.upgrade_champ3 && QUESTS._completed?.UG3) {
            ACHIEVEMENTS._stats.upgrade_champ3 = 1;
        }
        if (ACHIEVEMENTS._stats.monstersblended < QUESTS._global?.monstersblended) {
            ACHIEVEMENTS._stats.monstersblended = QUESTS._global.monstersblended;
        }
        if (!ACHIEVEMENTS._stats.wm2hall && QUESTS._completed?.WM2) {
            ACHIEVEMENTS._stats.wm2hall = 1;
        }
        ACHIEVEMENTS.Check("", 0, true);
    }

    public static CheckRetroactiveAchievments(): void {
        ACHIEVEMENTS.Check(ACHIEVEMENTS.DESCENT_LEVEL, MAPROOM_DESCENT.DescentLevel);
        if (BASE.isInfernoMainYardOrOutpost) {
            ACHIEVEMENTS.Check(ACHIEVEMENTS.INFERNO_QUESTS_COMPLETED, QUESTS.amountCompleted);
        }
    }

    public static Check(stat: string = "", value: number = 0, checkall: boolean = false): void {
        try {
            if (GLOBAL._loadmode === GLOBAL.e_BASE_MODE.BUILD || stat === "hugerage" || checkall) {
                if (stat && ACHIEVEMENTS._stats[stat] !== undefined && ACHIEVEMENTS._stats[stat] < value) {
                    ACHIEVEMENTS._stats[stat] = value;
                }
                if (!ACHIEVEMENTS._completed) {
                    ACHIEVEMENTS._completed = {};
                }
                
                for (let i = 1; i < ACHIEVEMENTS._achievements.length; i++) {
                    const a = ACHIEVEMENTS._achievements[i];
                    let block = false;
                    if (a.block) block = true;
                    
                    if ((checkall || !ACHIEVEMENTS._completed[i]) && !block) {
                        let fail = false;
                        for (const n in a.rules) {
                            if (n === "UNLOCK") {
                                if (!CREATURELOCKER._lockerData[a.rules.UNLOCK] || CREATURELOCKER._lockerData[a.rules.UNLOCK].t === 1) {
                                    fail = true;
                                }
                            } else if (a.rules[n] > ACHIEVEMENTS._stats[n]) {
                                fail = true;
                                if (a.ANY === undefined || a.ANY === 0) break;
                            } else if (a.ANY !== undefined) {
                                break;
                            }
                        }
                        if (!fail) {
                            ACHIEVEMENTS._completed[i] = 1;
                            ACHIEVEMENTS._finished.push(i);
                        }
                    }
                }
            }
        } catch (e: any) {
            LOGGER.Log("err", "ACHIEVEMENTS.Check: " + (e.message || "") + " | " + (e.stack || ""));
        }
    }

    public static Report(): number[] {
        const result: number[] = [];
        for (let i = 0; i < ACHIEVEMENTS._finished.length; i++) {
            result.push(ACHIEVEMENTS._finished[i]);
        }
        ACHIEVEMENTS._finished = [];
        return result;
    }

    public static Export(): any {
        if (!ACHIEVEMENTS._completed) {
            ACHIEVEMENTS._completed = {};
        }
        return {
            s: ACHIEVEMENTS._stats,
            c: ACHIEVEMENTS._completed
        };
    }
}
