package
{
   import com.monsters.mailbox.FriendPicker;
   import com.monsters.mailbox.Message;
   import com.monsters.mailbox.model.Contact;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.FullScreenEvent;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class SIGNPOPUP extends Sprite
   {
      
      public static const GRAY:uint = 6710886;
      
      public static const BLACK:uint = 0;
       
      
      public var picker:FriendPicker;
      
      public var sendBtn:Button;
      
      public var subject_txt:TextField;
      
      public var status_txt:TextField;
      
      public var closeBtn:SimpleButton;
      
      public var bg_mc:MovieClip;
      
      public var requestType:String = "subject";
      
      private var timer:Timer;
      
      public var fsWarning:MovieClip;
      
      public var _sign:BFOUNDATION;
      
      public var _senderName:String;
      
      public var _senderPic:String;
      
      public var _senderid:int;
      
      public var _subject:String;
      
      public var _mode:String;
      
      public function SIGNPOPUP()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         this.timer = new Timer(100);
         this.timer.addEventListener(TimerEvent.TIMER,this.Validate);
         this.timer.start();
         this.closeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeDown);
         var _loc1_:Contact = new Contact(String(BASE._userID),{
            "first_name":BASE._ownerName,
            "last_name":"",
            "pic_square":BASE._ownerPic
         });
         this.picker.preloadSelection(_loc1_);
      }
      
      private function closeDown(param1:MouseEvent) : void
      {
         var _loc2_:String = !!this.subject_txt.text ? this.subject_txt.text : "No Message";
         this._sign.SetGiftingProps(0,_loc2_,this._senderid,this._senderName,this._senderPic);
         SIGNS.Hide();
      }
      
      private function sendDown(param1:MouseEvent) : void
      {
         var _loc3_:Array = null;
         this._sign._subject = this.subject_txt.text;
         this._subject = this.subject_txt.text;
         var _loc2_:Number = this.picker.getCurrentData().userid;
         var _loc4_:URLLoaderApi = new URLLoaderApi();
         if(this._mode == "create")
         {
            _loc3_ = [["threadid",0],["targetid",_loc2_],["targetbaseid",0],["type",this.requestType],["subject",this._subject]];
            _loc4_.load(GLOBAL._apiURL + "player/sendmessage",_loc3_,this.onSuccess,this.onFail);
            this.sendBtn.Enabled = false;
            this.sendBtn.removeEventListener(MouseEvent.CLICK,this.sendDown);
         }
         else if(this._mode == "edit")
         {
            _loc3_ = [["threadid",this._sign._threadid],["subject",this._subject]];
            _loc4_.load(GLOBAL._apiURL + "player/editthread",_loc3_,this.onSuccess,this.onFail);
            this.sendBtn.Enabled = false;
            this.sendBtn.removeEventListener(MouseEvent.CLICK,this.sendDown);
         }
      }
      
      public function Setup() : void
      {
         if(this._mode == "create")
         {
            this.sendBtn.SetupKey("btn_send");
         }
         else if(this._mode == "edit")
         {
            this.sendBtn.SetupKey("btn_save");
            this.subject_txt.text = this._subject;
         }
         this.status_txt.text = "";
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
            this._sign.SetGiftingProps(param1.threadid,this._subject,this._senderid,this._senderName,this._senderPic);
            SIGNS.Hide();
         }
      }
      
      private function onFail(param1:IOErrorEvent) : void
      {
         this.displayError();
      }
      
      public function displayError() : void
      {
         this.status_txt.text = "Message failed";
         this.sendBtn.Enabled = true;
         this.sendBtn.addEventListener(MouseEvent.CLICK,this.sendDown);
      }
      
      private function onAdd(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAdd);
         this.Center();
         stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.detectFS);
         this.detectFS();
      }
      
      private function detectFS(param1:FullScreenEvent = null) : void
      {
         if(Boolean(stage) && stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            this.fsWarning.tBody.htmlText = KEYS.Get("fswarning");
            addChild(this.fsWarning);
         }
         else if(this.contains(this.fsWarning))
         {
            removeChild(this.fsWarning);
         }
      }
      
      private function onRemoved(param1:Event) : void
      {
         stage.removeEventListener(FullScreenEvent.FULL_SCREEN,this.detectFS);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         this.timer.stop();
      }
      
      private function Validate(param1:TimerEvent) : void
      {
         var _loc2_:Boolean = true;
         if(!this.picker.currentSelection)
         {
            _loc2_ = false;
         }
         if(Message.getNotWS(this.subject_txt.text).length == 0 || this.subject_txt.text == "Subject")
         {
            _loc2_ = false;
         }
         if(_loc2_)
         {
            this.sendBtn.Enabled = true;
            this.sendBtn.addEventListener(MouseEvent.CLICK,this.sendDown);
         }
         else
         {
            this.sendBtn.Enabled = false;
            this.sendBtn.removeEventListener(MouseEvent.CLICK,this.sendDown);
         }
      }
      
      public function Center() : void
      {
         POPUPSETTINGS.AlignToCenter(this);
      }
      
      public function ScaleUp() : void
      {
         POPUPSETTINGS.ScaleUp(this);
      }
   }
}
