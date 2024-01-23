package com.monsters.events
{
   import com.monsters.monsters.MonsterBase;
   import flash.events.Event;
   
   public class CreepEvent extends Event
   {
      
      public static const ATTACKING_MONSTER_SPAWNED:String = "attackingCreepSpawned";
      
      public static const DEFENDING_CREEP_SPAWNED:String = "defendingCreepSpawned";
       
      
      private var m_Creep:MonsterBase;
      
      public function CreepEvent(param1:String, param2:MonsterBase)
      {
         super(param1);
         this.m_Creep = param2;
      }
      
      public function get creep() : MonsterBase
      {
         return this.m_Creep;
      }
   }
}
