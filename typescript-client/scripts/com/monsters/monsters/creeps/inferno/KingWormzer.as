package com.monsters.monsters.creeps.inferno
{
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.abilities.AOEDamageOnAttackOncePerTarget;
   import com.monsters.monsters.creeps.CreepBase;
   import flash.geom.Point;
   
   public class KingWormzer extends CreepBase
   {
       
      
      public function KingWormzer(param1:String, param2:String, param3:Point, param4:Number, param5:int = 0, param6:int = 2147483647, param7:Point = null, param8:Boolean = false, param9:BFOUNDATION = null, param10:Number = 1, param11:Boolean = false, param12:MonsterBase = null)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
         var _loc13_:* = Targeting.k_TARGETS_BUILDINGS | Targeting.k_TARGETS_GROUND;
         // Monster targeting parameters disabled.
         // King Wormer's splash damage did not work against monsters in the original game, and is too overpowered when re-enabled.
         //if(param8)
         //{
         //   _loc13_ |= Targeting.k_TARGETS_ATTACKERS;
         //}
         //else
         //{
         //   _loc13_ |= Targeting.k_TARGETS_DEFENDERS;
         //}
         addComponent(new AOEDamageOnAttackOncePerTarget(100,_loc13_,4));
      }
   }
}
