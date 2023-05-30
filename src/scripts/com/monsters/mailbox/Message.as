package com.monsters.mailbox
{
   import com.monsters.maproom_advanced.MapRoom;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.FullScreenEvent;
   import flash.events.IOErrorEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class Message extends Message_CLIPB
   {
      
      public static const GRAY:uint = 6710886;
      
      public static const BLACK:uint = 0;
       
      
      public var requestType:String = "message";
      
      public var sendHandler:Function;
      
      public var successHandler:Function;
      
      public var truceShareHandler:Function;
      
      private var timer:Timer;
      
      public var picker:com.monsters.mailbox.FriendPicker;
      
      public var baseID:int = 0;
      
      public function Message(param1:String = "all")
      {
         super();
         (mcFrame as frame).Setup(true,this.closeDown);
         this.picker = new com.monsters.mailbox.FriendPicker(param1);
         this.picker.x = 238;
         this.picker.y = 65;
         this.baseID = 0;
         addChild(this.picker);
         sendBtn.SetupKey("btn_send");
         sendBtn.addEventListener(MouseEvent.CLICK,this.sendDown);
         status_txt.htmlText = "";
         addEventListener(Event.ADDED_TO_STAGE,this.onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         this.timer = new Timer(100);
         this.timer.addEventListener(TimerEvent.TIMER,this.Validate);
         this.timer.start();
         tolabel_txt.htmlText = KEYS.Get("mail_new_to");
         subjectlabel_txt.htmlText = KEYS.Get("mail_new_subject");
         messagelabel_txt.htmlText = KEYS.Get("mail_new_message");
      }
      
      public static function getNotWS(param1:String) : String
      {
         param1 = param1.split("\r").join("");
         param1 = param1.split("\t").join("");
         param1 = param1.split("\n").join("");
         return param1.split(" ").join("");
      }
      
      public static function cleanText(param1:String) : String
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc2_:Array = param1.split("\r");
         if(_loc2_.length > 1)
         {
            _loc3_ = String(_loc2_[0]);
            _loc4_ = 1;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ += " " + _loc2_[_loc4_];
               _loc4_++;
            }
            return _loc3_;
         }
         return param1;
      }
      
      private function onAdd(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAdd);
         this.y = -15;
         addEventListener(KeyboardEvent.KEY_DOWN,this.onEscapeListener);
         stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.detectFS);
         this.detectFS();
      }
      
      private function detectFS(param1:FullScreenEvent = null) : void
      {
         if(Boolean(stage) && stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            fsWarning.tBody.htmlText = KEYS.Get("fswarning");
            addChild(fsWarning);
         }
         else if(this.contains(fsWarning))
         {
            removeChild(fsWarning);
         }
      }
      
      private function onEscapeListener(param1:KeyboardEvent) : void
      {
         if(param1.charCode == 27)
         {
            this.closeDown();
         }
      }
      
      public function init() : void
      {
         body_txt.htmlText = "";
         subject_txt.textColor = GRAY;
         subject_txt.htmlText = "<b>";
         subject_txt.addEventListener(MouseEvent.MOUSE_DOWN,this.subjectDown);
      }
      
      private function subjectDown(param1:MouseEvent) : void
      {
         subject_txt.textColor = BLACK;
         subject_txt.text = "";
         subject_txt.removeEventListener(MouseEvent.MOUSE_DOWN,this.subjectDown);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
      }
      
      private function onKey(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            if(stage.focus == subject_txt)
            {
               stage.focus = body_txt;
               body_txt.text = "";
            }
         }
      }
      
      public function Validate(... rest) : void
      {
         var _loc2_:Boolean = true;
         if(!this.picker.currentSelection)
         {
            _loc2_ = false;
         }
         if(getNotWS(subject_txt.text).length == 0 || subject_txt.text == "Subject")
         {
            _loc2_ = false;
         }
         if(getNotWS(body_txt.text).length < 2)
         {
            _loc2_ = false;
         }
         if(_loc2_)
         {
            sendBtn.Enabled = true;
            sendBtn.addEventListener(MouseEvent.CLICK,this.sendDown);
         }
         else
         {
            sendBtn.Enabled = false;
            sendBtn.removeEventListener(MouseEvent.CLICK,this.sendDown);
         }
      }
      
      private function sendDown(param1:MouseEvent) : void
      {
         var _loc2_:String = body_txt.text;
         var _loc3_:Number = this.picker.getCurrentData().userid;
         var _loc4_:Array = [["threadid",0],["targetid",_loc3_],["targetbaseid",0],["type",this.requestType],["subject",subject_txt.text],["message",_loc2_]];
         var _loc5_:URLLoaderApi = new URLLoaderApi();
         if(this.requestType == "migraterequest" && this.baseID != 0)
         {
            _loc4_.push(["baseid",this.baseID]);
         }
         _loc5_.load(GLOBAL._apiURL + "player/sendmessage",_loc4_,this.onSuccess,this.onFail);
         sendBtn.Enabled = false;
         sendBtn.removeEventListener(MouseEvent.CLICK,this.sendDown);
      }
      
      private function onSuccess(param1:Object) : void
      {
         if(param1.error != undefined && param1.error != 0)
         {
            try
            {
               LOGGER.Log("err","mailbox-" + param1.error);
            }
            catch(e:*)
            {
            }
            this.displayError();
         }
         else
         {
            if(this.requestType == "trucerequest")
            {
               try
               {
                  this.truceShareHandler(this.picker.getCurrentData().firstname,"");
               }
               catch(e:*)
               {
               }
            }
            this.closeDown();
            dispatchEvent(new Event(Event.COMPLETE));
            if(this.requestType == "migraterequest" && MapRoomManager.instance.isInMapRoom2)
            {
               MapRoom.SetPendingInvitation();
               MapRoom.HideInfoMine();
            }
            try
            {
               this.successHandler(param1);
            }
            catch(e:*)
            {
            }
         }
      }
      
      private function onFail(param1:IOErrorEvent) : void
      {
         this.displayError();
      }
      
      public function displayError() : void
      {
         if(this.requestType == "migraterequest")
         {
            status_txt.htmlText = KEYS.Get("mailbox_invitepending");
         }
         else
         {
            status_txt.htmlText = KEYS.Get("mail_messagefailed");
         }
         sendBtn.Enabled = true;
         sendBtn.addEventListener(MouseEvent.CLICK,this.sendDown);
      }
      
      private function closeDown(param1:MouseEvent = null) : void
      {
         stage.removeEventListener(FullScreenEvent.FULL_SCREEN,this.detectFS);
         this.parent.removeChild(this);
         SOUNDS.Play("close");
      }
      
      public function Resize() : void
      {
      }
      
      private function onRemoved(param1:Event) : void
      {
         GLOBAL.BlockerRemove();
         removeEventListener(KeyboardEvent.KEY_DOWN,this.onEscapeListener);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         this.timer.stop();
      }
   }
}
