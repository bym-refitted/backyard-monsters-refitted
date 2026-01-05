package com.monsters.replayableEvents
{
   import com.monsters.chat.Chat;
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MultiRewardReplayableEventUI extends MultiRewardEventsBar implements IReplayableEventUI
   {
      
      public static var CLICKED_ACTION:String = "eventBarAction";
      
      public static var CLICKED_INFO:String = "eventBarInfo";
      
      public static const k_REWARD_COLOR:uint = 15924337;
      
      public static const k_PROGRESS_COLOR:uint = 8567294;
       
      
      private var _event:ReplayableEvent;
      
      private var m_progressBarFill:Shape;
      
      private var m_rewardGraphics:Vector.<RewardGraphics>;
      
      private var k_BUFFER:Number = 0.25;
      
      public function MultiRewardReplayableEventUI()
      {
         this.m_rewardGraphics = new Vector.<RewardGraphics>();
         super();
      }
      
      public function get eventUI() : DisplayObject
      {
         return this;
      }
      
      public function setup(param1:ReplayableEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:ReplayableEventQuota = null;
         var _loc8_:int = 0;
         var _loc9_:EventRewardRibbon = null;
         var _loc10_:Number = NaN;
         var _loc11_:Sprite = null;
         this._event = param1;
         tScore.visible = false;
         tScore.mouseEnabled = false;
         buttonHelp.addEventListener(MouseEvent.CLICK,this.ShowInfoPopup);
         buttonHelp.buttonMode = true;
         if(this._event.buttonCopy)
         {
            buttonAction.stop();
            buttonAction.addEventListener(MouseEvent.CLICK,this.ShowEventPopup,false,0,true);
            buttonAction.buttonMode = true;
            buttonActionLabel.text = this._event.buttonCopy;
            buttonActionLabel.mouseEnabled = false;
         }
         else
         {
            buttonActionLabel.visible = false;
            buttonAction.visible = false;
         }
         progressBarOverlay.visible = true;
         progressBarOverlay.mouseEnabled = false;
         if(this._event.imageURL)
         {
            ImageCache.GetImageWithCallBack(this._event.imageURL,this.onImageLoaded);
         }
         if(this._event.titleImage)
         {
            ImageCache.GetImageWithCallBack(this._event.titleImage,this.onLogoLoaded);
         }
         _loc2_ = 0;
         _loc4_ = 3;
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            this.getChildByName("reward" + _loc6_).visible = false;
            _loc6_++;
         }
         var _loc5_:uint = this._event.rewards.length;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            if(!((_loc7_ = this._event.rewards[_loc6_]).rewardID == null || _loc7_.rewardID == ""))
            {
               _loc8_ = _loc4_ - (_loc5_ - 1) + _loc2_;
               if((_loc9_ = this.getChildByName("reward" + String(_loc8_ - 1)) as EventRewardRibbon) == null)
               {
                  break;
               }
               _loc9_.visible = true;
               ImageCache.GetImageWithCallBack(_loc7_.imageURL,this.onRewardImageLoaded,true,4,"",[_loc9_]);
               _loc10_ = this._event.rewards[_loc6_].quota / this._event.maxScore - (_loc2_ > 0 ? this._event.rewards[_loc6_ - 1].quota / this._event.maxScore : 0);
               (_loc11_ = new Sprite()).x = _loc3_ + 2;
               _loc11_.y = 1;
               _loc11_.graphics.beginFill(k_REWARD_COLOR);
               _loc11_.graphics.drawRect(0,0,_loc10_ * progressBarFillMask.width,progressBarFillMask.height - 2);
               this.progressBarFill.addChild(_loc11_);
               _loc3_ += _loc11_.width;
               this.m_rewardGraphics.push(new RewardGraphics(_loc11_,_loc9_));
               _loc2_++;
               if(_loc2_ >= _loc4_)
               {
                  break;
               }
            }
            _loc6_++;
         }
         this.m_progressBarFill = new Shape();
         this.m_progressBarFill.x += 2;
         this.progressBarFill.addChild(this.m_progressBarFill);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStage);
      }
      
      private function removedFromStage(param1:Event) : void
      {
         this.m_rewardGraphics = null;
      }
      
      public function update() : void
      {
         var _loc1_:int = this._event.timeUntilNextDate;
         if(_loc1_ <= 0)
         {
            timeLabel.htmlText = "<b>DATE NOT INITIALIZED!</b>";
         }
         else
         {
            timeLabel.htmlText = "<b>" + GLOBAL.ToTime(_loc1_,true) + "</b>";
         }
         if(this._event.hasEventStarted)
         {
            this.m_progressBarFill.graphics.clear();
            this.m_progressBarFill.graphics.beginFill(k_PROGRESS_COLOR);
            this.m_progressBarFill.graphics.drawRect(0,0,this._event.progress * progressBarFillMask.width,progressBarFillMask.height);
            this.m_progressBarFill.graphics.endFill();
         }
         if(this._event.buttonCopy)
         {
            buttonActionLabel.text = this._event.buttonCopy;
         }
         tScore.htmlText = "<b>" + Math.max(this._event.score,0) + "/" + this._event.maxScore + "</b>";
         this.Resize();
      }
      
      private function Resize() : void
      {
         x = int(GLOBAL._SCREEN.x);
         y = int(GLOBAL._SCREEN.y + (GLOBAL._SCREEN.height - mcBackground.height));
         if(Chat._bymChat && Chat._bymChat.chatBox && Boolean(Chat._bymChat.chatBox.background))
         {
            y = int(Chat._bymChat.y + Chat._bymChat.chatBox.y + Chat._bymChat.chatBox.background.y - mcBackground.height);
         }
      }
      
      private function onImageLoaded(param1:String, param2:BitmapData) : void
      {
         var _loc3_:Bitmap = new Bitmap(param2);
         var _loc4_:Sprite;
         (_loc4_ = new Sprite()).addChild(_loc3_);
         _loc4_.mouseEnabled = false;
         _loc4_.mouseChildren = false;
         addChildAt(_loc4_,0);
         _loc4_.y -= _loc4_.height + this.k_BUFFER;
      }
      
      private function onLogoLoaded(param1:String, param2:BitmapData) : void
      {
         var _loc3_:Bitmap = new Bitmap(param2);
         addChild(_loc3_);
         _loc3_.visible = true;
      }
      
      private function onRewardImageLoaded(param1:String, param2:BitmapData, param3:Array) : void
      {
         var _loc4_:EventRewardRibbon = param3[0] as EventRewardRibbon;
         while(_loc4_.rewardImage0.numChildren)
         {
            _loc4_.rewardImage0.removeChildAt(0);
         }
         _loc4_.rewardImage0.addChild(new Bitmap(param2));
         _loc4_.visible = true;
      }
      
      private function ShowEventPopup(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(CLICKED_ACTION));
      }
      
      private function ShowInfoPopup(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(CLICKED_INFO));
      }
   }
}

import com.monsters.replayableEvents.MultiRewardReplayableEventUI;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import gs.TweenLite;

class RewardGraphics
{
    
   
   public var ribbon:EventRewardRibbon;
   
   public var fill:Sprite;
   
   private var width:Number;
   
   private var height:Number;
   
   public function RewardGraphics(param1:Sprite, param2:EventRewardRibbon)
   {
      super();
      this.width = param1.width;
      this.height = param1.height;
      this.ribbon = param2;
      this.fill = param1;
      this.fill.addEventListener(MouseEvent.MOUSE_OVER,this.OnProgressBarSectionMouseOver,false,0,true);
      this.ribbon.addEventListener(MouseEvent.MOUSE_OVER,this.OnProgressBarSectionMouseOver,false,0,true);
      this.fill.addEventListener(MouseEvent.MOUSE_OUT,this.OnProgressBarSectionMouseOut,false,0,true);
      this.ribbon.addEventListener(MouseEvent.MOUSE_OUT,this.OnProgressBarSectionMouseOut,false,0,true);
      this.OnProgressBarSectionMouseOut();
      this.fill.buttonMode = true;
      this.ribbon.buttonMode = true;
   }
   
   protected function OnProgressBarSectionMouseOut(param1:Event = null) : void
   {
      TweenLite.to(this.ribbon.rewardImage0,0.25,{"y":0});
      TweenLite.to(this.ribbon.rewardRibbon0,0.25,{"y":0});
      this.SendRewardToBack(this.ribbon);
      this.redraw(0);
   }
   
   protected function OnProgressBarSectionMouseOver(param1:Event) : void
   {
      TweenLite.to(this.ribbon.rewardImage0,0.25,{"y":-50});
      TweenLite.to(this.ribbon.rewardRibbon0,0.25,{
         "y":-50,
         "onComplete":this.BringRewardToFront,
         "onCompleteParams":[this.ribbon]
      });
      this.redraw(1);
   }
   
   private function redraw(param1:Number) : void
   {
      this.fill.graphics.clear();
      this.fill.graphics.lineStyle(1,11053224);
      this.fill.graphics.beginFill(MultiRewardReplayableEventUI.k_REWARD_COLOR,param1);
      this.fill.graphics.drawRect(0,0,this.width,this.height);
   }
   
   private function BringRewardToFront(param1:DisplayObject) : void
   {
   }
   
   private function SendRewardToBack(param1:DisplayObject) : void
   {
   }
}
