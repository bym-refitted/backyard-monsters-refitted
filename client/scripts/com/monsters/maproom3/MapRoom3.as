package com.monsters.maproom3
{
   import com.monsters.mailbox.FriendPicker;
   import com.monsters.maproom3.bookmarks.BookmarksManager;
   import com.monsters.maproom3.data.MapRoom3Data;
   import com.monsters.maproom3.tiles.MapRoom3TileSetManager;
   import com.monsters.maproom_manager.IMapRoom;
   import com.monsters.maproom_manager.IMapRoomCell;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class MapRoom3 implements IMapRoom
   {
      private static var m_MapRoom3Window:MapRoom3Window;
      
      private static var m_MapRoom3WindowHUD:MapRoom3WindowHUD;
      
      private var m_HeightMapLoader:URLLoader;
      
      private var m_MapRoom3Data:MapRoom3Data;
      
      private var m_CurrentBookmarkData:Object = {};
      
      private var m_LastCenterPoint:Point = null;
      
      private var m_WorldID:int = 0;
      
      private var m_Open:Boolean = false;
      
      public function MapRoom3(headerUrl:String)
      {
         super();
         if(headerUrl != null)
         {
            this.m_HeightMapLoader = new URLLoader(new URLRequest(headerUrl));
            this.m_HeightMapLoader.addEventListener(Event.COMPLETE,this.OnHeightMapLoaded,false,0,true);
            this.m_HeightMapLoader.addEventListener(IOErrorEvent.IO_ERROR,this.OnHeightMapLoadFailed,false,0,true);
            this.m_HeightMapLoader.addEventListener(IOErrorEvent.NETWORK_ERROR,this.OnHeightMapLoadFailed,false,0,true);
            this.m_HeightMapLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.OnHeightMapLoadFailed,false,0,true);
         }
      }
      
      public static function get mapRoom3Window() : MapRoom3Window
      {
         return m_MapRoom3Window;
      }
      
      public static function get mapRoom3WindowHUD() : MapRoom3WindowHUD
      {
         return m_MapRoom3WindowHUD;
      }
      
      public function set bookmarkData(param1:Object) : void
      {
         this.m_CurrentBookmarkData = param1;
      }
      
      public function get playerOwnedCells() : Vector.<IMapRoomCell>
      {
         return !!this.m_MapRoom3Data ? this.m_MapRoom3Data.playerOwnedCells : null;
      }
      
      public function get allianceDataById() : Dictionary
      {
         return !!this.m_MapRoom3Data ? this.m_MapRoom3Data.allianceDataById : null;
      }
      
      public function get worldID() : int
      {
         return this.m_WorldID;
      }
      
      public function set worldID(param1:int) : void
      {
         this.m_WorldID = param1;
      }
      
      public function get isOpen() : Boolean
      {
         return this.m_Open;
      }
      
      public function set mapWidth(param1:int) : void
      {
      }
      
      public function set mapHeight(param1:int) : void
      {
      }
      
      public function get flingerInRange() : Boolean
      {
         return true;
      }
      
      public function get viewOnly() : Boolean
      {
         return false;
      }
      
      public function OnHeightMapLoaded(param1:Event) : void
      {
         var serverData:Object = JSON.decode(this.m_HeightMapLoader.data);
         this.m_MapRoom3Data = new MapRoom3Data(serverData);
      }
      
      public function OnHeightMapLoadFailed(param1:Event) : void
      {
         this.m_MapRoom3Data = new MapRoom3Data(null);
      }
      
      public function Setup() : void
      {
         this.m_MapRoom3Data.LoadInitialCellData(this.m_LastCenterPoint);
         FriendPicker.ClearContacts();
      }
      
      public function ReadyToShow() : Boolean
      {
         return this.m_MapRoom3Data && this.m_MapRoom3Data.areAllCellsCreated && this.m_MapRoom3Data.isInitialCellDataLoaded && MapRoom3AssetCache.instance.areAssetsLoaded && MapRoom3TileSetManager.instance.isCurrentTileSetAndBackgroundLoaded;
      }
      
      public function ShowDelayed(param1:Boolean = false) : void
      {
         if(GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD)
         {
            GLOBAL.m_mapRoomFunctional = true;
         }
         if(this.m_Open == true)
         {
            return;
         }
         this.m_Open = true;
         BASE.Cleanup();
         this.m_MapRoom3Data.ParseInitialCellData();
         BookmarksManager.instance.Setup(this.m_CurrentBookmarkData,this.m_MapRoom3Data);
         this.m_MapRoom3Data.LoadBookmarkedCells(BookmarksManager.instance.GetBookmarksOfType(BookmarksManager.TYPE_CUSTOM));
         m_MapRoom3Window = new MapRoom3Window(this.m_MapRoom3Data);
         m_MapRoom3WindowHUD = new MapRoom3WindowHUD();
         GLOBAL._layerUI.addChild(m_MapRoom3Window);
         GLOBAL._layerUI.addChild(m_MapRoom3WindowHUD);
         UI2.SetupHUD();
         if(GLOBAL._currentCell == null)
         {
            GLOBAL._currentCell = this.m_MapRoom3Data.homeCell;
         }
         if(this.m_LastCenterPoint == null)
         {
            this.m_LastCenterPoint = new Point(this.m_MapRoom3Data.homeCell.cellX,this.m_MapRoom3Data.homeCell.cellY);
         }
         m_MapRoom3Window.Init(this.m_LastCenterPoint);
      }
      
      public function Hide() : void
      {
         this.m_Open = false;
         this.m_LastCenterPoint = m_MapRoom3Window.centerPoint;
         BookmarksManager.instance.Cleanup();
         this.Cleanup();
      }
      
      private function Cleanup() : void
      {
         if(m_MapRoom3WindowHUD != null)
         {
            m_MapRoom3WindowHUD.Clear();
            if(m_MapRoom3WindowHUD.parent != null)
            {
               m_MapRoom3WindowHUD.parent.removeChild(m_MapRoom3WindowHUD);
            }
            m_MapRoom3WindowHUD = null;
         }
         if(m_MapRoom3Window != null)
         {
            m_MapRoom3Window.Clear();
            if(m_MapRoom3Window.parent != null)
            {
               m_MapRoom3Window.parent.removeChild(m_MapRoom3Window);
            }
            m_MapRoom3Window = null;
         }
         if(this.m_MapRoom3Data != null)
         {
            this.m_MapRoom3Data.Clear();
         }
      }
      
      public function FindCell(param1:int, param2:int) : IMapRoomCell
      {
         return !!this.m_MapRoom3Data ? this.m_MapRoom3Data.GetMapRoom3Cell(param1,param2) : null;
      }
      
      public function LoadCell(param1:int, param2:int, param3:Boolean = false) : void
      {
      }
      
      public function CalculateCellId(param1:int, param2:int) : int
      {
         return param2 * this.m_MapRoom3Data.mapWidth + param1 + 1;
      }
      
      public function GetHexCellsInRange(param1:int, param2:int, param3:int) : Vector.<MapRoom3Cell>
      {
         if(this.m_MapRoom3Data == null)
         {
            return new Vector.<MapRoom3Cell>();
         }
         var _loc4_:MapRoom3Cell = this.m_MapRoom3Data.GetMapRoom3Cell(param1,param2);
         if(_loc4_ == null)
         {
            return new Vector.<MapRoom3Cell>();
         }
         return this.m_MapRoom3Data.GetHexCellsInRange(_loc4_,param3);
      }
      
      public function GetClosestCell(param1:int, param2:int, param3:int) : MapRoom3Cell
      {
         var _loc5_:Vector.<MapRoom3Cell> = null;
         var _loc6_:int = 0;
         var _loc9_:MapRoom3Cell = null;
         var _loc10_:MapRoom3Cell = null;
         if(this.m_MapRoom3Data == null)
         {
            return null;
         }
         var _loc4_:MapRoom3Cell = this.m_MapRoom3Data.GetMapRoom3Cell(param1,param2);
         if(_loc4_ == null)
         {
            return null;
         }
         _loc5_ = this.m_MapRoom3Data.GetHexCellsInRange(_loc4_,param3);
         var _loc8_:int = int.MAX_VALUE;
         var _loc11_:int = int(_loc5_.length);
         _loc6_ = _loc11_ - 1;
         while(_loc6_ >= 0)
         {
            _loc9_ = _loc5_[_loc6_];
            if(MapRoom3Cell.GetHexDistanceBetween(_loc9_,_loc10_) < _loc8_)
            {
               _loc8_ = 0;
               _loc10_ = _loc9_;
            }
            _loc6_--;
         }
         return _loc10_;
      }
      
      public function Tick() : void
      {
         if(Boolean(this.m_MapRoom3Data) && Boolean(m_MapRoom3Window))
         {
            this.m_MapRoom3Data.UpdateCellLoading(m_MapRoom3Window.centerPointForLoading);
         }
      }
      
      public function TickFast() : void
      {
         if(Boolean(this.m_MapRoom3Data) && !this.m_MapRoom3Data.areAllCellsCreated)
         {
            this.m_MapRoom3Data.UpdateCellCreation();
            return;
         }
         if(m_MapRoom3Window)
         {
            m_MapRoom3Window.TickFast();
         }
      }
      
      public function ResizeHandler() : void
      {
         if(m_MapRoom3Window)
         {
            m_MapRoom3Window.Resize();
         }
         if(m_MapRoom3WindowHUD)
         {
            m_MapRoom3WindowHUD.Resize();
         }
      }
      
      public function BookmarksClear() : void
      {
         BookmarksManager.instance.Cleanup();
         BookmarksManager.instance.SaveBookmarks();
      }
   }
}
