package com.monsters.monsters.creeps.inferno
{
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.creeps.CreepBase;
   import flash.geom.Point;
   
   public class Balthazar extends CreepBase
   {
       
      
      public function Balthazar(id:String, behavior:String, spawn:Point, rotation:Number, level:int = 0, health:int = 2147483647, center:Point = null, friendly:Boolean = false, housing:BFOUNDATION = null, damageMult:Number = 1, easy:Boolean = false, monster:MonsterBase = null)
      {
         super(id,behavior,spawn,rotation,level,health,center,friendly,housing,damageMult,easy,monster);
         if(Boolean(defenseFlags & Targeting.k_TARGETS_FLYING))
         {
            defenseFlags ^= Targeting.k_TARGETS_FLYING;
         }
         if(Boolean(defenseFlags & Targeting.k_TARGETS_GROUND))
         {
            defenseFlags ^= Targeting.k_TARGETS_GROUND;
         }
         if(poweredUp())
         {
            targetMode = 1;
         }
      }
   }
}
