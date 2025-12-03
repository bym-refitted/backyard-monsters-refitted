package com.monsters.mailbox
{
   import com.monsters.alliances.ALLIANCES;
   import com.monsters.display.ScrollSet;
   import com.monsters.enums.EnumPlayerType;
   import com.monsters.mailbox.model.Contact;
   import com.monsters.mailbox.model.ThreadData;
   import com.monsters.maproom_advanced.MapRoom;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.display.Sprite;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.FullScreenEvent;
   import flash.events.IOErrorEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.system.Capabilities;
   import flash.utils.Timer;
   import utils.DisplayScaler;
   
   public class Thread extends Thread_CLIP
   {
      
      public static const NARROW:uint = 473;
      
      public static const WIDE:uint = 487;
       
      
      public var data:ThreadData;
      
      public var members:Array;
      
      private var shell:Sprite;
      
      public var scroller:ScrollSet;
      
      public var _wide:Boolean = false;
      
      public var subject:String;
      
      public var messageState:Object;
      
      public var truceState:Object;
      
      public var editMode:Object;
      
      public var viewMode:Object;
      
      public var timer:Timer;
      
      private var spammy:Boolean;
      
      private var sending:Boolean = false;
      
      private var firstLoaded:Boolean = false;
      
      public var _mc:*;
      
      public function Thread()
      {
         this.messageState = {
            "boxWidth":300,
            "textWidth":300
         };
         this.truceState = {
            "boxWidth":230,
            "textWidth":230
         };
         this.editMode = {
            "inputBoxHeight":190,
            "inputBoxY":270,
            "textHeight":176,
            "textY":279,
            "outlineY":268,
            "outlineHeight":176,
            "largeOutlineVisible":true,
            "maskHeight":168,
            "smallOutlineVisible":false
         };
         this.viewMode = {
            "inputBoxHeight":60,
            "inputBoxY":401,
            "textHeight":48,
            "textY":410,
            "outlineY":410,
            "outlineHeight":48,
            "largeOutlineVisible":false,
            "maskHeight":300,
            "smallOutlineVisible":true
         };
         super();
         mask_mc.visible = false;
         removeChild(sendBtn);
         removeChild(acceptBtn);
         removeChild(denyBtn);
         removeChild(fsWarning);
         removeChild(viewBtn);
         largeOutline_mc.visible = false;
         addEventListener(Event.ADDED_TO_STAGE,this.onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         this.scroller = new ScrollSet();
         this.scroller.x = 498;
         this.scroller.y = 81;
         addChild(this.scroller);
      }
      
      public function Setup(param1:ThreadData) : void
      {
         this.shell = new Sprite();
         this.shell.mask = mask_mc;
         this.shell.x = 86;
         this.shell.y = 106;
         addChild(this.shell);
         this.members = [].concat();
         (mcFrame as frame).Setup(true,MailBox.ShowInbox);
         if(!param1.threadLoaded)
         {
            param1.addEventListener(Event.COMPLETE,this.threadLoadComplete);
            param1.addEventListener(Event.CHANGE,this.onThreadChanged);
            spinner.visible = true;
            param1.loadThread();
         }
         this._mc.subject_txt.htmlText = param1.subject.length > 30 ? param1.subject.substr(0,30) + "..." : param1.subject;
         this.scroller.visible = false;
         this.data = param1;
         this.Display(false);
         if(!param1.reported)
         {
            this._mc.reportBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.reportThread);
            this._mc.reportBtn.label_txt.htmlText = KEYS.Get("mail_ignoreplayer_btn");
            this._mc.reportBtn.buttonMode = true;
            this._mc.reportBtn.mouseChildren = false;
         }
         else
         {
            removeChild(reportBtn);
         }
      }
      
      public function prepareForKill() : void
      {
         if(stage)
         {
            stage.removeEventListener(FullScreenEvent.FULL_SCREEN,this.detectFS);
         }
      }
      
      private function onThreadChanged(param1:Event) : void
      {
         this.data.loadThread();
      }
      
      public function Validate(param1:TimerEvent = null) : Boolean
      {
         var _loc2_:Boolean = true;
         if(Message.getNotWS(msg_txt.text).length < 2)
         {
            _loc2_ = false;
         }
         sendBtn.Enabled = _loc2_ && !this.spammy && !this.sending;
         if(_loc2_ && !this.spammy && !this.sending)
         {
            sendBtn.addEventListener(MouseEvent.CLICK,this.sendDown);
         }
         else
         {
            sendBtn.removeEventListener(MouseEvent.CLICK,this.sendDown);
         }
         return _loc2_ && !this.spammy && !this.sending;
      }
      
      private function reportThread(... rest) : void
      {
         var popup:popup_report = null;
         var reportSendDown:Function = null;
         var reportCloseDown:Function = null;
         var onSuccessfulReport:Function = null;
         var args:Array = rest;
         reportSendDown = function(param1:MouseEvent):void
         {
            var _loc2_:Array = [["threadid",data.threadid],["reason","block"]];
            var _loc3_:URLLoaderApi = new URLLoaderApi();
            _loc3_.load(GLOBAL._apiURL + "player/reportmessagethread",_loc2_,onSuccessfulReport,onFail);
            popup.sendBtn.removeEventListener(MouseEvent.CLICK,reportSendDown);
            popup.sendBtn.Enabled = false;
         };
         reportCloseDown = function(param1:MouseEvent = null):void
         {
            SOUNDS.Play("close");
            GLOBAL.BlockerRemove();
            popup.parent.removeChild(popup);
         };
         onSuccessfulReport = function(param1:Object):void
         {
            var _loc2_:String = null;
            if(param1.error != undefined && param1.error != 0)
            {
               LOGGER.Log("err","message error in reporting thread- " + param1.error);
            }
            for(_loc2_ in param1)
            {
            }
            data.flagged = true;
            data.Changed();
            reportCloseDown();
            MailBox.ShowInbox();
         };
         SOUNDS.Play("click1");
         popup = new popup_report();
         popup.tTitle.htmlText = KEYS.Get("report_title");
         popup.tDesc.htmlText = KEYS.Get("report_desc");
         popup.Resize = function():void
         {
            popup.x = mcFrame.x + mcFrame.width * 0.5 + 100;
            popup.y = mcFrame.y + mcFrame.height * 0.5;
         };
         popup.sendBtn.SetupKey("btn_send");
         popup.mcFrame.Setup(true,reportCloseDown);
         popup.x = mcFrame.x + mcFrame.width * 0.5 + 100;
         popup.y = mcFrame.y + mcFrame.height * 0.5;
         popup.sendBtn.addEventListener(MouseEvent.CLICK,reportSendDown);
         GLOBAL.BlockerAdd();
         GLOBAL._layerWindows.addChild(popup);
      }
      
      private function onAdd(param1:Event) : void
      {
         this.Display();
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
            setChildIndex(fsWarning,this.numChildren - 1);
         }
         else if(this.contains(fsWarning))
         {
            removeChild(fsWarning);
         }
      }
      
      private function onMsgFocusIn(param1:FocusEvent = null) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this.editMode;
         outline_mc.visible = _loc2_["smallOutlineVisible"];
         largeOutline_mc.visible = _loc2_["largeOutlineVisible"];
         msg_txt.height = _loc2_["textHeight"];
         msg_txt.y = _loc2_["textY"];
         inputBox.y = _loc2_["inputBoxY"];
         inputBox.height = _loc2_["inputBoxHeight"];
         mask_mc.height = _loc2_["maskHeight"];
         this.scroller.ScrollTo(1);
         if(this.contains(inputBox))
         {
            setChildIndex(inputBox,this.numChildren - 1);
         }
         if(this.contains(largeOutline_mc))
         {
            setChildIndex(largeOutline_mc,this.numChildren - 1);
         }
         if(this.contains(msg_txt))
         {
            setChildIndex(msg_txt,this.numChildren - 1);
         }
         if(this.contains(sendBtn))
         {
            setChildIndex(sendBtn,this.numChildren - 1);
         }
         if(this.contains(acceptBtn))
         {
            setChildIndex(acceptBtn,this.numChildren - 1);
         }
         if(this.contains(denyBtn))
         {
            setChildIndex(denyBtn,this.numChildren - 1);
         }
         if(this.contains(viewBtn))
         {
            setChildIndex(viewBtn,this.numChildren - 1);
         }
         var _loc3_:Boolean = this._wide;
         if(this.shell.height > mask_mc.height)
         {
            this._wide = true;
         }
         else
         {
            this._wide = false;
         }
         if(_loc3_ != this._wide)
         {
            this.Display();
         }
      }
      
      private function onMsgFocusOut(param1:FocusEvent = null) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this.viewMode;
         outline_mc.visible = _loc2_["smallOutlineVisible"];
         largeOutline_mc.visible = _loc2_["largeOutlineVisible"];
         msg_txt.height = _loc2_["textHeight"];
         msg_txt.y = _loc2_["textY"];
         inputBox.y = _loc2_["inputBoxY"];
         inputBox.height = _loc2_["inputBoxHeight"];
         mask_mc.height = _loc2_["maskHeight"];
         if(this.contains(inputBox))
         {
            setChildIndex(inputBox,this.numChildren - 1);
         }
         if(this.contains(outline_mc))
         {
            setChildIndex(outline_mc,this.numChildren - 1);
         }
         if(this.contains(msg_txt))
         {
            setChildIndex(msg_txt,this.numChildren - 1);
         }
         if(this.contains(sendBtn))
         {
            setChildIndex(sendBtn,this.numChildren - 1);
         }
         if(this.contains(acceptBtn))
         {
            setChildIndex(acceptBtn,this.numChildren - 1);
         }
         if(this.contains(denyBtn))
         {
            setChildIndex(denyBtn,this.numChildren - 1);
         }
         if(this.contains(viewBtn))
         {
            setChildIndex(viewBtn,this.numChildren - 1);
         }
         var _loc3_:Boolean = this._wide;
         if(this.shell.height > mask_mc.height)
         {
            this._wide = true;
         }
         else
         {
            this._wide = false;
         }
         if(_loc3_ != this._wide)
         {
            this.Display();
         }
         if(!this._wide)
         {
            this.scroller.visible = false;
            this.scroller.ScrollTo(0,false);
         }
         else
         {
            this.scroller.ScrollTo(1);
         }
      }
      
      private function onRemoved(param1:Event) : void
      {
         removeEventListener(KeyboardEvent.KEY_DOWN,this.onEscapeListener);
         this.data.removeEventListener(Event.CHANGE,this.onThreadChanged);
         this.data.removeEventListener(Event.COMPLETE,this.threadLoadComplete);
         if(this.timer)
         {
            this.timer.stop();
         }
      }
      
      private function onEscapeListener(param1:KeyboardEvent) : void
      {
         if(param1.charCode == 27)
         {
         }
      }
      
      public function threadLoadComplete(param1:Event) : void
      {
         var _loc3_:ThreadMember = null;
         var _loc5_:Object = null;
         var _loc6_:Boolean = false;
         var _loc7_:ThreadMember = null;
         var _loc8_:ThreadMember = null;
         sendBtn.SetupKey("btn_send");
         outline_mc.width = 300;
         largeOutline_mc.width = 300;
         msg_txt.width = 300;
         addChild(sendBtn);
         if(this.data.trucestate == "requested")
         {
            if(this.data.convo[0].targetid == LOGIN._playerID)
            {
               acceptBtn.SetupKey("btn_truceaccept");
               acceptBtn.addEventListener(MouseEvent.CLICK,this.truceAccept);
               denyBtn.SetupKey("btn_trucereject");
               denyBtn.addEventListener(MouseEvent.CLICK,this.truceReject);
               outline_mc.width = 230;
               largeOutline_mc.width = 230;
               msg_txt.width = 230;
               addChild(acceptBtn);
               addChild(denyBtn);
            }
         }
         if(this.data.migratestate == "requested")
         {
            if(this.data.convo[0].targetid == LOGIN._playerID)
            {
               acceptBtn.SetupKey("btn_truceaccept");
               acceptBtn.addEventListener(MouseEvent.CLICK,this.migrateAccept);
               denyBtn.SetupKey("invite_decline");
               denyBtn.addEventListener(MouseEvent.CLICK,this.migrateReject);
               viewBtn.SetupKey("map_view_btn");
               viewBtn.addEventListener(MouseEvent.CLICK,this.migrateView);
               outline_mc.width = 230;
               largeOutline_mc.width = 230;
               msg_txt.width = 230;
               addChild(acceptBtn);
               addChild(denyBtn);
               addChild(viewBtn);
            }
            else if(this.data.convo[0].userid == LOGIN._playerID)
            {
               denyBtn.SetupKey("btn_revoke");
               denyBtn.addEventListener(MouseEvent.CLICK,this.migrateRevoke);
               addChild(denyBtn);
            }
         }
         acceptBtn.Enabled = denyBtn.Enabled = sendBtn.Enabled = viewBtn.Enabled = false;
         msg_txt.htmlText = "";
         this.timer = new Timer(500);
         this.timer.addEventListener(TimerEvent.TIMER,this.Validate);
         this.timer.start();
         spinner.visible = false;
         if(this.contains(spinner))
         {
            removeChild(spinner);
         }
         acceptBtn.Enabled = denyBtn.Enabled = true;
         if(this.data.migratestate == "requested")
         {
            viewBtn.Enabled = true;
         }
         var _loc2_:* = false;
         if(this.data.convo.length >= 1)
         {
            _loc2_ = (_loc5_ = this.data.convo[this.data.convo.length - 1]).userid == LOGIN._playerID;
         }
         if(!_loc2_)
         {
            msg_txt.addEventListener(FocusEvent.FOCUS_IN,this.onMsgFocusIn);
            msg_txt.addEventListener(FocusEvent.FOCUS_OUT,this.onMsgFocusOut);
            addChild(msg_txt);
            msg_txt.visible = true;
         }
         else
         {
            msg_txt.visible = false;
         }
         this.spammy = _loc2_;
         if(this.data.unread)
         {
            --GLOBAL._unreadMessages;
            UI2._top.Update();
            this.data.unread = false;
            this.data.Changed();
         }
         this.subject = this.data.subject;
         if(this.members.length > 1)
         {
            _loc3_ = this.members[this.members.length - 1];
         }
         var _loc4_:uint = 0;
         while(_loc4_ < this.data.convo.length)
         {
            _loc6_ = false;
            for each(_loc7_ in this.members)
            {
               if(this.data.convo[_loc4_].messageid == _loc7_.data.messageid)
               {
                  _loc6_ = true;
                  _loc3_ = _loc7_;
               }
            }
            if(!_loc6_)
            {
               (_loc8_ = new ThreadMember()).Setup(this.data.convo[_loc4_]);
               _loc8_.shouldLoadImage();
               this.shell.addChild(_loc8_);
               if(_loc3_)
               {
                  _loc8_.y = _loc3_.y + _loc3_.getVisibleHeight() + 6;
               }
               else
               {
                  _loc8_.y = 0;
               }
               this.members.push(_loc8_);
               _loc3_ = _loc8_;
               if(this.data.convo[_loc4_].userid != LOGIN._playerID)
               {
                  _loc8_.setOrientation("right");
               }
            }
            _loc4_++;
         }
         if(this.shell.height > mask_mc.height)
         {
            this._wide = true;
         }
         else
         {
            this._wide = false;
         }
         this.Display();
         this.onMsgFocusOut();
         this.detectFS();
         if(!this.firstLoaded)
         {
            this.firstLoaded = true;
         }
         if(this._wide)
         {
            this.scroller.ScrollTo(1,false);
         }
      }
      
      public function Display(... rest) : void
      {
         if(this._wide)
         {
            this.scroller.Init(this.shell,mask_mc,0,106,319);
            this.scroller.BottomPadding = 20;
            this.scroller.visible = true;
            this.scroller.ScrollTo(1);
            mcFrame.width = WIDE;
         }
         else
         {
            mcFrame.width = NARROW;
         }
         mcFrame.Setup(true,MailBox.ShowInbox);
      }
      
      private function truceAccept(param1:MouseEvent) : void
      {
         SOUNDS.Play("click1");
         var _loc2_:uint = this.data.userid;
         var _loc3_:String = KEYS.Get("mail_defaulttruceaccept");
         if(Message.getNotWS(msg_txt.text).length > 1)
         {
            _loc3_ = msg_txt.text;
         }
         var _loc4_:Array = [["threadid",this.data.threadid],["targetid",_loc2_],["targetbaseid",0],["type","truceaccept"],["subject",this.subject],["message",_loc3_]];
         var _loc5_:URLLoaderApi;
         (_loc5_ = new URLLoaderApi()).load(GLOBAL._apiURL + "player/sendmessage",_loc4_,this.onTruceAcceptSuccess,this.onFail);
         acceptBtn.Enabled = denyBtn.Enabled = sendBtn.Enabled = false;
         acceptBtn.removeEventListener(MouseEvent.CLICK,this.truceAccept);
         denyBtn.removeEventListener(MouseEvent.CLICK,this.truceReject);
         this.onMsgFocusOut();
         this.sending = true;
         this.Validate();
      }
      
      private function truceReject(param1:MouseEvent) : void
      {
         SOUNDS.Play("click1");
         var _loc2_:uint = this.data.userid;
         var _loc3_:String = KEYS.Get("mail_defaulttrucereject");
         if(Message.getNotWS(msg_txt.text).length > 1)
         {
            _loc3_ = msg_txt.text;
         }
         var _loc4_:Array = [["threadid",this.data.threadid],["targetid",_loc2_],["targetbaseid",0],["type","trucereject"],["subject",this.subject],["message",_loc3_]];
         var _loc5_:URLLoaderApi;
         (_loc5_ = new URLLoaderApi()).load(GLOBAL._apiURL + "player/sendmessage",_loc4_,this.onTruceRejectSuccess,this.onFail);
         this.sending = true;
         this.Validate();
         acceptBtn.Enabled = denyBtn.Enabled = sendBtn.Enabled = viewBtn.Enabled = false;
         this.onMsgFocusOut();
      }
      
      private function migrateAccept(param1:MouseEvent) : void
      {
         SOUNDS.Play("click1");
         if(MapRoomManager.instance.isInMapRoom3)
         {
            GLOBAL.Message(KEYS.Get("msg_invalid_mr2_invitation_in_mr3"));
            return;
         }
         MapRoom.inviteBaseID = this.data.baseID;
         MapRoom.migrateThread = this;
         MapRoom.PreAcceptInvitation(this.parent);
      }
      
      private function migrateReject(param1:MouseEvent) : void
      {
         SOUNDS.Play("click1");
         if(MapRoomManager.instance.isInMapRoom3)
         {
            return;
         }
         MapRoom.inviteBaseID = this.data.baseID;
         MapRoom.migrateThread = this;
         MapRoom.RejectInvitation(param1);
      }
      
      private function migrateRevoke(param1:MouseEvent) : void
      {
         SOUNDS.Play("click1");
         var _loc2_:uint = this.data.userid;
         var _loc3_:Contact = Contact.contactWithUserId(this.data.convo[0].userid,true);
         var _loc4_:String = _loc3_.firstname;
         var _loc5_:String = KEYS.Get("invite_revoke",{"v1":_loc4_});
         var _loc6_:Array = [["threadid",this.data.threadid],["targetid",_loc2_],["targetbaseid",0],["type","migraterevoke"],["subject",this.subject],["message",_loc5_]];
         var _loc7_:URLLoaderApi;
         (_loc7_ = new URLLoaderApi()).load(GLOBAL._apiURL + "player/sendmessage",_loc6_,this.onMigrateRevokeSuccess,this.onFail);
         this.sending = true;
         this.Validate();
         acceptBtn.Enabled = denyBtn.Enabled = sendBtn.Enabled = viewBtn.Enabled = false;
         this.onMsgFocusOut();
      }
      
      private function migrateView(param1:MouseEvent) : void
      {
         if(MapRoomManager.instance.isInMapRoom3)
         {
            GLOBAL.Message(KEYS.Get("msg_invalid_mr2_invitation_in_mr3"));
            return;
         }
         if(ALLIANCES._myAlliance)
         {
            GLOBAL.Message(KEYS.Get("msg_mustleavealliance"));
            return;
         }
         SOUNDS.Play("click1");
         GLOBAL._currentCell = null;
         MapRoom._Setup(this.data.coords,this.data.worldID,this.data.baseID,true,this);
         MapRoomManager.instance.Show();
      }
      
      private function onMigrateAcceptSuccess(param1:Object) : void
      {
         if(param1.error != undefined && param1.error != 0)
         {
            LOGGER.Log("err","error on migrate accept " + param1.error);
            return;
         }
         this.data.migratestate = "accepted";
         this.data.Changed();
         MailBox.ShowInbox();
         var _loc2_:String = Contact.contactWithUserId(this.data.convo[0].userid).firstname;
         this.sending = false;
      }
      
      private function onMigrateRejectSuccess(param1:Object) : void
      {
         if(param1.error != 0)
         {
            return;
         }
         this.data.migratestate = "rejected";
         this.data.Changed();
         MailBox.ShowInbox();
         this.sending = false;
      }
      
      private function onMigrateRevokeSuccess(param1:Object) : void
      {
         if(param1.error != 0)
         {
            return;
         }
         this.data.migratestate = "revoked";
         this.data.Changed();
         MailBox.ShowInbox();
         this.sending = false;
      }
      
      private function sendDown(param1:MouseEvent) : void
      {
         if(!this.Validate())
         {
            return;
         }
         var _loc2_:uint = this.data.targetid;
         stage.focus = null;
         var _loc3_:String = msg_txt.text;
         var _loc4_:Array = [["threadid",this.data.threadid],["targetid",_loc2_],["targetbaseid",0],["type","message"],["subject",this.subject],["message",_loc3_]];
         var _loc5_:URLLoaderApi;
         (_loc5_ = new URLLoaderApi()).load(GLOBAL._apiURL + "player/sendmessage",_loc4_,this.onSuccess,this.onFail);
         this.sending = true;
         this.Validate();
      }
      
      private function onTruceAcceptSuccess(param1:Object) : void
      {
         if(param1.error != undefined && param1.error != 0)
         {
            LOGGER.Log("err","error on truce accept " + param1.error);
            return;
         }
         this.data.trucestate = "accepted";
         this.data.Changed();
         MailBox.ShowInbox();
         var _loc2_:String = Contact.contactWithUserId(this.data.convo[0].userid).firstname;
         MAPROOM.TruceAccepted(_loc2_,"");
         this.sending = false;
      }
      
      private function onTruceRejectSuccess(param1:Object) : void
      {
         if(param1.error != 0)
         {
            return;
         }
         this.data.trucestate = "rejected";
         this.data.Changed();
         MailBox.ShowInbox();
         this.sending = false;
      }
      
      private function onSuccess(param1:Object) : void
      {
         if(param1.error != undefined && param1.error != 0)
         {
            LOGGER.Log("err","message error - " + param1.error);
         }
         ++this.data.messagecount;
         this.data.Changed();
         this.sending = false;
      }
      
      private function onFail(param1:IOErrorEvent) : void
      {
         this.sending = false;
      }
      
      public function scrollToMember(param1:ThreadMember) : void
      {
      }
      
      public function heightForThread() : Number
      {
         return 100;
      }

      public function ScaleUp() : void
      {
         if (Capabilities.playerType == EnumPlayerType.DESKTOP)
         {
            DisplayScaler.scaleElement(this);
         }
      }
   }
}
