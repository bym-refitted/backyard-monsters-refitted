package com.monsters.maproom_manager
{
   public interface IMapRoomCell
   {
       
      
      function get baseID() : Number;
      
      function get baseType() : int;
      
      function get cellX() : int;
      
      function get cellY() : int;
      
      function get cellHeight() : int;
      
      function get isDestroyed() : Boolean;
      
      function get isLocked() : Boolean;
   }
}
