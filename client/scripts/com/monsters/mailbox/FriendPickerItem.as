package com.monsters.mailbox
{
   import com.monsters.mailbox.model.Contact;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   
   public class FriendPickerItem extends FriendPickerItem_CLIP
   {
       
      
      public var data:Contact;
      
      public var name_str:String;
      
      private var idleFrameLabel:String;
      
      private var loader:Loader;
      
      public function FriendPickerItem(param1:Contact)
      {
         super();
         this.data = param1;
         var _loc2_:String = param1.lastname.length > 2 ? " " + param1.lastname.charAt(0).toUpperCase() + "." : "";
         this.name_str = param1.firstname.toUpperCase() + _loc2_;
         name_txt.htmlText = "<b>" + this.name_str;
         userid_txt.text = KEYS.Get("label_userid",{"v1":param1.userid});
         this.idleFrameLabel = param1.friend ? "green" : "gray";
         background.gotoAndStop(this.idleFrameLabel);
         this.addEventListener(MouseEvent.MOUSE_OVER,this.thisOver);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.thisOut);
      }
      
      private function thisOver(param1:MouseEvent) : void
      {
         background.gotoAndStop("white");
      }
      
      private function thisOut(param1:MouseEvent) : void
      {
         background.gotoAndStop(this.idleFrameLabel);
      }
      
      public function displayAs(param1:String) : void
      {
      }
      
      public function shouldLoadImage() : void
      {
         if(!this.loader)
         {
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onImgComplete);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onErr);
            try
            {
               if(this.data.pic.length > 5)
               {
                  this.loader.load(new URLRequest(this.data.pic),new LoaderContext(true));
               }
            }
            catch(e:*)
            {
            }
         }
      }
      
      private function onErr(param1:IOErrorEvent) : void
      {
      }
      
      private function onImgComplete(param1:Event) : void
      {
         addChild(this.loader);
         this.loader.x = placeholder.x;
         this.loader.y = placeholder.y;
         this.loader.width = this.loader.height = 50;
         this.setChildIndex(photoRing,this.numChildren - 1);
      }
      
      override public function toString() : String
      {
         return this.name_str;
      }
   }
}
