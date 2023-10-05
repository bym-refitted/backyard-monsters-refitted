package com.monsters.event_store
{
   import com.monsters.display.ScrollSetV;
   import flash.display.Sprite;
   
   public class EventStoreDisplayGrid extends Sprite
   {
      
      private static const MAX_ITEMS_PER_ROW:uint = 5;
      
      private static const X_BUFFER:Number = 10;
      
      private static const Y_BUFFER:Number = 10;
       
      
      private var m_ScrollContents:Sprite;
      
      private var m_ScrollSpacer:Sprite;
      
      private var m_ScrollMask:Sprite;
      
      private var m_ScrollBar:ScrollSetV;
      
      private var m_DisplayItems:Vector.<com.monsters.event_store.EventStorePrize>;
      
      private var m_AvailablePrizes:Array = null;
      
      public function EventStoreDisplayGrid(param1:Sprite)
      {
         this.m_DisplayItems = new Vector.<com.monsters.event_store.EventStorePrize>();
         super();
         this.m_ScrollContents = new Sprite();
         addChild(this.m_ScrollContents);
         this.m_ScrollSpacer = new Sprite();
         this.m_ScrollSpacer.graphics.beginFill(16777215,0.01);
         this.m_ScrollSpacer.graphics.drawRect(0,0,2,2);
         this.m_ScrollSpacer.graphics.endFill();
         this.m_ScrollContents.addChild(this.m_ScrollSpacer);
         this.m_ScrollMask = new Sprite();
         this.m_ScrollMask.graphics.beginFill(16777215,0.01);
         this.m_ScrollMask.graphics.drawRect(0,0,param1.width,param1.height);
         this.m_ScrollMask.graphics.endFill();
         this.m_ScrollMask.mouseEnabled = false;
         this.m_ScrollMask.mouseChildren = false;
         this.m_ScrollContents.mask = this.m_ScrollMask;
         addChild(this.m_ScrollMask);
         this.m_ScrollBar = new ScrollSetV(this.m_ScrollContents,this.m_ScrollMask,true);
         this.m_ScrollBar.x = param1.width - this.m_ScrollBar.width;
         addChild(this.m_ScrollBar);
      }
      
      internal function Populate() : void
      {
         var _loc1_:Array = null;
         if(this.m_AvailablePrizes == null)
         {
            _loc1_ = [{
               "id":"prize_rezghul",
               "xpcost":999
            },{
               "id":"prize_gold_totem",
               "xpcost":9999
            },{
               "id":"prize_black_totem",
               "xpcost":999
            },{
               "id":"prize_spurtz_cannon_1",
               "xpcost":9999
            },{
               "id":"prize_spurtz_cannon_2",
               "xpcost":999
            },{
               "id":"prize_spurtz_cannon_bd",
               "xpcost":9999
            },{
               "id":"prize_unlock_vorg",
               "xpcost":999
            },{
               "id":"prize_unlock_slimeattikus",
               "xpcost":9999
            },{
               "id":"prize_korath",
               "xpcost":999
            },{
               "id":"prize_korath_ability_1",
               "xpcost":9999
            },{
               "id":"prize_korath_ability_2",
               "xpcost":999
            }];
            this.OnAvailableItemsLoaded(_loc1_);
         }
         else
         {
            this._Populate();
         }
      }
      
      private function OnAvailableItemsLoaded(param1:Array) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         this.m_AvailablePrizes = new Array();
         var _loc2_:uint = param1.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_];
            if((_loc5_ = EventStorePrizeData.FindEventStorePrizeData(_loc4_.id)) != null)
            {
               _loc5_.xpcost = _loc4_.xpcost;
               this.m_AvailablePrizes.push(_loc5_);
            }
            _loc3_++;
         }
         this._Populate();
      }
      
      private function _Populate() : void
      {
         var _loc1_:int = 0;
         var _loc5_:com.monsters.event_store.EventStorePrize = null;
         if(this.m_AvailablePrizes == null)
         {
            return;
         }
         var _loc2_:Number = X_BUFFER;
         var _loc3_:Number = Y_BUFFER;
         var _loc4_:Object = null;
         _loc5_ = null;
         var _loc6_:uint = this.m_AvailablePrizes.length;
         _loc1_ = 0;
         while(_loc1_ < _loc6_)
         {
            _loc4_ = this.m_AvailablePrizes[_loc1_];
            _loc5_ = new com.monsters.event_store.EventStorePrize(_loc4_);
            this.m_DisplayItems.push(_loc5_);
            this.m_ScrollContents.addChild(_loc5_);
            _loc5_.x = _loc2_;
            _loc5_.y = _loc3_;
            if((_loc1_ + 1) % MAX_ITEMS_PER_ROW == 0)
            {
               _loc2_ = X_BUFFER;
               _loc3_ += _loc5_.height + Y_BUFFER;
            }
            else
            {
               _loc2_ += _loc5_.width + X_BUFFER;
            }
            _loc1_++;
         }
         this.m_ScrollSpacer.width = 1;
         this.m_ScrollSpacer.height = this.m_ScrollContents.height + Y_BUFFER;
         this.m_ScrollBar.checkResize();
      }
      
      internal function Clear() : void
      {
         var _loc1_:com.monsters.event_store.EventStorePrize = null;
         var _loc2_:uint = this.m_DisplayItems.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.m_DisplayItems[_loc3_];
            this.m_ScrollContents.removeChild(_loc1_);
            _loc1_.Destroy();
            _loc3_++;
         }
         this.m_DisplayItems.length = 0;
      }
   }
}
