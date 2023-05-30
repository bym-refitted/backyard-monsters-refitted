package com.monsters.event_store
{
   import com.monsters.display.ImageCache;
   import com.monsters.replayableEvents.ReplayableEventHandler;
   import com.monsters.rewarding.Reward;
   import com.monsters.rewarding.RewardHandler;
   import com.monsters.rewarding.RewardLibrary;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   
   public class EventStorePrize extends EventStoreDisplayItem
   {
       
      
      private var m_Id:String;
      
      private var m_NameKey:String;
      
      private var m_DescriptionKey:String;
      
      private var m_ImageURL:String;
      
      private var m_LockedImageURL:String;
      
      private var m_PreviewImageURL:String;
      
      private var m_CorrespondingReward:Reward;
      
      private var m_CorrespondingRewardValue:Number;
      
      private var m_XPCost:uint;
      
      private var m_Image:Bitmap;
      
      public function EventStorePrize(param1:Object)
      {
         this.m_Image = new Bitmap();
         super();
         this.m_Id = param1.id;
         this.m_NameKey = param1.name_key;
         this.m_DescriptionKey = param1.description_key;
         this.m_ImageURL = param1.image;
         this.m_LockedImageURL = param1.locked_image;
         this.m_PreviewImageURL = param1.preview_image;
         this.m_XPCost = param1.xpcost;
         this.m_Image = new Bitmap();
         buttonMode = true;
         nameText.htmlText = KEYS.Get(this.m_NameKey);
         imageHolder.addChild(this.m_Image);
         addEventListener(MouseEvent.CLICK,this.OnClicked,false,0,true);
         var _loc2_:uint = ReplayableEventHandler.eventXP;
         if(_loc2_ < this.m_XPCost)
         {
            xpText.htmlText = _loc2_ + "/" + this.m_XPCost;
            xpBarBlue.visible = false;
            xpBarGreen.visible = true;
            xpBarYellow.visible = false;
         }
         else
         {
            xpText.htmlText = KEYS.Get("event_store_prize_unlocked");
            xpBarBlue.visible = false;
            xpBarGreen.visible = false;
            xpBarYellow.visible = true;
         }
         var _loc3_:String = String(param1.correspondingRewardId);
         this.m_CorrespondingRewardValue = param1.correspondingRewardValue;
         this.m_CorrespondingReward = RewardHandler.instance.getRewardByID(_loc3_);
         if(this.m_CorrespondingReward != null && this.m_CorrespondingReward.value >= this.m_CorrespondingRewardValue)
         {
            lockIcon.visible = false;
            tickIcon.visible = true;
            xpBarBlue.visible = true;
            xpBarGreen.visible = false;
            xpBarYellow.visible = false;
            xpText.htmlText = KEYS.Get("event_store_prize_purchased");
            ImageCache.GetImageWithCallBack(this.m_ImageURL,this.OnImageLoaded);
            return;
         }
         if(this.m_CorrespondingReward == null)
         {
            this.m_CorrespondingReward = RewardLibrary.getRewardByID(_loc3_);
         }
         if(this.m_CorrespondingReward == null)
         {
            lockIcon.visible = true;
            tickIcon.visible = false;
            ImageCache.GetImageWithCallBack(this.m_LockedImageURL,this.OnImageLoaded);
            return;
         }
         var _loc4_:String;
         if((_loc4_ = String(param1.requiredReward)) == null || _loc4_ == "")
         {
            lockIcon.visible = false;
            tickIcon.visible = false;
            ImageCache.GetImageWithCallBack(this.m_ImageURL,this.OnImageLoaded);
            return;
         }
         var _loc5_:Reward = RewardHandler.instance.getRewardByID(_loc4_);
         var _loc6_:Number = Number(param1.requiredRewardValue);
         if(_loc5_ == null || _loc5_.value < _loc6_)
         {
            lockIcon.visible = true;
            tickIcon.visible = false;
            ImageCache.GetImageWithCallBack(this.m_LockedImageURL,this.OnImageLoaded);
            return;
         }
         lockIcon.visible = false;
         tickIcon.visible = false;
         ImageCache.GetImageWithCallBack(this.m_ImageURL,this.OnImageLoaded);
      }
      
      internal function get id() : String
      {
         return this.m_Id;
      }
      
      internal function get nameKey() : String
      {
         return this.m_NameKey;
      }
      
      internal function get descriptionKey() : String
      {
         return this.m_DescriptionKey;
      }
      
      internal function get imageURL() : String
      {
         return this.m_ImageURL;
      }
      
      internal function get lockedImageURL() : String
      {
         return this.m_LockedImageURL;
      }
      
      internal function get previewImageURL() : String
      {
         return this.m_PreviewImageURL;
      }
      
      internal function get correspondingReward() : Reward
      {
         return this.m_CorrespondingReward;
      }
      
      internal function get correspondingRewardValue() : Number
      {
         return this.m_CorrespondingRewardValue;
      }
      
      internal function get xpCost() : uint
      {
         return this.m_XPCost;
      }
      
      private function OnImageLoaded(param1:String, param2:BitmapData) : void
      {
         if(this.m_Image != null)
         {
            this.m_Image.bitmapData = param2;
         }
      }
      
      public function Destroy() : void
      {
         removeEventListener(MouseEvent.CLICK,this.OnClicked);
         imageHolder.removeChild(this.m_Image);
         this.m_Image.bitmapData = null;
         this.m_Image = null;
         this.m_CorrespondingReward = null;
      }
      
      private function OnClicked(param1:MouseEvent) : void
      {
         EventStoreItemSelectedPopup.instance.Show(this);
      }
   }
}
