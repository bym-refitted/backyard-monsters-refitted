package com.monsters.subscriptions.ui
{
   import com.monsters.display.ImageCache;
   import com.monsters.subscriptions.SubscriptionHandler;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SubscriptionJoinPopup extends subscriptions_promo_popup
   {
       
      
      private const _DAVECLUB_IMAGEURL:String = "subscriptions/";
      
      private const _DAVECLUB_BENEFIT_IMAGEURL:Array = ["daveClub_slot01.png","daveClub_slot02.png","daveClub_slot03.png","daveClub_slot04.png","daveClub_slot05.png","daveClub_slot06.v2.png"];
      
      public var rewardIndex:int = 0;
      
      private var circleNavigation:Array;
      
      public function SubscriptionJoinPopup()
      {
         super();
         POPUPSETTINGS.AlignToCenter(this);
         this.circleNavigation = [mcCircle1,mcCircle2,mcCircle3,mcCircle4,mcCircle5,mcCircle6];
         this.visible = false;
         this.setup();
      }
      
      public function setup() : void
      {
         ImageCache.GetImageWithCallBack(this._DAVECLUB_IMAGEURL + "daveclub_promo_BG_buttons.v2.png",this.daveClubImageLoaded,true,1,"",[mcImageBG]);
         ImageCache.GetImageWithCallBack(this._DAVECLUB_IMAGEURL + "daveClub_promo_pricetag_995.png",this.daveClubImageLoaded,true,1,"",[mcImagePrice]);
         var _loc1_:int = 0;
         while(_loc1_ < this.circleNavigation.length)
         {
            this.circleNavigation[_loc1_].gotoAndStop("off");
            _loc1_++;
         }
         tDescription1.htmlText = KEYS.Get("daveClub_promo_desc1");
         tDescription2.htmlText = KEYS.Get("daveClub_promo_desc2");
         mcArrowLeft.buttonMode = true;
         mcArrowLeft.mouseChildren = false;
         mcArrowLeft.addEventListener(MouseEvent.CLICK,this.onArrowClickPrev);
         mcArrowRight.buttonMode = true;
         mcArrowRight.mouseChildren = false;
         mcArrowRight.addEventListener(MouseEvent.CLICK,this.onArrowClickNext);
         bCancel.buttonMode = true;
         bCancel.mouseChildren = false;
         bCancel.addEventListener(MouseEvent.CLICK,this.onCancelClick);
         bJoin.buttonMode = true;
         bJoin.mouseChildren = false;
         bJoin.addEventListener(MouseEvent.CLICK,this.onJoinClick);
         this.changePortrait(0);
      }
      
      public function update() : void
      {
      }
      
      public function changePortrait(param1:int = 0) : void
      {
         if(param1 < 0)
         {
            param1 = int(this._DAVECLUB_BENEFIT_IMAGEURL.length - 1);
         }
         if(param1 >= this._DAVECLUB_BENEFIT_IMAGEURL.length)
         {
            param1 = 0;
         }
         ImageCache.GetImageWithCallBack(this._DAVECLUB_IMAGEURL + this._DAVECLUB_BENEFIT_IMAGEURL[param1],this.daveClubImageLoaded,true,1,"",[mcImageSlot]);
         this.rewardIndex = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this.circleNavigation.length)
         {
            if(_loc2_ == this.rewardIndex)
            {
               (this.circleNavigation[_loc2_] as MovieClip).gotoAndStop("on");
            }
            else
            {
               (this.circleNavigation[_loc2_] as MovieClip).gotoAndStop("off");
            }
            _loc2_++;
         }
      }
      
      private function onArrowClickPrev(param1:MouseEvent) : void
      {
         this.changePortrait(this.rewardIndex - 1);
      }
      
      private function onArrowClickNext(param1:MouseEvent) : void
      {
         this.changePortrait(this.rewardIndex + 1);
      }
      
      public function onJoinClick(param1:MouseEvent = null) : void
      {
         print("|SubscriptionJoinPopup| - join clicked");
         dispatchEvent(new Event(SubscriptionHandler.JOIN));
      }
      
      public function onCancelClick(param1:MouseEvent = null) : void
      {
         print("|SubscriptionJoinPopup| - cancel clicked");
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      private function daveClubImageLoaded(param1:String, param2:BitmapData, param3:Array = null) : void
      {
         var _loc5_:Bitmap = null;
         var _loc4_:MovieClip;
         _loc4_ = param3[0];
         if(_loc4_)
         {
            while(_loc4_.numChildren > 0)
            {
               _loc4_.removeChildAt(0);
            }
            _loc5_ = new Bitmap(param2);
            _loc4_.addChild(_loc5_);
            _loc4_.visible = true;
         }
         if(!this.visible)
         {
            this.visible = true;
         }
      }
      
      public function Hide() : void
      {
         mcArrowLeft.removeEventListener(MouseEvent.CLICK,this.onArrowClickPrev);
         mcArrowRight.removeEventListener(MouseEvent.CLICK,this.onArrowClickNext);
         bCancel.removeEventListener(MouseEvent.CLICK,this.onCancelClick);
         bJoin.removeEventListener(MouseEvent.CLICK,this.onJoinClick);
         SOUNDS.Play("close");
      }
      
      public function Resize() : void
      {
         this.x = GLOBAL._SCREENCENTER.x;
         this.y = GLOBAL._SCREENCENTER.y;
      }
   }
}
