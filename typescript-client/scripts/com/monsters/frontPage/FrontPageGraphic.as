package com.monsters.frontPage
{
   import com.monsters.display.ImageCache;
   import com.monsters.frontPage.categories.Category;
   import com.monsters.frontPage.events.FrontPageEvent;
   import com.monsters.frontPage.messages.Message;
   import com.monsters.utils.VideoUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.media.Video;
   import flash.net.NetStream;
   import gs.TweenLite;
   
   public class FrontPageGraphic extends popup_frontpage_CLIP
   {
      
      public static const MEDIA_WIDTH:uint = 620;
      
      public static const MEDIA_HEIGHT:uint = 340;
       
      
      private var _activeMessage:Message;
      
      private var _media:DisplayObject;
      
      private var _videoStream:NetStream;
      
      private var _carousel:Sprite;
      
      private var _container:frontpage_featuredItem_CLIP;
      
      public function FrontPageGraphic(param1:Message = null)
      {
         super();
         bNext.visible = false;
         bPrev.visible = false;
         bNext.tLabel.htmlText = KEYS.Get("btn_next");
         bPrev.tLabel.htmlText = KEYS.Get("btn_prev");
         bNext.mouseChildren = false;
         bPrev.mouseChildren = false;
         bNext.buttonMode = true;
         bPrev.buttonMode = true;
         bNext.addEventListener(MouseEvent.CLICK,this.clickedNext);
         bPrev.addEventListener(MouseEvent.CLICK,this.clickedPrevious);
         addEventListener(MouseEvent.ROLL_OVER,this.rollOver);
         addEventListener(MouseEvent.ROLL_OUT,this.rollOut);
         if(param1)
         {
            this.showMessage(param1);
         }
      }
      
      private function rollOver(param1:MouseEvent) : void
      {
         this.tweenNavigationButtonAlphaTo(1);
      }
      
      private function rollOut(param1:MouseEvent) : void
      {
         this.tweenNavigationButtonAlphaTo(0);
      }
      
      private function tweenNavigationButtonAlphaTo(param1:int) : void
      {
         TweenLite.to(bNext,0.25,{"alpha":param1});
         TweenLite.to(bPrev,0.25,{"alpha":param1});
      }
      
      private function clickedNext(param1:MouseEvent) : void
      {
         dispatchEvent(new FrontPageEvent(FrontPageEvent.NEXT));
      }
      
      private function clickedPrevious(param1:MouseEvent) : void
      {
         dispatchEvent(new FrontPageEvent(FrontPageEvent.PREVIOUS));
      }
      
      public function destroy() : void
      {
         bNext.removeEventListener(MouseEvent.CLICK,this.clickedNext);
         bPrev.removeEventListener(MouseEvent.CLICK,this.clickedPrevious);
         removeEventListener(MouseEvent.ROLL_OVER,this.rollOver);
         removeEventListener(MouseEvent.ROLL_OUT,this.rollOut);
      }
      
      public function updateCategories(param1:Category, param2:Vector.<Category>) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Category = null;
         var _loc7_:CarouselCategory = null;
         if(this._carousel)
         {
            mcCarousel.removeChild(this._carousel);
         }
         this._carousel = new Sprite();
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc5_ = 0;
         while(_loc5_ < param2.length)
         {
            _loc6_ = param2[_loc5_];
            (_loc7_ = new CarouselCategory(_loc6_,_loc6_ == param1)).addEventListener(MouseEvent.CLICK,this.clickedCategory,false,0,true);
            _loc7_.x = _loc3_;
            this._carousel.addChild(_loc7_);
            _loc3_ += _loc7_.width;
            if(_loc5_ + 1 < param2.length)
            {
               _loc3_ += 5;
            }
            if(_loc4_ == 0)
            {
               _loc4_ = _loc7_.width / 2;
            }
            _loc5_++;
         }
         this._carousel.x = -(this._carousel.width * 0.5) + _loc4_;
         mcCarousel.addChild(this._carousel);
      }
      
      protected function clickedCategory(param1:MouseEvent) : void
      {
         var _loc2_:CarouselCategory = param1.currentTarget as CarouselCategory;
         dispatchEvent(new FrontPageEvent(FrontPageEvent.CHANGE_CATEGORY,_loc2_.category));
      }
      
      public function showMessage(param1:Message) : void
      {
         this._container = this.createMessageContainer();
         this._container.tTitle.htmlText = param1.title;
         this._container.tBody.htmlText = param1.body;
         if(this._media)
         {
            this.clearMedia();
         }
         if(param1.videoURL)
         {
            this.loadVideo(param1.videoURL);
         }
         else if(param1.imageURL)
         {
            ImageCache.GetImageWithCallBack(param1.imageURL,this.loadedImage);
         }
         param1.setupButton(this._container.bAction);
      }
      
      private function createMessageContainer() : frontpage_featuredItem_CLIP
      {
         if(this._container)
         {
            TweenLite.to(this._container,0.5,{
               "alpha":0,
               "onComplete":this.removeOldContainer,
               "onCompleteParams":[this._container]
            });
         }
         this._container = new frontpage_featuredItem_CLIP();
         mcContainer.addChildAt(this._container,0);
         return this._container;
      }
      
      private function removeOldContainer(param1:frontpage_featuredItem_CLIP) : void
      {
         mcContainer.removeChild(param1);
         param1 = null;
      }
      
      private function loadVideo(param1:String) : void
      {
         this._media = new Video(MEDIA_WIDTH,MEDIA_HEIGHT);
         this._videoStream = VideoUtils.getVideoStream(this._media as Video,param1);
         VideoUtils.loopStream(this._videoStream);
         this._container.mcImage.addChild(this._media);
      }
      
      private function clearMedia() : void
      {
         if(this._videoStream)
         {
            this._videoStream.close();
         }
      }
      
      private function loadedImage(param1:String, param2:BitmapData) : void
      {
         this._media = new Bitmap(param2);
         this._container.mcImage.addChild(this._media);
      }
   }
}

import com.monsters.frontPage.categories.Category;
import flash.display.Sprite;
import flash.events.MouseEvent;
import gs.TweenLite;
import gs.easing.Elastic;
import gs.easing.Expo;

class CarouselCategory extends Sprite
{
   
   private static const _DOES_DISPLAY_LABEL:Boolean = false;
   
   private static const _TWEEN_SCALE_NORMAL:Number = 0.5;
   
   private static const _TWEEN_SCALE_ON:Number = 0.75;
   
   private static const _TWEEN_SCALE_EXTRA:Number = 0.8;
    
   
   public var category:Category;
   
   public var button:CarouselCategoryButton2;
   
   private var _isActive:Boolean = false;
   
   public function CarouselCategory(param1:Category, param2:Boolean = false)
   {
      super();
      this.button = new CarouselCategoryButton2();
      this.button.buttonMode = true;
      addChild(this.button);
      this.category = param1;
      this.isActive = param2;
      this.button.tLabel.htmlText = param1.name;
      this.button.tLabel.visible = _DOES_DISPLAY_LABEL;
      addEventListener(MouseEvent.ROLL_OUT,this.onRollOut,false,0,true);
      addEventListener(MouseEvent.ROLL_OVER,this.onRollOver,false,0,true);
      this.button.mcBar.gotoAndStop(1);
      TweenLite.to(this.button.mcBar,0,{
         "scaleX":_TWEEN_SCALE_NORMAL,
         "scaleY":_TWEEN_SCALE_NORMAL,
         "ease":Expo.easeOut
      });
      this.toggleAnimations();
   }
   
   private function onRollOut(param1:MouseEvent) : void
   {
      if(!this._isActive)
      {
         this.onDeactivate();
      }
   }
   
   private function onRollOver(param1:MouseEvent) : void
   {
      TweenLite.to(this.button.mcBar,0.75,{
         "scaleX":_TWEEN_SCALE_ON,
         "scaleY":_TWEEN_SCALE_ON,
         "ease":Elastic.easeOut,
         "delay":0
      });
   }
   
   private function onActivate(param1:MouseEvent = null) : void
   {
      TweenLite.killTweensOf(this.button.mcBar);
      TweenLite.to(this.button.mcBar,0.25,{
         "scaleX":_TWEEN_SCALE_EXTRA,
         "scaleY":_TWEEN_SCALE_EXTRA,
         "ease":Elastic.easeOut
      });
      TweenLite.to(this.button.mcBar,0.15,{
         "scaleX":_TWEEN_SCALE_ON,
         "scaleY":_TWEEN_SCALE_ON,
         "ease":Expo.easeOut,
         "delay":0.25
      });
      this.button.mcBar.gotoAndStop(1);
   }
   
   private function onDeactivate(param1:MouseEvent = null) : void
   {
      TweenLite.killTweensOf(this.button.mcBar);
      TweenLite.to(this.button.mcBar,0.2,{
         "scaleX":_TWEEN_SCALE_NORMAL,
         "scaleY":_TWEEN_SCALE_NORMAL,
         "ease":Expo.easeOut
      });
      this.button.mcBar.gotoAndStop(2);
   }
   
   private function toggleAnimations() : void
   {
      if(this._isActive)
      {
         this.onActivate();
      }
      else
      {
         this.onDeactivate();
      }
   }
   
   public function set isActive(param1:Boolean) : void
   {
      if(this._isActive != param1)
      {
         this._isActive = param1;
         this.toggleAnimations();
      }
   }
}
