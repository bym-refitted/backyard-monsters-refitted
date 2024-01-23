package com.monsters.events
{
   import com.monsters.interfaces.ITargetable;
   import flash.events.Event;
   
   public class ProjectileEvent extends Event
   {
      
      public static const k_hit:String = "projectileHit";
       
      
      public var m_targetCreep:ITargetable;
      
      public var m_targetBuilding:BFOUNDATION;
      
      public function ProjectileEvent(param1:String, param2:ITargetable, param3:BFOUNDATION = null)
      {
         super(param1);
         this.m_targetCreep = param2;
         this.m_targetBuilding = param3;
      }
   }
}
