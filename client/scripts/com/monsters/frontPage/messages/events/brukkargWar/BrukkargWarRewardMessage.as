package com.monsters.frontPage.messages.events.brukkargWar
{
   import com.monsters.frontPage.messages.KeywordMessage;
   
   public class BrukkargWarRewardMessage extends KeywordMessage
   {
       
      
      public function BrukkargWarRewardMessage()
      {
         super("event_bruwarreward3","btn_brag");
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         return false;
      }
      
      override protected function onButtonClick() : void
      {
         POPUPS.Next();
         GLOBAL.Brag("event5-reward","event_bruwarreward3_streamtitle","event_bruwarreward3_streamdesc","event_bruwarreward3_stream.png");
      }
   }
}
