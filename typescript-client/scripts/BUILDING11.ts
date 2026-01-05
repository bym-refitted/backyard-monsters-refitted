import IOErrorEvent from 'openfl/events/IOErrorEvent';
import MouseEvent from 'openfl/events/MouseEvent';
import Point from 'openfl/geom/Point';
import Rectangle from 'openfl/geom/Rectangle';
import { ALLIANCES } from './com/monsters/alliances/ALLIANCES';
import { BuildingEvent } from './com/monsters/events/BuildingEvent';
import { MapRoomManager } from './com/monsters/maproom_manager/MapRoomManager';
import { BFOUNDATION } from './BFOUNDATION';
import { ACHIEVEMENTS } from './ACHIEVEMENTS';
import { BASE } from './BASE';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { LOGGER } from './LOGGER';
import { MAPROOM } from './MAPROOM';
import { PLEASEWAIT } from './PLEASEWAIT';
import { POPUPS } from './POPUPS';
import { STORE } from './STORE';
import { URLLoaderApi } from './URLLoaderApi';

/**
 * BUILDING11 - Map Room
 * Extends BFOUNDATION for the world map room building
 */
export class BUILDING11 extends BFOUNDATION {
    public static readonly CHANGED_TO_MR2: string = "changedToMR2";
    private callPending: boolean = false;

    constructor() {
        super();
        this._type = 11;
        this._footprint = [new Rectangle(0, 0, 90, 90)];
        this._gridCost = [[new Rectangle(0, 0, 90, 90), 10], [new Rectangle(10, 10, 70, 70), 200]];
        this.SetProps();
    }

    public override Tick(seconds: number): void {
        if (this._countdownBuild.Get() > 0 || this.health < this.maxHealth * 0.5) {
            this._canFunction = false;
        } else {
            this._canFunction = true;
            MAPROOM.initMaproomSetup = true;
        }
        if (MapRoomManager.instance.isInMapRoom3) {
            GLOBAL.StatSet("mrl", 3);
        } else {
            if (this._lvl.Get() < 2 && GLOBAL.StatGet("mrl") === 2) {
                GLOBAL.StatSet("mrl", 2);
            }
            if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD && this._lvl.Get() === 1 && 
                GLOBAL.StatGet("mrl") !== 2 && BASE._saveCounterA === BASE._saveCounterB && !BASE._saving) {
                this.NewWorld();
            }
        }
        if (!GLOBAL._catchup && GLOBAL._render && this._countdownUpgrade.Get() && 
            this._countdownUpgrade.Get() < 60 * 60 * 24 * 2) {
            this.PopupUpgrade(2);
        }
        super.Tick(seconds);
    }

    private NewWorld(): void {
        if (!MapRoomManager.instance.isInMapRoom3 && GLOBAL.mode === GLOBAL._loadmode && GLOBAL._flags.maproom2) {
            ACHIEVEMENTS.Check("map2", 1);
            if (this.callPending) return;
            this.callPending = true;
            const data: any[] = [["version", 2]];
            new URLLoaderApi().load(GLOBAL._mapURL + "setmapversion", data, this.NewWorldSuccess.bind(this), this.NewWorldFail.bind(this));
        }
    }

    private NewWorldSuccess(serverData: any): void {
        if (serverData.error === 0) {
            if (GLOBAL.mode !== GLOBAL._loadmode) return;
            GLOBAL.StatSet(BUILDING11.CHANGED_TO_MR2, 1);
            GLOBAL.StatSet("mrl", 2, true);
            MapRoomManager.instance.mapRoomVersion = MapRoomManager.MAP_ROOM_VERSION_2;
            GLOBAL._baseURL = serverData.baseurl;
            GLOBAL._homeBaseID = serverData.homebaseid;
            BASE._loadedBaseID = serverData.homebaseid;
            BASE._baseID = 0;
            BASE._loadedFriendlyBaseID = GLOBAL._homeBaseID;
            MapRoomManager.instance.BookmarksClear();
            if (serverData.basesaveid !== 1) {
                BASE._lastSaveID = serverData.basesaveid;
            }
            if (serverData.homebase?.length === 2 && serverData.homebase[0] > -1 && serverData.homebase[1] > -1) {
                if (serverData.worldsize) {
                    MapRoomManager.instance.mapWidth = serverData.worldsize[0];
                    MapRoomManager.instance.mapHeight = serverData.worldsize[1];
                }
                GLOBAL._mapHome = new Point(serverData.homebase[0], serverData.homebase[1]);
                if (serverData.outposts) {
                    GLOBAL._mapOutpost = [];
                    for (const outpost of serverData.outposts) {
                        if (outpost.length === 2) {
                            GLOBAL._mapOutpost.push(new Point(outpost[0], outpost[1]));
                        }
                    }
                }
                GLOBAL.eventDispatcher.dispatchEvent(new BuildingEvent(BuildingEvent.ENTER_MR2, this));
            } else {
                LOGGER.Log("err", "BUILDING11.NewWorldSuccess Invalid home base coordinate.");
            }
        } else {
            this.callPending = true;
            GLOBAL._flags.discordOldEnough = false;
        }
        this.callPending = false;
        PLEASEWAIT.Hide();
    }

    private NewWorldFail(event: IOErrorEvent): void {
        this.callPending = false;
        LOGGER.Log("err", "BUILDING11.NewWorld HTTP");
        PLEASEWAIT.Hide();
    }

    public override PlaceB(): void {
        super.PlaceB();
        GLOBAL._bMap = this;
    }

    public override Constructed(): void {
        GLOBAL._bMap = this;
        super.Constructed();
    }

    public override UpgradeB(): void {
        super.UpgradeB();
        this.PopupUpgrade(1);
    }

    public PopupUpgrade(n: number): void {
        if (GLOBAL.StatGet("mrp") < n && !STORE._open) {
            GLOBAL.StatSet("mrp", n);
            GLOBAL._selectedBuilding = GLOBAL._bMap;
        }
    }

    public override Upgraded(): void {
        if (!MapRoomManager.instance.isInMapRoom3) {
            PLEASEWAIT.Show(KEYS.Get("wait_newworld"));
        }
        super.Upgraded();
    }

    public override Recycle(): void {
        if (MapRoomManager.instance.isInMapRoom2) {
            if (ALLIANCES._myAlliance !== null) {
                GLOBAL.Message(KEYS.Get("map_alliance_recycle", { v1: ALLIANCES._myAlliance.name }));
                return;
            }
            GLOBAL._mapOutpostIDs.length = 0;
            GLOBAL.Message(KEYS.Get("newmap_recycle1"), KEYS.Get("btn_recycle"), this.RecycleD.bind(this));
        } else {
            if (MapRoomManager.instance.isInMapRoom3 && !GLOBAL._aiDesignMode) {
                GLOBAL.Message(KEYS.Get("map_cannot_recycle_map_room3"));
                return;
            }
            GLOBAL.Message(KEYS.Get("newmap_recycle2"), KEYS.Get("btn_recycle"), this.RecycleD.bind(this));
        }
        GLOBAL.eventDispatcher.dispatchEvent(new BuildingEvent(BuildingEvent.ATTEMPT_RECYCLE, this));
    }

    private RecycleD(): void {
        if (GLOBAL.mode !== GLOBAL._loadmode) return;
        const data: any[] = [["version", 1]];
        if (MapRoomManager.instance.isInMapRoom3) {
            this.RecycleB();
            return;
        }
        new URLLoaderApi().load(GLOBAL._mapURL + "setmapversion", data, this.RecycleDSuccess.bind(this), this.RecycleDFail.bind(this));
    }

    private RecycleDSuccess(serverData: any): void {
        PLEASEWAIT.Hide();
        if (serverData.error === 0 && GLOBAL.mode === GLOBAL._loadmode) {
            if (!MapRoomManager.instance.isInMapRoom3) {
                GLOBAL.StatSet("mrl", 1, true);
            }
            GLOBAL._bMap = null;
            MapRoomManager.instance.mapRoomVersion = MapRoomManager.MAP_ROOM_VERSION_1;
            GLOBAL._baseURL = serverData.baseurl;
            BASE._baseID = 0;
            BASE._loadedFriendlyBaseID = 0;
            for (let i = 1; i < 5; i++) {
                BASE._GIP["r" + i].Set(0);
            }
            BASE._lastProcessedGIP = GLOBAL.Timestamp();
            GLOBAL._mapOutpost = [];
            if (serverData.basesaveid !== 1) {
                BASE._lastSaveID = serverData.basesaveid;
            }
            MapRoomManager.instance.BookmarksClear();
            this.RecycleB();
            if (this._lvl.Get() === 2) {
                GLOBAL.Message(KEYS.Get("newmap_return"));
            }
            GLOBAL.eventDispatcher.dispatchEvent(new BuildingEvent(BuildingEvent.DESTROY_MAPROOM, this));
        }
    }

    private RecycleDFail(event: IOErrorEvent): void {
        PLEASEWAIT.Hide();
        LOGGER.Log("err", "BUILDING11.Recycle HTTP");
    }

    public override Setup(building: any): void {
        super.Setup(building);
        if (this._lvl.Get() > 1) {
            ACHIEVEMENTS.Check("map2", 1);
        }
        if (this._countdownBuild.Get() === 0) {
            GLOBAL._bMap = this;
        }
    }
}
