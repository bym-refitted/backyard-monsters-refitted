import { SecNum } from './com/cc/utils/SecNum';
import { InstanceManager } from './com/monsters/managers/InstanceManager';
import { BFOUNDATION } from './BFOUNDATION';
import { ACADEMYPOPUP } from './ACADEMYPOPUP';
import { GLOBAL } from './GLOBAL';
import { SOUNDS } from './SOUNDS';
import { BASE } from './BASE';
import { KEYS } from './KEYS';
import { CREATURELOCKER } from './CREATURELOCKER';
import { BUILDING26 } from './BUILDING26';
import { LOGGER } from './LOGGER';
import { POPUPS } from './POPUPS';
import { popup_monster } from './popup_monster';

/**
 * ACADEMY - Handles monster training upgrades
 * Converted from ActionScript to TypeScript
 */
export class ACADEMY {
    public static readonly ID: number = 26;
    
    public static _building: BFOUNDATION | null = null;
    public static _mc: ACADEMYPOPUP | null = null;
    public static _monsterID: string = '';
    public static _open: boolean = false;
    
    private static _monsterString: string = "C";
    private static _maxMonsters: number = 16;
    private static readonly _infernoFrameOffset: number = 6;
    private static readonly _yardMaxMonsters: number = 16;
    private static readonly _infernoMaxMonsters: number = 9;
    
    constructor() {
        // Empty constructor
    }
    
    public static Show(building: BFOUNDATION): void {
        if (!ACADEMY._open) {
            ACADEMY._open = true;
            ACADEMY._building = building;
            GLOBAL.BlockerAdd();
            ACADEMY._mc = GLOBAL._layerWindows.addChild(new ACADEMYPOPUP()) as ACADEMYPOPUP;
            ACADEMY._mc.Center();
            ACADEMY._mc.ScaleUp();
        }
    }
    
    public static Hide(event?: MouseEvent): void {
        if (ACADEMY._open) {
            GLOBAL.BlockerRemove();
            SOUNDS.Play("close");
            BASE.BuildingDeselect();
            ACADEMY._open = false;
            GLOBAL._layerWindows.removeChild(ACADEMY._mc!);
            ACADEMY._mc = null;
        }
    }
    
    public static StartMonsterUpgrade(monsterID: string, checkOnly: boolean = false): { error: boolean; errorMessage: string; status: string } {
        let trainingCosts: any[] | null = null;
        
        if (!GLOBAL.player.m_upgrades[monsterID]) {
            GLOBAL.player.m_upgrades[monsterID] = { level: 1 };
        }
        
        let hasError: boolean = false;
        let errorMessage: string = "";
        let status: string = KEYS.Get("acad_status_level", { v1: GLOBAL.player.m_upgrades[monsterID].level });
        
        if (ACADEMY._building && !ACADEMY._building._upgrading) {
            if (!GLOBAL.player.m_upgrades[monsterID].time) {
                if (CREATURELOCKER._lockerData[monsterID] && CREATURELOCKER._lockerData[monsterID].t === 2) {
                    if (GLOBAL.player.m_upgrades[monsterID].level < CREATURELOCKER._creatures[monsterID].trainingCosts.length + 1) {
                        if (GLOBAL.player.m_upgrades[monsterID].level <= ACADEMY._building._lvl.Get()) {
                            trainingCosts = CREATURELOCKER._creatures[monsterID].trainingCosts[GLOBAL.player.m_upgrades[monsterID].level - 1];
                            
                            if (BASE.Charge(3, trainingCosts![0], true) > 0) {
                                if (!checkOnly) {
                                    BASE.Charge(3, trainingCosts![0]);
                                    GLOBAL.player.m_upgrades[monsterID].time = new SecNum(GLOBAL.Timestamp() + trainingCosts![1]);
                                    GLOBAL.player.m_upgrades[monsterID].duration = trainingCosts![1];
                                    ACADEMY._building._upgrading = monsterID;
                                    BASE.Save();
                                    LOGGER.Stat([11, parseInt(monsterID.substr(1)), GLOBAL.player.m_upgrades[monsterID].level + 1]);
                                }
                            } else {
                                hasError = true;
                                errorMessage = BASE.isInfernoMainYardOrOutpost ? KEYS.Get("acad_err_sulfur") : KEYS.Get("acad_err_putty");
                                status = BASE.isInfernoMainYardOrOutpost ? KEYS.Get("acad_err_sulfur") : KEYS.Get("acad_err_putty");
                            }
                        } else {
                            hasError = true;
                            errorMessage = KEYS.Get("acad_err_upgrade");
                            status = KEYS.Get("acad_err_upgrade");
                            
                            if (BASE.isInfernoMainYardOrOutpost && GLOBAL.player.m_upgrades[monsterID].level >= 5) {
                                hasError = true;
                                errorMessage = KEYS.Get("acad_err_fullytrained");
                                status = KEYS.Get("acad_err_lfullytrained", { v1: GLOBAL.player.m_upgrades[monsterID].level });
                            }
                        }
                    } else {
                        hasError = true;
                        errorMessage = KEYS.Get("acad_err_fullytrained");
                        status = KEYS.Get("acad_err_lfullytrained", { v1: GLOBAL.player.m_upgrades[monsterID].level });
                    }
                } else {
                    hasError = true;
                    errorMessage = KEYS.Get("acad_err_locked");
                    status = KEYS.Get("acad_err_locked");
                }
            } else {
                hasError = true;
                errorMessage = KEYS.Get("acad_err_training", { v1: GLOBAL.player.m_upgrades[monsterID].level + 1 });
                status = KEYS.Get("acad_err_trainingstatus", {
                    v1: GLOBAL.player.m_upgrades[monsterID].level + 1,
                    v2: GLOBAL.ToTime(GLOBAL.player.m_upgrades[monsterID].time.Get() - GLOBAL.Timestamp())
                });
            }
        } else {
            hasError = true;
            errorMessage = KEYS.Get("acad_err_busy");
            
            if (GLOBAL.player.m_upgrades[monsterID].time) {
                status = KEYS.Get("acad_err_trainingstatus", {
                    v1: GLOBAL.player.m_upgrades[monsterID].level + 1,
                    v2: GLOBAL.ToTime(GLOBAL.player.m_upgrades[monsterID].time.Get() - GLOBAL.Timestamp())
                });
            }
        }
        
        return {
            error: hasError,
            errorMessage: errorMessage,
            status: status
        };
    }
    
    public static CancelMonsterUpgrade(monsterID: string): void {
        delete GLOBAL.player.m_upgrades[monsterID].time;
        delete GLOBAL.player.m_upgrades[monsterID].duration;
        
        const academyInstances: BUILDING26[] = InstanceManager.getInstancesByClass(BUILDING26) as BUILDING26[];
        
        for (const academy of academyInstances) {
            if (academy._upgrading === monsterID) {
                academy._upgrading = null;
                break;
            }
        }
        
        BASE.Fund(3, CREATURELOCKER._creatures[monsterID].trainingCosts[GLOBAL.player.m_upgrades[monsterID].level - 1][0]);
        BASE.Save();
    }
    
    public static FinishMonsterUpgrade(monsterID: string): void {
        delete GLOBAL.player.m_upgrades[monsterID].time;
        delete GLOBAL.player.m_upgrades[monsterID].duration;
        ++GLOBAL.player.m_upgrades[monsterID].level;
        
        if (GLOBAL.player.monsterListByID(monsterID)) {
            GLOBAL.player.monsterListByID(monsterID).level = GLOBAL.player.m_upgrades[monsterID].level;
        }
        
        const stat: any[] = CREATURELOCKER._creatures[monsterID].props.cResource;
        
        if (stat && GLOBAL.player.m_upgrades[monsterID].level === stat.length - 1) {
            LOGGER.KongStat([5, monsterID.substr(1)]);
        }
        
        const academyInstances: BUILDING26[] = InstanceManager.getInstancesByClass(BUILDING26) as BUILDING26[];
        
        for (const academy of academyInstances) {
            if (academy._upgrading === monsterID) {
                academy._upgrading = null;
                break;
            }
        }
        
        LOGGER.Stat([12, monsterID.substr(monsterID.indexOf("C") + 1), GLOBAL.player.m_upgrades[monsterID].level]);
        
        if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD) {
            let bragImage: string | null = null;
            
            if (CREATURELOCKER._creatures[monsterID].stream[2]) {
                bragImage = String(CREATURELOCKER._creatures[monsterID].stream[2]);
            }
            
            const monsterName: string = KEYS.Get(CREATURELOCKER._creatures[monsterID].name);
            
            const Post = (): void => {
                if (BASE.isInfernoMainYardOrOutpost) {
                    GLOBAL.CallJS("sendFeed", [
                        "academy-training",
                        KEYS.Get("acad_stream_title_inf", {
                            v1: monsterName,
                            v2: GLOBAL.player.m_upgrades[monsterID].level
                        }),
                        KEYS.Get("acad_stream_description"),
                        bragImage,
                        0
                    ]);
                } else {
                    GLOBAL.CallJS("sendFeed", [
                        "academy-training",
                        KEYS.Get("acad_stream_title", {
                            v1: monsterName,
                            v2: GLOBAL.player.m_upgrades[monsterID].level
                        }),
                        KEYS.Get("acad_stream_description"),
                        bragImage,
                        0
                    ]);
                }
                POPUPS.Next();
            };
            
            const popupMC: popup_monster = new popup_monster();
            popupMC.tText.htmlText = KEYS.Get("acad_pop_complete", { v1: monsterName });
            popupMC.bAction.SetupKey("btn_warnyourfriends");
            popupMC.bAction.addEventListener("click", Post);
            popupMC.bAction.Highlight = true;
            popupMC.bSpeedup.visible = false;
            POPUPS.Push(popupMC, null, null, null, `${monsterID}-150.png`);
        }
    }
    
    public static Tick(): void {
        for (const monsterID in GLOBAL.player.m_upgrades) {
            const upgrade = GLOBAL.player.m_upgrades[monsterID];
            
            if (upgrade.time != null) {
                if (GLOBAL.player.m_upgrades[monsterID].time.Get() <= GLOBAL.Timestamp()) {
                    ACADEMY.FinishMonsterUpgrade(monsterID);
                }
            }
        }
        
        ACADEMY.Update();
    }
    
    public static Update(): void {
        if (ACADEMY._mc) {
            ACADEMY._mc.Update();
        }
    }
}
