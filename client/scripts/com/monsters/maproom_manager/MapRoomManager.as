package com.monsters.maproom_manager
{
   import com.monsters.maproom3.MapRoom3;
   import com.monsters.maproom3.MapRoom3Cell;
   import com.monsters.maproom_advanced.MapRoom;
   import com.monsters.monsters.components.CModifiableProperty;
   import config.singletonlock.SingletonLock;
   import flash.events.IOErrorEvent;
   import flash.utils.Dictionary;
   
   public class MapRoomManager
   {
      
      private static var s_Instance:MapRoomManager = null;
      
      public static const MAP_ROOM_VERSION_1:int = 1;
      
      public static const MAP_ROOM_VERSION_2:int = 2;
      
      public static const MAP_ROOM_VERSION_3:int = 3;
       
      
      private var m_CurrentMapRoom:IMapRoom;
      
      private var m_MapRoom3URL:String;
      
      private var m_MapRoomVersion:int = 1;
      
      private var m_AttackCostMultiplier:CModifiableProperty;
      
      public function MapRoomManager(param1:SingletonLock)
      {
         this.m_AttackCostMultiplier = new CModifiableProperty(Number.MAX_VALUE,Number.MIN_VALUE,1);
         super();
      }
      
      public static function get instance() : MapRoomManager
      {
         return s_Instance = s_Instance || new MapRoomManager(new SingletonLock());
      }
      
      public function get currentMapRoom() : IMapRoom
      {
         return this.m_CurrentMapRoom;
      }
      
      public function get mapRoom3URL() : String
      {
         return this.m_MapRoom3URL;
      }
      
      public function set mapRoom3URL(param1:String) : void
      {
         this.m_MapRoom3URL = param1;
      }
      
      public function get attackCostMultiplier() : CModifiableProperty
      {
         return this.m_AttackCostMultiplier;
      }
      
      public function get isInMapRoom2() : Boolean
      {
         return this.m_MapRoomVersion == MAP_ROOM_VERSION_2;
      }
      
      public function get isInMapRoom3() : Boolean
      {
         return this.m_MapRoomVersion == MAP_ROOM_VERSION_3;
      }
      
      public function get isInMapRoom2or3() : Boolean
      {
         return this.isInMapRoom2 || this.isInMapRoom3;
      }
      
      public function set bookmarkData(param1:Object) : void
      {
         this.m_CurrentMapRoom.bookmarkData = param1;
      }
      
      public function set mapWidth(param1:int) : void
      {
         this.m_CurrentMapRoom.mapWidth = param1;
      }
      
      public function set mapHeight(param1:int) : void
      {
         this.m_CurrentMapRoom.mapHeight = param1;
      }
      
      public function get worldID() : int
      {
         return this.m_CurrentMapRoom.worldID;
      }
      
      public function set worldID(param1:int) : void
      {
         this.m_CurrentMapRoom.worldID = param1;
      }
      
      public function get isOpen() : Boolean
      {
         return this.m_CurrentMapRoom.isOpen;
      }
      
      public function get flingerInRange() : Boolean
      {
         return this.m_CurrentMapRoom.flingerInRange;
      }
      
      public function get viewOnly() : Boolean
      {
         return this.m_CurrentMapRoom.viewOnly;
      }
      
      public function get playerOwnedCells() : Vector.<IMapRoomCell>
      {
         return this.m_CurrentMapRoom.playerOwnedCells;
      }
      
      public function get allianceDataById() : Dictionary
      {
         return this.m_CurrentMapRoom.allianceDataById;
      }
      
      public function init(onMapRoom3:Boolean, mapRoom3HeaderURL:String) : void
      {
         this.m_CurrentMapRoom = onMapRoom3 ? new MapRoom3(mapRoom3HeaderURL) : new MapRoom();
         if(onMapRoom3)
         {
            this.mapRoomVersion = MAP_ROOM_VERSION_3;
         }
      }
      
      public function OnMapRoom3RelocationSuccessful(param1:String) : void
      {
         this.BookmarksClear();
         GLOBAL._currentCell = null;
         this.m_CurrentMapRoom = new MapRoom3(param1);
      }
      
      public function set mapRoomVersion(param1:int) : void
      {
         if(param1 != MAP_ROOM_VERSION_1 && param1 != MAP_ROOM_VERSION_2 && param1 != MAP_ROOM_VERSION_3)
         {
            return;
         }
         if(param1 == MAP_ROOM_VERSION_1 && this.m_CurrentMapRoom is MapRoom3)
         {
            param1 = MAP_ROOM_VERSION_3;
         }
         this.m_MapRoomVersion = param1;
      }
      
      public function get mapRoomVersion() : int
      {
         return this.m_MapRoomVersion;
      }
      
      public function SetupAndShow() : void
      {
         this.m_CurrentMapRoom.Setup();
         this.Show();
      }
      
      public function Show() : void
      {
         if(GLOBAL.mode === "build")
         {
            GLOBAL.m_mapRoomFunctional = true;
         }
         if(WMATTACK._inProgress || Boolean(MONSTERBAITER._attacking))
         {
            return;
         }
         if(!GLOBAL._flags.discordOldEnough) 
         {
            GLOBAL.Message(KEYS.Get("newmap_discord_age"));
            return;
         }
         if(GLOBAL._flags.maproom2 != 1)
         {
            GLOBAL.Message(KEYS.Get("map_msg_disabled"));
            return;
         }
         if((!BASE.isMainYard || GLOBAL._bMap && GLOBAL._bMap._canFunction || GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD) && (GLOBAL.mode == "help" || !this.isOpen))
         {
            PLEASEWAIT.Show(KEYS.Get("newmap_opening"));
            if(this.isOpen)
            {
               this.Hide();
            }
            GLOBAL._showMapWaiting = 1;
            return;
         }
         if(!GLOBAL._bMap)
         {
            GLOBAL.Message(KEYS.Get("map_msg_notbuilt"));
            return;
         }
         if(!GLOBAL._bMap._canFunction)
         {
            GLOBAL.Message(KEYS.Get("map_msg_damaged"));
            return;
         }
      }
      
      public function ReadyToShow() : Boolean
      {
         return this.m_CurrentMapRoom.ReadyToShow();
      }
      
      public function ShowDelayed(param1:Boolean = false) : void
      {
         this.m_CurrentMapRoom.ShowDelayed(param1);
      }
      
      public function Hide() : void
      {
         this.m_CurrentMapRoom.Hide();
      }
      
      public function Tick() : void
      {
         this.m_CurrentMapRoom.Tick();
      }
      
      public function TickFast() : void
      {
         if(this.m_CurrentMapRoom != null)
         {
            this.m_CurrentMapRoom.TickFast();
         }
      }
      
      public function BookmarksClear() : void
      {
         this.m_CurrentMapRoom.BookmarksClear();
      }
      
      public function ResizeHandler() : void
      {
         this.m_CurrentMapRoom.ResizeHandler();
      }
      
      public function FindCell(param1:int, param2:int) : IMapRoomCell
      {
         return this.m_CurrentMapRoom.FindCell(param1,param2);
      }
      
      public function LoadCell(param1:int, param2:int, param3:Boolean = false) : void
      {
         this.m_CurrentMapRoom.LoadCell(param1,param2,param3);
      }
      
      public function CalculateCellId(param1:int, param2:int) : int
      {
         return this.m_CurrentMapRoom.CalculateCellId(param1,param2);
      }
      
      public function GetHexCellsInRange(param1:int, param2:int, param3:int) : Vector.<MapRoom3Cell>
      {
         var _loc4_:MapRoom3;
         return !!(_loc4_ = this.m_CurrentMapRoom as MapRoom3) ? _loc4_.GetHexCellsInRange(param1,param2,param3) : new Vector.<MapRoom3Cell>();
      }
      
      public function GetClosestCell(param1:int, param2:int, param3:int) : MapRoom3Cell
      {
         var _loc4_:MapRoom3;
         return !!(_loc4_ = this.m_CurrentMapRoom as MapRoom3) ? _loc4_.GetClosestCell(param1,param2,param3) : null;
      }
      
      public function UpgradeToMapRoom3() : void
      {
         GLOBAL._save = false;
         PLEASEWAIT.Show(KEYS.Get("upgrading_to_map_room3"));
         new URLLoaderApi().load(this.m_MapRoom3URL + "setmapversion",[["version",3]],this.MapRoom3UpgradeSuccess,this.MapRoom3UpgradeFail);
      }
      
      private function MapRoom3UpgradeSuccess(param1:Object) : void
      {
         if(param1.error == 0)
         {
            this.init(true,GLOBAL._apiURL + "bm/getnewmap");
            this.m_CurrentMapRoom.Setup();

            PLEASEWAIT.Show(KEYS.Get("nwm_loading"));
            GLOBAL._showMapWaiting = 1;

            // Comment: Old implementation forced users to reload their browser
            // PLEASEWAIT.Show(KEYS.Get("upgraded_to_map_room3_refresh"));
            // GLOBAL.CallJS("cc.reloadParent");
         }
         else
         {
            PLEASEWAIT.Hide();
            LOGGER.Log("err",param1.error);
            GLOBAL.ErrorMessage("Error upgrading to Map Room 3");
         }
      }
      
      private function MapRoom3UpgradeFail(param1:IOErrorEvent) : void
      {
         PLEASEWAIT.Hide();
         LOGGER.Log("err","HTTP error upgrading to Map Room 3");
         GLOBAL.ErrorMessage("HTTP error upgrading to Map Room 3");
      }
      
      public function DowngradeFromMapRoom3() : void
      {
      }
      
      public function CheckForAndForceUpgradeFromMapRoom1() : void
      {
         if(this.isInMapRoom3 == true)
         {
            return;
         }
         if(this.currentMapRoom is MapRoom3)
         {
            return;
         }
         if(BASE.isInfernoMainYardOrOutpost == true)
         {
            return;
         }
         if(INFERNO_DESCENT_POPUPS.isInDescent() == true)
         {
            return;
         }
         if(PLEASEWAIT._mc != null)
         {
            return;
         }
         if(MapRoomManager.instance.isInMapRoom2 == false)
         {
            // Map Room 3 popup disabled
            // MapRoom3ConfirmMigrationPopup.instance.Show(true);
         }
      }
   }
}
