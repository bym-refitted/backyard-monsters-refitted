package com.monsters.replayableEvents.attackDefend.brukkargWar.messages
{
   import com.monsters.frontPage.messages.KeywordMessage;
   
   public class SpurtzCannonRewardMessage3 extends KeywordMessage
   {
       
      
      public function SpurtzCannonRewardMessage3()
      {
         super("event_bruwarreward3","btn_brag");
      }
      
      override protected function onButtonClick() : void
      {
         GLOBAL.Brag("event5-reward","event_bruwarreward3_streamtitle","event_bruwarreward3_streamdesc","event_bruwarreward3_stream.png");
      }
   }
}
