package com.monsters.maproom_advanced
{
   public final class CellData
   {
       
      
      public var cell:com.monsters.maproom_advanced.MapRoomCell;
      
      public var range:int;
      
      public function CellData(param1:com.monsters.maproom_advanced.MapRoomCell, param2:int)
      {
         super();
         this.cell = param1;
         this.range = param2;
      }
   }
}
