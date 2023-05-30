package com.monsters.event_store
{
   import com.monsters.display.ImageCache;
   import com.monsters.replayableEvents.ReplayableEventHandler;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class EventStorePopup extends EventStorePopupMC
   {
      
      private static var s_Instance:com.monsters.event_store.EventStorePopup = null;
       
      
      private var m_TabButtons:Vector.<ButtonBrown>;
      
      private var m_TabDisplays:Vector.<DisplayObject>;
      
      private var m_EventStoreDisplayGrid:com.monsters.event_store.EventStoreDisplayGrid;
      
      private var m_TitleImage:Bitmap = null;
      
      private var m_SelectedTabButton:ButtonBrown = null;
      
      private var m_IsShowing:Boolean = false;
      
      public function EventStorePopup(param1:SingletonLock)
      {
         super();
         this.m_TitleImage = new Bitmap();
         titleImageHolder.addChild(this.m_TitleImage);
         this.m_TabButtons = new Vector.<ButtonBrown>();
         this.m_TabDisplays = new Vector.<DisplayObject>();
         var _loc2_:ButtonBrown = tabButton1 as ButtonBrown;
         _loc2_.SetupKey("event_store_details_tab");
         _loc2_.addEventListener(MouseEvent.CLICK,this.OnTabButtonClicked);
         this.m_TabButtons.push(_loc2_);
         var _loc3_:DisplayObject = new Sprite();
         this.m_TabDisplays.push(_loc3_);
         displayContainer.addChild(_loc3_);
         var _loc4_:ButtonBrown;
         (_loc4_ = tabButton2 as ButtonBrown).SetupKey("event_store_prizes_tab");
         _loc4_.addEventListener(MouseEvent.CLICK,this.OnTabButtonClicked);
         this.m_TabButtons.push(_loc4_);
         this.m_EventStoreDisplayGrid = new com.monsters.event_store.EventStoreDisplayGrid(displayContainer);
         this.m_TabDisplays.push(this.m_EventStoreDisplayGrid);
         displayContainer.addChild(this.m_EventStoreDisplayGrid);
      }
      
      public static function get instance() : com.monsters.event_store.EventStorePopup
      {
         return s_Instance = s_Instance || new com.monsters.event_store.EventStorePopup(new SingletonLock());
      }
      
      public function Show(param1:uint = 1) : void
      {
         if(this.m_IsShowing == true)
         {
            return;
         }
         if(ReplayableEventHandler.activeEvent == null)
         {
         }
         POPUPS.Push(this);
         this.m_IsShowing = true;
         if(Boolean(ReplayableEventHandler.activeEvent) && Boolean(ReplayableEventHandler.activeEvent.eventStoreTitleImage))
         {
            ImageCache.GetImageWithCallBack(ReplayableEventHandler.activeEvent.eventStoreTitleImage,this.OnTitleImageLoaded);
         }
         else
         {
            ImageCache.GetImageWithCallBack("events/hellraisers/hellraisers_event_store_title.png",this.OnTitleImageLoaded);
         }
         var _loc2_:uint = ReplayableEventHandler.eventXP;
         experienceDisplay.xpBalanceText.htmlText = KEYS.Get("event_store_xp_balance",{"v1":_loc2_});
         this.m_EventStoreDisplayGrid.Populate();
         this.SelectTab(this.m_TabButtons[param1]);
      }
      
      private function OnTitleImageLoaded(param1:String, param2:BitmapData) : void
      {
         this.m_TitleImage.bitmapData = param2;
         this.m_TitleImage.x = -(this.m_TitleImage.width * 0.5);
      }
      
      public function Hide() : void
      {
         if(this.m_IsShowing == false)
         {
            return;
         }
         this.m_EventStoreDisplayGrid.Clear();
         this.m_TitleImage.bitmapData = null;
         POPUPS.Next();
         this.m_IsShowing = false;
      }
      
      private function OnTabButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:ButtonBrown = param1.currentTarget as ButtonBrown;
         if(_loc2_ == null || _loc2_ == this.m_SelectedTabButton)
         {
            return;
         }
         this.SelectTab(_loc2_);
      }
      
      private function SelectTab(param1:ButtonBrown) : void
      {
         var _loc4_:ButtonBrown = null;
         var _loc5_:DisplayObject = null;
         var _loc2_:uint = this.m_TabButtons.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.m_TabButtons[_loc3_];
            _loc5_ = this.m_TabDisplays[_loc3_];
            if(_loc4_ == param1)
            {
               _loc4_.Highlight = true;
               _loc5_.visible = true;
               this.m_SelectedTabButton = _loc4_;
               displayContainer.gotoAndStop("tabSelected" + (_loc3_ + 1));
            }
            else
            {
               _loc4_.Highlight = false;
               _loc5_.visible = false;
            }
            _loc3_++;
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
