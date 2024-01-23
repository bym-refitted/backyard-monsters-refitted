package com.monsters.mailbox
{
   import com.monsters.mailbox.model.ThreadData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import gs.TweenLite;
   
   public class Inbox extends Inbox_CLIP
   {
      
      public static var sent:Array;
      
      public static var recd:Array;
      
      public static var all:Array;
      
      public static var _instance:Inbox;
       
      
      public var config:Array;
      
      private var currentConfig:int = -1;
      
      public var activeBox:Array;
      
      private var rowsPerPage:uint = 6;
      
      private var shell:Sprite;
      
      public var currentPage:uint = 0;
      
      public var pageLimit:uint;
      
      private var currentSorter:MovieClip;
      
      private var currentSort:String;
      
      private var reversed:Boolean = false;
      
      public var _sorters:Sprite;
      
      private var firstLoaded:Boolean = false;
      
      public function Inbox()
      {
         var _loc2_:MovieClip = null;
         super();
         (mcFrame as frame).Setup(true,MailBox.Hide);
         newBtn.SetupKey("btn_compose");
         newBtn.addEventListener(MouseEvent.CLICK,this.onNewDown);
         this._sorters = new Sprite();
         addChild(this._sorters);
         bPrevious.Trigger();
         bNext.Trigger();
         bNext.visible = bPrevious.visible = false;
         bPrevious.buttonMode = bNext.buttonMode = true;
         var _loc1_:Array = [fromBtn,subjectBtn,dateBtn,unreadBtn];
         for each(_loc2_ in _loc1_)
         {
            _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.sortHandler);
            _loc2_.mouseChildren = false;
            _loc2_.buttonMode = true;
            _loc2_.useHandCursor = true;
            _loc2_.sorter_mc.gotoAndStop(1);
            removeChild(_loc2_);
         }
         noMessages_btn.visible = false;
         noMessages_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.onNewDown);
         noMessages_btn.useHandCursor = true;
         noMessages_btn.buttonMode = true;
         noMessages_btn.mouseChildren = false;
         this.config = [{
            "controls":[fromBtn,subjectBtn,dateBtn,unreadBtn],
            "button":inBtn,
            "itemMode":"inbox",
            "defaultSorter":dateBtn
         },{
            "controls":[subjectBtn,dateBtn],
            "button":outBtn,
            "itemMode":"outbox",
            "defaultSorter":dateBtn
         },{
            "controls":[fromBtn,subjectBtn,dateBtn,unreadBtn],
            "button":outBtn,
            "itemMode":"all",
            "defaultSorter":dateBtn
         }];
         inBtn.SetupKey("btn_inbox");
         outBtn.SetupKey("btn_outbox");
         removeChild(inBtn);
         removeChild(outBtn);
         addEventListener(Event.ADDED_TO_STAGE,this.onAdd);
         title_txt.htmlText = KEYS.Get("mail_title");
         noMessages_btn.label_txt.htmlText = "<b>" + KEYS.Get("mail_nomessages") + "</b>";
         _instance = this;
      }
      
      public static function openThread(param1:ThreadData) : void
      {
         var _loc2_:Thread = new Thread();
         _loc2_._mc = _loc2_;
         _loc2_.Setup(param1);
         MailBox.ShowThread(_loc2_);
      }
      
      private static function onThreadOpen(param1:Event) : void
      {
         var _loc2_:ThreadData = InboxMessage(param1.target).data;
         openThread(_loc2_);
      }
      
      public static function pushNewMessage(param1:ThreadData) : void
      {
         var _loc2_:InboxMessage = new InboxMessage();
         _loc2_.Setup(param1);
         _loc2_.addEventListener("open",onThreadOpen);
         if(param1.targetid == LOGIN._playerID || param1.messagecount > 1)
         {
            recd.push(_loc2_);
         }
         else
         {
            sent.push(_loc2_);
         }
         all.push(_loc2_);
      }
      
      private function onAdd(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAdd);
      }
      
      public function showIn(... rest) : void
      {
         inBtn.Highlight = true;
         outBtn.Highlight = false;
         this.activeBox = all;
         this.configureForObjectIndex(2);
      }
      
      public function showOut(... rest) : void
      {
         inBtn.Highlight = false;
         outBtn.Highlight = true;
         this.configureForObjectIndex(2);
      }
      
      public function configureForObjectIndex(param1:uint = 0) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc2_:Object = this.config[param1];
         if(this.currentConfig >= 0)
         {
            for each(_loc4_ in this.config[this.currentConfig].controls)
            {
               if(this._sorters.contains(_loc4_))
               {
                  this._sorters.removeChild(_loc4_);
               }
            }
         }
         for each(_loc3_ in _loc2_.controls)
         {
            this._sorters.addChild(_loc3_);
         }
         this.currentConfig = param1;
         this.currentSort = "";
         this.reversed = true;
         _loc2_.defaultSorter.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
      }
      
      public function Setup() : void
      {
         this.shell = new Sprite();
         addChild(this.shell);
         this.shell.mask = mask_mc;
         sent = new Array();
         recd = new Array();
         all = new Array();
         this.Tick();
      }
      
      public function Tick(... rest) : void
      {
         var _loc2_:URLLoaderApi = new URLLoaderApi();
         _loc2_.load(GLOBAL._apiURL + "player/getmessagethreads",[],this.handleLoadSuccessful,this.handleLoadError);
      }
      
      private function handleLoadSuccessful(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:uint = 0;
         var _loc6_:ThreadData = null;
         var _loc7_:Number = NaN;
         var _loc8_:ThreadData = null;
         var _loc2_:Boolean = false;
         for(_loc3_ in param1.threads)
         {
            _loc4_ = false;
            _loc5_ = 0;
            while(_loc5_ < all.length)
            {
               if(all[_loc5_].data.threadid == param1.threads[_loc3_].threadid)
               {
                  _loc4_ = true;
                  _loc7_ = (_loc6_ = all[_loc5_].data).sendtime;
                  _loc6_.Setup(param1.threads[_loc3_]);
                  if(_loc7_ != _loc6_.sendtime)
                  {
                     _loc6_.Changed();
                  }
               }
               _loc5_++;
            }
            if(!_loc4_)
            {
               (_loc8_ = new ThreadData(param1.threads[_loc3_])).addEventListener(Event.CHANGE,this.listenForFlagging);
               pushNewMessage(_loc8_);
               _loc2_ = true;
            }
         }
         if(!this.firstLoaded)
         {
            this.firstLoaded = true;
            inBtn.addEventListener(MouseEvent.CLICK,this.showIn);
            outBtn.addEventListener(MouseEvent.CLICK,this.showOut);
            dispatchEvent(new Event(Event.COMPLETE));
            this.showIn();
            this.showInB();
         }
         else if(_loc2_)
         {
            this.showIn();
         }
      }
      
      public function showInB() : void
      {
         var _loc1_:int = 0;
         if(MAILBOX._threadidToOpen != -1)
         {
            _loc1_ = 0;
            while(_loc1_ < all.length)
            {
               if(all[_loc1_].data.threadid == MAILBOX._threadidToOpen)
               {
                  openThread(all[_loc1_].data);
                  break;
               }
               _loc1_++;
            }
         }
         MAILBOX._threadidToOpen = -1;
      }
      
      public function listenForFlagging(param1:Event) : void
      {
         var _loc2_:ThreadData = param1.target as ThreadData;
         if(_loc2_.flagged)
         {
            this.displayArray(all);
            this.scrollToPage(0);
         }
      }
      
      public function displayArray(param1:Array) : void
      {
         var _loc6_:InboxMessage = null;
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            if(!param1[_loc3_].data.flagged)
            {
               _loc2_.push(param1[_loc3_]);
            }
            _loc3_++;
         }
         this.cleanup();
         if(_loc2_.length == 0)
         {
            noMessages_btn.visible = true;
            this._sorters.visible = false;
            this.shell.visible = false;
         }
         else
         {
            this.shell.visible = true;
            noMessages_btn.visible = false;
            this._sorters.visible = true;
         }
         if(_loc2_.length > this.rowsPerPage)
         {
            bNext.addEventListener(MouseEvent.MOUSE_DOWN,this.nextDown);
            bPrevious.addEventListener(MouseEvent.MOUSE_DOWN,this.prevDown);
            this.pageLimit = Math.floor((_loc2_.length - 1) / this.rowsPerPage);
            bNext.visible = true;
            bPrevious.visible = true;
         }
         else
         {
            bNext.visible = false;
            bPrevious.visible = false;
         }
         var _loc4_:uint = 50;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc6_ = _loc2_[_loc5_];
            this.shell.addChild(_loc6_);
            _loc6_.x = 76 + mask_mc.width * Math.floor(_loc5_ / this.rowsPerPage);
            _loc6_.y = 126 + _loc5_ * _loc4_ - this.rowsPerPage * _loc4_ * Math.floor(_loc5_ / this.rowsPerPage);
            _loc5_++;
         }
      }
      
      private function nextDown(param1:MouseEvent) : void
      {
         SOUNDS.Play("click1");
         if(this.currentPage < this.pageLimit)
         {
            this.scrollToPage(this.currentPage + 1);
         }
      }
      
      private function prevDown(param1:MouseEvent) : void
      {
         SOUNDS.Play("click1");
         if(this.currentPage > 0)
         {
            this.scrollToPage(this.currentPage - 1);
         }
      }
      
      public function scrollToPage(param1:uint = 0) : void
      {
         this.currentPage = param1;
         TweenLite.to(this.shell,0.3,{"x":-param1 * mask_mc.width});
         var _loc2_:uint = (param1 + 1) * this.rowsPerPage > this.activeBox.length ? this.activeBox.length : uint((param1 + 1) * this.rowsPerPage);
         var _loc3_:uint = param1 * this.rowsPerPage;
         while(_loc3_ < _loc2_)
         {
            this.activeBox[_loc3_].shouldLoadImage();
            _loc3_++;
         }
         if(this.currentPage > 0)
         {
            bPrevious.Trigger(true);
         }
         else
         {
            bPrevious.Trigger(false);
         }
         if(this.currentPage < this.pageLimit)
         {
            bNext.Trigger(true);
         }
         else
         {
            bNext.Trigger(false);
         }
      }
      
      private function cleanup() : void
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this.shell.numChildren)
         {
            _loc1_.push(this.shell.getChildAt(_loc2_));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc1_[_loc2_].parent.removeChild(_loc1_[_loc2_]);
            _loc2_++;
         }
      }
      
      private function handleLoadError(param1:IOErrorEvent) : void
      {
      }
      
      private function onNewDown(param1:MouseEvent) : void
      {
         var mess:Message = null;
         var e:MouseEvent = param1;
         SOUNDS.Play("click1");
         mess = new Message();
         mess.addEventListener(Event.COMPLETE,this.showOut);
         GLOBAL.BlockerAdd();
         GLOBAL._layerWindows.addChild(mess);
         mess.init();
         mess.successHandler = function(param1:Object):void
         {
            var _loc2_:ThreadData = new ThreadData({
               "sendtime":GLOBAL.Timestamp(),
               "threadid":param1.threadid,
               "userid":LOGIN._playerID,
               "targetid":mess.picker.getCurrentData().userid,
               "messagetype":"message",
               "unread":0,
               "messageid":param1.messageid,
               "truceid":0,
               "subject":mess.subject_txt.text,
               "messagecount":1
            });
            Inbox.pushNewMessage(_loc2_);
            reversed = false;
            currentSorter = null;
            currentSort = null;
            dateBtn.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
         };
      }
      
      private function sortHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         if(this.currentSorter)
         {
            this.currentSorter.sorter_mc.gotoAndStop(1);
            this.currentSorter.gotoAndStop(1);
         }
         switch(param1.target)
         {
            case fromBtn:
               _loc2_ = "firstname";
               break;
            case subjectBtn:
               _loc2_ = "subject";
               break;
            case dateBtn:
               _loc2_ = "sendtime";
               break;
            case unreadBtn:
               _loc2_ = "unread";
         }
         var _loc3_:Boolean = _loc2_ == "firstname" || _loc2_ == "subject" ? true : false;
         var _loc4_:uint = _loc3_ ? Array.CASEINSENSITIVE : Array.NUMERIC;
         if(this.currentSort == _loc2_)
         {
            this.reversed = !this.reversed;
            if(this.reversed == _loc3_)
            {
               _loc4_ |= Array.DESCENDING;
            }
         }
         else
         {
            if(!_loc3_)
            {
               _loc4_ |= Array.DESCENDING;
            }
            this.reversed = false;
         }
         if(this.reversed)
         {
            param1.target.sorter_mc.gotoAndStop(3);
         }
         else
         {
            param1.target.sorter_mc.gotoAndStop(2);
         }
         var _loc5_:Array = this.activeBox.sortOn(_loc2_,_loc4_);
         this.currentSort = _loc2_;
         this.currentSorter = param1.target as MovieClip;
         this.currentSorter.gotoAndStop(2);
         this.displayArray(_loc5_);
         this.scrollToPage(0);
      }
      
      public function Resize() : void
      {
         this.x = GLOBAL._SCREENCENTER.x;
         this.y = GLOBAL._SCREENCENTER.y;
      }
   }
}
