package com.monsters.replayableEvents.attacking.hellRaisers.messages
{
   import com.monsters.frontPage.messages.KeywordMessage;
   
   public class HellRaisersStartMessage extends KeywordMessage
   {
       
      
      public function HellRaisersStartMessage()
      {
         super("hellraisersstart","btn_info");
      }
      
      override protected function onButtonClick() : void
      {
         POPUPS.Next();
         GLOBAL.Message(">Show Event Details Page");
      }
   }
}
