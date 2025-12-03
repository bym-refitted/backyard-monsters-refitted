package com.monsters.mailbox
{
   import com.monsters.enums.EnumPlayerType;
   import com.monsters.mailbox.model.Contact;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.system.Capabilities;
   import utils.DisplayScaler;
   
   public class MailBox extends Sprite
   {
      
      public static var contacts:Array;
      
      private static var instance:MailBox;
      
      public static var currentThread:Thread;
       
      
      public var inbox:Inbox;
      
      public function MailBox()
      {
         super();
         instance = this;
      }
      
      public static function Hide(param1:MouseEvent = null) : void
      {
         if(currentThread)
         {
            currentThread.prepareForKill();
         }
         currentThread = null;
         MAILBOX.Hide();
      }
      
      public static function ShowInbox(... rest) : void
      {
         if(currentThread)
         {
            SOUNDS.Play("close");
            currentThread.prepareForKill();
            GLOBAL.BlockerRemove();
            if(currentThread.parent)
            {
               currentThread.parent.removeChild(currentThread);
            }
            currentThread = null;
         }
         instance.addChild(instance.inbox);
      }
      
      public static function ShowThread(param1:Thread) : void
      {
         GLOBAL.BlockerAdd();
         GLOBAL._layerWindows.addChild(param1);
         param1.ScaleUp();
         param1.x = 100;
         param1.y = -15;
         currentThread = param1;
      }
      
      public function Setup() : void
      {
         contacts = [];
         var _loc1_:Contact = new Contact(String(LOGIN._playerID),{
            "first_name":"Me",
            "last_name":"",
            "pic_square":LOGIN._playerPic
         },true);
         var _loc2_:Contact = new Contact("0",{
            "first_name":"D.A.V.E.",
            "last_name":"",
            "pic_square":""
         },true);
         _loc2_.picClass = system_message;
         var _loc3_:URLLoaderApi = new URLLoaderApi();
         _loc3_.load(GLOBAL._apiURL + "player/getmessagetargets",null,this.onTargetsSuccess,this.onTargetsFail);
      }
      
      public function Tick() : void
      {
         if(this.inbox)
         {
            this.inbox.Tick();
         }
      }
      
      private function onTargetsSuccess(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:Contact = null;
         var _loc2_:Boolean = false;
         for(_loc3_ in param1.targets)
         {
            _loc4_ = new Contact(_loc3_,param1.targets[_loc3_]);
            contacts.push(_loc4_);
         }
         this.inbox = new Inbox();
         this.inbox.addEventListener(Event.COMPLETE,this.onInboxInit);
         this.inbox.Setup();
         ShowInbox();
      }
      
      private function onInboxInit(param1:Event) : void
      {
      }
      
      private function onTargetsFail(param1:IOErrorEvent) : void
      {
         Hide();
      }
      
      public function Resize() : void
      {
         this.x = 0;
         this.y = 0;
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
