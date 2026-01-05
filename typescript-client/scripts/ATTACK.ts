import { SecNum } from './com/cc/utils/SecNum';
import { ALLIANCES } from './com/monsters/alliances/ALLIANCES';
import { BYMConfig } from './com/monsters/configs/BYMConfig';
import { ScrollSet } from './com/monsters/display/ScrollSet';
import { ResourceBombs } from './com/monsters/effects/ResourceBombs';
import { ParticleDamageItem } from './com/monsters/effects/particles/ParticleDamageItem';
import { ParticleText } from './com/monsters/effects/particles/ParticleText';
import { EnumYardType } from './com/monsters/enums/EnumYardType';
import { AttackEvent } from './com/monsters/events/AttackEvent';
import { IAttackable } from './com/monsters/interfaces/IAttackable';
import { InstanceManager } from './com/monsters/managers/InstanceManager';
import { MapRoom3AttackFinishedPopup } from './com/monsters/maproom3/popups/MapRoom3AttackFinishedPopup';
import { popup_attackend } from './com/monsters/maproom_advanced/popup_attackend';
import { MapRoomManager } from './com/monsters/maproom_manager/MapRoomManager';
import { MonsterBase } from './com/monsters/monsters/MonsterBase';
import { ChampionBase } from './com/monsters/monsters/champions/ChampionBase';
import { Krallen } from './com/monsters/monsters/champions/Krallen';
import { MonsterData } from './com/monsters/player/MonsterData';
import { Player } from './com/monsters/player/Player';
import { SiegeWeapons } from './com/monsters/siege/SiegeWeapons';
import { ParticleLoot } from './ParticleLoot';
import { ParticleVacuumLoot } from './ParticleVacuumLoot';

import { ACHIEVEMENTS } from './ACHIEVEMENTS';
import { BASE } from './BASE';
import { BFOUNDATION } from './BFOUNDATION';
import { BMUSHROOM } from './BMUSHROOM';
import { BUILDING14 } from './BUILDING14';
import { CHAMPIONCAGE } from './CHAMPIONCAGE';
import { CREATURELOCKER } from './CREATURELOCKER';
import { CREATURES } from './CREATURES';
import { CREEPS } from './CREEPS';
import { DROPZONE } from './DROPZONE';
import { GLOBAL } from './GLOBAL';
import { INFERNO_DESCENT_POPUPS } from './INFERNO_DESCENT_POPUPS';
import { INFERNO_EMERGENCE_EVENT } from './INFERNO_EMERGENCE_EVENT';
import { INFERNO_EMERGENCE_POPUPS } from './INFERNO_EMERGENCE_POPUPS';
import { INFERNOPORTAL } from './INFERNOPORTAL';
import { KEYS } from './KEYS';
import { LOGGER } from './LOGGER';
import { LOGIN } from './LOGIN';
import { MAP } from './MAP';
import { MAPROOM } from './MAPROOM';
import { MAPROOM_DESCENT } from './MAPROOM_DESCENT';
import { POPUPS } from './POPUPS';
import { POWERUPS } from './POWERUPS';
import { SOUNDS } from './SOUNDS';
import { SPECIALEVENT } from './SPECIALEVENT';
import { STORE } from './STORE';
import { TRIBES } from './TRIBES';
import { TUTORIAL } from './TUTORIAL';
import { UI2 } from './UI2';
import { WMATTACK } from './WMATTACK';
import { WMBASE } from './WMBASE';
import { YARD_PROPS } from './YARD_PROPS';
import { frame } from './frame';
import { popup_attack_log } from './popup_attack_log';
import { popup_damaged_ai } from './popup_damaged_ai';
import { popup_defense } from './popup_defense';
import { popup_taunt_friend } from './popup_taunt_friend';

/**
 * ATTACK - Handles attack mode combat, loot, and creature management
 * Converted from ActionScript to TypeScript
 */
export class ATTACK {
    public static readonly USE_CUMULATIVE_FLINGER_CAPACITY: boolean = true;
    
    public static _damageGrid: any;
    public static _loot: { [key: string]: SecNum };
    public static _hpLoot1: number = 0;
    public static _hpLoot2: number = 0;
    public static _hpLoot3: number = 0;
    public static _hpLoot4: number = 0;
    public static _log: any[] = [];
    public static _dropZone: DROPZONE | null = null;
    public static _flingerCooldown: number = 0;
    public static _flingerCooling: number = 0;
    public static _flingerBucket: { [key: string]: SecNum } = {};
    public static _bombSize: number = 0;
    public static _countdown: number = 0;
    public static _attackStart: number = 0;
    public static _sentOver: boolean = false;
    private static m_waitingForSaveToComplete: boolean = false;
    public static _flingValue: number = 0;
    public static _flingCount: number = 0;
    public static _logOpen: boolean = false;
    public static _shownLog: boolean = false;
    public static _acted: boolean = false;
    public static _healthOnStart: number = 0;
    public static _healthOnComplete: number = 0;
    public static _taunted: boolean = false;
    public static _tauntThreshold: number = 0.1;
    public static _attackLog: popup_attack_log | null = null;
    public static _shownAIPopup: boolean = false;
    public static _shownFinal: boolean = false;
    public static _flungSpace: SecNum = new SecNum(0);
    public static _deltaLoot: any = {};
    public static _hpDeltaLoot: any = {};
    public static _savedDeltaLoot: any = {};
    public static _creaturesFlung: SecNum = new SecNum(0);
    public static _creaturesLoaded: SecNum = new SecNum(0);
    private static m_recentlyAttacked: Map<any, number> = new Map();
    private static m_lastAttackTime: number = 0;
    public static _curCreaturesAvailable: { [key: string]: number } = {};
    
    constructor() {
        // Empty constructor
    }
    
    public static get waitingForSaveToComplete(): boolean {
        return ATTACK.m_waitingForSaveToComplete;
    }
    
    public static get hasCreaturesToAttackWith(): boolean {
        const creatures = CREATURELOCKER._creatures;
        const available = ATTACK._curCreaturesAvailable;
        const guardianData = GLOBAL._playerGuardianData;
        
        if (GLOBAL._loadmode === GLOBAL.mode || (GLOBAL._loadmode !== GLOBAL.mode && !MAPROOM_DESCENT.DescentPassed)) {
            for (const guardian of guardianData) {
                if (guardian && guardian.hp.Get() > 0 && guardian.status === ChampionBase.k_CHAMPION_STATUS_NORMAL) {
                    return true;
                }
            }
        }
        
        for (const creatureID in available) {
            if (available[creatureID] && available[creatureID] > 0 && creatures[creatureID]) {
                return true;
            }
        }
        
        return false;
    }
    
    public static Setup(): void {
        ATTACK.m_recentlyAttacked = new Map();
        ATTACK._flingerCooldown = 5;
        ATTACK._flingerCooling = 0;
        ATTACK._creaturesFlung.Set(0);
        ATTACK._creaturesLoaded.Set(0);
        ATTACK._flingerBucket = {};
        ATTACK._flingCount = 0;
        ATTACK._log = [];
        ATTACK._attackStart = GLOBAL.Timestamp();
        ATTACK._flungSpace = new SecNum(0);
        ATTACK._loot = {
            r1: new SecNum(0),
            r2: new SecNum(0),
            r3: new SecNum(0),
            r4: new SecNum(0)
        };
        ATTACK._savedDeltaLoot = {
            r1: new SecNum(0),
            r2: new SecNum(0),
            r3: new SecNum(0),
            r4: new SecNum(0)
        };
        ATTACK._deltaLoot = { dirty: false };
        ATTACK._hpDeltaLoot = { dirty: false };
        ATTACK._hpLoot1 = 0;
        ATTACK._hpLoot2 = 0;
        ATTACK._hpLoot3 = 0;
        ATTACK._hpLoot4 = 0;
        ATTACK._dropZone = null;
        ATTACK._sentOver = false;
        ATTACK.m_waitingForSaveToComplete = false;
        ATTACK._logOpen = false;
        ATTACK._shownLog = false;
        ATTACK._shownAIPopup = false;
        ATTACK._acted = false;
        ATTACK._flingValue = 0;
        
        if (GLOBAL._attackersCatapult && 
            (GLOBAL.mode === GLOBAL.e_BASE_MODE.ATTACK || 
             GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK || 
             GLOBAL.mode === GLOBAL.e_BASE_MODE.VIEW || 
             GLOBAL.mode === GLOBAL.e_BASE_MODE.WMVIEW)) {
            ResourceBombs.Setup();
        }
        
        if (!MapRoomManager.instance.isInMapRoom2) {
            ATTACK._curCreaturesAvailable = {};
            const player: Player = GLOBAL.attackingPlayer || GLOBAL.player;
            const monsterCount = player.monsterList.length;
            
            for (let i = 0; i < monsterCount; i++) {
                ATTACK._curCreaturesAvailable[player.monsterList[i].m_creatureID] = player.monsterList[i].numHealthyHousedCreeps;
            }
        } else if (GLOBAL.mode === GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK) {
            GLOBAL._attackerMapCreaturesStart = {};
            for (const creatureID in ATTACK._curCreaturesAvailable) {
                GLOBAL._attackerMapCreaturesStart[creatureID] = new SecNum(ATTACK._curCreaturesAvailable[creatureID]);
            }
        }
    }
    
    public static AttackData(): { champions: any[]; monsters: any[] } {
        const attackPayload: { champions: any[]; monsters: any[] } = { champions: [], monsters: [] };
        
        for (let i = 0; i < GLOBAL._playerGuardianData.length; i++) {
            const guardianData = GLOBAL._playerGuardianData[i];
            const guardianKey = "G" + guardianData.t;
            
            attackPayload.champions.push({
                type: guardianKey,
                stats: CHAMPIONCAGE._guardians[guardianKey].props
            });
        }
        
        for (const creatureID in ATTACK._curCreaturesAvailable) {
            attackPayload.monsters.push({
                id: creatureID,
                count: ATTACK._curCreaturesAvailable[creatureID],
                stats: CREATURELOCKER._creatures[creatureID].props
            });
        }
        
        return attackPayload;
    }
    
    public static Tick(): void {
        if (ATTACK._flingerCooling > 0) {
            --ATTACK._flingerCooling;
        }
        
        --ATTACK._countdown;
        
        if (ATTACK._countdown === -120) {
            ATTACK.RetreatAll();
        }
        
        let hasCreatures = false;
        let creatureCount = 0;
        
        for (let i = 0; i < GLOBAL._playerGuardianData.length; i++) {
            if (GLOBAL._playerGuardianData[i] && 
                GLOBAL._playerGuardianData[i].hp.Get() > 0 && 
                GLOBAL._playerGuardianData[i].status === ChampionBase.k_CHAMPION_STATUS_NORMAL) {
                creatureCount++;
            }
        }
        
        for (const creatureID in ATTACK._curCreaturesAvailable) {
            creatureCount += ATTACK._curCreaturesAvailable[creatureID];
        }
        
        let hasBombs = false;
        for (const bomb of ResourceBombs._bombs) {
            if (bomb.catapultLevel <= GLOBAL._attackersCatapult) {
                if (bomb.resource === 3) {
                    if (!bomb.used && creatureCount > 0) {
                        hasBombs = true;
                    }
                } else if (!bomb.used) {
                    hasBombs = true;
                }
            }
        }
        
        let activeBombCount = 0;
        for (const key in ResourceBombs._activeBombs) {
            activeBombCount++;
        }
        hasBombs = hasBombs || activeBombCount > 0;
        
        for (const key in ATTACK._flingerBucket) {
            creatureCount += ATTACK._flingerBucket[key].Get();
        }
        
        hasCreatures = creatureCount > 0;
        
        let hasBuildings = false;
        const buildings = InstanceManager.getInstancesByClass(BFOUNDATION) as BFOUNDATION[];
        for (const building of buildings) {
            if (!(building instanceof BMUSHROOM) && 
                building._class !== "wall" && 
                building._class !== "trap" && 
                building._class !== "enemy" && 
                building._class !== "decoration" && 
                building._class !== "cage" && 
                building.health > 0) {
                hasBuildings = true;
                break;
            }
        }
        
        if (!ATTACK._sentOver && (!hasBuildings || !CREEPS._creepCount)) {
            if (ATTACK._countdown < 0 || !hasBuildings || (!hasCreatures && !hasBombs)) {
                ATTACK._sentOver = true;
                if (BASE._saveOver !== 1) {
                    BASE.Save(1, false, true);
                }
                ATTACK.m_waitingForSaveToComplete = true;
            }
        }
    }
    
    public static ShowLog(delay: number = 0): void {
        let shouldShowTaunt: boolean = BASE._isProtected > 0;
        const townHallInstances = InstanceManager.getInstancesByClass(BUILDING14) as BUILDING14[];
        
        for (const townHall of townHallInstances) {
            if (townHall.health === 0) {
                shouldShowTaunt = true;
            }
        }
        
        ATTACK._shownLog = false;
        
        if (!ATTACK._logOpen && GLOBAL.mode === GLOBAL.e_BASE_MODE.ATTACK) {
            ATTACK._logOpen = true;
            ATTACK._shownLog = true;
            
            let logLength = 0;
            for (const key in ATTACK._log) {
                logLength++;
            }
            
            if (logLength > 0) {
                const onActionDown = (event: MouseEvent): void => {
                    const target = event.target as any;
                    if (target.label === "Next" || target.labelKey === "btn_returnhome" || target.labelKey === "btn_skip") {
                        ATTACK._logOpen = false;
                        if (ATTACK._attackLog?.parent) {
                            ATTACK._attackLog.parent.removeChild(ATTACK._attackLog);
                        }
                        ATTACK.EndB();
                    }
                    if (target.labelKey === "btn_talktrash") {
                        ATTACK.ShowTaunt();
                    }
                };
                
                ATTACK._attackLog = new popup_attack_log();
                ATTACK._attackLog.Resize = () => {
                    if (ATTACK._attackLog) {
                        ATTACK._attackLog.x = 0;
                        ATTACK._attackLog.y = 0;
                    }
                };
                
                (ATTACK._attackLog.mcFrame as frame).Setup(false);
                ATTACK._attackLog.title_txt.htmlText = "<b>" + KEYS.Get("attack_log_title") + "</b>";
                GLOBAL._layerMessages.addChild(ATTACK._attackLog);
                
                if (shouldShowTaunt && !ATTACK._taunted && MAPROOM._visitingFriend) {
                    ATTACK._attackLog.bAction.SetupKey("btn_talktrash");
                    ATTACK._attackLog.bAction.addEventListener("click", onActionDown);
                    ATTACK._attackLog.bAction.Highlight = true;
                    
                    if (MapRoomManager.instance.isInMapRoom2) {
                        ATTACK._attackLog.b2.Setup(KEYS.Get("btn_next"));
                    } else {
                        ATTACK._attackLog.b2.SetupKey("btn_returnhome");
                    }
                    ATTACK._attackLog.b2.addEventListener("click", onActionDown);
                } else {
                    ATTACK._attackLog.removeChild(ATTACK._attackLog.b2);
                    ATTACK._attackLog.bAction.Highlight = false;
                    
                    if (MapRoomManager.instance.isInMapRoom2) {
                        ATTACK._attackLog.bAction.Setup(KEYS.Get("btn_next"));
                    } else {
                        ATTACK._attackLog.bAction.SetupKey("btn_returnhome");
                    }
                    ATTACK._attackLog.bAction.addEventListener("click", onActionDown);
                }
                
                let str = ATTACK.LogRead();
                str += "<br><br>";
                ATTACK._attackLog.shell.body_txt.htmlText = str;
                ATTACK._attackLog.shell.body_txt.autoSize = "left";
                
                const ss = new ScrollSet();
                ATTACK._attackLog.addChild(ss);
                ss.x = 613;
                ss.y = 115;
                ss.Init(ATTACK._attackLog.shell, ATTACK._attackLog.maskMC, 0, ATTACK._attackLog.maskMC.y, 270);
                ATTACK._attackLog.shell.mask = ATTACK._attackLog.maskMC;
            } else {
                ATTACK.EndB();
            }
        } else {
            ATTACK.EndB();
        }
    }
    
    public static ShowTaunt(event?: MouseEvent): void {
        let imgNumber = 1;
        
        try {
            if (ATTACK._attackLog?.parent) {
                ATTACK._attackLog.parent.removeChild(ATTACK._attackLog);
            }
        } catch (e) {
            // Ignore
        }
        
        const taunt = new popup_taunt_friend();
        taunt.tTitle.htmlText = KEYS.Get("popup_title_tauntfriend");
        taunt.Resize = () => {
            taunt.x = 0;
            taunt.y = 0;
        };
        
        const onClose = (): void => {
            if (taunt.parent) {
                taunt.parent.removeChild(taunt);
            }
            ATTACK.End();
        };
        
        const onShare = (e: MouseEvent): void => {
            ATTACK._taunted = true;
            GLOBAL.CallJS("sendFeed", [
                "taunt",
                KEYS.Get("attack_taunt_streamtitle"),
                KEYS.Get("attack_taunt_streambody"),
                "taunt" + imgNumber + ".png",
                BASE._loadedFBID
            ]);
            onClose();
        };
        
        const SwitchB = (n: number): void => {
            imgNumber = n;
            for (let i = 1; i < 4; i++) {
                taunt["mcIcon" + i].alpha = 0.4;
            }
            taunt["mcIcon" + n].alpha = 1;
        };
        
        const Switch = (n: number) => {
            return (e?: MouseEvent) => SwitchB(n);
        };
        
        taunt.bShare.SetupKey("btn_talktrash");
        GLOBAL._layerMessages.addChild(taunt);
        taunt.bShare.addEventListener("click", onShare);
        taunt.bShare.Highlight = true;
        (taunt.mcFrame as frame).Setup(true, onClose);
        
        for (let i = 1; i < 4; i++) {
            taunt["mcIcon" + i].buttonMode = true;
            taunt["mcIcon" + i].gotoAndStop(i);
            taunt["mcIcon" + i].addEventListener("click", Switch(i));
        }
        
        SwitchB(1);
    }
    
    public static DropZone(size: number, type: number = 1): void {
        if (!ATTACK._dropZone) {
            ATTACK._dropZone = MAP._BUILDINGBASES.addChild(new DROPZONE(size, type)) as DROPZONE;
        } else {
            ATTACK._dropZone.Update(size, type);
        }
    }
    
    public static Log(id: string, event: string): void {
        ATTACK._acted = true;
        
        for (let i = 0; i < ATTACK._log.length; i++) {
            if (ATTACK._log[i].id === id) {
                ATTACK._log[i].event = event;
                ATTACK._log[i].time = GLOBAL.Timestamp() - ATTACK._attackStart;
                return;
            }
        }
        
        ATTACK._log.push({
            id: id,
            time: GLOBAL.Timestamp() - ATTACK._attackStart,
            event: event
        });
    }
    
    public static LogRead(): string {
        let result = "";
        
        if (ATTACK._log.length > 0) {
            result = "<ul>";
            ATTACK._log.sort((a, b) => a.time - b.time);
            
            for (let i = 0; i < ATTACK._log.length; i++) {
                result += `<li><font color="#999999">${GLOBAL.ToTime(ATTACK._log[i].time, true)}</font>: ${ATTACK._log[i].event}</li>`;
            }
            result += "</ul>";
            
            const totalLoot = ATTACK._loot.r1.Get() + ATTACK._loot.r2.Get() + ATTACK._loot.r3.Get() + ATTACK._loot.r4.Get();
            if (totalLoot > 0) {
                result += "<br>" + KEYS.Get("attack_log_resourceslooted") + ":<br>";
                const lootItems: [number, string][] = [];
                
                if (ATTACK._loot.r1.Get() > 0) {
                    lootItems.push([ATTACK._loot.r1.Get(), KEYS.Get(GLOBAL._resourceNames[0])]);
                }
                if (ATTACK._loot.r2.Get() > 0) {
                    lootItems.push([ATTACK._loot.r2.Get(), KEYS.Get(GLOBAL._resourceNames[1])]);
                }
                if (ATTACK._loot.r3.Get() > 0) {
                    lootItems.push([ATTACK._loot.r3.Get(), KEYS.Get(GLOBAL._resourceNames[2])]);
                }
                if (ATTACK._loot.r4.Get() > 0) {
                    lootItems.push([ATTACK._loot.r4.Get(), KEYS.Get(GLOBAL._resourceNames[3])]);
                }
                result += GLOBAL.Array2String(lootItems);
            }
        }
        
        return result;
    }
    
    public static RemoveDropZone(): void {
        if (ATTACK._dropZone) {
            ATTACK._dropZone.Destroy();
            MAP._BUILDINGBASES.removeChild(ATTACK._dropZone);
        }
        ATTACK._dropZone = null;
    }
    
    public static Spawn(point: { x: number; y: number }, radius: number): void {
        const flungItems: [number, string][] = [];
        
        for (const creatureID in ATTACK._flingerBucket) {
            if (ATTACK._flingerBucket[creatureID].Get() > 0) {
                if (creatureID.substr(0, 1) === "G") {
                    const guardianIndex = GLOBAL.getPlayerGuardianIndex(parseInt(creatureID.substr(1)));
                    const guardianLevel = GLOBAL._playerGuardianData[guardianIndex].l.Get();
                    const angle = Math.random() * 360 * 0.0174532925;
                    const dist = Math.random() * radius / 2;
                    const spawnPoint = { x: point.x + Math.sin(angle) * dist, y: point.y + Math.cos(angle) * dist };
                    
                    CREEPS.SpawnGuardian(
                        GLOBAL._playerGuardianData[guardianIndex].t,
                        MAP._BUILDINGTOPS,
                        "bounce",
                        guardianLevel,
                        spawnPoint,
                        Math.random() * 360,
                        GLOBAL._playerGuardianData[guardianIndex].hp.Get(),
                        GLOBAL._playerGuardianData[guardianIndex].fb.Get(),
                        GLOBAL._playerGuardianData[guardianIndex].pl.Get()
                    );
                    
                    if (!MapRoomManager.instance.isInMapRoom3) {
                        ATTACK._flungSpace.Add(CHAMPIONCAGE.GetGuardianProperty(creatureID.substr(0, 2), guardianLevel, "bucket"));
                    }
                    
                    const guardianName = "Level " + guardianLevel + " " + CHAMPIONCAGE._guardians["G" + GLOBAL._playerGuardianData[guardianIndex].t].name;
                    flungItems.push([1, guardianName]);
                    CREEPS._flungGuardian[guardianIndex] = true;
                } else {
                    ATTACK._flungSpace.Add(CREATURES.GetProperty(creatureID, "bucket") * ATTACK._flingerBucket[creatureID].Get());
                    const monsterName = KEYS.Get(CREATURELOCKER._creatures[creatureID].name);
                    flungItems.push([ATTACK._flingerBucket[creatureID].Get(), monsterName]);
                    
                    for (let j = 0; j < ATTACK._flingerBucket[creatureID].Get(); j++) {
                        const angle = Math.random() * 360 * 0.0174532925;
                        const dist = Math.random() * radius / 2;
                        const spawnPoint = { x: point.x + Math.sin(angle) * dist, y: point.y + Math.cos(angle) * dist };
                        
                        const monster = CREEPS.Spawn(creatureID, MAP._BUILDINGTOPS, "bounce", spawnPoint, Math.random() * 360);
                        monster._hitLimit = Number.MAX_SAFE_INTEGER;
                        
                        if (!MapRoomManager.instance.isInMapRoom2or3) {
                            GLOBAL.attackingPlayer.monsterListByID(creatureID).add(-1);
                        } else if (MapRoomManager.instance.isInMapRoom3) {
                            GLOBAL.attackingPlayer.monsterListByID(creatureID).linkCreepToData(monster);
                        }
                    }
                    
                    if (ALLIANCES._myAlliance) {
                        LOGGER.Stat([28, creatureID, ATTACK._flingerBucket[creatureID].Get(), ALLIANCES._allianceID]);
                    } else {
                        LOGGER.Stat([28, creatureID, ATTACK._flingerBucket[creatureID].Get()]);
                    }
                    
                    ATTACK._flingValue += CREATURES.GetProperty(creatureID, "cResource");
                }
            }
        }
        
        ATTACK._creaturesFlung.Add(ATTACK._creaturesLoaded.Get());
        ATTACK._creaturesLoaded.Set(0);
        
        if (flungItems.length === 1 && flungItems[0][0] === 1) {
            ATTACK.Log("fling" + ATTACK._flingCount, `<font color="#0000FF">${KEYS.Get("attack_log_flungin", { v1: GLOBAL.Array2String(flungItems) })}</font>`);
        } else {
            ATTACK.Log("fling" + ATTACK._flingCount, `<font color="#0000FF">${KEYS.Get("attack_log_flungin_pl", { v1: GLOBAL.Array2String(flungItems) })}</font>`);
        }
        
        ++ATTACK._flingCount;
        ATTACK._flingerBucket = {};
        ATTACK._flingerCooling = ATTACK._flingerCooldown;
        UI2.Update();
        
        if (BASE._saveOver !== 1) {
            BASE.Save();
        }
        
        ATTACK.RemoveDropZone();
    }
    
    public static BucketAdd(creatureID: string): boolean {
        let capacity = GLOBAL._buildingProps[4].capacity[GLOBAL._attackersFlinger - 1];
        
        if (MAPROOM_DESCENT.InDescent) {
            capacity = YARD_PROPS._yardProps[4].capacity[GLOBAL._attackersFlinger - 1];
        }
        
        if (POWERUPS.CheckPowers(POWERUPS.ALLIANCE_DECLAREWAR, "OFFENSE")) {
            capacity += Math.floor(capacity * 0.25);
        }
        
        if (MapRoomManager.instance.isInMapRoom3 && ATTACK.USE_CUMULATIVE_FLINGER_CAPACITY) {
            capacity -= ATTACK._flungSpace.Get();
        }
        
        if (creatureID.substr(0, 1) === "G") {
            const guardianIndex = GLOBAL.getPlayerGuardianIndex(parseInt(creatureID.substr(1)));
            if (!MapRoomManager.instance.isInMapRoom3) {
                capacity -= CHAMPIONCAGE.GetGuardianProperty(creatureID.substr(0, 2), GLOBAL._playerGuardianData[guardianIndex].l.Get(), "bucket");
            }
            ATTACK._flingerBucket[creatureID] = new SecNum(1);
            ATTACK._creaturesLoaded.Add(1);
            SOUNDS.Play("click1");
        } else if (ATTACK._curCreaturesAvailable[creatureID] > 0) {
            for (const key in ATTACK._flingerBucket) {
                capacity -= CREATURES.GetProperty(key, "bucket") * ATTACK._flingerBucket[key].Get();
            }
            
            if (capacity >= CREATURES.GetProperty(creatureID, "bucket")) {
                ATTACK._curCreaturesAvailable[creatureID] = ATTACK._curCreaturesAvailable[creatureID] - 1;
                ATTACK._creaturesLoaded.Add(1);
                
                if (!ATTACK._flingerBucket[creatureID]) {
                    ATTACK._flingerBucket[creatureID] = new SecNum(0);
                }
                ATTACK._flingerBucket[creatureID].Add(1);
                SOUNDS.Play("click1");
            }
        }
        
        return false;
    }
    
    public static BucketRemove(creatureID: string): boolean {
        if (ATTACK._flingerBucket[creatureID] && ATTACK._flingerBucket[creatureID].Get() > 0) {
            ATTACK._flingerBucket[creatureID].Add(-1);
            
            if (creatureID.substr(0, 1) === "G") {
                delete ATTACK._flingerBucket[creatureID];
            } else {
                ATTACK._curCreaturesAvailable[creatureID] += 1;
            }
            
            ATTACK._creaturesLoaded.Add(-1);
            SOUNDS.Play("click1");
            return true;
        }
        
        return false;
    }
    
    public static BucketUpdate(): void {
        let bucketSize = 0;
        
        for (const creatureID in ATTACK._flingerBucket) {
            if (creatureID.substr(0, 1) === "G") {
                let guardianIndex = 0;
                while (guardianIndex < GLOBAL._playerGuardianData.length) {
                    if (creatureID.substr(1) === GLOBAL._playerGuardianData[guardianIndex].t) {
                        break;
                    }
                    guardianIndex++;
                }
                bucketSize += CHAMPIONCAGE.GetGuardianProperty(creatureID.substr(0, 2), GLOBAL._playerGuardianData[guardianIndex].l.Get(), "bucket");
            } else {
                bucketSize += CREATURES.GetProperty(creatureID, "bucket") * ATTACK._flingerBucket[creatureID].Get();
            }
        }
        
        ResourceBombs.BombRemove();
        
        if (UI2._top && UI2._top._siegeweapon) {
            UI2._top._siegeweapon.Cancel();
        }
        
        if (bucketSize === 0) {
            ATTACK.RemoveDropZone();
        } else {
            bucketSize /= 4;
            if (bucketSize < 200) {
                bucketSize = 200;
            }
            ATTACK.DropZone(bucketSize, 1);
        }
        
        UI2.Update();
    }
    
    public static Loot(
        resourceType: number,
        amount: number,
        x: number,
        y: number,
        displaySize: number = 10,
        building: BFOUNDATION | null = null,
        vacuum: boolean = false
    ): number {
        if (LOGIN._playerLevel < 20) {
            amount += amount * Math.max(0, (20 - LOGIN._playerLevel) * 0.03);
        }
        
        ATTACK._loot["r" + resourceType].Add(amount);
        
        switch (resourceType) {
            case 1:
                ATTACK._hpLoot1 += amount;
                break;
            case 2:
                ATTACK._hpLoot2 += amount;
                break;
            case 3:
                ATTACK._hpLoot3 += amount;
                break;
            case 4:
                ATTACK._hpLoot4 += amount;
        }
        
        let actualGain = amount;
        const maxResource = GLOBAL._resources["r" + resourceType + "max"];
        const currentResource = GLOBAL._resources["r" + resourceType].Get();
        const krallen = CREEPS.krallen;
        
        let adjustedMax = maxResource;
        if (krallen) {
            adjustedMax += maxResource * krallen._buff;
        }
        
        if (currentResource + amount > adjustedMax) {
            if ((BASE.isInfernoMainYardOrOutpost && MAPROOM_DESCENT.DescentPassed) || GLOBAL.mode === GLOBAL._loadmode) {
                actualGain = adjustedMax - currentResource;
                if (actualGain < 0) {
                    actualGain = 0;
                }
            }
        }
        
        GLOBAL._resources["r" + resourceType].Add(actualGain);
        GLOBAL._hpResources["r" + resourceType] += actualGain;
        
        if (ATTACK._deltaLoot["r" + resourceType]) {
            ATTACK._deltaLoot["r" + resourceType].Add(actualGain);
            ATTACK._hpDeltaLoot["r" + resourceType] += actualGain;
        } else {
            ATTACK._deltaLoot["r" + resourceType] = new SecNum(actualGain);
            ATTACK._hpDeltaLoot["r" + resourceType] = actualGain;
        }
        
        ATTACK._deltaLoot.dirty = true;
        ATTACK._hpDeltaLoot.dirty = true;
        
        if (GLOBAL._render && building) {
            let particleType = resourceType;
            if (BASE.isInfernoMainYardOrOutpost) {
                particleType += 4;
            }
            
            if (vacuum) {
                new ParticleVacuumLoot(building, amount, particleType);
            } else {
                new ParticleLoot(building, amount, particleType);
            }
            ParticleText.Create({ x: x, y: y - 35 }, amount, particleType);
        }
        
        return amount;
    }
    
    public static SaveDeltaLoot(): void {
        if (ATTACK._deltaLoot.dirty) {
            for (let i = 1; i < 5; i++) {
                if (ATTACK._deltaLoot["r" + i]) {
                    if (ATTACK._savedDeltaLoot["r" + i]) {
                        ATTACK._savedDeltaLoot["r" + i].Add(ATTACK._deltaLoot["r" + i].Get());
                    } else {
                        ATTACK._savedDeltaLoot["r" + i] = new SecNum(ATTACK._deltaLoot["r" + i].Get());
                    }
                    
                    if (ATTACK._deltaLoot["r" + i].Get() !== ATTACK._hpDeltaLoot["r" + i]) {
                        LOGGER.Log("log", "ATTACK.SaveDeltaLoot delta loot mismatch secure " + ATTACK._deltaLoot["r" + i].Get() + " unsecure " + ATTACK._hpDeltaLoot["r" + i]);
                        GLOBAL.ErrorMessage("ATTACK.SaveDeltaLoot");
                    }
                }
            }
        }
        
        ATTACK._deltaLoot = { dirty: false };
        ATTACK._hpDeltaLoot = { dirty: false };
    }
    
    public static CleanLoot(): void {
        ATTACK._savedDeltaLoot = {
            r1: new SecNum(0),
            r2: new SecNum(0),
            r3: new SecNum(0),
            r4: new SecNum(0)
        };
    }
    
    public static Miss(x: number, y: number): void {
        // Empty implementation
    }
    
    public static damage(amount: number, target: IAttackable | null = null, modifier: number = 0): void {
        const currentTime = Date.now();
        
        if (currentTime - ATTACK.m_lastAttackTime > 400) {
            ATTACK.m_recentlyAttacked = new Map();
            ATTACK.m_lastAttackTime = currentTime;
        }
        
        let particleType = ParticleText.TYPE_DAMAGE;
        if (amount < 0) {
            particleType = ParticleText.TYPE_HEAL;
        }
        
        const point = { x: target?.x || 0, y: target?.y || 0 };
        if (target && target instanceof MonsterBase) {
            point.y -= (target as MonsterBase)._altitude;
        }
        
        const recentCount = ATTACK.m_recentlyAttacked.get(target) || 0;
        ATTACK.m_recentlyAttacked.set(target, recentCount + 1);
        
        if (recentCount > 2) {
            return;
        }
        
        if (recentCount === 1) {
            point.x += 10 * amount.toString().length;
        } else if (recentCount === 2) {
            point.x -= 10 * amount.toString().length;
        }
        
        const damageItem = ParticleText.Create(point, amount, particleType);
        
        if (modifier !== 0 && damageItem) {
            const sign = modifier < 0 ? "-" : "+";
            damageItem._mc.tLootA.htmlText += "(" + sign + Math.abs(Math.round(modifier)) + ")";
            damageItem._mc.tLootB.htmlText += "(" + sign + Math.abs(Math.round(modifier)) + ")";
        }
    }
    
    public static Damage(x: number, y: number, amount: number, param4: boolean = true, param5: boolean = false): void {
        // Empty implementation
    }
    
    public static ProcessDamageGrid(): void {
        // Empty implementation
    }
    
    public static RetreatAll(): void {
        for (const creep of CREEPS._creeps) {
            creep.changeModeRetreat();
        }
        
        if (BASE._saveOver !== 1) {
            BASE.Save(1, false, true);
        }
        
        GLOBAL.Message(KEYS.Get("attack_msg_attackover"));
    }
    
    private static BucketClear(): void {
        for (const creatureID in ATTACK._flingerBucket) {
            const count = ATTACK._flingerBucket[creatureID].Get();
            for (let i = 0; i <= count; i++) {
                ATTACK.BucketRemove(creatureID);
            }
        }
        ATTACK.BucketUpdate();
    }
    
    private static updateCreepAttackToPlayerSavingFunction(): void {
        const creepCount = CREEPS.m_attackingCreeps.length;
        
        for (let i = 0; i < creepCount; i++) {
            if (!CREEPS.m_attackingCreeps[i].isDisposable) {
                const monsterData = GLOBAL.attackingPlayer.monsterListByID(CREEPS.m_attackingCreeps[i]._creatureID);
                
                if (monsterData) {
                    let j = 0;
                    while (j < monsterData.m_creeps.length && 
                           monsterData.m_creeps[j].health < (CREEPS.m_attackingCreeps[i] as MonsterBase).maxHealth) {
                        j++;
                    }
                    
                    const currentHealth = (CREEPS.m_attackingCreeps[i] as MonsterBase).health;
                    monsterData.m_creeps[j].health = currentHealth > 0 ? currentHealth : 1;
                }
            }
        }
        
        BASE.SaveB();
    }
    
    public static End(): void {
        ATTACK.m_waitingForSaveToComplete = false;
        ATTACK.BucketClear();
        
        if (!ATTACK._sentOver) {
            if (BASE._saveOver !== 1) {
                BASE.Save(1, false, true);
            }
            ATTACK._sentOver = true;
        }
        
        if (GLOBAL.mode === GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode === GLOBAL.e_BASE_MODE.IATTACK) {
            if (CREEPS._guardian && CREEPS._guardian.health > 0) {
                LOGGER.Stat([53, CREEPS._guardian._creatureID, 1]);
            }
            if (CREATURES._guardian && CREATURES._guardian.health > 0) {
                LOGGER.Stat([55, CREATURES._guardian._creatureID, 1]);
            }
        }
        
        for (const creep of CREEPS._creeps) {
            creep.changeModeRetreat();
        }
        
        SiegeWeapons.deactivateWeapon();
        
        if (MapRoomManager.instance.isInMapRoom2or3 && BASE.isMainYardOrInfernoMainYard && 
            (GLOBAL.mode === GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK)) {
            ATTACK._logOpen = false;
            ATTACK.ShowLog();
            ATTACK._shownFinal = false;
        } else if (MAPROOM_DESCENT.DescentLevel && MAPROOM_DESCENT.InDescent) {
            ATTACK.ShowComplete();
        } else {
            ATTACK.EndB();
        }
        
        const totalLoot = ATTACK._loot.r1.Get() + ATTACK._loot.r2.Get() + ATTACK._loot.r3.Get() + ATTACK._loot.r4.Get();
        LOGGER.KongStat([3, totalLoot]);
    }
    
    public static ShowComplete(): void {
        ATTACK.EndB();
    }
    
    private static EndBForMapRoom3(): void {
        const damagePercent = ATTACK.CalculateBaseDamagePercent();
        const isVictory = damagePercent >= BYMConfig.k_sVICTORY_THRESHOLD;
        
        if (BASE.isMainYard) {
            GLOBAL.ShowMap();
        } else if (BASE.isOutpost) {
            if (!isVictory) {
                MapRoom3AttackFinishedPopup.instance.Show(isVictory);
            }
        } else if (GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK) {
            WMBASE._destroyed = isVictory;
            MapRoom3AttackFinishedPopup.instance.Show(isVictory);
        }
    }
    
    public static EndB(): void {
        ATTACK._shownFinal = true;
        const isInDescent = INFERNO_DESCENT_POPUPS.isInDescent();
        
        let currentHealth = 0;
        let maxHealth = 0;
        
        const buildings = InstanceManager.getInstancesByClass(BFOUNDATION) as BFOUNDATION[];
        for (const building of buildings) {
            if (building._class !== "wall" && 
                !(building._class === "trap" && building._class === "enemy" && building._fired) &&
                !(building._type === 53 && building._expireTime < GLOBAL.Timestamp())) {
                currentHealth += building.health;
                maxHealth += building.maxHealth;
            }
        }
        
        const damagePercent = 100 - (100 / maxHealth * currentHealth);
        
        if (MapRoomManager.instance.isInMapRoom3 && !isInDescent && !BASE.isInfernoMainYardOrOutpost) {
            ATTACK.EndBForMapRoom3();
            return;
        }
        
        let isVictory = false;
        
        if (MapRoomManager.instance.isInMapRoom2 && !isInDescent) {
            if ((BASE.isOutpostMapRoom2Only || GLOBAL._loadmode === GLOBAL.e_BASE_MODE.WMATTACK) && 
                damagePercent >= BYMConfig.k_sVICTORY_THRESHOLD) {
                isVictory = true;
                if (GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK) {
                    WMBASE._destroyed = true;
                }
            } else if ((BASE.isMainYardInfernoOnly || GLOBAL._loadmode === GLOBAL.e_BASE_MODE.IWMATTACK) && 
                       damagePercent >= BYMConfig.k_sVICTORY_THRESHOLD) {
                isVictory = true;
                if (GLOBAL._loadmode === GLOBAL.e_BASE_MODE.IWMATTACK) {
                    WMBASE._destroyed = true;
                }
            }
        } else if (GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK || GLOBAL.mode === GLOBAL.e_BASE_MODE.IWMATTACK) {
            const townHalls = InstanceManager.getInstancesByClass(BUILDING14) as BUILDING14[];
            
            for (const townHall of townHalls) {
                if (townHall.health === 0 && townHall._repairing === 0 &&
                    (GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK || GLOBAL.mode === GLOBAL.e_BASE_MODE.IWMATTACK)) {
                    if (TRIBES.TribeForBaseID(BASE._wmID).id === 2) {
                        ACHIEVEMENTS.Check("wm2hall", 1);
                    }
                    if (!MAPROOM_DESCENT.InDescent) {
                        isVictory = true;
                    }
                    break;
                }
            }
            
            if (damagePercent >= BYMConfig.k_sVICTORY_THRESHOLD && MAPROOM_DESCENT.InDescent) {
                isVictory = true;
            }
            
            if (INFERNO_DESCENT_POPUPS.isInDescent()) {
                INFERNO_DESCENT_POPUPS.ShowPostAttackPopup(
                    MAPROOM_DESCENT._descentLvl,
                    isVictory,
                    [ATTACK._loot.r1.Get(), ATTACK._loot.r2.Get(), ATTACK._loot.r3.Get(), ATTACK._loot.r4.Get()],
                    [MAPROOM_DESCENT._loot.r1.Get(), MAPROOM_DESCENT._loot.r2.Get(), MAPROOM_DESCENT._loot.r3.Get(), MAPROOM_DESCENT._loot.r4.Get()]
                );
                ACHIEVEMENTS.Check(ACHIEVEMENTS.DESCENT_LEVEL, MAPROOM_DESCENT.DescentLevel);
            }
        }
        
        if (BASE.isInfernoMainYardOrOutpost) {
            SOUNDS.PlayMusic("musicibuild");
        } else {
            SOUNDS.PlayMusic("musicbuild");
        }
        
        GLOBAL.eventDispatcher.dispatchEvent(new AttackEvent(AttackEvent.ATTACK_OVER, isVictory, BASE._wmID, ATTACK._loot));
        
        if ((MapRoomManager.instance.isInMapRoom2 && BASE.isOutpostMapRoom2Only) || 
            GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK || 
            GLOBAL.mode === GLOBAL.e_BASE_MODE.IWMATTACK) {
            const popup = new popup_attackend(isVictory);
            popup.mcFrame.Setup(false);
            POPUPS.Push(popup);
            
            if (MapRoomManager.instance.isInMapRoom2 && !GLOBAL.m_mapRoomFunctional) {
                GLOBAL.Message(KEYS.Get("map_msg_damaged"));
            }
        } else if (MapRoomManager.instance.isInMapRoom2) {
            GLOBAL.ShowMap();
        } else if (GLOBAL._loadmode === GLOBAL.mode) {
            BASE.LoadBase(null, 0, 0, GLOBAL.e_BASE_MODE.BUILD, false, EnumYardType.MAIN_YARD);
        } else if (MAPROOM_DESCENT.InDescent) {
            BASE.LoadBase(null, 0, 0, GLOBAL.e_BASE_MODE.BUILD, false, EnumYardType.MAIN_YARD);
        } else {
            BASE.LoadBase(GLOBAL._infBaseURL, 0, 0, "ibuild", false, EnumYardType.INFERNO_YARD);
        }
    }
    
    public static WellDefended(wildMonsters: boolean = true, attackersName: string = ""): void {
        const tribe = TRIBES.TribeForBaseID(WMATTACK._attackersBaseID);
        
        const activeEvent = SPECIALEVENT.getActiveSpecialEvent();
        if (activeEvent.active) {
            activeEvent.EndRound(true);
            return;
        }
        
        if (INFERNO_EMERGENCE_EVENT.isAttackActive) {
            INFERNO_EMERGENCE_POPUPS.ShowStagePassed(INFERNOPORTAL.building._lvl.Get());
            return;
        }
        
        const Post = (): void => {
            if (wildMonsters) {
                GLOBAL.CallJS("sendFeed", [
                    "defense-wild",
                    KEYS.Get("ai_gooddefense_streamtitle", { v1: tribe.name }),
                    KEYS.Get("ai_gooddefense", { v1: tribe.name }),
                    tribe.streampostpic
                ]);
            } else {
                GLOBAL.CallJS("sendFeed", [
                    "defense-human",
                    KEYS.Get("attack_gooddefense_streamtitle", { v1: attackersName }),
                    KEYS.Get("attack_gooddefense_streambody"),
                    "defense2.png"
                ]);
            }
            POPUPS.Next();
        };
        
        const popupMC = new popup_defense();
        
        if (wildMonsters) {
            popupMC.tText.htmlText = "<b>" + KEYS.Get("ai_gooddefense", { v1: tribe.name }) + "</b>";
        } else {
            popupMC.tText.htmlText = "<b>" + KEYS.Get("attack_gooddefense", { v1: attackersName }) + "</b>";
        }
        
        popupMC.bAction.SetupKey("btn_brag");
        popupMC.bAction.addEventListener("click", Post);
        popupMC.bAction.Highlight = true;
        
        if (wildMonsters) {
            POPUPS.Push(popupMC, null, null, null, tribe.splash.split("popups/").join(""));
        } else {
            POPUPS.Push(popupMC, null, null, null, "defense2.png");
        }
    }
    
    public static PoorDefense(): void {
        if (INFERNO_EMERGENCE_EVENT.isAttackActive) {
            INFERNO_EMERGENCE_POPUPS.ShowStagePassed(INFERNOPORTAL.building._lvl.Get());
            return;
        }
        
        if (TUTORIAL._stage > 40) {
            const mc = new popup_damaged_ai();
            
            const RepairAll = (event?: MouseEvent): void => {
                mc.bAction.removeEventListener("click", RepairAll);
                mc.bAction2.removeEventListener("click", RepairNow);
                
                const buildings = InstanceManager.getInstancesByClass(BFOUNDATION) as BFOUNDATION[];
                for (const building of buildings) {
                    if (building.health < building.maxHealth && building._repairing === 0) {
                        building.Repair();
                    }
                }
                
                SOUNDS.Play("repair1", 0.25);
                POPUPS.Next();
            };
            
            const RepairNow = (event?: MouseEvent): void => {
                mc.bAction.removeEventListener("click", RepairAll);
                mc.bAction2.removeEventListener("click", RepairNow);
                
                const buildings = InstanceManager.getInstancesByClass(BFOUNDATION) as BFOUNDATION[];
                for (const building of buildings) {
                    if (building.health < building.maxHealth && building._repairing === 0) {
                        building.Repair();
                    }
                }
                
                STORE.ShowB(3, 1, ["FIX"], true);
                POPUPS.Next();
            };
            
            (mc.mcFrame as frame).Setup(false);
            mc.tA.htmlText = "<b>" + KEYS.Get("ai_poordefense_ta") + "</b>";
            mc.tB.htmlText = "<b>" + KEYS.Get("ai_poordefense_tb") + "</b>";
            mc.tC.htmlText = KEYS.Get("ai_poordefense_tc");
            mc.bAction.SetupKey("ai_repairdamage_btn");
            mc.bAction.addEventListener("click", RepairAll);
            mc.bAction2.SetupKey("pop_damaged_repairnow_btn");
            mc.bAction2.addEventListener("click", RepairNow);
            mc.bAction2.Highlight = true;
            
            POPUPS.Push(mc, null, null, "shotgun", "military.png");
        }
    }
    
    protected static CalculateBaseDamagePercent(maxPercent: number = 100): number {
        let maxHealth = 0;
        let currentHealth = 0;
        
        const buildings = InstanceManager.getInstancesByClass(BFOUNDATION) as BFOUNDATION[];
        
        for (const building of buildings) {
            if (building._class !== "wall" && 
                !(building._class === "trap" && building._class === "enemy" && building._fired) &&
                !(building._type === 53 && building._expireTime < GLOBAL.Timestamp())) {
                currentHealth += building.health;
                maxHealth += building.maxHealth;
            }
        }
        
        return maxPercent - (currentHealth / maxHealth * maxPercent);
    }
}
