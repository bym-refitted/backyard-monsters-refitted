package com.monsters.monsters.creeps
{
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.abilities.AOEDamageOnAttack;
   import flash.geom.Point;
   
   public class Fink extends CreepBase
   {
       
      
      public function Fink(creatureID:String, behaviour:String, spawnPoint:Point, rotation:Number, level:int = 0, health:int = 2147483647, center:Point = null, friendly:Boolean = false, house:BFOUNDATION = null, damageMult:Number = 1, goEasy:Boolean = false, monster:MonsterBase = null)
      {
         var flags:* = 0;
         super(creatureID,behaviour,spawnPoint,rotation,level,health,center,friendly,house,damageMult,goEasy,monster);
         if(poweredUp())
         {
            flags = Targeting.k_TARGETS_BUILDINGS | Targeting.k_TARGETS_GROUND;
            flags |= friendly ? Targeting.k_TARGETS_ATTACKERS : Targeting.k_TARGETS_DEFENDERS;
            addComponent(new AOEDamageOnAttack(60,flags,powerUpLevel(),60,false));
         }
      }
   }
}
