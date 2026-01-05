package com.monsters.replayableEvents.looting
{
   import com.monsters.frontPage.messages.DebugMessage;
   import com.monsters.frontPage.messages.Message;
   import com.monsters.frontPage.messages.events.kingOfTheHill.*;
   import com.monsters.kingOfTheHill.KOTHHandler;
   import com.monsters.replayableEvents.ReplayableEvent;
   
   public class KingOfTheHill extends ReplayableEvent
   {
       
      
      public function KingOfTheHill()
      {
         _name = "Champion King of the Hill";
         _progress = -1;
         _priority = 0;
         _id = 4;
         _buttonCopy = KEYS.Get("btn_info");
         _titleImage = "events/koth/koth_title.png";
         _imageURL = "events/koth/koth_reward.png";
         _messages = Vector.<Message>([new KOTHPromoMessage1(),new KOTHPromoMessage2(),new KOTHPromoMessage3(),new KOTHStartMessage(),new DebugMessage()]);
         super();
         _originalStartDate = 1339441200;
         _duration = 604800;
      }
      
      override public function get hasCompletedEvent() : Boolean
      {
         return false;
      }
      
      override public function pressedActionButton() : void
      {
         if(!KOTHHandler.instance.doesQualify)
         {
            GLOBAL.Message(KEYS.Get("msg_krallen_nomr2"));
            return;
         }
         CHAMPIONCAGE.ShowKrallenTab();
      }
      
      override public function set score(param1:Number) : void
      {
         var _loc2_:Vector.<uint> = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         super.score = param1;
         if(KOTHHandler.instance.lootThresholds.length > 0)
         {
            _loc2_ = KOTHHandler.instance.lootThresholds;
            _loc3_ = _loc2_[0];
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length && param1 < _loc3_)
            {
               if(param1 >= _loc2_[_loc5_])
               {
                  _loc3_ = _loc2_[_loc5_ - 1];
                  _loc4_ = _loc2_[_loc5_];
                  break;
               }
               _loc5_++;
            }
            progress = (param1 - _loc4_) / (_loc3_ - _loc4_);
         }
         else
         {
            progress = 0;
         }
      }
      
      override public function doesQualify() : Boolean
      {
         return false;
      }
   }
}
