package com.monsters.replayableEvents.yardCrawl.battletoads
{
   import com.monsters.frontPage.messages.Message;
   import com.monsters.frontPage.messages.events.battletoads.*;
   import com.monsters.replayableEvents.yardCrawl.YardCrawl;
   import com.monsters.rewarding.RewardHandler;
   import com.monsters.rewarding.RewardLibrary;
   import com.monsters.rewarding.rewards.vorg.UnblockVorgReward;
   import com.monsters.rewarding.rewards.vorg.UnlockVorgReward;
   
   public class Battletoads extends YardCrawl
   {
      
      public static const ID:uint = 1;
       
      
      private const _MONSTER_REWARD_ID:String = "C16";
      
      public function Battletoads()
      {
         _name = "Creature Carnage";
         _originalStartDate = 0;
         _id = ID;
         _progress = -1;
         _priority = 100;
         _yardsToDestroy = 10;
         _titleImage = "events/creatureCarnage/creatureCarnage_logo.v3.png";
         _imageURL = "events/creatureCarnage/creatureCarnage_event.v3.png";
         _messages = Vector.<Message>([new BattletoadsPromoMessage1(),new BattletoadsPromoMessage2(),new BattletoadsPromoMessage3(),new BattletoadsStartMessage(),new BattletoadsEndMessage()]);
         _rewardMessage = new BattletoadsRewardMessage();
         super();
      }
      
      override public function doesQualify() : Boolean
      {
         var _loc1_:uint = GLOBAL.townHall._lvl.Get();
         return _loc1_ >= 2 && _loc1_ <= 4;
      }
      
      public function doesAutomaticalyGetReward() : Boolean
      {
         return Boolean(GLOBAL.townHall) && GLOBAL.townHall._lvl.Get() >= 5 && !startDate;
      }
      
      override protected function onImport() : void
      {
         if(this.doesAutomaticalyGetReward())
         {
            RewardHandler.instance.addAndApplyReward(RewardLibrary.getRewardByID(UnblockVorgReward.ID));
         }
      }
      
      override protected function onEventComplete() : void
      {
         RewardHandler.instance.addAndApplyReward(RewardLibrary.getRewardByID(UnlockVorgReward.ID));
      }
   }
}
