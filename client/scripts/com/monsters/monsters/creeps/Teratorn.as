package com.monsters.monsters.creeps
{
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.abilities.GlavesOnAttack;
   import com.monsters.utils.ObjectPool;
   import flash.geom.Point;
   
   public class Teratorn extends CreepBase
   {
       
      
      public function Teratorn(param1:String, param2:String, param3:Point, param4:Number, param5:int = 0, param6:int = 2147483647, param7:Point = null, param8:Boolean = false, param9:BFOUNDATION = null, param10:Number = 1, param11:Boolean = false, param12:MonsterBase = null)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
         SPRITES.SetupSprite("shadow");
         if(poweredUp())
         {
            addComponent(new GlavesOnAttack(powerUpLevel()));
         }
      }
      
      override protected function rangedAttack(param1:ITargetable) : ITargetable
      {
         if(param1 is BFOUNDATION)
         {
            var spawnPt:Point = ObjectPool.getPoint(_tmpPoint.x, _tmpPoint.y - _altitude);
            return FIREBALLS.Spawn(spawnPt, _targetBuilding._position, _targetBuilding, 6, damage, 0, 0, FIREBALLS.TYPE_MAGMA, this);
         }
         return FIREBALLS.Spawn2(_tmpPoint, _targetCreep._tmpPoint, _targetCreep, 10, damage, 0, FIREBALLS.TYPE_MAGMA, 1, this);
      }
   }
}
