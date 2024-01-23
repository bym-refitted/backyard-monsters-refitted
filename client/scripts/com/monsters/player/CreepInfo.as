package com.monsters.player
{
   import com.monsters.monsters.MonsterBase;
   
   public final class CreepInfo
   {
       
      
      private var m_health:Number;
      
      public var ownerID:uint;
      
      public var self:MonsterBase;
      
      public var queued:uint;
      
      public function CreepInfo(param1:int = 0, param2:int = 2147483647, param3:MonsterBase = null)
      {
         super();
         this.ownerID = param1;
         this.health = param2;
         this.self = param3;
         this.queued = 0;
      }
      
      public function get health() : Number
      {
         return this.m_health;
      }
      
      public function set health(param1:Number) : void
      {
         this.m_health = param1 > 0 ? param1 : 0;
      }
   }
}
