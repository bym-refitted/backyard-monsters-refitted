package com.monsters.replayableEvents.attacking.hellRaisers
{
   import com.monsters.events.AttackEvent;
   import com.monsters.frontPage.messages.KeywordMessage;
   import com.monsters.frontPage.messages.Message;
   import com.monsters.managers.InstanceManager;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.replayableEvents.IReplayableEventUI;
   import com.monsters.replayableEvents.Maproom3EventHUD;
   import com.monsters.replayableEvents.ReplayableEvent;
   import com.monsters.replayableEvents.attacking.hellRaisers.messages.HellRaisersPromoMessage;
   import com.monsters.replayableEvents.attacking.hellRaisers.messages.HellRaisersStartMessage;
   import com.monsters.replayableEvents.attacking.hellRaisers.popups.HellRaisersBattleSummary;
   
   public class HellRaisers extends ReplayableEvent
   {
      
      public static const k_eventPage:String = "http://www.kixeye.com/hell-raisers";
      
      private static const k_hellRaisersTribeID:uint = uint("derp");
       
      
      public function HellRaisers()
      {
         _name = "Hell Raisers";
         _progress = -1;
         _priority = 0;
         _id = 7;
         _buttonCopy = KEYS.Get("btn_info");
         _titleImage = "events/hellraisers/hellraisers_title.png";
         _eventStoreTitleImage = "events/hellraisers/hellraisers_event_store_title.png";
         _imageURL = "events/hellraisers/hellraisers_reward.png";
         _messages = Vector.<Message>([new HellRaisersPromoMessage("hellraiserspop1"),new HellRaisersPromoMessage("hellraiserspop2"),new HellRaisersPromoMessage("hellraiserspop3"),new HellRaisersStartMessage(),new KeywordMessage("hellraisersend")]);
         super();
         _originalStartDate = 0;
         _duration = _DEFAULT_EVENT_DURATION;
      }
      
      override public function get preEventHUDImageURL() : String
      {
         return "events/hellraisers/preEventHud.png";
      }
      
      override public function get eventHUDImageURL() : String
      {
         return "events/hellraisers/eventHud.png";
      }
      
      override protected function onInitialize() : void
      {
         GLOBAL.eventDispatcher.addEventListener(AttackEvent.ATTACK_OVER,this.onAttackEnd);
      }
      
      protected function onAttackEnd(param1:AttackEvent) : void
      {
         var _loc2_:uint = 0;
         if(param1.attackType == k_hellRaisersTribeID)
         {
            _loc2_ = this.getBasesWorthInXP();
            POPUPS.Push(new HellRaisersBattleSummary(param1.wasBaseDestroyed,_loc2_).graphic);
            score += _loc2_;
         }
      }
      
      private function getBasesWorthInXP() : Number
      {
         var _loc1_:uint = 0;
         var _loc3_:BFOUNDATION = null;
         var _loc2_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         for each(_loc3_ in _loc2_)
         {
            _loc1_++;
         }
         return _loc1_;
      }
      
      override public function createNewUI() : IReplayableEventUI
      {
         return new Maproom3EventHUD();
      }
      
      override public function doesQualify() : Boolean
      {
         return MapRoomManager.instance.isInMapRoom3;
      }
   }
}
