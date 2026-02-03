package com.monsters.monsters.creeps
{
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.utils.ObjectPool;
   import flash.display.BitmapData;
   import flash.geom.Point;
   
   public class Zafreeti extends CreepBase
   {
       
      
      public function Zafreeti(param1:String, param2:String, param3:Point, param4:Number, param5:int = 0, param6:int = 2147483647, param7:Point = null, param8:Boolean = false, param9:BFOUNDATION = null, param10:Number = 1, param11:Boolean = false, param12:MonsterBase = null)
      {
         _graphic = new BitmapData(56,70,true,0);
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
         SPRITES.SetupSprite("bigshadow");
         attackFlags = Targeting.getOldStyleTargets(1);
      }
      
      override protected function rangedAttack(param1:ITargetable) : ITargetable
      {
         if(int(_creatureID.substr(1)) < 5)
         {
            SOUNDS.Play("hit" + int(1 + Math.random() * 3),0.1 + Math.random() * 0.1);
         }
         else if(int(_creatureID.substr(1)) < 10)
         {
            SOUNDS.Play("hit" + int(3 + Math.random() * 2),0.1 + Math.random() * 0.1);
         }
         else
         {
            SOUNDS.Play("hit" + int(4 + Math.random() * 1),0.1 + Math.random() * 0.1);
         }
         var spawnPt:Point = ObjectPool.getPoint(_tmpPoint.x, _tmpPoint.y - _altitude);
         return FIREBALLS.Spawn2(spawnPt, _targetCreep._tmpPoint, _targetCreep, 25, damage, 0, FIREBALLS.TYPE_FIREBALL, 1, this);
      }
   }
}
