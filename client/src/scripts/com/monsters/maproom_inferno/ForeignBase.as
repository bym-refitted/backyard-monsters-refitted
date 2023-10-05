package com.monsters.maproom_inferno
{
   import com.monsters.maproom_inferno.model.BaseObject;
   import com.monsters.maproom_inferno.views.MapBasePopup;
   import flash.display.Loader;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   
   public class ForeignBase extends ForeignBaseInferno_CLIP
   {
       
      
      public var mapX:uint;
      
      public var mapY:uint;
      
      public var attackBtn:Button;
      
      public var helpBtn:Button;
      
      public var truceBtn:Button;
      
      public var msgBtn:Button;
      
      private var loadingImage:Boolean = false;
      
      public var offState:Sprite;
      
      private var nameMargin:uint = 10;
      
      private var _state:String;
      
      private var mouseTimer:Timer;
      
      private var pin:Sprite;
      
      private var currentHitArea:SimpleButton;
      
      public var data:BaseObject;
      
      public var colorCode:uint;
      
      public var image:Sprite;
      
      public var nameBox:Sprite;
      
      public var popUp:MapBasePopup;
      
      public var handler:com.monsters.maproom_inferno.PlayerHandler;
      
      public var loader:Loader;
      
      private var imageLoadState:uint = 0;
      
      public function ForeignBase()
      {
         super();
         this.popUp = new MapBasePopup();
         this.popUp.title_txt.htmlText = "<b>" + KEYS.Get("map_options") + "</b>";
         this.popUp.x = 21;
         this.popUp.y = 40;
         this.addChild(this.popUp);
      }
      
      public function Setup(param1:BaseObject) : void
      {
         var _loc2_:uint = 0;
         this.data = param1;
         if(this.data.friend.Get() == 1)
         {
            this.colorCode = PushPin.GREEN;
         }
         else if(this.data.attacksfrom.Get() == 0 && this.data.attacksto.Get() == 0)
         {
            this.colorCode = PushPin.YELLOW;
         }
         else if(this.data.attacksto.Get() > this.data.attacksfrom.Get())
         {
            this.colorCode = PushPin.ORANGE;
         }
         else if(this.data.attacksto.Get() < this.data.attacksfrom.Get())
         {
            this.colorCode = PushPin.RED;
         }
         this.loader = new Loader();
         removeChild(this.popUp);
         this.attackBtn = this.popUp.attackBtn;
         this.helpBtn = this.popUp.helpBtn;
         this.truceBtn = this.popUp.truceBtn;
         this.msgBtn = this.popUp.msgBtn;
         this.offState = new Sprite();
         this.offState.mouseChildren = false;
         this.image = new Sprite();
         this.image.addChild(photoFrame_mc);
         this.image.addChild(placeholder);
         this.image.addChild(frame_mc);
         this.offState.addChild(this.image);
         this.nameBox = new Sprite();
         this.nameBox.addChild(box_mc);
         this.nameBox.addChild(name_txt);
         this.offState.addChild(this.nameBox);
         this.nameBox.x = -2;
         addChild(nail);
         removeChild(smallhit);
         removeChild(largehit);
         name_txt.autoSize = TextFieldAutoSize.LEFT;
         name_txt.htmlText = "<b>" + this.data.ownerName.toUpperCase() + "</b>";
         name_txt.x = name_txt.textWidth * -0.5;
         var _loc3_:Number = name_txt.textWidth + 2 * 7;
         box_mc.width = _loc3_ < 51 ? 51 : _loc3_;
         level.lv_txt.htmlText = "<b>" + param1.level.Get();
         this.attackBtn.Setup(KEYS.Get("map_attack_btn"));
         this.helpBtn.Setup(KEYS.Get("map_help_btn"));
         this.truceBtn.Setup(KEYS.Get("map_truce_btn"));
         this.msgBtn.Setup(KEYS.Get("map_message_btn"));
         removeChild(mediumhit);
         this.setState("off");
         addEventListener(MouseEvent.MOUSE_OVER,this.thisOver);
         addEventListener(MouseEvent.MOUSE_DOWN,this.thisDown);
         param1.addEventListener(Event.CHANGE,this.Update);
         this.mouseTimer = new Timer(400);
         this.mouseTimer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.mouseTimer.start();
         this.handler = new com.monsters.maproom_inferno.PlayerHandler();
         this.Update();
      }
      
      public function setState(param1:String) : void
      {
         var LoadImageError:Function;
         var state:String = param1;
         if(state == "off")
         {
            addChildAt(this.offState,0);
            this.currentHitArea = smallhit;
            if(!this.loadingImage && this.data.pic && this.data.pic.length > 5 && this.imageLoadState == 0)
            {
               try
               {
                  LoadImageError = function(param1:IOErrorEvent):void
                  {
                  };
                  this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onPortraitComplete);
                  this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,LoadImageError,false,0,true);
                  this.loader.load(new URLRequest(this.data.pic),new LoaderContext(true));
                  this.imageLoadState = 1;
               }
               catch(e:Error)
               {
                  DescentMapRoom.BRIDGE.Log("err","ForeignBase state set: " + e.errorID + " - " + e.getStackTrace());
               }
            }
            if(this.contains(this.popUp))
            {
               removeChild(this.popUp);
            }
         }
         else if(state == "down")
         {
            this.currentHitArea = largehit;
            addChild(this.popUp);
            this.popUp.Show();
         }
         this._state = state;
         dispatchEvent(new Event(state));
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      private function thisOver(param1:MouseEvent) : void
      {
         if(this._state == "off")
         {
            this.setState("over");
         }
      }
      
      private function thisDown(param1:MouseEvent) : void
      {
         if(this._state == "off" || this._state == "over")
         {
            this.setState("down");
         }
      }
      
      private function onPortraitComplete(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = placeholder.x;
         _loc3_ = placeholder.y;
         this.imageLoadState = 2;
         this.loader.width = this.loader.height = 44;
         this.image.addChildAt(this.loader,this.image.numChildren - 1);
         this.loader.x = _loc2_;
         this.loader.y = _loc3_;
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         if(this._state != "off")
         {
            if(mouseX < this.currentHitArea.x || mouseX > this.currentHitArea.x + this.currentHitArea.width || mouseY < this.currentHitArea.y || mouseY > this.currentHitArea.y + this.currentHitArea.height)
            {
               this.setState("off");
            }
         }
      }
      
      public function Update(param1:Event = null) : void
      {
         this.handler.configure(this);
      }
   }
}
