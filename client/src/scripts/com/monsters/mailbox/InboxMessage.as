package com.monsters.mailbox
{
   import com.monsters.mailbox.model.Contact;
   import com.monsters.mailbox.model.ThreadData;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   
   public class InboxMessage extends InboxMessage_CLIP
   {
       
      
      public var firstname:String;
      
      public var sendtime:Number;
      
      public var subject:String;
      
      public var unread:uint = 0;
      
      public var image;
      
      public var data:ThreadData;
      
      public var isAdmin:Boolean = false;
      
      public function InboxMessage()
      {
         super();
         b1.SetupKey("mail_open_btn");
         b1.addEventListener(MouseEvent.CLICK,this.openDown);
      }
      
      private function openDown(param1:MouseEvent) : void
      {
         SOUNDS.Play("click1");
         dispatchEvent(new Event("open"));
      }
      
      public function Setup(param1:ThreadData) : void
      {
         this.data = param1;
         this.isAdmin = param1.userid == 0;
         this.data.addEventListener(Event.CHANGE,this.displayData);
         this.displayData();
      }
      
      public function displayData(... rest) : void
      {
         var _loc2_:Contact = null;
         var _loc3_:String = null;
         if(this.data.userid == LOGIN._playerID)
         {
            _loc2_ = Contact.contactWithUserId(this.data.targetid);
         }
         else
         {
            _loc2_ = Contact.contactWithUserId(this.data.userid);
         }
         if(this.isAdmin)
         {
            _loc2_ = Contact.contactWithUserId(this.data.userid,true);
         }
         if(_loc2_)
         {
            this.firstname = _loc2_.firstname;
            _loc3_ = _loc2_.lastname.length > 1 ? " " + _loc2_.lastname.charAt(0).toUpperCase() + "." : "";
            sender_txt.htmlText += _loc2_.firstname + _loc3_;
         }
         else
         {
            this.firstname = "";
         }
         bg_mc.gotoAndStop("white");
         if(this.isAdmin)
         {
            bg_mc.gotoAndStop("admin");
         }
         else if(this.data.trucestate)
         {
            if(this.data.trucestate == "requested")
            {
               subjectType_txt.htmlText = "<b>" + KEYS.Get("inbox_trucerequested");
               bg_mc.gotoAndStop("blue");
            }
            else if(this.data.trucestate == "rejected")
            {
               subjectType_txt.htmlText = "<b>" + KEYS.Get("inbox_trucerejected");
               bg_mc.gotoAndStop("red");
            }
            else if(this.data.trucestate == "accepted")
            {
               subjectType_txt.htmlText = "<b>" + KEYS.Get("inbox_truceaccepted");
               bg_mc.gotoAndStop("green");
            }
         }
         if(this.data.unread)
         {
            subject_txt.htmlText = "<b>" + this.data.subject;
            sender_txt.htmlText = "<b>" + this.firstname + _loc3_;
            sent_txt.htmlText = "<b>" + this.getTimeDistanceString(this.data.sendtime);
            this.unread = 1;
            dot_mc.visible = true;
         }
         else
         {
            subject_txt.htmlText = this.data.subject;
            sender_txt.htmlText = this.firstname + _loc3_;
            sent_txt.htmlText = this.getTimeDistanceString(this.data.sendtime);
            this.unread = 0;
            dot_mc.visible = false;
         }
         this.sendtime = this.data.sendtime;
         this.subject = this.data.subject;
         userid_txt.htmlText = KEYS.Get("label_userid",{"v1":this.data.userid});
         replies_txt.htmlText = KEYS.Get("mail_numreplies",{"v1":this.data.messagecount - 1});
      }
      
      public function shouldLoadImage() : void
      {
         var _loc1_:Contact = null;
         var _loc2_:Class = null;
         if(!this.image && !this.isAdmin)
         {
            this.image = new Loader();
            this.image.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onImgComplete);
            this.image.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onErr);
            if(this.data.userid == LOGIN._playerID)
            {
               _loc1_ = Contact.contactWithUserId(this.data.targetid,true);
            }
            else
            {
               _loc1_ = Contact.contactWithUserId(this.data.userid,true);
            }
            if(_loc1_)
            {
               try
               {
                  this.image.load(new URLRequest(_loc1_.pic),new LoaderContext(true));
               }
               catch(e:*)
               {
               }
            }
         }
         else if(this.isAdmin && !this.image)
         {
            _loc2_ = Contact.contactWithUserId(this.data.userid,true).picClass;
            this.image = new _loc2_();
            this.onImgComplete();
         }
      }
      
      private function onErr(param1:IOErrorEvent) : void
      {
      }
      
      private function onImgComplete(param1:Event = null) : void
      {
         addChildAt(this.image,0);
         this.image.x = placeholder.x;
         this.image.y = placeholder.y;
         this.image.width = this.image.height = 50;
         if(this.contains(placeholder))
         {
            removeChild(placeholder);
         }
      }
      
      public function getTimeDistanceString(param1:Number) : String
      {
         var _loc5_:String = null;
         var _loc2_:Number = GLOBAL.Timestamp();
         var _loc3_:int = _loc2_ - param1;
         var _loc4_:int = 0;
         if(_loc3_ < 60)
         {
            _loc5_ = (_loc4_ = _loc3_) == 1 ? "mail_time_second" : "mail_time_seconds";
         }
         else if(_loc3_ < 60 * 60)
         {
            _loc5_ = (_loc4_ = int(_loc3_ / 60)) == 1 ? "mail_time_minute" : "mail_time_minutes";
         }
         else if(_loc3_ < 60 * 60 * 24)
         {
            _loc5_ = (_loc4_ = int(_loc3_ / 60 / 60)) == 1 ? "mail_time_hour" : "mail_time_hours";
         }
         else if(_loc3_ < 60 * 60 * 24 * 7)
         {
            _loc5_ = (_loc4_ = int(_loc3_ / 60 / 60 / 24)) == 1 ? "mail_time_day" : "mail_time_days";
         }
         else if(_loc3_ < 60 * 60 * 24 * 7 * 31)
         {
            _loc5_ = (_loc4_ = int(_loc3_ / 60 / 60 / 24 / 7)) == 1 ? "mail_time_week" : "mail_time_weeks";
         }
         else
         {
            _loc5_ = (_loc4_ = int(_loc3_ / 60 / 60 / 24 / 7 / 31)) == 1 ? "mail_time_month" : "mail_time_months";
         }
         return KEYS.Get("mail_time_ago",{
            "v1":_loc4_,
            "v2":KEYS.Get(_loc5_)
         });
      }
   }
}
