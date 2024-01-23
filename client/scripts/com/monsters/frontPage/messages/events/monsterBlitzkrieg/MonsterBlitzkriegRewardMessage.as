package com.monsters.frontPage.messages.events.monsterBlitzkrieg
{
   import com.monsters.frontPage.messages.KeywordMessage;
   
   public class MonsterBlitzkriegRewardMessage extends KeywordMessage
   {
       
      
      public function MonsterBlitzkriegRewardMessage()
      {
         super("event2reward","btn_brag");
         this.imageURL = _IMAGE_DIRECTORY + "fp_event2start.v2.jpg";
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         return false;
      }
      
      override protected function onButtonClick() : void
      {
         GLOBAL.CallJS("sendFeed",["event2-reward",KEYS.Get("event2reward_streamtitle"),KEYS.Get("event2reward_streambody"),"event2reward_stream.v2.png"]);
         POPUPS.Next();
      }
   }
}
