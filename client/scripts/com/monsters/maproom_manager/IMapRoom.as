package com.monsters.maproom_manager
{
   import flash.utils.Dictionary;
   
   public interface IMapRoom
   {
       
      
      function set bookmarkData(param1:Object) : void;
      
      function set mapWidth(param1:int) : void;
      
      function set mapHeight(param1:int) : void;
      
      function get worldID() : int;
      
      function set worldID(param1:int) : void;
      
      function get isOpen() : Boolean;
      
      function get flingerInRange() : Boolean;
      
      function get viewOnly() : Boolean;
      
      function get playerOwnedCells() : Vector.<IMapRoomCell>;
      
      function get allianceDataById() : Dictionary;
      
      function Setup() : void;
      
      function ReadyToShow() : Boolean;
      
      function ShowDelayed(param1:Boolean = false) : void;
      
      function Hide() : void;
      
      function Tick() : void;
      
      function TickFast() : void;
      
      function BookmarksClear() : void;
      
      function ResizeHandler() : void;
      
      function FindCell(param1:int, param2:int) : IMapRoomCell;
      
      function LoadCell(param1:int, param2:int, param3:Boolean = false) : void;
      
      function CalculateCellId(param1:int, param2:int) : int;
   }
}
