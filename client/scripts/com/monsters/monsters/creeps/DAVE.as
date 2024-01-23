package com.monsters.monsters.creeps
{
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.abilities.DAVERockets;
   import flash.geom.Point;
   
   public class DAVE extends CreepBase
   {
       
      
      public function DAVE(param1:String, param2:String, param3:Point, param4:Number, param5:int = 0, param6:int = 2147483647, param7:Point = null, param8:Boolean = false, param9:BFOUNDATION = null, param10:Number = 1, param11:Boolean = false, param12:MonsterBase = null)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
         if(poweredUp())
         {
            addComponent(new DAVERockets());
         }
      }
      
      override protected function rangedAttack(param1:ITargetable) : ITargetable
      {
         if(param1 is BFOUNDATION)
         {
            FIREBALLS.Spawn(new Point(_tmpPoint.x + Math.random() * 20 - 10,_tmpPoint.y + Math.random() * 20 - 10),_targetBuilding._position,_targetBuilding,10,damage / 2,0,0,FIREBALL.TYPE_MISSILE,this);
            return FIREBALLS.Spawn(new Point(_tmpPoint.x + Math.random() * 20 - 10,_tmpPoint.y + Math.random() * 20 - 10),_targetBuilding._position,_targetBuilding,10,damage / 2,0,0,FIREBALL.TYPE_MISSILE,this);
         }
         FIREBALLS.Spawn2(new Point(_tmpPoint.x + Math.random() * 20 - 10,_tmpPoint.y + Math.random() * 20 - 10),_targetCreep._tmpPoint,_targetCreep,10,damage / 2,0,FIREBALL.TYPE_MISSILE,1,this);
         return FIREBALLS.Spawn2(new Point(_tmpPoint.x + Math.random() * 20 - 10,_tmpPoint.y + Math.random() * 20 - 10),_targetCreep._tmpPoint,_targetCreep,10,damage / 2,0,FIREBALL.TYPE_MISSILE,1,this);
      }
      
      override public function deathSplat() : void
      {
         SOUNDS.Play("monsterlanddave");
      }
   }
}
