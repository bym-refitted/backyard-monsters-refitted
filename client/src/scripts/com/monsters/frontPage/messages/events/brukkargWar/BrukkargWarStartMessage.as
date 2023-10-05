package com.monsters.frontPage.messages.events.brukkargWar
{
   import com.monsters.frontPage.messages.KeywordMessage;
   import com.monsters.replayableEvents.ReplayableEventHandler;
   
   public class BrukkargWarStartMessage extends KeywordMessage
   {
       
      
      public function BrukkargWarStartMessage()
      {
         super("event_bruwarstart","btn_nextwave");
      }
      
      override protected function onButtonClick() : void
      {
         ReplayableEventHandler.activeEvent.pressedActionButton();
         POPUPS.Next();
      }
   }
}
