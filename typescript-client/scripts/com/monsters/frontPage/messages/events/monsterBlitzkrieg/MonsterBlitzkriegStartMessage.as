package com.monsters.frontPage.messages.events.monsterBlitzkrieg
{
   import com.monsters.frontPage.messages.KeywordMessage;
   import com.monsters.replayableEvents.ReplayableEventHandler;
   
   public class MonsterBlitzkriegStartMessage extends KeywordMessage
   {
       
      
      public function MonsterBlitzkriegStartMessage()
      {
         super("event2start","btn_nextwave");
         this.imageURL = _IMAGE_DIRECTORY + "fp_event2start.v2.jpg";
      }
      
      override protected function onButtonClick() : void
      {
         ReplayableEventHandler.activeEvent.pressedActionButton();
         POPUPS.Next();
      }
   }
}
