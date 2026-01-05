import { SecNum } from './com/cc/utils/SecNum';
import { TRIBES } from './com/monsters/ai/TRIBES';
import { WMBASE } from './com/monsters/ai/WMBASE';
import { ALLIANCES } from './com/monsters/alliances/ALLIANCES';
import { AutoBankManager } from './com/monsters/autobanking/AutoBankManager';
import { BaseBuffHandler } from './com/monsters/baseBuffs/BaseBuffHandler';
import { BYMConfig } from './com/monsters/configs/BYMConfig';
import { BuildingOverlay } from './com/monsters/display/BuildingOverlay';
import { ResourceBombs } from './com/monsters/effects/ResourceBombs';
import { Fire } from './com/monsters/effects/fire/Fire';
import { ParticleText } from './com/monsters/effects/particles/ParticleText';
import { Smoke } from './com/monsters/effects/smoke/Smoke';
import { EnumYardType } from './com/monsters/enums/EnumYardType';
import { InstanceManager } from './com/monsters/managers/InstanceManager';
import { MapRoom3 } from './com/monsters/maproom3/MapRoom3';
import { MapRoom3Tutorial } from './com/monsters/maproom3/MapRoom3Tutorial';
import { MapRoomManager } from './com/monsters/maproom_manager/MapRoomManager';
import { ChampionBase } from './com/monsters/monsters/champions/ChampionBase';
import { PATHING } from './com/monsters/pathing/PATHING';
import { Player } from './com/monsters/player/Player';
import { RasterData } from './com/monsters/rendering/RasterData';
import { RewardHandler } from './com/monsters/rewarding/RewardHandler';
import { SiegeWeapons } from './com/monsters/siege/SiegeWeapons';

import { ACADEMY } from './ACADEMY';
import { ACHIEVEMENTS } from './ACHIEVEMENTS';
import { ATTACK } from './ATTACK';
import { BFOUNDATION } from './BFOUNDATION';
import { BTOWER } from './BTOWER';
import { BTRAP } from './BTRAP';
import { BWALL } from './BWALL';
import { Bunker } from './Bunker';
import { CHECKER } from './CHECKER';
import { CREATURELOCKER } from './CREATURELOCKER';
import { CREATURES } from './CREATURES';
import { CREEPS } from './CREEPS';
import { CUSTOMATTACKS } from './CUSTOMATTACKS';
import { EFFECTS } from './EFFECTS';
import { FIREBALLS } from './FIREBALLS';
import { GAME } from './GAME';
import { GIBLETS } from './GIBLETS';
import { GIFTS } from './GIFTS';
import { GLOBAL } from './GLOBAL';
import { GRID } from './GRID';
import { HOUSING } from './HOUSING';
import { KEYS } from './KEYS';
import { LOGGER } from './LOGGER';
import { LOGIN } from './LOGIN';
import { MAP } from './MAP';
import { MAPROOM } from './MAPROOM';
import { MAPROOM_DESCENT } from './MAPROOM_DESCENT';
import { MAPROOM_INFERNO } from './MAPROOM_INFERNO';
import { MARKETING } from './MARKETING';
import { MONSTERBAITER } from './MONSTERBAITER';
import { MUSHROOMS } from './MUSHROOMS';
import { NewPopupSystem } from './NewPopupSystem';
import { PLEASEWAIT } from './PLEASEWAIT';
import { POPUPS } from './POPUPS';
import { POWERUPS } from './POWERUPS';
import { PROJECTILES } from './PROJECTILES';
import { QUEUE } from './QUEUE';
import { QUESTS } from './QUESTS';
import { ResourcePackages } from './ResourcePackages';
import { SOUNDS } from './SOUNDS';
import { SPECIALEVENT } from './SPECIALEVENT';
import { SPECIALEVENT_WM1 } from './SPECIALEVENT_WM1';
import { SPRITES } from './SPRITES';
import { STORE } from './STORE';
import { Targeting } from './Targeting';
import { TUTORIAL } from './TUTORIAL';
import { UI2 } from './UI2';
import { UPDATES } from './UPDATES';
import { URLLoaderApi } from './URLLoaderApi';
import { WMATTACK } from './WMATTACK';
import { WORKERS } from './WORKERS';

/**
 * BASE - Core game base management class
 * Handles loading, saving, building, processing of the game base
 * Converted from ActionScript to TypeScript (6671 lines original)
 */
export class BASE {
    // Base identification
    public static _baseID: number = 0;
    public static _wmID: number = 0;
    public static _loadedBaseID: number = 0;
    public static _loadedFriendlyBaseID: number = 0;
    public static _loadedFBID: number = 0;
    public static _baseSeed: number = 0;
    public static _baseName: string = "";
    public static _baseLevel: number = 0;
    public static _baseValue: number = 0;
    public static _basePoints: number = 0;
    public static _outpostValue: number = 0;
    public static _userID: number = 0;
    public static _allianceID: number = 0;
    
    // Resources
    public static _resources: any = {};
    public static _hpResources: any = {};
    public static _deltaResources: any = {};
    public static _hpDeltaResources: any = {};
    public static _savedDeltaResources: any = {};
    public static _ideltaResources: any = null;
    public static _iresources: any = null;
    public static _bankedValue: number = 0;
    public static _bankedTime: number = 0;
    
    // Credits
    public static _credits: SecNum = new SecNum(0);
    public static _hpCredits: number = 0;
    
    // GIP (Generated In Production)
    public static _GIP: any = {};
    public static _processedGIP: any = {};
    public static _rawGIP: any = {};
    public static _lastProcessedGIP: number = 0;
    
    // Saving/Loading state
    public static _blockSave: boolean = false;
    public static _saveCounterA: number = 0;
    public static _saveCounterB: number = 0;
    public static _saving: boolean = false;
    public static _paging: boolean = false;
    public static _lastSaveID: number = 0;
    public static _attackID: number = 0;
    public static _lastSaved: number = 0;
    public static _lastSaveRequest: number = 0;
    public static _saveOver: number = 0;
    public static _returnHome: boolean = false;
    public static _saveProtect: number = 0;
    public static _saveErrors: number = 0;
    public static _pageErrors: number = 0;
    public static _loadTime: number = 0;
    public static _loading: boolean = false;
    public static _infernoSaveLoad: boolean = false;
    public static _lastPaged: number = 0;
    
    // Processing state
    public static _lastProcessed: number = 0;
    public static _lastProcessedB: number = 0;
    public static _catchupTime: number = 0;
    public static _currentTime: number = 0;
    public static _processing: boolean = false;
    public static _timer: number = 0;
    private static s_processing: boolean = false;
    private static _tmpPercent: number = 0;
    
    // Building data
    public static _baseData: any[] = [];
    public static _upgradeData: any = {};
    public static _buildingCount: number = 0;
    public static _buildingHealthData: any = {};
    public static _buildingData: any = {};
    public static _buildingsAll: any = {};
    public static _buildingsWalls: any = {};
    public static _buildingsTowers: any = {};
    public static _buildingsBunkers: any = {};
    public static _buildingsHousing: any[] = [];
    public static _buildingsMain: any = {};
    public static _buildingsMushrooms: any = {};
    public static _buildingsGifts: any = {};
    public static _buildingsStored: any = {};
    public static buildings: BFOUNDATION[] = [];
    public static _buildingCounts: any = {};
    public static _buildingStatsToggle: boolean = false;
    
    // Monster data
    public static _rawMonsters: any = {};
    
    // Mushroom data
    public static _mushroomList: any[] = [];
    public static _lastSpawnedMushroom: number = 0;
    
    // Map/Visual settings
    public static _size: number = 400;
    public static _angle: number = 0.8;
    public static _shakeCountdown: number = 0;
    
    // Attack tracking
    public static _attackerArray: any[] = [];
    public static _attackerNameArray: any[] = [];
    public static _currentAttacks: any[] = [];
    public static _attacksModified: boolean = false;
    
    // Temporary data
    public static _tempLoot: any = {};
    public static _tempGifts: any[] = [];
    public static _tempSentGifts: any[] = [];
    public static _tempSentInvites: any[] = [];
    
    // Protection/Status flags
    public static _isProtected: number = 0;
    public static _isReinforcements: number = 0;
    public static _isSanctuary: number = 0;
    public static _isFan: number = 0;
    public static _isBookmarked: number = 0;
    public static _installsGenerated: number = 0;
    
    // Owner info
    public static _ownerName: string = "";
    public static _ownerPic: string = "";
    
    // Pending operations
    public static _pendingPurchase: any[] = [];
    public static _pendingPromo: number = 0;
    public static _pendingFBPromo: number = 0;
    public static _pendingFBPromoIDs: any[] = [];
    public static _salePromoTime: number = 0;
    public static _loadBase: any[] = [];
    
    // Damage tracking
    public static _percentDamaged: number = 0;
    public static _damagedBaseWarnTime: number = 0;
    
    // Takeover
    public static _takeoverFirstOpen: number = 0;
    public static _takeoverPreviousOwnersName: string = "";
    
    // Siege data
    private static _oldSiegeData: any = {};
    
    // Load object
    public static loadObject: any = {};
    
    // Alliance armament
    public static _allianceArmamentTime: SecNum = new SecNum(0);
    
    // Resource cells
    private static s_resourceCells: any = {};
    
    // Yard type
    public static _loadedYardType: number = 0;
    private static m_yardType: number = EnumYardType.MAIN_YARD;
    
    // First load flag
    protected static _firstBaseLoaded: boolean = true;
    
    // User digits
    public static _userDigits: number[] = [];
    
    // Guardian data
    public static _guardianData: any[] = [];
    
    // Event bases
    public static s_eventBases: number[] = [];
    
    // UI state
    public static _showingWhatsNew: boolean = false;
    public static _needCurrentCell: boolean = false;
    public static _currentCellLoc: { x: number, y: number } | null = null;
    
    // Level progression data
    private static readonly s_levels: number[] = [
        0, 900, 3500, 5000, 7500, 10500, 14700, 20580, 28812, 40337, 56472, 79060, 
        110684, 154958, 216941, 303717, 425204, 595286, 833401, 1166761, 1633465, 
        2286851, 3201591, 4482228, 6275119, 8785167, 12299234, 17218927, 24106498, 
        33749097, 47248736, 66148230, 92607522, 129650530, 181510743, 254115040, 
        355761056, 498065478, 697291669, 976208337, 1366691671, 1913368339, 
        2678715675, 3750201945, 5250282723, 7350395812, 10290554137, 14406775792, 
        20169486109, 28237280553, 39532192774, 55345069884, 77483097838, 
        108476336973, 151866871762, 212613620467, 297659068653, 357190880000, 
        428629050000, 514354860000, 617225830000, 740670990000, 888805180000, 
        1066566210000, 1279879450000, 1535853400000, 1843026400000, 2211631680000, 
        2653958010000, 3184749610000, 3821699530000, 4586039430000, 5503247310000, 
        6603896770000, 7924676120000, 9509611340000, 11411533600000, 13693840320000, 
        16432608380000, 19719130050000, 23662956060000, 28395547270000, 
        34074656720000, 40889588060000, 49067505670000, 58881006800000, 
        70657208160000, 84788649790000, 101746379740000, 122095655680000, 
        146514786810000, 175817744170000, 210981293000000, 253177551600000, 
        303813061920000, 364575674300000, 437490809160000, 524988970990000, 
        629986765180000, 755984118210000
    ];
    
    private static _loadedSomething: boolean = false;
    private static _addtionalLoadArguments: any[] = [];
    
    constructor() {
        BASE._baseID = 0;
        BASE.Setup();
        BASE.Load();
    }
    
    // Property getters/setters
    public static get yardType(): number {
        return BASE.m_yardType;
    }
    
    public static set yardType(value: number) {
        BASE.m_yardType = value;
    }
    
    public static get firstBaseLoaded(): boolean {
        return BASE._firstBaseLoaded;
    }
    
    public static get processing(): boolean {
        return BASE.s_processing;
    }
    
    public static get resourceCells(): any {
        return BASE.s_resourceCells;
    }
    
    // Yard type helpers
    public static get isMainYard(): boolean {
        return BASE.m_yardType === EnumYardType.MAIN_YARD;
    }
    
    public static get isOutpost(): boolean {
        return BASE.m_yardType === EnumYardType.OUTPOST || 
               BASE.m_yardType === EnumYardType.INFERNO_OUTPOST;
    }
    
    public static get isInfernoMainYardOrOutpost(): boolean {
        return BASE.m_yardType === EnumYardType.INFERNO_YARD || 
               BASE.m_yardType === EnumYardType.INFERNO_OUTPOST;
    }
    
    public static get isMainYardOrInfernoMainYard(): boolean {
        return BASE.m_yardType === EnumYardType.MAIN_YARD || 
               BASE.m_yardType === EnumYardType.INFERNO_YARD;
    }
    
    public static get isOutpostOrInfernoOutpost(): boolean {
        return BASE.m_yardType === EnumYardType.OUTPOST || 
               BASE.m_yardType === EnumYardType.INFERNO_OUTPOST;
    }
    
    public static get isOutpostMapRoom2Only(): boolean {
        return BASE.m_yardType === EnumYardType.OUTPOST;
    }
    
    public static get isOutpostInfernoOnly(): boolean {
        return BASE.m_yardType === EnumYardType.INFERNO_OUTPOST;
    }
    
    public static get isMainYardInfernoOnly(): boolean {
        return BASE.m_yardType === EnumYardType.INFERNO_YARD;
    }
    
    public static Setup(): void {
        BASE._buildingsHousing = [];
        BASE._buildingsBunkers = {};
        BASE._pendingPurchase = [];
        BASE._buildingCount = 0;
        BASE._processing = false;
        BASE._buildingStatsToggle = false;
        BASE._angle = 0.8;
        BASE._lastPaged = 0;
        BASE._blockSave = false;
        BASE._damagedBaseWarnTime = 0;
        BASE._saveCounterA = 0;
        BASE._saveCounterB = 0;
        BASE._saveOver = 0;
        BASE._returnHome = false;
        BASE._saveProtect = 0;
        BASE._saving = false;
        BASE._paging = false;
        BASE._saveErrors = 0;
        BASE._currentAttacks = [];
        BASE._attacksModified = false;
        BASE._pageErrors = 0;
        BASE._lastSaved = 0;
        BASE._infernoSaveLoad = false;
        BASE._isProtected = 0;
        BASE._isReinforcements = 0;
        BASE._isSanctuary = 0;
        BASE._isFan = 0;
        BASE._isBookmarked = 0;
        BASE._installsGenerated = 0;
        
        BASE._ideltaResources = {
            dirty: false,
            r1: new SecNum(0),
            r2: new SecNum(0),
            r3: new SecNum(0),
            r4: new SecNum(0),
            r1max: 0,
            r2max: 0,
            r3max: 0,
            r4max: 0
        };
        
        BASE._iresources = {
            r1: new SecNum(0),
            r2: new SecNum(0),
            r3: new SecNum(0),
            r4: new SecNum(0),
            r1max: 0,
            r2max: 0,
            r3max: 0,
            r4max: 0
        };
        
        BASE._deltaResources = {
            dirty: false,
            r1: new SecNum(0),
            r2: new SecNum(0),
            r3: new SecNum(0),
            r4: new SecNum(0)
        };
        
        BASE._hpDeltaResources = {
            dirty: false,
            r1: 0,
            r2: 0,
            r3: 0,
            r4: 0
        };
        
        BASE._savedDeltaResources = {
            r1: new SecNum(0),
            r2: new SecNum(0),
            r3: new SecNum(0),
            r4: new SecNum(0)
        };
        
        BASE._loadBase = [];
        GLOBAL.Clear();
    }
    
    public static Cleanup(): void {
        SPECIALEVENT.ClearWildMonsterPowerups();
        SPECIALEVENT_WM1.ClearWildMonsterPowerups();
        BaseBuffHandler.instance.clearBuffs();
        RewardHandler.instance.clear();
        GLOBAL.player.clear();
        
        if (GLOBAL.attackingPlayer) {
            GLOBAL.attackingPlayer.clear();
        }
        
        CREATURES.Clear();
        CREEPS.Clear();
        InstanceManager.clearAll();
        
        BASE.buildings = [];
        BASE._buildingsAll = {};
        BASE._buildingsWalls = {};
        BASE._buildingsTowers = {};
        BASE._buildingsMain = {};
        BASE._buildingsMushrooms = {};
        BASE._buildingsGifts = {};
        BASE._buildingsStored = {};
        
        GLOBAL.setTownHall(null);
        GLOBAL._bAcademy = null;
        GLOBAL._bBaiter = null;
        GLOBAL._bFlinger = null;
        GLOBAL._bHatchery = null;
        GLOBAL._bHatcheryCC = null;
        GLOBAL._bHousing = null;
        GLOBAL._bJuicer = null;
        GLOBAL._bLocker = null;
        GLOBAL._bMap = null;
        GLOBAL._bStore = null;
        
        UI2.Hide("warning");
        UI2.Hide("scareAway");
        WMATTACK._inProgress = false;
        MONSTERBAITER._scaredAway = false;
        CUSTOMATTACKS._started = false;
        WMATTACK._queued = null;
        
        GRID.Cleanup();
        PATHING.Cleanup();
        RasterData.clear();
        
        BASE._showingWhatsNew = false;
        
        BASE._deltaResources = {
            dirty: false,
            r1: new SecNum(0),
            r2: new SecNum(0),
            r3: new SecNum(0),
            r4: new SecNum(0)
        };
        
        BASE._hpDeltaResources = {
            dirty: false,
            r1: 0,
            r2: 0,
            r3: 0,
            r4: 0
        };
        
        BASE._savedDeltaResources = {
            r1: new SecNum(0),
            r2: new SecNum(0),
            r3: new SecNum(0),
            r4: new SecNum(0)
        };
    }
    
    public static LoadBase(
        url: string | null = null,
        userId: number = 0,
        baseId: number = 0,
        baseMode: string = "build",
        isError: boolean = false,
        baseType: number = -1,
        cellId: number = 0,
        keyValuePairs: any[] | null = null
    ): boolean {
        if (isNaN(baseId)) baseId = 0;
        if (isNaN(userId)) userId = 0;
        
        if (MapRoomManager.instance.isInMapRoom2or3 && MapRoomManager.instance.isOpen) {
            MapRoomManager.instance.Hide();
        }
        
        if (MAPROOM_INFERNO._open) {
            MAPROOM_INFERNO.Hide();
        }
        
        if (MAPROOM._open) {
            MAPROOM.Hide();
        }
        
        if (!MapRoomManager.instance.isInMapRoom2or3 && 
            (baseMode === GLOBAL.e_BASE_MODE.ATTACK || baseMode === GLOBAL.e_BASE_MODE.IATTACK) && 
            (GLOBAL.mode !== GLOBAL.e_BASE_MODE.BUILD && GLOBAL.mode !== GLOBAL.e_BASE_MODE.IBUILD)) {
            return false;
        }
        
        if (!BASE._loading) {
            GLOBAL._reloadonerror = isError;
            
            if (baseId === 0 && userId === 0) {
                if (baseMode !== GLOBAL.e_BASE_MODE.IBUILD) {
                    baseMode = GLOBAL.e_BASE_MODE.BUILD;
                }
            }
            
            if ((baseMode === GLOBAL.e_BASE_MODE.ATTACK || baseMode === GLOBAL.e_BASE_MODE.WMATTACK) && 
                !MapRoomManager.instance.isInMapRoom2or3 && 
                (!GLOBAL._bFlinger || !GLOBAL._bFlinger._canFunction) && 
                !BASE.isInfernoMainYardOrOutpost) {
                LOGGER.Log("err", "Impossible fling");
                GLOBAL.ErrorMessage("BASE.LoadBase impossible fling");
                return false;
            }
            
            BASE._loadBase = [url, userId, baseId, baseMode, baseType, cellId];
            
            if (!MapRoomManager.instance.isInMapRoom2or3 && 
                (baseMode === GLOBAL.e_BASE_MODE.ATTACK || 
                 baseMode === GLOBAL.e_BASE_MODE.WMATTACK || 
                 baseMode === GLOBAL.e_BASE_MODE.IATTACK || 
                 baseMode === GLOBAL.e_BASE_MODE.IWMATTACK)) {
                PLEASEWAIT.Show(KEYS.Get("msg_preparing"));
                BASE.Save(0, false, true);
            } else if (!BASE._saving) {
                if (keyValuePairs) {
                    BASE._addtionalLoadArguments.push(keyValuePairs);
                }
                BASE.LoadBaseB();
                BASE._addtionalLoadArguments = [];
            }
        }
        
        return true;
    }
    
    public static LoadBaseB(): void {
        console.log("|BASE| - LoadBaseB() _loadBase:" + JSON.stringify(BASE._loadBase));
        
        GLOBAL._baseURL2 = BASE._loadBase[0];
        const userId = Number(BASE._loadBase[1]);
        const baseId = Number(BASE._loadBase[2]);
        const baseMode = String(BASE._loadBase[3]);
        const baseType = Number(BASE._loadBase[4]);
        const cellId = Number(BASE._loadBase[5]);
        
        BASE._loadBase = [];
        GLOBAL.Setup(baseMode);
        BASE.Load(GLOBAL._baseURL2, userId, baseId, baseType, cellId);
    }
    
    public static Load(
        url: string | null = null,
        userId: number = 0,
        baseId: number = 0,
        baseType: number = -1,
        cellId: number = 0
    ): void {
        GLOBAL._baseLoads += 1;
        BASE._loading = true;
        BASE._baseID = baseId;
        BASE._baseLevel = 0;
        BASE._saveOver = 0;
        BASE._returnHome = false;
        BASE._saveProtect = 0;
        
        PLEASEWAIT.Hide();
        BASE.Cleanup();
        
        if (MapRoomManager.instance.isInMapRoom3 && baseType !== -1) {
            BASE.m_yardType = baseType;
        } else if (baseType >= EnumYardType.MAIN_YARD) {
            BASE.m_yardType = baseType;
        }
        
        if (BASE.isMainYardOrInfernoMainYard) {
            if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode === GLOBAL.e_BASE_MODE.IBUILD) {
                GLOBAL.attackingPlayer = GLOBAL.player;
            }
        }
        
        GLOBAL.attackingPlayer.isAttacking = GLOBAL.attackingPlayer !== GLOBAL.player;
        
        PLEASEWAIT.Show(KEYS.Get("msg_loading"));
        GRID.CreateGrid();
        POPUPS.Setup();
        CREEPS.Clear();
        GLOBAL.Clear();
        MAP.Clear();
        UI2.Clear();
        ResourceBombs.Clear();
        CREATURES.Clear();
        PROJECTILES.Clear();
        ATTACK.Setup();
        ResourcePackages.Clear();
        GIBLETS.Clear();
        CREATURELOCKER.Setup();
        CUSTOMATTACKS.Setup();
        UPDATES.Setup();
        BuildingOverlay.Clear();
        ParticleText.Clear();
        SPRITES.Clear();
        SPRITES.Setup();
        Fire.Clear();
        ResourceBombs.Data();
        ALLIANCES.Setup();
        
        GLOBAL._catchup = true;
        BASE._mushroomList = [];
        BASE._lastSpawnedMushroom = 0;
        BASE._size = 400;
        
        // Build request data and load from server
        const requestData: any[] = [];
        requestData.push(["userid", userId > 0 ? userId : ""]);
        if (cellId) {
            requestData.push(["cellid", cellId]);
        }
        requestData.push(["baseid", BASE._baseID]);
        
        let loadMode = GLOBAL._loadmode;
        if (MapRoomManager.instance.isInMapRoom2or3) {
            if (loadMode === GLOBAL.e_BASE_MODE.WMATTACK) {
                loadMode = GLOBAL.e_BASE_MODE.ATTACK;
            }
            if (loadMode === GLOBAL.e_BASE_MODE.WMVIEW) {
                loadMode = GLOBAL.e_BASE_MODE.VIEW;
            }
        }
        
        requestData.push(["type", loadMode]);
        
        if (loadMode === GLOBAL.e_BASE_MODE.ATTACK || 
            loadMode === GLOBAL.e_BASE_MODE.WMATTACK || 
            loadMode === GLOBAL.e_BASE_MODE.IATTACK || 
            loadMode === GLOBAL.e_BASE_MODE.IWMATTACK) {
            const attackData = JSON.stringify(ATTACK.AttackData());
            requestData.push(["attackData", attackData]);
        }
        
        // Load from appropriate URL
        const loader = new URLLoaderApi();
        if (url) {
            loader.load(url + "load", requestData, BASE.handleBaseLoadSuccessful, BASE.handleBaseLoadError);
        } else if (BASE.isInfernoMainYardOrOutpost || (BASE.isEventBaseId(BASE._baseID) && GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK)) {
            loader.load(GLOBAL._infBaseURL + "load", requestData, BASE.handleBaseLoadSuccessful, BASE.handleBaseLoadError);
        } else {
            loader.load(GLOBAL._baseURL + "load", requestData, BASE.handleBaseLoadSuccessful, BASE.handleBaseLoadError);
        }
    }
    
    private static handleBaseLoadSuccessful(serverData: any): void {
        try {
            if (serverData.error === 0) {
                BASE.loadObject = serverData;
                // Process server data and build base
                BASE.Build();
            } else {
                GLOBAL.ErrorMessage(serverData.error, GLOBAL.ERROR_ORANGE_BOX_ONLY);
                PLEASEWAIT.Hide();
            }
        } catch (error: any) {
            GLOBAL.Message(KEYS.Get("err_loading_base"));
            LOGGER.Log("err", "Failed to load user base with error: " + error.message);
        }
    }
    
    private static handleBaseLoadError(event: any): void {
        if (GLOBAL._reloadonerror) {
            GLOBAL.CallJS("reloadPage");
        } else {
            LOGGER.Log("err", "BASE.Load HTTP");
            PLEASEWAIT.Hide();
            GLOBAL.ErrorMessage("BASE.Load HTTP");
        }
    }
    
    public static Build(): void {
        PLEASEWAIT.Update(KEYS.Get("msg_building"));
        
        if (MAPROOM_INFERNO._open) {
            MAPROOM_INFERNO.Hide();
        }
        if (MAPROOM._open) {
            MAPROOM.Hide();
        }
        
        UI2.Setup();
        GLOBAL.ResizeGame(null);
        GLOBAL._render = false;
        PATHING.Setup();
        
        let terrainType = "grass";
        if (BASE.isInfernoMainYardOrOutpost) {
            terrainType = "lava";
        }
        
        const map = new MAP(terrainType);
        const targeting = new Targeting();
        QUEUE.Spawn(0);
        Smoke.Setup();
        
        // Process building data 
        // ... (building creation logic would go here)
        
        BFOUNDATION.redrawAllShadowData();
        
        GRID.Clear();
        MAP.SortDepth();
        HOUSING.HousingSpace();
        MONSTERBAITER.Update();
        
        BASE.Process();
    }
    
    public static Process(): void {
        PLEASEWAIT.Update(KEYS.Get("msg_processing"));
        BASE._tmpPercent = 0;
        
        HOUSING.Cull();
        BASE.CalcResources();
        
        BASE._baseLevel = BASE.BaseLevel().level;
        BASE._bankedValue = 0;
        GLOBAL.t = BASE._lastProcessed;
        BASE._lastProcessedB = BASE._lastProcessed;
        BASE._catchupTime = BASE._currentTime - BASE._lastProcessed;
        
        BASE._timer = Date.now();
        BASE.HideFootprints();
        
        // Continue processing
        BASE.ProcessD();
    }
    
    public static ProcessD(): void {
        BASE.s_processing = true;
        
        if (GLOBAL.mode === GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK) {
            ATTACK.Setup();
        }
        
        EFFECTS.Process(BASE._catchupTime);
        
        if (BASE.isMainYard) {
            CREATURELOCKER.Tick();
        }
        
        if (BASE._tempGifts) {
            GIFTS.Process(BASE._tempGifts);
        }
        
        UPDATES.Catchup();
        HOUSING.Cull();
        HOUSING.Populate();
        SOUNDS.Setup();
        
        GLOBAL._render = true;
        GLOBAL._catchup = false;
        
        UI2.Update();
        PLEASEWAIT.Hide();
        BASE.CalcResources();
        UI2._scrollMap = true;
        
        if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD) {
            if (!WMATTACK._inProgress) {
                UI2.Show("top");
                UI2.Show("bottom");
            }
        } else if (GLOBAL.mode === GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK) {
            UI2.Show("top");
        }
        
        BASE._baseLevel = BASE.BaseLevel().level;
        BASE._loadTime = GLOBAL.Timestamp();
        BASE._lastSaved = GLOBAL.Timestamp();
        BASE.Save();
        
        QUESTS.TutorialCheck();
        QUESTS.Check();
        PATHING.ResetCosts();
        TUTORIAL.Process();
        MUSHROOMS.Setup();
        NewPopupSystem.instance.CheckAll(true);
        
        LOGGER.Stat([29, GLOBAL.mode]);
        BASE._loading = false;
        
        GLOBAL.CallJS("cc.injectFriendsSwf", null, false);
        BASE.s_processing = false;
        BASE.HideFootprints();
    }
    
    public static Tick(): void {
        let saveDelay = 2;
        if (GLOBAL._flags.savedelay) {
            saveDelay = GLOBAL._flags.savedelay;
        }
        
        if (BASE._saveCounterA !== BASE._saveCounterB) {
            if (GLOBAL.mode === GLOBAL.e_BASE_MODE.ATTACK && BASE._saveOver !== 1) {
                if (GLOBAL.Timestamp() - BASE._lastSaveRequest > saveDelay * 2 || GLOBAL.Timestamp() - BASE._lastSaved > 15) {
                    BASE.SaveB();
                }
            } else if (GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK && BASE._saveOver !== 1) {
                if (GLOBAL.Timestamp() - BASE._lastSaveRequest > saveDelay * 2 || GLOBAL.Timestamp() - BASE._lastSaved > 20) {
                    BASE.SaveB();
                }
            } else if (GLOBAL.Timestamp() - BASE._lastSaveRequest >= saveDelay || 
                       BASE._pendingPurchase.length > 0 || 
                       (BASE._loadBase.length > 0 && BASE._saveOver !== 1)) {
                BASE.SaveB();
            }
            
            if (GLOBAL.mode === GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK) {
                UI2._top.mcSave.gotoAndStop(4);
            } else {
                UI2._top.mcSave.gotoAndStop(2);
            }
        } else {
            if (GLOBAL.mode === GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK) {
                UI2._top.mcSave.gotoAndStop(3);
            } else {
                UI2._top.mcSave.gotoAndStop(1);
            }
        }
        
        if (GLOBAL.Timestamp() % 10 === 0) {
            CHECKER.Check();
            if (!BASE.isInfernoMainYardOrOutpost) {
                AutoBankManager.autobank();
            }
        }
        
        ++BASE._lastPaged;
        BASE.ShakeB();
    }
    
    public static Purchase(itemId: string, quantity: number, source: string, param4: boolean = false): boolean {
        if (BASE._pendingPurchase.length > 0) {
            GLOBAL.ErrorMessage(KEYS.Get("msg_err_purchase"), GLOBAL.ERROR_ORANGE_BOX_ONLY);
            return false;
        }
        
        if (!quantity || quantity <= 0) {
            GLOBAL.ErrorMessage("BASE.Purchase zero quantity");
            LOGGER.Log("err", `BASE.Purchase Id ${itemId}, illegal quantity ${quantity}, possible hack`);
            return false;
        }
        
        BASE._pendingPurchase = [itemId, quantity, BASE._saveCounterA + 1, source, param4];
        
        if (source !== "store") {
            LOGGER.Stat([61, itemId, quantity]);
        }
        
        BASE.Save();
        return true;
    }
    
    public static Save(saveOver: number = 0, returnHome: boolean = false, immediate: boolean = false, infernoSave: boolean = false): void {
        if (UI2._top && UI2._top.mcSave) {
            if (GLOBAL.mode === GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK) {
                UI2._top.mcSave.gotoAndStop(4);
            } else {
                UI2._top.mcSave.gotoAndStop(2);
            }
        }
        
        if (saveOver > 0) {
            BASE._saveOver = saveOver;
        }
        
        if (returnHome) {
            BASE._returnHome = true;
        }
        
        BASE._lastSaveRequest = GLOBAL.Timestamp();
        ++BASE._saveCounterA;
        
        if (immediate || BASE._pendingPurchase.length > 0) {
            BASE.SaveB();
        }
        
        if (BASE.isInfernoMainYardOrOutpost || infernoSave || GLOBAL._loadmode !== GLOBAL.mode) {
            BASE._infernoSaveLoad = true;
        }
    }
    
    public static SaveB(): void {
        // Implementation for saving to server
        BASE._saving = true;
        BASE._lastSaved = GLOBAL.Timestamp();
        BASE._saveCounterB = BASE._saveCounterA;
        
        // Save logic would go here
        
        BASE._saving = false;
    }
    
    public static Charge(resourceType: number, amount: number, checkOnly: boolean = false, useInferno: boolean = false): boolean {
        const resources = useInferno ? BASE._iresources : BASE._resources;
        const resourceKey = "r" + resourceType;
        
        if (checkOnly) {
            return resources[resourceKey].Get() >= amount;
        }
        
        if (resources[resourceKey].Get() >= amount) {
            resources[resourceKey].Add(-amount);
            return true;
        }
        
        return false;
    }
    
    public static CalcResources(): void {
        // Calculate max resources based on storage buildings
        const buildings = InstanceManager.getInstancesByClass(BFOUNDATION) as BFOUNDATION[];
        
        BASE._resources.r1max = 0;
        BASE._resources.r2max = 0;
        BASE._resources.r3max = 0;
        BASE._resources.r4max = 0;
        
        for (const building of buildings) {
            if (building._capacity) {
                for (let i = 1; i <= 4; i++) {
                    if (building._capacity["r" + i]) {
                        BASE._resources["r" + i + "max"] += building._capacity["r" + i];
                    }
                }
            }
        }
    }
    
    public static BaseLevel(): { level: number; nextLevel: number; progress: number } {
        let level = 1;
        
        for (let i = 0; i < BASE.s_levels.length; i++) {
            if (BASE._basePoints >= BASE.s_levels[i]) {
                level = i + 1;
            } else {
                break;
            }
        }
        
        const currentLevelPoints = BASE.s_levels[level - 1] || 0;
        const nextLevelPoints = BASE.s_levels[level] || BASE.s_levels[BASE.s_levels.length - 1];
        const progress = (BASE._basePoints - currentLevelPoints) / (nextLevelPoints - currentLevelPoints);
        
        return {
            level: level,
            nextLevel: nextLevelPoints,
            progress: progress
        };
    }
    
    public static PointsAdd(amount: number): void {
        BASE._basePoints += amount;
    }
    
    public static PointsRemove(amount: number): void {
        BASE._basePoints -= amount;
        if (BASE._basePoints < 0) {
            BASE._basePoints = 0;
        }
    }
    
    public static Shake(intensity: number = 10): void {
        BASE._shakeCountdown = intensity;
    }
    
    private static ShakeB(): void {
        if (BASE._shakeCountdown > 0) {
            BASE._shakeCountdown--;
            // Apply shake effect to map
        }
    }
    
    public static HideFootprints(): void {
        // Hide building footprints
    }
    
    public static ShowFootprints(): void {
        // Show building footprints
    }
    
    public static BuildingDeselect(): void {
        // Deselect current building
    }
    
    public static isEventBaseId(baseId: number): boolean {
        return BASE.s_eventBases.indexOf(baseId) !== -1;
    }
    
    public static addBuildingC(buildingType: number): BFOUNDATION | null {
        // Create and add a building of the specified type
        // Returns the created building foundation
        return null;
    }
    
    public static Page(): void {
        // Paging logic for periodic server sync
        BASE._paging = true;
        BASE._lastPaged = 0;
        
        // Page request would go here
        
        BASE._paging = false;
    }
    
    public static repairAllBuildingsToMinimumPercentage(percentage: number): void {
        percentage = Math.max(0, Math.min(1, percentage));
        const buildings = InstanceManager.getInstancesByClass(BFOUNDATION) as BFOUNDATION[];
        
        for (const building of buildings) {
            const minHealth = building.maxHealth * percentage;
            if (building.health < minHealth) {
                building.setHealth(minHealth);
            }
        }
    }
    
    public static startHealAllHelper(): void {
        // Helper for healing all creatures
        BASE.Save();
    }
    
    public static healShinyNowHelper(): void {
        // Helper for instant heal with shiny
        const cost = STORE.GetHealAllShinyCost();
        STORE.ShowB(3, 1, ["HAMS"], true);
        POPUPS.Next();
    }
}
