package com.monsters.maproom3.bookmarks
{
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom3.MapRoom3Cell;
   
   public class Bookmark
   {
       
      
      private var m_MapRoom3Cell:MapRoom3Cell;
      
      private var m_UserDefinedName:String = "";
      
      public function Bookmark(param1:MapRoom3Cell, param2:String = "")
      {
         super();
         this.m_MapRoom3Cell = param1;
         this.m_UserDefinedName = param2;
      }
      
      private static function MakeDefaultBookmarkName(param1:MapRoom3Cell) : String
      {
         switch(param1.cellType)
         {
            case EnumYardType.PLAYER:
               return KEYS.Get("bm_starter_cell_name",{"fname":param1.name});
            case EnumYardType.RESOURCE:
               return KEYS.Get("bm_resource_cell_name",{"v1":param1.baseLevel});
            case EnumYardType.STRONGHOLD:
               return KEYS.Get("bm_stronghold_cell_name",{"v1":param1.baseLevel});
            case EnumYardType.FORTIFICATION:
               return KEYS.Get("bm_fortification_cell_name",{"v1":param1.baseLevel});
            case EnumYardType.EMPTY:
            default:
               if(param1.isOwnedByWildMonster)
               {
                  return KEYS.Get("bm_wild_monster_cell_name");
               }
               return "";
         }
      }
      
      public function get mapCell() : MapRoom3Cell
      {
         return this.m_MapRoom3Cell;
      }
      
      public function get cellX() : int
      {
         return !!this.m_MapRoom3Cell ? this.m_MapRoom3Cell.cellX : -1;
      }
      
      public function get cellY() : int
      {
         return !!this.m_MapRoom3Cell ? this.m_MapRoom3Cell.cellY : -1;
      }
      
      public function get displayName() : String
      {
         return !!this.m_UserDefinedName ? this.m_UserDefinedName : MakeDefaultBookmarkName(this.m_MapRoom3Cell);
      }
      
      public function get userDefinedName() : String
      {
         return this.m_UserDefinedName;
      }
      
      public function set userDefinedName(param1:String) : void
      {
         this.m_UserDefinedName = param1;
      }
      
      internal function Clear() : void
      {
         this.m_MapRoom3Cell = null;
         this.m_UserDefinedName = null;
      }
   }
}
