package com.monsters.subscriptions.rewards
{
   import com.monsters.rewarding.Reward;
   
   public class ImprovedHCCReward extends Reward
   {
      
      public static const ID:String = "improvedHCC";
       
      
      private const _QUEUE_LIMIT:uint = 30;
      
      public function ImprovedHCCReward()
      {
         super();
      }
      
      override public function canBeApplied() : Boolean
      {
         return GLOBAL.isAtHome();
      }
      
      override protected function onApplication() : void
      {
         HATCHERYCC.queueLimit = this._QUEUE_LIMIT;
         if(MAPROOM_DESCENT.DescentPassed)
         {
            HATCHERYCC.doesShowInfernoCreeps = true;
         }
      }
      
      override public function reset() : void
      {
         this.removed();
      }
      
      override public function removed() : void
      {
         HATCHERYCC.queueLimit = HATCHERYCC.DEFAULT_QUEUE_LIMIT;
         HATCHERYCC.doesShowInfernoCreeps = false;
      }
   }
}
