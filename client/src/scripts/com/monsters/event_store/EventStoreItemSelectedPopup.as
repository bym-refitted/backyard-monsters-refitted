package com.monsters.event_store
{
   import com.monsters.display.ImageCache;
   import com.monsters.replayableEvents.ReplayableEventHandler;
   import com.monsters.rewarding.RewardHandler;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   
   public class EventStoreItemSelectedPopup extends EventStoreItemSelectedPopupMC
   {
      
      private static var s_Instance:com.monsters.event_store.EventStoreItemSelectedPopup = null;
       
      
      private var m_PrizeBeingDisplayed:com.monsters.event_store.EventStorePrize = null;
      
      private var m_TitleImage:Bitmap = null;
      
      private var m_PreviewImage:Bitmap = null;
      
      public function EventStoreItemSelectedPopup(param1:SingletonLock)
      {
         super();
         this.m_TitleImage = new Bitmap();
         titleImageHolder.addChild(this.m_TitleImage);
         this.m_PreviewImage = new Bitmap();
         previewImageHolder.addChild(this.m_PreviewImage);
      }
      
      public static function get instance() : com.monsters.event_store.EventStoreItemSelectedPopup
      {
         return s_Instance = s_Instance || new com.monsters.event_store.EventStoreItemSelectedPopup(new SingletonLock());
      }
      
      public function Show(param1:com.monsters.event_store.EventStorePrize) : void
      {
         var _loc4_:int = 0;
         if(this.m_PrizeBeingDisplayed != null)
         {
            this.Hide();
         }
         this.m_PrizeBeingDisplayed = param1;
         GLOBAL.BlockerAdd(GLOBAL._layerTop);
         POPUPS.Add(this);
         POPUPSETTINGS.AlignToCenter(this);
         if(Boolean(ReplayableEventHandler.activeEvent) && Boolean(ReplayableEventHandler.activeEvent.eventStoreTitleImage))
         {
            ImageCache.GetImageWithCallBack(ReplayableEventHandler.activeEvent.eventStoreTitleImage,this.OnTitleImageLoaded);
         }
         else
         {
            ImageCache.GetImageWithCallBack("events/hellraisers/hellraisers_event_store_title.png",this.OnTitleImageLoaded);
         }
         ImageCache.GetImageWithCallBack(this.m_PrizeBeingDisplayed.previewImageURL,this.OnPreviewImageLoaded);
         var _loc2_:uint = ReplayableEventHandler.eventXP;
         var _loc3_:String = KEYS.Get(this.m_PrizeBeingDisplayed.nameKey);
         prizeNameText.htmlText = KEYS.Get("prize_title",{"v1":_loc3_});
         descriptionText.htmlText = KEYS.Get(this.m_PrizeBeingDisplayed.descriptionKey);
         experienceDisplay.xpBalanceText.htmlText = KEYS.Get("event_store_xp_balance",{"v1":_loc2_});
         xpCostText.htmlText = KEYS.Get("event_store_cost",{"v1":this.m_PrizeBeingDisplayed.xpCost});
         if(this.m_PrizeBeingDisplayed.lockIcon.visible)
         {
            purchaseButton.Setup(KEYS.Get("event_store_prize_locked"));
            purchaseButton.Enabled = false;
         }
         else if(_loc2_ < this.m_PrizeBeingDisplayed.xpCost)
         {
            _loc4_ = this.m_PrizeBeingDisplayed.xpCost - _loc2_;
            purchaseButton.Setup(KEYS.Get("event_store_xp_needed",{"v1":_loc4_}));
            purchaseButton.Enabled = false;
         }
         else
         {
            purchaseButton.Setup(KEYS.Get("event_store_purchase"));
            purchaseButton.Enabled = true;
            purchaseButton.addEventListener(MouseEvent.CLICK,this.OnPurchaseClicked);
         }
      }
      
      private function OnTitleImageLoaded(param1:String, param2:BitmapData) : void
      {
         this.m_TitleImage.bitmapData = param2;
         this.m_TitleImage.x = -(this.m_TitleImage.width * 0.5);
      }
      
      private function OnPreviewImageLoaded(param1:String, param2:BitmapData) : void
      {
         this.m_PreviewImage.bitmapData = param2;
      }
      
      public function Hide() : void
      {
         if(this.m_PrizeBeingDisplayed == null)
         {
            return;
         }
         purchaseButton.removeEventListener(MouseEvent.CLICK,this.OnPurchaseClicked);
         purchaseButton.Enabled = false;
         this.m_TitleImage.bitmapData = null;
         this.m_PreviewImage.bitmapData = null;
         POPUPS.Remove(this);
         GLOBAL.BlockerRemove();
         this.m_PrizeBeingDisplayed = null;
      }
      
      private function OnPurchaseClicked(param1:MouseEvent) : void
      {
         if(this.m_PrizeBeingDisplayed == null)
         {
            return;
         }
         if(this.m_PrizeBeingDisplayed.correspondingReward == null)
         {
            return;
         }
         if(ReplayableEventHandler.eventXP < this.m_PrizeBeingDisplayed.xpCost)
         {
            return;
         }
         ReplayableEventHandler.eventXP -= this.m_PrizeBeingDisplayed.xpCost;
         RewardHandler.instance.addAndApplyReward(this.m_PrizeBeingDisplayed.correspondingReward);
         if(this.m_PrizeBeingDisplayed.correspondingRewardValue)
         {
            this.m_PrizeBeingDisplayed.correspondingReward.value = this.m_PrizeBeingDisplayed.correspondingRewardValue;
         }
      }
   }
}

class SingletonLock
{
    
   
   public function SingletonLock()
   {
      super();
   }
}
