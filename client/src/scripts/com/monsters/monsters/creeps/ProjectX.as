package com.monsters.monsters.creeps
{
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.abilities.AOEDamageOnDeath;
   import flash.geom.Point;
   
   public class ProjectX extends CreepBase
   {
       
      
      public function ProjectX(param1:String, param2:String, param3:Point, param4:Number, param5:int = 0, param6:int = 2147483647, param7:Point = null, param8:Boolean = false, param9:BFOUNDATION = null, param10:Number = 1, param11:Boolean = false, param12:MonsterBase = null)
      {
         var _loc13_:* = 0;
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
         if(poweredUp())
         {
            _loc13_ = Targeting.k_TARGETS_BUILDINGS | Targeting.k_TARGETS_GROUND;
            if(param8)
            {
               _loc13_ |= Targeting.k_TARGETS_ATTACKERS;
            }
            else
            {
               _loc13_ |= Targeting.k_TARGETS_DEFENDERS;
            }
            addComponent(new AOEDamageOnDeath(60,_loc13_));
         }
      }
   }
}
