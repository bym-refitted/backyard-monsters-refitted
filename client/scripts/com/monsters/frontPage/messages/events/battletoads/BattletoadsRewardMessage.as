package com.monsters.frontPage.messages.events.battletoads
{
   import com.monsters.frontPage.messages.KeywordMessage;
   
   public class BattletoadsRewardMessage extends KeywordMessage
   {
       
      
      public function BattletoadsRewardMessage()
      {
         super("event1reward","btn_brag");
         this.imageURL = _IMAGE_DIRECTORY + "fp_event1reward.v2.jpg";
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         return false;
      }
      
      override protected function onButtonClick() : void
      {
         GLOBAL.CallJS("sendFeed",["event1-reward",KEYS.Get("event1reward_streamtitle"),KEYS.Get("event1reward_streambody"),"event1reward_stream.png"]);
      }
   }
}
