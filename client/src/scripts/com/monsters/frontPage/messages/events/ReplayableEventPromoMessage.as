package com.monsters.frontPage.messages.events
{
   import com.monsters.frontPage.messages.KeywordMessage;
   import com.monsters.replayableEvents.ReplayableEventHandler;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ReplayableEventPromoMessage extends KeywordMessage
   {
       
      
      private var _button:MovieClip;
      
      public function ReplayableEventPromoMessage(param1:String, param2:String = "")
      {
         if(!param2 && !GLOBAL._flags.kongregate && !GLOBAL._flags.viximo)
         {
            param2 = "btn_keepposted";
         }
         super(param1,param2);
      }
      
      override public function setupButton(param1:Button) : Button
      {
         var _loc3_:Number = NaN;
         var _loc4_:DisplayObjectContainer = null;
         if(!_buttonCopy)
         {
            param1.visible = false;
            return param1;
         }
         var _loc2_:Number = param1.x;
         _loc3_ = param1.y;
         (_loc4_ = param1.parent).removeChild(param1);
         this._button = new frontpage_stonebtn();
         this._button.x = _loc2_;
         this._button.y = _loc3_;
         this._button.addEventListener(MouseEvent.CLICK,clickedButton);
         this._button.buttonMode = true;
         this._button.tLabel.text = _buttonCopy;
         _loc4_.addChild(this._button);
         return null;
      }
      
      override protected function onButtonClick() : void
      {
         ReplayableEventHandler.optInForEventEmails();
         this._button.enabled = false;
         this._button.visible = false;
         POPUPS.Next();
         GLOBAL.Message(KEYS.Get("msg_rsvpconfirmed",{"v1":LOGIN._email}));
      }
   }
}
