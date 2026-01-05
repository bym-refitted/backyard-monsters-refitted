import { ImageCache } from './com/monsters/display/ImageCache';
import { InstanceManager } from './com/monsters/managers/InstanceManager';
import { ACADEMYPOPUP_CLIP } from './ACADEMYPOPUP_CLIP';
import { ACADEMY } from './ACADEMY';
import { BASE } from './BASE';
import { CREATURELOCKER } from './CREATURELOCKER';
import { CREATURES } from './CREATURES';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { BRESOURCE } from './BRESOURCE';
import { BFOUNDATION } from './BFOUNDATION';
import { BUILDING26 } from './BUILDING26';
import { LOGGER } from './LOGGER';
import { POPUPS } from './POPUPS';
import { POPUPSETTINGS } from './POPUPSETTINGS';
import { STORE } from './STORE';
import { popup_monster } from './popup_monster';

/**
 * ACADEMYPOPUP - UI popup for the Academy building
 * Converted from ActionScript to TypeScript
 */
export class ACADEMYPOPUP extends ACADEMYPOPUP_CLIP {
    public static _page: number = 1;
    public static _monsterID: string = '';
    public static _maxSpeed: number = 0;
    public static _maxHealth: number = 0;
    public static _maxDamage: number = 0;
    public static _maxTime: number = 0;
    public static _maxResource: number = 0;
    public static _maxStorage: number = 0;
    public static _instantUpgradeCost: number = 0;
    
    private static _monsterString: string = "C";
    private static _maxMonsters: number = 19;
    private static lastAction: number = 0;
    
    private readonly _infernoFrameOffset: number = 6;
    private _portraitImage: any | null = null;
    private _guidePage: number = 1;
    
    // UI elements (defined in CLIP class)
    declare bPrevious: any;
    declare bNext: any;
    declare bA: any;
    declare bB: any;
    declare mcImage: any;
    declare speed_txt: any;
    declare health_txt: any;
    declare damage_txt: any;
    declare cost_txt: any;
    declare housing_txt: any;
    declare time_txt: any;
    declare before_txt: any;
    declare after_txt: any;
    declare tName: any;
    declare bSpeedA: any;
    declare bHealthA: any;
    declare bDamageA: any;
    declare bResourceA: any;
    declare bStorageA: any;
    declare bTimeA: any;
    declare tSpeedA: any;
    declare tHealthA: any;
    declare tDamageA: any;
    declare tResourceA: any;
    declare tStorageA: any;
    declare tTimeA: any;
    declare bSpeedB: any;
    declare bHealthB: any;
    declare bDamageB: any;
    declare bResourceB: any;
    declare bStorageB: any;
    declare bTimeB: any;
    declare tSpeedB: any;
    declare tHealthB: any;
    declare tDamageB: any;
    declare tResourceB: any;
    declare tStorageB: any;
    declare tTimeB: any;
    declare txtGuide: any;
    declare bContinue: any;
    
    constructor() {
        super();
        
        if (BASE.isInfernoMainYardOrOutpost) {
            ACADEMYPOPUP._monsterString = "IC";
            ACADEMYPOPUP._maxMonsters = CREATURELOCKER.NUM_ICREEP_TYPE;
            if (ACADEMYPOPUP._page > ACADEMYPOPUP._maxMonsters) {
                ACADEMYPOPUP._page = 1;
            }
        } else {
            ACADEMYPOPUP._monsterString = "C";
            ACADEMYPOPUP._maxMonsters = CREATURELOCKER.NUM_CREEP_TYPE + 1;
        }
        
        this.bPrevious.addEventListener("click", this.Previous.bind(this));
        this.bPrevious.mcArrow.gotoAndStop(2);
        this.bNext.addEventListener("click", this.Next.bind(this));
        this.bNext.mcArrow.gotoAndStop(2);
        
        for (let i: number = 1; i < 5; i++) {
            this.bB["mcR" + i].visible = false;
            this.bB["mcR" + i].gotoAndStop(i + (BASE.isInfernoMainYardOrOutpost ? this._infernoFrameOffset : 0));
            if (i !== 3) {
                this.bB["mcR" + i].alpha = 0.25;
            }
            this.bB["mcR" + i].tTitle.htmlText = "<b>" + KEYS.Get(GLOBAL._resourceNames[i - 1]) + "</b>";
            this.bB["mcR" + i].tValue.htmlText = "<b>0</b>";
        }
        
        this.bB.mcTime.visible = false;
        this.bB.mcTime.gotoAndStop((BASE.isInfernoMainYardOrOutpost ? this._infernoFrameOffset : 0) + 6);
        this.bB.mcTime.tTitle.htmlText = "<b>" + KEYS.Get("#r_time#") + "</b>";
        
        for (const creatureID in CREATURELOCKER._creatures) {
            if (CREATURES.GetProperty(creatureID, "speed", 10) > ACADEMYPOPUP._maxSpeed) {
                ACADEMYPOPUP._maxSpeed = CREATURES.GetProperty(creatureID, "speed", 10);
            }
            if (CREATURES.GetProperty(creatureID, "health", 10) > ACADEMYPOPUP._maxHealth) {
                ACADEMYPOPUP._maxHealth = CREATURES.GetProperty(creatureID, "health", 10);
            }
            if (CREATURES.GetProperty(creatureID, "damage", 10) > ACADEMYPOPUP._maxDamage) {
                ACADEMYPOPUP._maxDamage = CREATURES.GetProperty(creatureID, "damage", 10);
            }
            if (CREATURES.GetProperty(creatureID, "cTime", 10) > ACADEMYPOPUP._maxTime) {
                ACADEMYPOPUP._maxTime = CREATURES.GetProperty(creatureID, "cTime", 10);
            }
            if (CREATURES.GetProperty(creatureID, "cResource", 10) > ACADEMYPOPUP._maxResource) {
                ACADEMYPOPUP._maxResource = CREATURES.GetProperty(creatureID, "cResource", 10);
            }
            if (CREATURES.GetProperty(creatureID, "cStorage", 10) > ACADEMYPOPUP._maxStorage) {
                ACADEMYPOPUP._maxStorage = CREATURES.GetProperty(creatureID, "cStorage", 10);
            }
        }
        
        if (ACADEMY._building?._upgrading) {
            ACADEMYPOPUP._page = parseInt(String(ACADEMY._building._upgrading).substr(
                ACADEMY._building._upgrading.indexOf("C") + 1
            ));
        }
        
        this.Setup(ACADEMYPOPUP._monsterString + ACADEMYPOPUP._page);
        
        this.speed_txt.htmlText = "<b>" + KEYS.Get("acad_att_speed") + "</b>";
        this.health_txt.htmlText = "<b>" + KEYS.Get("acad_att_health") + "</b>";
        this.damage_txt.htmlText = "<b>" + KEYS.Get("acad_att_damage") + "</b>";
        this.cost_txt.htmlText = "<b>" + KEYS.Get("acad_att_cost") + "</b>";
        
        if (BASE.isInfernoMainYardOrOutpost) {
            this.cost_txt.htmlText = "<b>" + KEYS.Get("infacad_att_cost") + "</b>";
        }
        
        this.housing_txt.htmlText = "<b>" + KEYS.Get("acad_att_housing") + "</b>";
        this.time_txt.htmlText = "<b>" + KEYS.Get("acad_att_time") + "</b>";
        this.before_txt.htmlText = "<b>" + KEYS.Get("acad_att_before") + "</b>";
        this.after_txt.htmlText = "<b>" + KEYS.Get("acad_att_after") + "</b>";
    }
    
    public Setup(monsterID: string): void {
        ACADEMYPOPUP._monsterID = monsterID;
        if (!GLOBAL.player.m_upgrades[ACADEMYPOPUP._monsterID]) {
            GLOBAL.player.m_upgrades[ACADEMYPOPUP._monsterID] = { level: 1 };
        }
        this.Update(true);
        ACADEMYPOPUP.lastAction = 0;
    }
    
    private UpdatePortrait(imagePath: string, bitmapData: any, params: any[]): void {
        if (this._portraitImage && this._portraitImage.parent) {
            this._portraitImage.parent.removeChild(this._portraitImage);
            this._portraitImage = null;
        }
        if (params[0] === ACADEMYPOPUP._monsterID) {
            this._portraitImage = this.mcImage.addChild({ bitmap: bitmapData });
        }
    }
    
    private CalculateInstantCost(): void {
        const trainingCosts = CREATURELOCKER._creatures[ACADEMYPOPUP._monsterID].trainingCosts[
            GLOBAL.player.m_upgrades[ACADEMYPOPUP._monsterID].level - 1
        ];
        const monsterName: string = KEYS.Get(CREATURELOCKER._creatures[ACADEMYPOPUP._monsterID].name);
        const resourceCost: number = trainingCosts[0];
        const timeCost: number = trainingCosts[1];
        const shinyCost: number = STORE.GetTimeCost(timeCost);
        const additionalCost: number = Math.ceil(Math.pow(Math.sqrt(resourceCost / 2), 0.75));
        ACADEMYPOPUP._instantUpgradeCost = shinyCost + additionalCost;
    }
    
    public Update(forceUpdate: boolean = false): void {
        const upgrade = GLOBAL.player.m_upgrades[ACADEMYPOPUP._monsterID];
        const startResult = ACADEMY.StartMonsterUpgrade(ACADEMYPOPUP._monsterID, true);
        const trainingCosts = CREATURELOCKER._creatures[ACADEMYPOPUP._monsterID].trainingCosts[
            GLOBAL.player.m_upgrades[ACADEMYPOPUP._monsterID].level - 1
        ];
        
        if (this._portraitImage && this._portraitImage.parent) {
            this._portraitImage.parent.removeChild(this._portraitImage);
            this._portraitImage = null;
        }
        
        ImageCache.GetImageWithCallBack(
            "monsters/" + ACADEMYPOPUP._monsterID + "-portrait.jpg",
            this.UpdatePortrait.bind(this),
            true,
            1,
            "",
            [ACADEMYPOPUP._monsterID]
        );
        
        if (upgrade.time) {
            this.bA.bAction.removeEventListener("click", this.SpeedUp.bind(this));
            this.bA.bAction.removeEventListener("click", this.InstantMonsterUpgrade.bind(this));
            this.bB.bAction.removeEventListener("click", this.StartMonsterUpgrade.bind(this));
            this.bB.bAction.removeEventListener("click", this.CancelMonsterUpgrade.bind(this));
            this.bA.gArrow.visible = false;
            this.bA.tDescription.visible = false;
            this.bA.gCoin.visible = false;
            this.bA.bAction.SetupKey("btn_speedup");
            this.bA.bAction.addEventListener("click", this.SpeedUp.bind(this));
            this.bA.bAction.Highlight = true;
            this.bA.bAction.Enabled = true;
            this.bB.bAction.SetupKey("btn_cancel");
            this.bB.bAction.addEventListener("click", this.CancelMonsterUpgrade.bind(this));
            this.bB.bAction.visible = true;
            this.bB.mcR1.visible = false;
            this.bB.mcR2.visible = false;
            this.bB.mcR3.visible = false;
            this.bB.mcR4.visible = false;
            this.bB.mcTime.visible = false;
            if (ACADEMYPOPUP._monsterID === ACADEMY._building?._upgrading) {
                this.bPrevious.visible = this.bNext.visible = false;
            }
        } else {
            if (!startResult.error) {
                this.bA.tDescription.htmlText = KEYS.Get("academy_traininstantly");
                this.CalculateInstantCost();
                this.bA.gArrow.visible = true;
                this.bA.tDescription.visible = true;
                this.bA.gCoin.visible = true;
                this.bA.bAction.removeEventListener("click", this.SpeedUp.bind(this));
                this.bA.bAction.Setup(KEYS.Get("btn_useshiny", { v1: ACADEMYPOPUP._instantUpgradeCost }));
                this.bA.bAction.removeEventListener("click", this.SpeedUp.bind(this));
                this.bA.bAction.Enabled = true;
                this.bA.bAction.Highlight = true;
                this.bA.bAction.removeEventListener("click", this.InstantMonsterUpgrade.bind(this));
                this.bA.bAction.addEventListener("click", this.InstantMonsterUpgrade.bind(this));
                this.bB.bAction.SetupKey("acad_starttraining_btn");
                this.bB.bAction.addEventListener("click", this.StartMonsterUpgrade.bind(this));
                this.bB.bAction.removeEventListener("click", this.CancelMonsterUpgrade.bind(this));
                this.bB.bAction.visible = true;
                this.bB.bAction.Enabled = true;
                this.bB.mcR1.visible = true;
                this.bB.mcR2.visible = true;
                this.bB.mcR3.visible = true;
                const resourceColor = trainingCosts[0] > GLOBAL._resources.r3.Get() ? "FF0000" : "000000";
                this.bB.mcR3.tValue.htmlText = `<b><font color="#${resourceColor}">${GLOBAL.FormatNumber(trainingCosts[0])}</font></b>`;
                this.bB.mcR4.visible = true;
                this.bB.mcTime.visible = true;
                this.bB.mcTime.tValue.htmlText = "<b>" + GLOBAL.ToTime(trainingCosts[1]) + "</b>";
            } else if (startResult.status === KEYS.Get("acad_err_putty") || startResult.status === KEYS.Get("acad_err_sulfur")) {
                this.bA.tDescription.visible = true;
                this.bA.gArrow.visible = true;
                this.bA.gCoin.visible = true;
                this.bA.tDescription.htmlText = KEYS.Get("academy_traininstantly");
                this.bB.mcR1.visible = true;
                this.bB.mcR2.visible = true;
                this.bB.mcR3.visible = true;
                const resourceColor = trainingCosts[0] > GLOBAL._resources.r3.Get() ? "FF0000" : "000000";
                this.bB.mcR3.tValue.htmlText = `<b><font color="#${resourceColor}">${GLOBAL.FormatNumber(trainingCosts[0])}</font></b>`;
                this.bB.mcR4.visible = true;
                this.bB.mcTime.visible = true;
                this.bB.mcTime.tValue.htmlText = "<b>" + GLOBAL.ToTime(trainingCosts[1]) + "</b>";
                this.CalculateInstantCost();
                this.bA.bAction.Setup(KEYS.Get("btn_useshiny", { v1: ACADEMYPOPUP._instantUpgradeCost }));
                this.bA.bAction.removeEventListener("click", this.InstantMonsterUpgrade.bind(this));
                this.bA.bAction.addEventListener("click", this.InstantMonsterUpgrade.bind(this));
                this.bA.bAction.removeEventListener("click", this.SpeedUp.bind(this));
                this.bA.bAction.Enabled = true;
                this.bA.bAction.Highlight = true;
                this.bB.bAction.Setup(startResult.errorMessage);
                this.bB.bAction.removeEventListener("click", this.StartMonsterUpgrade.bind(this));
                this.bB.bAction.removeEventListener("click", this.CancelMonsterUpgrade.bind(this));
                this.bB.bAction.Enabled = false;
                this.bB.bAction.visible = true;
            } else if (this.bA.label !== startResult.errorMessage) {
                this.bA.gArrow.visible = false;
                this.bA.tDescription.visible = false;
                this.bA.gCoin.visible = false;
                this.bB.mcR1.visible = false;
                this.bB.mcR2.visible = false;
                this.bB.mcR3.visible = false;
                this.bB.mcR4.visible = false;
                this.bB.mcTime.visible = false;
                this.bA.bAction.removeEventListener("click", this.InstantMonsterUpgrade.bind(this));
                this.bA.bAction.removeEventListener("click", this.SpeedUp.bind(this));
                this.bA.bAction.Setup(startResult.errorMessage);
                this.bA.bAction.Enabled = false;
                this.bA.bAction.Highlight = false;
                this.bB.bAction.removeEventListener("click", this.StartMonsterUpgrade.bind(this));
                this.bB.bAction.removeEventListener("click", this.CancelMonsterUpgrade.bind(this));
                this.bB.bAction.visible = false;
            }
            this.bA.bAction.Highlight = false;
            this.bPrevious.visible = this.bNext.visible = true;
        }
        
        let infoText = "<b>" + KEYS.Get("acad_mon_name") + "</b> " + KEYS.Get(CREATURELOCKER._creatures[ACADEMYPOPUP._monsterID].name) + "<br>";
        infoText += "<b>" + KEYS.Get("acad_mon_status") + "</b> " + startResult.status;
        infoText += "<br>" + KEYS.Get(CREATURELOCKER._creatures[ACADEMYPOPUP._monsterID].description);
        this.tName.htmlText = infoText;
        
        let damage: number = CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "damage");
        const isHealer: boolean = damage <= 0;
        
        this.bSpeedA.mcBar.width = 100 / ACADEMYPOPUP._maxSpeed * CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "speed");
        this.bHealthA.mcBar.width = 100 / ACADEMYPOPUP._maxHealth * CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "health");
        
        if (!isHealer) {
            this.bDamageA.mcBar.width = 100 / ACADEMYPOPUP._maxDamage * damage;
        } else {
            this.bDamageA.mcBar.width = 100 / ACADEMYPOPUP._maxDamage * -damage;
        }
        
        this.bResourceA.mcBar.width = 100 / ACADEMYPOPUP._maxResource * CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "cResource");
        this.bStorageA.mcBar.width = 100 / ACADEMYPOPUP._maxStorage * CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "cStorage");
        this.bTimeA.mcBar.width = 100 / ACADEMYPOPUP._maxTime * CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "cTime");
        
        this.tSpeedA.htmlText = KEYS.Get("mon_att_speedvalue", { v1: CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "speed") });
        this.tHealthA.htmlText = CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "health").toString();
        
        if (!isHealer) {
            this.tDamageA.htmlText = damage.toString();
        } else {
            this.tDamageA.htmlText = -damage + " (" + KEYS.Get("str_heal") + ")";
        }
        
        this.tResourceA.htmlText = KEYS.Get("mon_att_costvalue", {
            v1: CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "cResource"),
            v2: KEYS.Get(BRESOURCE.GetResourceNameKey(3))
        });
        this.tStorageA.htmlText = KEYS.Get("mon_att_housingvalue", { v1: CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "cStorage") });
        this.tTimeA.htmlText = GLOBAL.ToTime(CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "cTime"), true);
        
        let afterLevel: number = GLOBAL.player.m_upgrades[ACADEMYPOPUP._monsterID].level;
        let canUpgrade: boolean = false;
        let maxBuildingLevel: number = 1;
        
        for (const prop of GLOBAL._buildingProps) {
            if (prop.id === 26) {
                if (prop.costs && prop.costs.length > maxBuildingLevel) {
                    maxBuildingLevel = prop.costs.length;
                }
            }
        }
        
        canUpgrade = GLOBAL.player.m_upgrades[ACADEMYPOPUP._monsterID].level <= maxBuildingLevel;
        
        if (canUpgrade) {
            afterLevel = GLOBAL.player.m_upgrades[ACADEMYPOPUP._monsterID].level + 1;
        } else {
            afterLevel = GLOBAL.player.m_upgrades[ACADEMYPOPUP._monsterID].level;
        }
        
        damage = CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "damage", afterLevel);
        if (isHealer) {
            damage = -damage;
        }
        
        this.bSpeedB.mcBar.width = 100 / ACADEMYPOPUP._maxSpeed * CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "speed", afterLevel);
        this.bHealthB.mcBar.width = 100 / ACADEMYPOPUP._maxHealth * CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "health", afterLevel);
        this.bDamageB.mcBar.width = 100 / ACADEMYPOPUP._maxDamage * damage;
        this.bResourceB.mcBar.width = 100 / ACADEMYPOPUP._maxResource * CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "cResource", afterLevel);
        this.bStorageB.mcBar.width = 100 / ACADEMYPOPUP._maxStorage * CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "cStorage", afterLevel);
        this.bTimeB.mcBar.width = 100 / ACADEMYPOPUP._maxTime * CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "cTime", afterLevel);
        
        this.tSpeedB.htmlText = KEYS.Get("mon_att_speedvalue", { v1: CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "speed", afterLevel) });
        this.tHealthB.htmlText = CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "health", afterLevel).toString();
        
        if (!isHealer) {
            this.tDamageB.htmlText = damage.toString();
        } else {
            this.tDamageB.htmlText = damage + " (" + KEYS.Get("str_heal") + ")";
        }
        
        this.tResourceB.htmlText = KEYS.Get("mon_att_costvalue", {
            v1: CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "cResource", afterLevel),
            v2: KEYS.Get(BRESOURCE.GetResourceNameKey(3))
        });
        this.tStorageB.htmlText = KEYS.Get("mon_att_housingvalue", { v1: CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "cStorage", afterLevel) });
        this.tTimeB.htmlText = GLOBAL.ToTime(CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "cTime", afterLevel), true);
        
        // Update bar colors based on stat changes
        this.bSpeedB.mcBar.gotoAndStop(CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "speed") !== CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "speed", afterLevel) ? 2 : 1);
        this.bHealthB.mcBar.gotoAndStop(CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "health") !== CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "health", afterLevel) ? 2 : 1);
        this.bDamageB.mcBar.gotoAndStop(CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "damage") !== CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "damage", afterLevel) ? 2 : 1);
        this.bResourceB.mcBar.gotoAndStop(CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "cResource") !== CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "cResource", afterLevel) ? 2 : 1);
        this.bStorageB.mcBar.gotoAndStop(CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "cStorage") !== CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "cStorage", afterLevel) ? 2 : 1);
        this.bTimeB.mcBar.gotoAndStop(CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "cTime") !== CREATURES.GetProperty(ACADEMYPOPUP._monsterID, "cTime", afterLevel) ? 2 : 1);
    }
    
    public StartMonsterUpgrade(event: MouseEvent): void {
        ACADEMY.StartMonsterUpgrade(ACADEMYPOPUP._monsterID);
        this.Setup(ACADEMYPOPUP._monsterID);
    }
    
    public InstantMonsterUpgrade(event: MouseEvent): void {
        if (BASE._credits.Get() < ACADEMYPOPUP._instantUpgradeCost) {
            POPUPS.DisplayGetShiny();
            return;
        }
        
        if (GLOBAL.player.m_upgrades[ACADEMYPOPUP._monsterID].time) {
            delete GLOBAL.player.m_upgrades[ACADEMYPOPUP._monsterID].time;
        }
        
        if (GLOBAL.player.m_upgrades[ACADEMYPOPUP._monsterID].duration) {
            delete GLOBAL.player.m_upgrades[ACADEMYPOPUP._monsterID].duration;
        }
        
        ++GLOBAL.player.m_upgrades[ACADEMYPOPUP._monsterID].level;
        GLOBAL.player.upgradeHealthData(ACADEMYPOPUP._monsterID);
        
        const buildingInstances: BUILDING26[] = InstanceManager.getInstancesByClass(BUILDING26) as BUILDING26[];
        
        for (const building of buildingInstances) {
            if (building._upgrading === ACADEMYPOPUP._monsterID) {
                building._upgrading = null;
                break;
            }
        }
        
        LOGGER.Stat([47, ACADEMYPOPUP._monsterID, GLOBAL.player.m_upgrades[ACADEMYPOPUP._monsterID].level]);
        
        if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD) {
            let bragImage: string | null = null;
            
            if (CREATURELOCKER._creatures[ACADEMYPOPUP._monsterID].stream[2]) {
                bragImage = String(CREATURELOCKER._creatures[ACADEMYPOPUP._monsterID].stream[2]);
            }
            
            let monsterName: string = String(CREATURELOCKER._creatures[ACADEMYPOPUP._monsterID].name);
            if (monsterName.substring(0, 1) === "#") {
                monsterName = KEYS.Get(monsterName);
            }
            
            const Post = (): void => {
                if (BASE.isInfernoMainYardOrOutpost) {
                    GLOBAL.CallJS("sendFeed", [
                        "academy-training",
                        KEYS.Get("acad_stream_title_inf", {
                            v1: monsterName,
                            v2: GLOBAL.player.m_upgrades[ACADEMYPOPUP._monsterID].level
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
                            v2: GLOBAL.player.m_upgrades[ACADEMYPOPUP._monsterID].level
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
            POPUPS.Push(popupMC, null, null, null, `${ACADEMYPOPUP._monsterID}-150.png`);
        }
        
        BASE.Purchase("ITR", ACADEMYPOPUP._instantUpgradeCost, "academy");
    }
    
    public CancelMonsterUpgrade(event: MouseEvent): void {
        GLOBAL.Message(
            KEYS.Get("acad_confirmcancel", { v1: KEYS.Get(CREATURELOCKER._creatures[ACADEMYPOPUP._monsterID].name) }),
            KEYS.Get("acad_confirmcancel_btn"),
            this.CancelMonsterUpgradeB.bind(this)
        );
    }
    
    public CancelMonsterUpgradeB(): void {
        ACADEMY.CancelMonsterUpgrade(ACADEMYPOPUP._monsterID);
        this.Setup(ACADEMYPOPUP._monsterID);
    }
    
    public SpeedUp(event: MouseEvent): void {
        ACADEMY._monsterID = ACADEMYPOPUP._monsterID;
        STORE.SpeedUp("SP4");
    }
    
    public Previous(event?: MouseEvent): void {
        ACADEMYPOPUP.lastAction = -1;
        
        do {
            --ACADEMYPOPUP._page;
            if (ACADEMYPOPUP._page === 0) {
                ACADEMYPOPUP._page = ACADEMYPOPUP._maxMonsters;
            }
        } while (this.CheckMonsterLock(ACADEMYPOPUP._monsterString + ACADEMYPOPUP._page) === true);
        
        if (this.CheckMonsterLock(ACADEMYPOPUP._monsterString + ACADEMYPOPUP._page)) {
            if (ACADEMYPOPUP.lastAction > 0) {
                this.Next();
            } else {
                this.Previous();
            }
        } else {
            this.Setup(ACADEMYPOPUP._monsterString + ACADEMYPOPUP._page);
        }
    }
    
    public Next(event?: MouseEvent): void {
        ACADEMYPOPUP.lastAction = 1;
        
        do {
            ++ACADEMYPOPUP._page;
            if (ACADEMYPOPUP._page > ACADEMYPOPUP._maxMonsters) {
                ACADEMYPOPUP._page = 1;
            }
        } while (this.CheckMonsterLock(ACADEMYPOPUP._monsterString + ACADEMYPOPUP._page) === true);
        
        if (this.CheckMonsterLock(ACADEMYPOPUP._monsterString + ACADEMYPOPUP._page)) {
            if (ACADEMYPOPUP.lastAction > 0) {
                this.Next();
            } else {
                this.Previous();
            }
        } else {
            this.Setup(ACADEMYPOPUP._monsterString + ACADEMYPOPUP._page);
        }
    }
    
    public CheckMonsterLock(monsterID: string): boolean {
        const isBlocked: boolean = Boolean(CREATURELOCKER._creatures[monsterID]?.blocked);
        return isBlocked;
    }
    
    public Help(event?: MouseEvent): void {
        const maxPages: number = 5;
        this._guidePage += 1;
        
        if (this._guidePage > maxPages) {
            this._guidePage = 1;
        }
        
        this.gotoAndStop(this._guidePage);
        
        if (this._guidePage > 1) {
            this.txtGuide.htmlText = KEYS.Get("acad_tut_" + (this._guidePage - 1));
            if (this._guidePage === 2) {
                this.bContinue.addEventListener("click", this.Help.bind(this));
                this.bContinue.SetupKey("btn_continue");
            }
        }
    }
    
    public Hide(event?: MouseEvent): void {
        ACADEMY.Hide(event);
    }
    
    public Center(): void {
        POPUPSETTINGS.AlignToCenter(this);
    }
    
    public ScaleUp(): void {
        POPUPSETTINGS.ScaleUp(this);
    }
}
