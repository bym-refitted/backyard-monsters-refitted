package com.monsters.maproom3.data
{
   
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom3.MapRoom3;
   import com.monsters.maproom3.MapRoom3Cell;
   import com.monsters.maproom3.bookmarks.Bookmark;
   import com.monsters.maproom3.tiles.MapRoom3TileSetManager;
   import com.monsters.maproom_manager.IMapRoomCell;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public class MapRoom3Data
   {
      
      private static const CELL_LOAD_BUFFER_X:int = 30;
      
      private static const CELL_LOAD_BUFFER_Y:int = 30;
      
      private static const MAX_CELLS_TO_REQUEST:int = 500;
      
      private static const DEFAULT_CELL_EXPIRIY_TIME:int = 120000;
      
      private static const PLAYER_CELL_EXPIRIY_TIME:int = 30000;
      
      private static const CELL_CREATION_LOOP_TIMEOUT:int = 25;
      
      public static var DEBUG_WORLD_ID:int = 0;
       
      
      private var m_Width:int;
      
      private var m_Height:int;
      
      private var m_BorderCell:MapRoom3Cell;
      
      private var m_MapRoom3Cells:Vector.<MapRoom3Cell>;
      
      private var m_PlayerOwnedCells:Vector.<IMapRoomCell>;
      
      private var m_AllianceDataById:Dictionary;
      
      private var m_PendingCellDataRequest:Object = null;
      
      private var m_ExpiryTimeByCellId:Dictionary;
      
      private var m_CreatingMapData:Object = null;
      
      private var m_CellCreationIndexX:int = -1;
      
      private var m_CellCreationIndexY:int = -1;
      
      private var m_InitialCellData:Object = null;
      
      private var m_InitialPlayerCellData:Object = null;
      
      private var m_InitialCentrePoint:Point = null;
      
      public function MapRoom3Data(serverData:Object = null)
      {
         this.m_AllianceDataById = new Dictionary();
         this.m_ExpiryTimeByCellId = new Dictionary();
         super();
         if(serverData == null)
         {
            serverData = GenerateDefaultMapData();
         }
         this.m_Width = serverData.width;
         this.m_Height = serverData.height;
         this.m_BorderCell = new MapRoom3Cell(0,0,MapRoom3TileSetManager.BORDER_CELL_HEIGHT,EnumYardType.BORDER);
         var _loc2_:int = this.m_Width * this.m_Height;
         this.m_MapRoom3Cells = new Vector.<MapRoom3Cell>(_loc2_);
         this.m_PlayerOwnedCells = new Vector.<IMapRoomCell>();
         this.m_CreatingMapData = serverData;
         this.m_CellCreationIndexX = 0;
         this.m_CellCreationIndexY = 0;
         this.UpdateCellCreation();
      }
      
      public static function GetCellsRequestURL() : String
      {
         return MapRoomManager.instance.mapRoom3URL + "getcells";
      }
      
      private static function GenerateDefaultMapData() : Object
      {
         var _loc4_:int = 0;
         var _loc1_:int = 500;
         var _loc2_:Object = {};
         _loc2_.width = _loc1_;
         _loc2_.height = _loc1_;
         _loc2_.data = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc1_)
            {
               _loc2_.data.push({
                  "h":0,
                  "t":EnumYardType.EMPTY
               });
               _loc4_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function get mapWidth() : Number
      {
         return this.m_Width;
      }
      
      public function get mapHeight() : Number
      {
         return this.m_Height;
      }
      
      public function get playerOwnedCells() : Vector.<IMapRoomCell>
      {
         return this.m_PlayerOwnedCells;
      }
      
      public function get homeCell() : IMapRoomCell
      {
         return Boolean(this.m_PlayerOwnedCells) && Boolean(this.m_PlayerOwnedCells.length) ? this.m_PlayerOwnedCells[0] : null;
      }
      
      public function get allianceDataById() : Dictionary
      {
         return this.m_AllianceDataById;
      }
      
      public function get areAllCellsCreated() : Boolean
      {
         return this.m_CreatingMapData == null;
      }
      
      public function get isInitialCellDataLoaded() : Boolean
      {
         return this.m_InitialCellData != null && this.m_InitialPlayerCellData != null;
      }
      
      public function UpdateCellCreation() : void
      {
         var index:int = 0;
         var cellData:Object = null;
         if(this.areAllCellsCreated == true)
         {
            return;
         }
         // Timeout disabled - we have a loading screen that blocks interaction anyway
         // No need to artificially slow down cell creation with time-slicing
         // var timer:int = getTimer();
         this.m_CellCreationIndexX;
         while(this.m_CellCreationIndexX < this.m_Width)
         {
            this.m_CellCreationIndexY;
            while(this.m_CellCreationIndexY < this.m_Height)
            {
               index = this.GetCellIndex(this.m_CellCreationIndexX,this.m_CellCreationIndexY);
               cellData = this.m_CreatingMapData.data[index];
               this.m_MapRoom3Cells[index] = new MapRoom3Cell(this.m_CellCreationIndexX,this.m_CellCreationIndexY,cellData.h,cellData.t);
               // Timeout check disabled for faster loading
               // if(getTimer() - timer > CELL_CREATION_LOOP_TIMEOUT)
               // {
               //    return;
               // }
               ++this.m_CellCreationIndexY;
            }
            this.m_CellCreationIndexY = 0;
            ++this.m_CellCreationIndexX;
         }
         this.m_CreatingMapData = null;
      }
      
      public function LoadInitialCellData(param1:Point) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(this.areAllCellsCreated)
         {
            _loc3_ = this.m_MapRoom3Cells.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               this.m_MapRoom3Cells[_loc4_].ClearData();
               _loc4_++;
            }
            this.m_PlayerOwnedCells.length = 0;
         }
         this.m_InitialCentrePoint = param1;
         var _loc2_:Array = [];
         if(DEBUG_WORLD_ID)
         {
            _loc2_.push(["worldid",DEBUG_WORLD_ID]);
         }
         _loc2_.push(["token", LOGIN.token]);
         new URLLoaderApi().load(MapRoomManager.instance.mapRoom3URL + "initworldmap",_loc2_,this.OnInitialPlayerCellDataLoaded);
      }
      
      private function OnInitialPlayerCellDataLoaded(serverData:Object) : void
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         this.m_InitialPlayerCellData = serverData;
         if(this.m_InitialCentrePoint == null)
         {
            this.m_InitialCentrePoint = new Point(serverData.celldata[0].x,serverData.celldata[0].y);
         }
         var _loc2_:Array = [];
         var _loc3_:int = Math.max(0,this.m_InitialCentrePoint.x - CELL_LOAD_BUFFER_X);
         var _loc4_:int = Math.min(this.m_Width,this.m_InitialCentrePoint.x + CELL_LOAD_BUFFER_Y + 1);
         var _loc5_:int = Math.max(0,this.m_InitialCentrePoint.y - CELL_LOAD_BUFFER_Y);
         var _loc6_:int = Math.min(this.m_Height,this.m_InitialCentrePoint.y + CELL_LOAD_BUFFER_Y + 1);
         var _loc7_:int = _loc3_;
         while(_loc7_ < _loc4_)
         {
            _loc9_ = _loc5_;
            while(_loc9_ < _loc6_)
            {
               _loc10_ = MapRoomManager.instance.CalculateCellId(_loc7_,_loc9_);
               _loc2_.push(_loc10_);
               _loc9_++;
            }
            _loc7_++;
         }
         var _loc8_:Array = [["cellids",JSON.encode(_loc2_)]];
         if(DEBUG_WORLD_ID)
         {
            _loc8_.push(["worldid",DEBUG_WORLD_ID]);
         }
         _loc8_.push(["token", LOGIN.token]); // TODO: Why does the server still return cells if we don't send a token? verify auth should fail?
         new URLLoaderApi().load(GetCellsRequestURL(),_loc8_,this.OnInitialCellDataLoaded);
      }
      
      private function OnInitialCellDataLoaded(serverData:Object) : void
      {
         this.m_InitialCellData = serverData;
      }
      
      public function ParseInitialCellData() : void
      {
         if(this.m_InitialPlayerCellData != null)
         {
            this.ParseCellData(this.m_InitialPlayerCellData);
         }
         if(this.m_InitialCellData != null)
         {
            this.ParseCellData(this.m_InitialCellData);
         }
      }
      
      private function GetCellIndex(param1:int, param2:int) : int
      {
         return param1 < 0 || param2 < 0 || param1 >= this.m_Width || param2 >= this.m_Height ? -1 : param2 * this.m_Width + param1;
      }
      
      public function GetMapRoom3Cell(param1:int, param2:int) : MapRoom3Cell
      {
         var _loc3_:int = this.GetCellIndex(param1,param2);
         if(_loc3_ != -1 && this.m_MapRoom3Cells.length > _loc3_)
         {
            return this.m_MapRoom3Cells[_loc3_];
         }
         return this.m_BorderCell;
      }
      
      public function Clear() : void
      {
         this.m_PendingCellDataRequest = null;
         this.m_InitialCellData = null;
         this.m_InitialPlayerCellData = null;
         this.m_InitialCentrePoint = null;
         this.m_ExpiryTimeByCellId = new Dictionary();
         this.m_AllianceDataById = new Dictionary();
      }
      
      public function LoadBookmarkedCells(param1:Vector.<Bookmark>) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(this.m_PendingCellDataRequest != null)
         {
            return;
         }
         var _loc2_:Array = [];
         var _loc3_:int = getTimer();
         var _loc4_:int = int(param1.length);
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc7_ = param1[_loc5_].cellX;
            _loc8_ = param1[_loc5_].cellY;
            if(!(_loc7_ < 0 || _loc7_ >= this.m_Width || _loc8_ < 0 || _loc8_ >= this.m_Height))
            {
               _loc9_ = MapRoomManager.instance.CalculateCellId(_loc7_,_loc8_);
               if(!(this.m_ExpiryTimeByCellId[_loc9_] != null && (this.m_ExpiryTimeByCellId[_loc9_] == -1 || _loc3_ < this.m_ExpiryTimeByCellId[_loc9_])))
               {
                  this.m_ExpiryTimeByCellId[_loc9_] = -1;
                  _loc2_.push(_loc9_);
                  if(_loc2_.length >= MAX_CELLS_TO_REQUEST)
                  {
                     break;
                  }
               }
            }
            _loc5_++;
         }
         if(_loc2_.length == 0)
         {
            return;
         }
         var _loc6_:Array = [["cellids",JSON.encode(_loc2_)]];
         if(DEBUG_WORLD_ID)
         {
            _loc6_.push(["worldid",DEBUG_WORLD_ID]);
         }
         _loc6_.push(["token", LOGIN.token]);
         this.m_PendingCellDataRequest = _loc6_;
         new URLLoaderApi().load(GetCellsRequestURL(),_loc6_,this.OnCellDataLoaded);
      }
      
      public function UpdateCellLoading(param1:Point) : void
      {
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         if(this.m_PendingCellDataRequest != null)
         {
            return;
         }
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = -1;
         var _loc7_:int = param1.x;
         var _loc8_:int = param1.y;
         var _loc9_:int = getTimer();
         var _loc10_:int = CELL_LOAD_BUFFER_X * CELL_LOAD_BUFFER_Y * 4;
         var _loc11_:uint = 0;
         while(_loc11_ < _loc10_)
         {
            _loc13_ = _loc7_ + _loc3_;
            _loc14_ = _loc8_ + _loc4_;
            if(_loc3_ == _loc4_ || _loc3_ < 0 && _loc3_ == -_loc4_ || _loc3_ > 0 && _loc3_ == 1 - _loc4_)
            {
               _loc16_ = _loc5_;
               _loc5_ = -_loc6_;
               _loc6_ = _loc16_;
            }
            _loc3_ += _loc5_;
            _loc4_ += _loc6_;
            if(!(_loc13_ < 0 || _loc13_ >= this.m_Width || _loc14_ < 0 || _loc14_ >= this.m_Height))
            {
               _loc15_ = MapRoomManager.instance.CalculateCellId(_loc13_,_loc14_);
               if(!(this.m_ExpiryTimeByCellId[_loc15_] != null && (this.m_ExpiryTimeByCellId[_loc15_] == -1 || _loc9_ < this.m_ExpiryTimeByCellId[_loc15_])))
               {
                  this.m_ExpiryTimeByCellId[_loc15_] = -1;
                  _loc2_.push(_loc15_);
                  if(_loc2_.length >= MAX_CELLS_TO_REQUEST)
                  {
                     break;
                  }
               }
            }
            _loc11_++;
         }
         if(_loc2_.length == 0)
         {
            return;
         }
         var _loc12_:Array = [["cellids",JSON.encode(_loc2_)]];
         if(DEBUG_WORLD_ID)
         {
            _loc12_.push(["worldid",DEBUG_WORLD_ID]);
         }
         _loc12_.push(["token", LOGIN.token]);
         this.m_PendingCellDataRequest = _loc12_;
         new URLLoaderApi().load(GetCellsRequestURL(),_loc12_,this.OnCellDataLoaded);
      }
      
      private function OnCellDataLoaded(serverData:Object) : void
      {
         if(this.m_PendingCellDataRequest == null)
         {
            return;
         }
         this.m_PendingCellDataRequest = null;
         this.ParseCellData(serverData);
      }
      
      private function ParseCellData(serverData:Object) : void
      {
         var cellDataArray:Array = null;
         var cellData:Object = null;
         var mapRoomCell:MapRoom3Cell = null;
         var cellID:int = 0;
         cellDataArray = serverData.celldata;
         var timer:int = getTimer();
         var cellDataArrayLength:uint = cellDataArray.length;
         var index:int = 0;
         while(index < cellDataArrayLength)
         {
            cellData = cellDataArray[index];
            (mapRoomCell = this.GetMapRoom3Cell(cellData.x,cellData.y)).Setup(cellData);
            cellID = MapRoomManager.instance.CalculateCellId(mapRoomCell.cellX,mapRoomCell.cellY);
            this.m_ExpiryTimeByCellId[cellID] = timer + DEFAULT_CELL_EXPIRIY_TIME;
            if(mapRoomCell.isOwnedByPlayer)
            {
               this.m_ExpiryTimeByCellId[cellID] = timer + PLAYER_CELL_EXPIRIY_TIME;
               this.UpdateCellsInAttackRange(mapRoomCell);
               if(this.m_PlayerOwnedCells.indexOf(mapRoomCell) == -1)
               {
                  this.m_PlayerOwnedCells.push(mapRoomCell);
               }
            }
            if(mapRoomCell.cellType == EnumYardType.STRONGHOLD)
            {
               this.UpdateCellsInStrongholdRange(mapRoomCell);
            }
            index++;
         }
         if(serverData.alliancedata != null)
         {
            this.OnAllianceDataLoaded(serverData.alliancedata);
         }
         if(MapRoom3.mapRoom3Window != null)
         {
            MapRoom3.mapRoom3Window.Refresh();
         }
      }
      
      private function UpdateCellsInAttackRange(param1:MapRoom3Cell) : void
      {
         var _loc2_:MapRoom3Cell = null;
         var _loc3_:Vector.<MapRoom3Cell> = null;
         _loc3_ = this.GetHexCellsInRange(param1,param1.attackRange);
         var _loc4_:uint = _loc3_.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = _loc3_[_loc5_];
            param1.AddCellInAttackRange(_loc2_);
            _loc2_.AddInAttackRangeOf(param1);
            _loc5_++;
         }
      }
      
      private function UpdateCellsInStrongholdRange(param1:MapRoom3Cell) : void
      {
         var _loc2_:MapRoom3Cell = null;
         var _loc3_:Vector.<MapRoom3Cell> = null;
         _loc3_ = this.GetHexCellsInRange(param1,param1.attackRange);
         var _loc4_:uint = _loc3_.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = _loc3_[_loc5_];
            _loc2_.AddInRangeOfStronghold(param1);
            _loc5_++;
         }
      }
      
      private function OnAllianceDataLoaded(param1:Array) : void
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc2_:uint = param1.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc5_ = int((_loc4_ = param1[_loc3_]).alliance_id);
            if(this.m_AllianceDataById[_loc5_] != null)
            {
               this.m_AllianceDataById[_loc5_].Map(_loc4_);
            }
            else
            {
               this.m_AllianceDataById[_loc5_] = new MapRoom3AllianceData(_loc4_);
            }
            _loc3_++;
         }
      }
      
      public function GetHexCellsInRange(param1:MapRoom3Cell, param2:int) : Vector.<MapRoom3Cell>
      {
         var _loc3_:MapRoom3Cell = null;
         var _loc12_:int = 0;
         var _loc4_:Vector.<MapRoom3Cell> = new Vector.<MapRoom3Cell>();
         var _loc5_:int = param1.cellX;
         var _loc6_:int = param1.cellY;
         var _loc7_:int;
         var _loc8_:int = (_loc7_ = _loc5_ - (!!(_loc6_ % 2) ? Math.floor(Number(param2) * 0.5) : Math.ceil(Number(param2) * 0.5))) + param2;
         var _loc9_:int = _loc6_ - param2;
         var _loc10_:int = _loc6_ + param2;
         var _loc11_:int = _loc9_;
         while(_loc11_ <= _loc10_)
         {
            _loc12_ = _loc7_;
            while(_loc12_ <= _loc8_)
            {
               _loc3_ = this.GetMapRoom3Cell(_loc12_,_loc11_);
               if(_loc3_ != null && _loc3_ != this.m_BorderCell)
               {
                  _loc4_.push(_loc3_);
               }
               _loc12_++;
            }
            if(_loc11_ < _loc6_)
            {
               if(_loc11_ % 2)
               {
                  _loc8_++;
               }
               else
               {
                  _loc7_--;
               }
            }
            else if(_loc11_ % 2)
            {
               _loc7_++;
            }
            else
            {
               _loc8_--;
            }
            _loc11_++;
         }
         return _loc4_;
      }
   }
}
