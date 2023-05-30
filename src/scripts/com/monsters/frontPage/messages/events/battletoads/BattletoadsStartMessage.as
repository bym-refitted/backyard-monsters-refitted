package com.monsters.frontPage.messages.events.battletoads
{
   import com.monsters.frontPage.messages.KeywordMessage;
   import com.monsters.replayableEvents.ReplayableEventHandler;
   
   public class BattletoadsStartMessage extends KeywordMessage
   {
       
      
      public function BattletoadsStartMessage()
      {
         super("event1start","btn_attack");
         this.imageURL = _IMAGE_DIRECTORY + "fp_event1start.v2.jpg";
      }
      
      override protected function onButtonClick() : void
      {
         ReplayableEventHandler.activeEvent.pressedActionButton();
      }
   }
}
