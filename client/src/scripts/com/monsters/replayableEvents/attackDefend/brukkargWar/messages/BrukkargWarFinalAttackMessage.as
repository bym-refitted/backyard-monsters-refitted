package com.monsters.replayableEvents.attackDefend.brukkargWar.messages
{
   import com.monsters.frontPage.messages.KeywordMessage;
   import com.monsters.replayableEvents.ReplayableEvent;
   import com.monsters.replayableEvents.ReplayableEventHandler;
   
   public class BrukkargWarFinalAttackMessage extends KeywordMessage
   {
       
      
      public function BrukkargWarFinalAttackMessage()
      {
         super("event_bruwarfinal","btn_attack");
      }
      
      override protected function onButtonClick() : void
      {
         var _loc1_:ReplayableEvent = ReplayableEventHandler.activeEvent;
         if(_loc1_)
         {
            _loc1_.pressedActionButton();
         }
      }
   }
}
