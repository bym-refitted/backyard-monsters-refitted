package com.monsters.replayableEvents.attackDefend.brukkargWar.rewards
{
   import com.monsters.rewarding.Reward;
   
   public class SpurtzCannonReward1 extends Reward
   {
      
      public static const ID:String = "spurtzCannonReward";
       
      
      public function SpurtzCannonReward1()
      {
         super();
      }
      
      override protected function onApplication() : void
      {
         GLOBAL._buildingProps[SpurtzCannon.TYPE - 1].block = false;
         GLOBAL._buildingProps[SpurtzCannon.TYPE - 1].quantity = [1];
      }
      
      override public function removed() : void
      {
         GLOBAL._buildingProps[SpurtzCannon.TYPE - 1].block = true;
      }
      
      override public function reset() : void
      {
         if(this.canBeApplied())
         {
            this.removed();
         }
      }
      
      override public function canBeApplied() : Boolean
      {
         return GLOBAL.isAtHome();
      }
   }
}
