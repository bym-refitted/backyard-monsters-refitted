package com.monsters.mailbox
{
   import com.monsters.mailbox.model.Contact;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.text.TextFieldAutoSize;
   
   public class ThreadMember extends ThreadMember_CLIP
   {
       
      
      public var bg_mc:MovieClip;
      
      public var loader:Loader;
      
      public var data:Object;
      
      public var margin:uint = 10;
      
      public var left:Object;
      
      public var right:Object;
      
      private var configuration:Object;
      
      public function ThreadMember()
      {
         super();
         this.left = {
            "imageX":0,
            "bg":leftbg_mc,
            "txtX":77,
            "txtLayout":TextFieldAutoSize.LEFT
         };
         this.right = {
            "imageX":327,
            "bg":rightbg_mc,
            "txtX":3,
            "txtLayout":TextFieldAutoSize.RIGHT
         };
         this.setOrientation("left");
      }
      
      public function Setup(param1:Object) : void
      {
         body_txt.autoSize = this.configuration.txtLayout;
         body_txt.text = param1.message;
         this.configuration.bg.height = int(body_txt.height + this.margin * 2);
         this.configuration.bg.y = this.margin + int(0.5 * this.configuration.bg.height - this.margin);
         this.data = param1;
      }
      
      public function setOrientation(param1:String) : void
      {
         this.configuration = param1 == "left" ? this.left : this.right;
         var _loc2_:Object = param1 == "left" ? this.right : this.left;
         this.bg_mc = this.configuration.bg;
         placeholder.x = this.configuration.imageX;
         _loc2_.bg.visible = false;
         this.configuration.bg.visible = true;
         this.configuration.bg.height = int(body_txt.height + this.margin * 2);
         this.configuration.bg.y = this.margin + int(0.5 * this.configuration.bg.height - this.margin);
         photoRing.x = placeholder.x;
         photoRing.y = placeholder.y;
         body_txt.x = this.configuration.txtX;
         body_txt.autoSize = this.configuration.txtLayout;
      }
      
      public function getVisibleHeight() : int
      {
         return this.bg_mc.height > 50 ? int(this.bg_mc.height) : 50;
      }
      
      public function shouldLoadImage() : void
      {
         var _loc1_:Contact = null;
         var _loc2_:String = null;
         if(!this.loader)
         {
            _loc1_ = Contact.contactWithUserId(this.data.userid,true);
            if(!_loc1_)
            {
               return;
            }
            _loc2_ = _loc1_.pic;
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onImgComplete);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onErr);
            try
            {
               this.loader.load(new URLRequest(_loc2_));
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
         setChildIndex(photoRing,this.numChildren - 1);
      }
   }
}
