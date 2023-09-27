package com.monsters.replayableEvents.attacking.monsterMadness
{
   import com.monsters.chat.Chat;
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   
   public class MonsterMadnessInfoBar extends MonsterMadnessBar_CLIP
   {
       
      
      public var points:int;
      
      public var _timer:Timer;
      
      public var eventstage:int;
      
      private var _finalcountdown:int = 86400;
      
      private var _image:String;
      
      private const BASEIMAGEURL:String = "specialevent/monstermadness/";
      
      public function MonsterMadnessInfoBar()
      {
         super();
      }
      
      public static function ShowEventPopup(param1:MouseEvent = null) : void
      {
         MonsterMadness.showPopup(true);
      }
      
      public function Setup() : void
      {
         if(MonsterMadness.stage <= 0)
         {
            return;
         }
         this.addEventListener(MouseEvent.CLICK,ShowEventPopup);
         this.buttonMode = true;
         this.mouseChildren = false;
         bActionTxt.htmlText = KEYS.Get("btn_info");
         bActionTxt.mouseEnabled = false;
         bAction.addEventListener(MouseEvent.CLICK,ShowEventPopup);
         var _loc1_:int = 1;
         if(BASE.isInfernoMainYardOrOutpost)
         {
            _loc1_ = 2;
         }
         mcBG.gotoAndStop(_loc1_);
         bAction.gotoAndStop(_loc1_);
         this.Update();
         GLOBAL._layerUI.addChild(this);
      }
      
      public function Update() : void
      {
         if(MonsterMadness.stage > 1)
         {
            gotoAndStop(2);
         }
         else
         {
            gotoAndStop(1);
         }
         this.updateText();
         this.updateImage();
         this.Resize();
      }
      
      public function updateText() : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc1_:int = int(MonsterMadness.stage);
         var _loc2_:int = MonsterMadness.timeUntilNextPhase;
         var _loc3_:String = GLOBAL.ToTime(_loc2_);
         tLabel.htmlText = "<b>" + _loc3_ + "</b>";
         if(_loc1_ > 1 && _loc1_ < 5)
         {
            _loc4_ = 0;
            _loc5_ = int(MonsterMadness.points);
            _loc6_ = MonsterMadness.POINTS_GOAL1;
            if(_loc1_ == 2)
            {
               _loc6_ = MonsterMadness.POINTS_GOAL1;
               _loc7_ = KEYS.Get("mm_infobar_progressbar");
            }
            else if(_loc1_ == 3)
            {
               _loc6_ = MonsterMadness.POINTS_GOAL2 - MonsterMadness.POINTS_GOAL1;
               _loc5_ = MonsterMadness.points - MonsterMadness.POINTS_GOAL1;
               _loc7_ = KEYS.Get("mm_infobar_progressbar2");
            }
            else if(_loc1_ == 4)
            {
               _loc6_ = MonsterMadness.POINTS_GOAL3 - MonsterMadness.POINTS_GOAL2;
               _loc5_ = MonsterMadness.points - MonsterMadness.POINTS_GOAL2;
               _loc7_ = KEYS.Get("mm_infobar_progressbar3");
            }
            _loc4_ = Math.min(100,int(_loc5_ / _loc6_ * 100));
            barProgressTxt.htmlText = "" + _loc7_ + _loc4_ + " %" + "";
            barProgress.mcBar.width = Math.min(100,100 / _loc6_ * _loc5_);
         }
      }
      
      public function updateImage() : void
      {
         var _loc1_:int = int(MonsterMadness.stage);
         var _loc2_:String = "1";
         if(_loc1_ == 3)
         {
            _loc2_ = "2.v4";
         }
         else if(_loc1_ == 4)
         {
            _loc2_ = "3.v3";
         }
         else
         {
            _loc2_ = "1.v3";
         }
         if(this._image != this.BASEIMAGEURL + "mm_infoicon_" + _loc2_ + ".png")
         {
            this._image = this.BASEIMAGEURL + "mm_infoicon_" + _loc2_ + ".png";
            ImageCache.GetImageWithCallBack(this._image,this.onImageLoaded);
         }
      }
      
      public function onImageLoaded(param1:String, param2:BitmapData) : void
      {
         while(mcImage.numChildren)
         {
            mcImage.removeChildAt(0);
         }
         mcImage.addChild(new Bitmap(param2));
      }
      
      public function Hide() : void
      {
         if(Boolean(this) && Boolean(this.parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function Resize() : void
      {
         GLOBAL.RefreshScreen();
         x = int(GLOBAL._SCREEN.x + 5 + 30);
         y = int(GLOBAL._SCREEN.y + GLOBAL._SCREEN.height - mcHit.height - 10);
         if(Boolean(Chat._bymChat) && Boolean(Chat._bymChat.chatBox.background))
         {
            y = int(Chat._bymChat.y + Chat._bymChat.chatBox.y + Chat._bymChat.chatBox.background.y - 53);
         }
      }
   }
}
