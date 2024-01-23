package com.monsters.mailbox.model
{
   import com.monsters.mailbox.MailBox;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.geom.Point;
   
   public class ThreadData extends EventDispatcher
   {
       
      
      public var convo:Array;
      
      public var sendtime:Number;
      
      public var userid:Number;
      
      public var targetid:Number;
      
      public var threadid:Number;
      
      public var messagetype:String;
      
      public var unread:Boolean;
      
      public var messageid:Number;
      
      public var truceid:Number;
      
      public var subject:String;
      
      public var messagecount:int;
      
      public var reported:Boolean;
      
      public var threadLoaded:Boolean = false;
      
      public var trucestate:String;
      
      public var flagged:Boolean;
      
      public var migratestate:String;
      
      public var coords:Point;
      
      public var worldID:int;
      
      public var baseID:int;
      
      public function ThreadData(param1:Object)
      {
         super();
         this.Setup(param1);
      }
      
      public function Setup(param1:Object) : void
      {
         this.sendtime = param1.updatetime;
         this.userid = param1.userid;
         this.targetid = param1.targetid;
         this.threadid = param1.threadid;
         this.messagetype = param1.messagetype;
         this.flagged = false;
         if(param1.trucestate != undefined)
         {
            this.trucestate = param1.trucestate;
         }
         if(param1.migratestate != undefined)
         {
            this.migratestate = param1.migratestate;
            if(Boolean(param1.coords) && param1.coords.length > 1)
            {
               this.coords = new Point(param1.coords[0],param1.coords[1]);
            }
            if(param1.worldid)
            {
               this.worldID = param1.worldid;
            }
            if(param1.baseid)
            {
               this.baseID = param1.baseid;
            }
         }
         this.unread = param1.unread == 1;
         this.reported = param1.reportid > 0;
         this.messageid = param1.messageid;
         this.truceid = param1.truceid;
         this.subject = param1.subject;
         this.messagecount = param1.messagecount;
         this.convo = [];
      }
      
      public function loadThread() : void
      {
         var _loc1_:URLLoaderApi = new URLLoaderApi();
         var _loc2_:Array = [["threadid",this.threadid]];
         _loc1_.load(GLOBAL._apiURL + "player/getmessagethread",_loc2_,this.handleLoadSuccessful,this.handleLoadError);
      }
      
      private function handleLoadSuccessful(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         if(param1.error != 0)
         {
            MailBox.ShowInbox();
         }
         else
         {
            this.convo = [];
            for(_loc2_ in param1.thread)
            {
               if(param1.thread[_loc2_].message)
               {
                  _loc3_ = param1.thread[_loc2_];
                  this.convo.push(_loc3_);
               }
            }
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      public function Changed() : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function handleLoadError(param1:IOErrorEvent) : void
      {
         LOGGER.Log("err","IOError opening threadid " + this.threadid);
      }
      
      override public function toString() : String
      {
         return "[object ThreadData subject: " + this.subject + " threadLoaded: " + this.threadLoaded + " userid: " + this.userid + " targetid: " + this.targetid + " ]";
      }
   }
}
