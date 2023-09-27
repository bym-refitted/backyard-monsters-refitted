package com.monsters.maproom_inferno
{
   import com.monsters.display.ImageCache;
   import com.monsters.maproom.WildMonsterBaseInfo;
   import com.monsters.maproom_inferno.model.BaseObject;
   import com.monsters.maproom_inferno.views.MapBasePopup;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   
   public class WildMonsterBase extends WildMonsterBaseInferno_CLIP
   {
       
      
      public var mapX:uint;
      
      public var mapY:uint;
      
      public var attackBtn:Button;
      
      public var helpBtn:Button;
      
      private var loadingImage:Boolean = false;
      
      public var offState:Sprite;
      
      public var overState:Sprite;
      
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
      
      public var imageLoadState:uint = 0;
      
      public var info_mc:WildMonsterBaseInfo;
      
      public function WildMonsterBase()
      {
         super();
         this.popUp = new MapBasePopup();
         this.popUp.title_txt.htmlText = "<b>" + KEYS.Get("map_options") + "</b>";
         this.popUp.x = 21;
         this.popUp.y = 40;
         this.addChild(this.popUp);
         this.info_mc = new WildMonsterBaseInfo();
         this.info_mc.x = 22;
         this.info_mc.y = 10;
         this.addChild(this.info_mc);
      }
      
      public function Setup(param1:BaseObject) : void
      {
         this.data = param1;
         this.colorCode = PushPin.RED;
         this.loader = new Loader();
         removeChild(this.popUp);
         this.attackBtn = this.popUp.attackBtn;
         this.helpBtn = this.popUp.helpBtn;
         this.popUp.setHeightForButtons(2);
         this.popUp.removeChild(this.popUp.truceBtn);
         this.popUp.removeChild(this.popUp.msgBtn);
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
         this.overState = new Sprite();
         this.overState.mouseChildren = false;
         this.overState.addChild(this.info_mc);
         removeChild(smallhit);
         removeChild(largehit);
         name_txt.autoSize = TextFieldAutoSize.LEFT;
         level_txt.htmlText = "<b>" + this.data.level.Get().toString() + "</b>";
         name_txt.htmlText = "<b>" + KEYS.Get("inf_ai_tribe_mapview",{"v1":this.data.ownerName}).toUpperCase() + "</b>";
         name_txt.x = name_txt.textWidth * -0.5;
         var _loc2_:Number = name_txt.textWidth + 2 * 7;
         box_mc.width = _loc2_ < 51 ? 51 : _loc2_;
         this.attackBtn.SetupKey("map_attack_btn");
         this.helpBtn.SetupKey("map_view_btn");
         removeChild(mediumhit);
         this.setState("off");
         addEventListener(MouseEvent.MOUSE_OVER,this.thisOver);
         addEventListener(MouseEvent.MOUSE_DOWN,this.thisDown);
         this.mouseTimer = new Timer(400);
         this.mouseTimer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.mouseTimer.start();
         new com.monsters.maproom_inferno.PlayerHandler().configure(this);
      }
      
      public function setState(param1:String) : void
      {
         var state:String = param1;
         if(state == "off")
         {
            if(this.contains(this.overState))
            {
               removeChild(this.overState);
            }
            addChildAt(this.offState,0);
            this.currentHitArea = smallhit;
            if(!this.loadingImage && this.data.pic.length > 5 && this.imageLoadState == 0)
            {
               try
               {
                  ImageCache.GetImageWithCallBack(this.data.pic,this.onPortraitComplete);
                  this.loadingImage = true;
                  this.imageLoadState = 1;
               }
               catch(e:Error)
               {
                  LOGGER.Log("err","WildMonsterBase state set: " + e.errorID + " - " + e.getStackTrace());
               }
            }
            if(this.contains(this.popUp))
            {
               removeChild(this.popUp);
            }
         }
         else if(state == "down")
         {
            if(this.contains(this.overState))
            {
               removeChild(this.overState);
            }
            this.currentHitArea = largehit;
            addChild(this.popUp);
            this.popUp.Show();
         }
         else if(state == "over")
         {
         }
         this._state = state;
         dispatchEvent(new Event(state));
      }
      
      private function onPortraitComplete(param1:String, param2:BitmapData) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Bitmap = null;
         var _loc3_:int = placeholder.x;
         _loc4_ = placeholder.y;
         this.imageLoadState = 2;
         _loc5_ = new Bitmap(param2);
         _loc5_.width = _loc5_.height = 44;
         this.image.addChildAt(_loc5_,this.image.numChildren - 1);
         _loc5_.x = _loc3_;
         _loc5_.y = _loc4_;
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
   }
}
