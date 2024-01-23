package com.monsters.pathing
{
   public class PATHINGobject
   {
       
      
      public var pointX:int;
      
      public var pointY:int;
      
      public var depth:int;
      
      public var cost:int;
      
      public var building:BFOUNDATION;
      
      public function PATHINGobject()
      {
         super();
      }
      
      public function Init() : void
      {
         this.pointX = 0;
         this.pointY = 0;
         this.depth = 0;
         this.cost = 0;
         this.building = null;
      }
      
      public function get pointID() : int
      {
         return this.pointX * 1000 + this.pointY;
      }
   }
}
