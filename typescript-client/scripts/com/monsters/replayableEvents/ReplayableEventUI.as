package com.monsters.replayableEvents
{
   import com.monsters.chat.Chat;
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   
   public class ReplayableEventUI extends EventsBar_CLIP implements IReplayableEventUI
   {
      
      public static var CLICKED_ACTION:String = "eventBarAction";
      
      public static var CLICKED_INFO:String = "eventBarInfo";
       
      
      private var points:int;
      
      private var _timer:Timer;
      
      private var _phase:int;
      
      private const _finalcountdown:int = 86400;
      
      private var _image:String;
      
      private var _titlelogo:String;
      
      private var _event:ReplayableEvent;
      
      private const BASEIMAGEURL:String = "specialevent/";
      
      private var eventText_tLabel:Array;
      
      private var eventText_barProgressTxt:Array;
      
      private var eventText_bActionTxt:Array;
      
      public function ReplayableEventUI()
      {
         this.eventText_tLabel = ["tLabel","tLabel"];
         this.eventText_barProgressTxt = ["fp_infobar_progressbar","fp_infobar_progressbar"];
         this.eventText_bActionTxt = ["btn_info","btn_info"];
         super();
      }
      
      public function get eventUI() : DisplayObject
      {
         return this;
      }
      
      public function setup(param1:ReplayableEvent) : void
      {
         this._event = param1;
         bHelp.addEventListener(MouseEvent.CLICK,this.ShowInfoPopup);
         bHelp.buttonMode = true;
         var _loc2_:int = 1;
         if(BASE.isInfernoMainYardOrOutpost)
         {
            _loc2_ = 2;
         }
         mcBG.gotoAndStop(_loc2_);
         bAction.gotoAndStop(_loc2_);
         mcLogo.visible = false;
         mcLogo.enabled = false;
         mcLogo.mouseEnabled = false;
         gotoAndStop(this.phase);
         if(Boolean(this._event.buttonCopy) && this.phase > 1)
         {
            bActionTxt.htmlText = this._event.buttonCopy;
            bActionTxt.mouseEnabled = false;
            bActionTxt.visible = true;
            bAction.addEventListener(MouseEvent.CLICK,this.ShowEventPopup);
            bAction.buttonMode = true;
            bAction.visible = true;
            bAction.enabled = true;
            mcBG.width = 290;
            bHelp.x = 272;
         }
         else
         {
            bActionTxt.mouseEnabled = false;
            bActionTxt.visible = false;
            bAction.visible = false;
            bAction.enabled = false;
            mcBG.width = 290;
            bHelp.x = 272;
         }
         this.updateImage();
      }
      
      public function update() : void
      {
         this.Tick();
      }
      
      private function Tick(param1:* = null) : void
      {
         this.updateText();
         this.Resize();
      }
      
      private function get phase() : Number
      {
         if(this._event.hasEventStarted)
         {
            this._phase = 2;
         }
         else
         {
            this._phase = 1;
         }
         return this._phase;
      }
      
      private function updateText() : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         if(tTitle)
         {
            tTitle.htmlText = this._event.name;
            tTitle.mouseEnabled = false;
            if(this._event.titleImage)
            {
               tTitle.visible = false;
            }
         }
         var _loc1_:int = this._event.timeUntilNextDate;
         if(_loc1_ <= 0)
         {
            tLabel.htmlText = "<b>DATE NOT INITIALIZED!</b>";
         }
         else
         {
            _loc2_ = GLOBAL.ToTime(_loc1_,true);
            tLabel.htmlText = "<b>" + _loc2_ + "</b>";
         }
         tLabel.mouseEnabled = false;
         if(currentFrame > 1)
         {
            _loc3_ = 0;
            _loc4_ = this._event.progress;
            _loc5_ = 1;
            _loc5_ = 1;
            _loc4_ = this._event.progress;
            _loc6_ = this.PhaseKey(this.eventText_barProgressTxt);
            _loc3_ = Math.min(100,Math.floor(this._event.progress * 100));
            barProgressTxt.htmlText = "" + _loc6_ + " - " + _loc3_ + " %" + "";
            barProgress.mcBar.width = Math.min(100,this._event.progress * 100);
         }
         else if(this.phase > 1)
         {
            tLabel.htmlText = "<b>" + KEYS.Get("refresh_to_start_event") + "<b>";
         }
      }
      
      private function updateImage() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(Boolean(this._event.imageURL) && this._event.imageURL != this._image)
         {
            _loc1_ = this._event.imageURL;
            this._image = _loc1_;
            ImageCache.GetImageWithCallBack(this._image,this.onImageLoaded);
         }
         if(!this._event.hasEventStarted && this._event.titleImage && this._event.titleImage != this._titlelogo)
         {
            _loc2_ = this._event.titleImage;
            this._titlelogo = _loc2_;
            ImageCache.GetImageWithCallBack(this._titlelogo,this.onLogoLoaded);
         }
         else if(this._event.hasEventStarted && mcLogo.visible)
         {
            mcLogo.visible = false;
         }
      }
      
      private function onImageLoaded(param1:String, param2:BitmapData) : void
      {
         while(mcImage.numChildren)
         {
            mcImage.removeChildAt(0);
         }
         mcImage.addChild(new Bitmap(param2));
      }
      
      private function onLogoLoaded(param1:String, param2:BitmapData) : void
      {
         while(mcLogo.numChildren)
         {
            mcLogo.removeChildAt(0);
         }
         var _loc3_:Bitmap = new Bitmap(param2);
         _loc3_.y = -5;
         mcLogo.addChild(_loc3_);
         mcLogo.visible = true;
      }
      
      private function ShowEventPopup(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(CLICKED_ACTION));
      }
      
      private function ShowInfoPopup(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(CLICKED_INFO));
      }
      
      private function Hide() : void
      {
         if(Boolean(this) && Boolean(this.parent))
         {
            bHelp.removeEventListener(MouseEvent.CLICK,this.ShowInfoPopup);
            bAction.removeEventListener(MouseEvent.CLICK,this.ShowEventPopup);
            parent.removeChild(this);
         }
      }
      
      private function Resize() : void
      {
         GLOBAL.RefreshScreen();
         x = int(GLOBAL._SCREEN.x + 5 + 30);
         y = int(GLOBAL._SCREEN.y + GLOBAL._SCREEN.height - mcHit.height - 10);
         if(Chat._bymChat && Chat._bymChat.chatBox && Boolean(Chat._bymChat.chatBox.background))
         {
            y = int(Chat._bymChat.y + Chat._bymChat.chatBox.y + Chat._bymChat.chatBox.background.y - 53);
         }
      }
      
      private function PhaseKey(param1:Array, param2:Boolean = true) : String
      {
         if(this.phase - 1 < param1.length - 1)
         {
            if(param2)
            {
               return KEYS.Get(param1[this.phase - 1]);
            }
            return param1[this.phase - 1];
         }
         if(param2)
         {
            return KEYS.Get(param1[param1.length - 1]);
         }
         return param1[param1.length - 1];
      }
   }
}
