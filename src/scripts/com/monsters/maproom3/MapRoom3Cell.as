package com.monsters.maproom3
{
   import com.cc.tests.ABTest;
   import com.monsters.debug.Console;
   import com.monsters.enums.EnumBaseRelationship;
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom3.data.MapRoom3AllianceData;
   import com.monsters.maproom3.data.MapRoom3CellData;
   import com.monsters.maproom3.data.MapRoom3Data;
   import com.monsters.maproom3.tiles.MapRoom3TileSetManager;
   import com.monsters.maproom_manager.IMapRoomCell;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.utils.Dictionary;
   
   public class MapRoom3Cell implements IMapRoomCell
   {
      
      private static const ATTACK_COST_MULTIPLIERS_BY_TOWN_HALL_LEVEL:Array = [0,100,200,400,800,1600,4000,10000,25000,75000,225000];
      
      private static const MAX_BITS_CELL_X:uint = 9;
      
      private static const MAX_BITS_CELL_Y:uint = 9;
      
      private static const MAX_BITS_CELL_HEIGHT:uint = 7;
      
      private static const MAX_BITS_CELL_TYPE:uint = 7;
      
      private static const MAX_VALUE_CELL_X:uint = Math.pow(2,MAX_BITS_CELL_X) - 1;
      
      private static const MAX_VALUE_CELL_Y:uint = Math.pow(2,MAX_BITS_CELL_Y) - 1;
      
      private static const MAX_VALUE_CELL_HEIGHT:uint = Math.pow(2,MAX_BITS_CELL_HEIGHT) - 1;
      
      private static const MAX_VALUE_CELL_TYPE:uint = Math.pow(2,MAX_BITS_CELL_TYPE) - 1;
      
      private static const BIT_SHIFT_CELL_X:uint = 0;
      
      private static const BIT_SHIFT_CELL_Y:uint = BIT_SHIFT_CELL_X + MAX_BITS_CELL_X;
      
      private static const BIT_SHIFT_CELL_HEIGHT:uint = BIT_SHIFT_CELL_Y + MAX_BITS_CELL_Y;
      
      private static const BIT_SHIFT_CELL_TYPE:uint = BIT_SHIFT_CELL_HEIGHT + MAX_BITS_CELL_HEIGHT;
      
      private static var s_CellsInAttackRange:Dictionary = new Dictionary();
      
      private static var s_InAttackRangeOfCells:Dictionary = new Dictionary();
      
      private static var s_InRangeOfStrongholds:Dictionary = new Dictionary();
      
      private static var s_CurrentBuffEffectFrames:Dictionary = new Dictionary();
       
      
      private var m_CellData:MapRoom3CellData = null;
      
      private var m_CellGraphic:com.monsters.maproom3.MapRoom3CellGraphic = null;
      
      private var m_CellHeaderBitField:uint = 0;
      
      public function MapRoom3Cell(param1:int, param2:int, param3:int, param4:int)
      {
         super();
         if(param4 == -1)
         {
            param4 = int(EnumYardType.EMPTY);
         }
         this.m_CellHeaderBitField |= (param1 & MAX_VALUE_CELL_X) << BIT_SHIFT_CELL_X;
         this.m_CellHeaderBitField |= (param2 & MAX_VALUE_CELL_Y) << BIT_SHIFT_CELL_Y;
         this.m_CellHeaderBitField |= (param3 & MAX_VALUE_CELL_HEIGHT) << BIT_SHIFT_CELL_HEIGHT;
         this.m_CellHeaderBitField |= (param4 & MAX_VALUE_CELL_TYPE) << BIT_SHIFT_CELL_TYPE;
      }
      
      public static function GetHexDistanceBetween(param1:IMapRoomCell, param2:IMapRoomCell) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc3_ = param1.cellY;
         _loc4_ = param2.cellY;
         _loc5_ = param1.cellX - Math.floor(_loc3_ * 0.5);
         var _loc7_:int = (_loc6_ = param2.cellX - Math.floor(_loc4_ * 0.5)) - _loc5_;
         var _loc8_:int = _loc4_ - _loc3_;
         if(_loc7_ * _loc8_ >= 0)
         {
            return Math.abs(_loc7_ + _loc8_);
         }
         return Math.max(Math.abs(_loc7_),Math.abs(_loc8_));
      }
      
      public function get cellX() : int
      {
         return this.m_CellHeaderBitField >> BIT_SHIFT_CELL_X & MAX_VALUE_CELL_X;
      }
      
      public function get cellY() : int
      {
         return this.m_CellHeaderBitField >> BIT_SHIFT_CELL_Y & MAX_VALUE_CELL_Y;
      }
      
      public function get cellHeight() : int
      {
         return this.m_CellHeaderBitField >> BIT_SHIFT_CELL_HEIGHT & MAX_VALUE_CELL_HEIGHT;
      }
      
      public function get cellType() : int
      {
         return this.m_CellHeaderBitField >> BIT_SHIFT_CELL_TYPE & MAX_VALUE_CELL_TYPE;
      }
      
      public function get baseType() : int
      {
         return this.cellType;
      }
      
      public function get cellGraphic() : com.monsters.maproom3.MapRoom3CellGraphic
      {
         return this.m_CellGraphic;
      }
      
      public function set cellGraphic(param1:com.monsters.maproom3.MapRoom3CellGraphic) : void
      {
         this.m_CellGraphic = param1;
      }
      
      public function get name() : String
      {
         return !!this.m_CellData ? this.m_CellData.name : "";
      }
      
      public function get facebookID() : String
      {
         return !!this.m_CellData ? this.m_CellData.facebookID : "";
      }
      
      public function get baseID() : Number
      {
         return !!this.m_CellData ? this.m_CellData.baseID : 0;
      }
      
      public function get userID() : int
      {
         return !!this.m_CellData ? this.m_CellData.userID : 0;
      }
      
      public function get allianceID() : int
      {
         return !!this.m_CellData ? this.m_CellData.allianceID : 0;
      }
      
      public function get wildMonsterTribeId() : int
      {
         return !!this.m_CellData ? this.m_CellData.wildMonsterTribeId : 0;
      }
      
      public function get relationship() : int
      {
         return !!this.m_CellData ? this.m_CellData.relationship : EnumBaseRelationship.k_RELATIONSHIP_NONE;
      }
      
      public function get baseLevel() : int
      {
         return !!this.m_CellData ? this.m_CellData.baseLevel : 0;
      }
      
      public function get playerLevel() : int
      {
         return !!this.m_CellData ? this.m_CellData.playerLevel : 0;
      }
      
      public function get damage() : int
      {
         return !!this.m_CellData ? this.m_CellData.damage : 0;
      }
      
      public function get damagePercentage() : Number
      {
         return Number(this.damage) / 100;
      }
      
      public function get attackRange() : int
      {
         return !!this.m_CellData ? this.m_CellData.attackRange : 0;
      }
      
      public function get attackCost() : Array
      {
         return this.CalculateAttackCosts();
      }
      
      public function get containsValidBase() : Boolean
      {
         return this.baseID != 0;
      }
      
      public function get hasDamageProtection() : Boolean
      {
         return !!this.m_CellData ? this.m_CellData.hasDamageProtection : false;
      }
      
      public function get hasTruce() : Boolean
      {
         return !!this.m_CellData ? this.m_CellData.hasTruce : false;
      }
      
      public function get isBorder() : Boolean
      {
         return this.cellType == EnumYardType.BORDER;
      }
      
      public function get isBlocked() : Boolean
      {
         return this.isBorder || this.cellHeight >= MapRoom3TileSetManager.BLOCKED_CELL_STARTING_HEIGHT;
      }
      
      public function get isDataLoaded() : Boolean
      {
         return this.m_CellData != null;
      }
      
      public function get isDestroyed() : Boolean
      {
         return !!this.m_CellData ? this.m_CellData.isDestroyed : false;
      }
      
      public function get isLocked() : Boolean
      {
         return !!this.m_CellData ? this.m_CellData.isLocked : false;
      }
      
      public function get isInvisible() : Boolean
      {
         return !!this.m_CellData ? this.m_CellData.isInvisible && !this.isOwnedByPlayer : false;
      }
      
      public function get isOwnedByPlayer() : Boolean
      {
         return this.userID == LOGIN._playerID;
      }
      
      public function get isOwnedByFacebookFriend() : Boolean
      {
         return !!this.m_CellData ? this.m_CellData.isFacebookFriend : false;
      }
      
      public function get isOwnedByWildMonster() : Boolean
      {
         return this.userID == 0 && this.baseID != 0;
      }
      
      public function get isRandomWildMonsterBase() : Boolean
      {
         return this.isOwnedByWildMonster && this.cellType == EnumYardType.EMPTY;
      }
      
      public function Setup(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1.hasOwnProperty("i"))
         {
            _loc2_ = int(param1.i);
            this.m_CellHeaderBitField &= ~(MAX_VALUE_CELL_HEIGHT << BIT_SHIFT_CELL_HEIGHT);
            this.m_CellHeaderBitField |= (_loc2_ & MAX_VALUE_CELL_HEIGHT) << BIT_SHIFT_CELL_HEIGHT;
         }
         if(param1.hasOwnProperty("b"))
         {
            _loc3_ = int(param1.b);
            if(_loc3_ == -1)
            {
               _loc3_ = int(EnumYardType.EMPTY);
            }
            this.m_CellHeaderBitField &= ~(MAX_VALUE_CELL_TYPE << BIT_SHIFT_CELL_TYPE);
            this.m_CellHeaderBitField |= (_loc3_ & MAX_VALUE_CELL_TYPE) << BIT_SHIFT_CELL_TYPE;
         }
         if(this.m_CellData != null)
         {
            this.m_CellData.Map(param1);
         }
         else
         {
            this.m_CellData = new MapRoom3CellData(param1);
         }
      }
      
      public function ClearData() : void
      {
         var _loc1_:Number = MapRoomManager.instance.CalculateCellId(this.cellX,this.cellY);
         if(s_CellsInAttackRange[_loc1_] != null)
         {
            s_CellsInAttackRange[_loc1_].length = 0;
         }
         if(s_InAttackRangeOfCells[_loc1_] != null)
         {
            s_InAttackRangeOfCells[_loc1_].length = 0;
         }
         if(s_InRangeOfStrongholds[_loc1_] != null)
         {
            s_InRangeOfStrongholds[_loc1_].length = 0;
         }
         delete s_CurrentBuffEffectFrames[_loc1_];
         this.m_CellData = null;
      }
      
      public function AddCellInAttackRange(param1:MapRoom3Cell) : void
      {
         var _loc2_:Number = MapRoomManager.instance.CalculateCellId(this.cellX,this.cellY);
         var _loc3_:Vector.<MapRoom3Cell> = s_CellsInAttackRange[_loc2_] = s_CellsInAttackRange[_loc2_] || new Vector.<MapRoom3Cell>();
         if(_loc3_.indexOf(param1) == -1)
         {
            _loc3_.push(param1);
         }
      }
      
      public function AddInAttackRangeOf(param1:MapRoom3Cell) : void
      {
         var _loc2_:Number = MapRoomManager.instance.CalculateCellId(this.cellX,this.cellY);
         var _loc3_:Vector.<MapRoom3Cell> = s_InAttackRangeOfCells[_loc2_] = s_InAttackRangeOfCells[_loc2_] || new Vector.<MapRoom3Cell>();
         if(_loc3_.indexOf(param1) == -1)
         {
            _loc3_.push(param1);
         }
      }
      
      public function AddInRangeOfStronghold(param1:MapRoom3Cell) : void
      {
         var _loc2_:Number = MapRoomManager.instance.CalculateCellId(this.cellX,this.cellY);
         var _loc3_:Vector.<MapRoom3Cell> = s_InRangeOfStrongholds[_loc2_] = s_InRangeOfStrongholds[_loc2_] || new Vector.<MapRoom3Cell>();
         if(_loc3_.indexOf(param1) == -1)
         {
            _loc3_.push(param1);
         }
      }
      
      public function get hasCellsInAttackRange() : Boolean
      {
         var _loc1_:Number = MapRoomManager.instance.CalculateCellId(this.cellX,this.cellY);
         return s_CellsInAttackRange[_loc1_] != null && s_CellsInAttackRange[_loc1_].length > 0;
      }
      
      public function get cellsInAttackRange() : Vector.<MapRoom3Cell>
      {
         var _loc1_:Number = MapRoomManager.instance.CalculateCellId(this.cellX,this.cellY);
         return s_CellsInAttackRange[_loc1_];
      }
      
      public function get isInAttackRange() : Boolean
      {
         var _loc1_:Number = MapRoomManager.instance.CalculateCellId(this.cellX,this.cellY);
         return s_InAttackRangeOfCells[_loc1_] != null && s_InAttackRangeOfCells[_loc1_].length > 0;
      }
      
      public function get inAttackRangeOfCells() : Vector.<MapRoom3Cell>
      {
         var _loc1_:Number = MapRoomManager.instance.CalculateCellId(this.cellX,this.cellY);
         return s_InAttackRangeOfCells[_loc1_];
      }
      
      public function get isInRangeOfStronghold() : Boolean
      {
         var _loc1_:Number = MapRoomManager.instance.CalculateCellId(this.cellX,this.cellY);
         return s_InRangeOfStrongholds[_loc1_] != null && s_InRangeOfStrongholds[_loc1_].length > 0;
      }
      
      public function get inRangeOfStrongholds() : Vector.<MapRoom3Cell>
      {
         var _loc1_:Number = MapRoomManager.instance.CalculateCellId(this.cellX,this.cellY);
         return s_InRangeOfStrongholds[_loc1_];
      }
      
      public function get currentBuffEffectFrame() : int
      {
         var _loc1_:Number = MapRoomManager.instance.CalculateCellId(this.cellX,this.cellY);
         if(s_CurrentBuffEffectFrames[_loc1_] == null)
         {
            s_CurrentBuffEffectFrames[_loc1_] = Math.random() * MapRoom3AssetCache.STRONGHOLD_BUFF_EFFECT_TOTAL_FRAMES;
         }
         return s_CurrentBuffEffectFrames[_loc1_];
      }
      
      public function set currentBuffEffectFrame(param1:int) : void
      {
         var _loc2_:Number = MapRoomManager.instance.CalculateCellId(this.cellX,this.cellY);
         s_CurrentBuffEffectFrames[_loc2_] = param1;
      }
      
      public function DoesContainDisplayableBase() : Boolean
      {
         return !this.isBorder && !this.isBlocked && !this.isInvisible && this.containsValidBase;
      }
      
      public function LoadForAttack() : void
      {
         this.LoadLatestData(this.OnLoadedForAttack);
      }
      
      public function LoadForBuild() : void
      {
         this.LoadLatestData(this.OnLoadedForBuild);
      }
      
      private function LoadLatestData(param1:Function) : void
      {
         PLEASEWAIT.Show(KEYS.Get("msg_loading"));
         var _loc2_:int = MapRoomManager.instance.CalculateCellId(this.cellX,this.cellY);
         var _loc3_:Array = [["cellids",JSON.encode([_loc2_])]];
         new URLLoaderApi().load(MapRoom3Data.GetCellsRequestURL(),_loc3_,param1);
      }
      
      public function OnLoadedForAttack(param1:Object) : void
      {
         PLEASEWAIT.Hide();
         if(param1 == null || param1.celldata == null || param1.celldata is Array == false || param1.celldata.length == 0)
         {
            GLOBAL.Message(KEYS.Get("mr3_base_locked_cannot_attack"),KEYS.Get("btn_ok"));
            return;
         }
         this.Setup(param1.celldata[0]);
         if(this.isLocked)
         {
            GLOBAL.Message(KEYS.Get("mr3_base_locked_cannot_attack"),KEYS.Get("btn_ok"));
            return;
         }
         GLOBAL._currentCell = this;
         var _loc2_:Number = MapRoomManager.instance.CalculateCellId(this.cellX,this.cellY);
         if(this.userID == 0)
         {
            BASE.LoadBase(null,0,this.baseID,GLOBAL.e_BASE_MODE.WMVIEW,false,this.cellType,_loc2_);
         }
         else
         {
            BASE.LoadBase(null,0,this.baseID,this.isOwnedByFacebookFriend ? GLOBAL.e_BASE_MODE.HELP : GLOBAL.e_BASE_MODE.VIEW,false,this.cellType,_loc2_);
         }
      }
      
      public function OnLoadedForBuild(param1:Object) : void
      {
         PLEASEWAIT.Hide();
         if(param1 == null || param1.celldata == null || param1.celldata is Array == false || param1.celldata.length == 0)
         {
            GLOBAL.Message(KEYS.Get("mr3_base_locked_cannot_enter"),KEYS.Get("btn_ok"));
            return;
         }
         this.Setup(param1.celldata[0]);
         if(this.isLocked || this.isOwnedByPlayer == false)
         {
            GLOBAL.Message(KEYS.Get("mr3_base_locked_cannot_enter"),KEYS.Get("btn_ok"));
            MapRoom3.mapRoom3Window.Refresh();
            return;
         }
         GLOBAL._currentCell = this;
         var _loc2_:Number = MapRoomManager.instance.CalculateCellId(this.cellX,this.cellY);
         BASE.LoadBase(null,0,this.baseID,GLOBAL.e_BASE_MODE.BUILD,false,this.cellType,_loc2_);
      }
      
      private function CalculateAttackCosts() : Array
      {
         var _loc3_:MapRoom3Cell = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc10_:MapRoom3Cell = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc1_:Array = [0,0,0,0];
         if(this.isInAttackRange == true)
         {
            return _loc1_;
         }
         var _loc2_:int = int.MAX_VALUE;
         var _loc4_:uint = MapRoomManager.instance.playerOwnedCells.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc10_ = MapRoomManager.instance.playerOwnedCells[_loc5_] as MapRoom3Cell;
            switch(_loc10_.cellType)
            {
               case EnumYardType.PLAYER:
               case EnumYardType.RESOURCE:
               case EnumYardType.STRONGHOLD:
                  _loc11_ = GetHexDistanceBetween(_loc10_,this);
                  if((_loc12_ = Math.max(0,_loc11_ - _loc10_.attackRange)) < _loc2_)
                  {
                     _loc2_ = _loc12_;
                     _loc3_ = _loc10_;
                  }
                  break;
            }
            _loc5_++;
         }
         if(_loc3_ == null)
         {
            return _loc1_;
         }
         _loc6_ = GLOBAL.attackingPlayer.townHallLevel;
         _loc7_ = Math.min(_loc6_,ATTACK_COST_MULTIPLIERS_BY_TOWN_HALL_LEVEL.length - 1);
         _loc8_ = ATTACK_COST_MULTIPLIERS_BY_TOWN_HALL_LEVEL[_loc7_] * MapRoomManager.instance.attackCostMultiplier.value;
         var _loc9_:int = _loc2_ * (_loc8_ * this.GetABTestAttackCostMultiplier());
         _loc1_[0] = _loc9_;
         _loc1_[1] = _loc9_;
         _loc1_[2] = _loc9_;
         _loc1_[3] = 0;
         return _loc1_;
      }
      
      private function GetABTestAttackCostMultiplier() : Number
      {
         var _loc1_:int = ABTest.lastTwoDigits(ABTest.UserMD5("flingercosts"));
         if(_loc1_ >= 256)
         {
            return 1;
         }
         if(_loc1_ >= 168)
         {
            return 1.5;
         }
         if(_loc1_ >= 84)
         {
            return 0.5;
         }
         Console.warning("AB test on attack cost didnt work.");
         return 1;
      }
      
      public function DoesFortify(param1:MapRoom3Cell) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(param1.DoesContainDisplayableBase() == false)
         {
            return false;
         }
         if(this.cellType != EnumYardType.FORTIFICATION)
         {
            return false;
         }
         if(this.userID != param1.userID)
         {
            return false;
         }
         if(this.wildMonsterTribeId != param1.wildMonsterTribeId)
         {
            return false;
         }
         return param1.cellType == EnumYardType.PLAYER || param1.cellType == EnumYardType.RESOURCE || param1.cellType == EnumYardType.STRONGHOLD;
      }
      
      public function GetLocalisedCellTypeName() : String
      {
         switch(this.cellType)
         {
            case EnumYardType.PLAYER:
               return KEYS.Get("mr3_starter_cell_name");
            case EnumYardType.RESOURCE:
               return KEYS.Get("mr3_resource_cell_name");
            case EnumYardType.STRONGHOLD:
               return KEYS.Get("mr3_stronghold_cell_name");
            case EnumYardType.FORTIFICATION:
               return KEYS.Get("mr3_fortification_cell_name");
            case EnumYardType.EMPTY:
            default:
               if(this.isOwnedByWildMonster)
               {
                  return KEYS.Get("mr3_wild_monster_cell_name");
               }
               return "";
         }
      }
      
      public function GetAllianceData() : MapRoom3AllianceData
      {
         return MapRoomManager.instance.allianceDataById[this.allianceID];
      }
   }
}
