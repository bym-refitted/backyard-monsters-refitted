package com.monsters.maproom3.popups
{
   import com.monsters.display.ScrollSetV;
   import com.monsters.maproom3.data.MapRoom3FriendData;
   import flash.display.Sprite;
   
   public class MapRoom3RelocatePopupDisplayList extends Sprite
   {
       
      
      private var m_FriendsToDisplay:Vector.<MapRoom3FriendData>;
      
      private var m_FriendItemDisplays:Vector.<MapRoom3RelocatePopupItemDisplay>;
      
      private var m_Container:Sprite;
      
      private var m_ScrollMask:Sprite;
      
      private var m_ScrollBar:ScrollSetV;
      
      public function MapRoom3RelocatePopupDisplayList(param1:Vector.<MapRoom3FriendData>, param2:int = -1)
      {
         super();
         this.m_FriendsToDisplay = param1;
         this.m_Container = new Sprite();
         addChild(this.m_Container);
         this.CreateFriendDisplays();
         var _loc3_:Number = this.m_Container.height;
         if(param2 != -1 && param2 < this.m_FriendItemDisplays.length)
         {
            _loc3_ = param2 * this.m_FriendItemDisplays[0].height;
         }
         this.m_ScrollMask = new Sprite();
         this.m_ScrollMask.graphics.beginFill(16777215,0.01);
         this.m_ScrollMask.graphics.drawRect(0,0,this.m_Container.width,_loc3_);
         this.m_ScrollMask.graphics.endFill();
         this.m_ScrollMask.mouseEnabled = false;
         this.m_ScrollMask.mouseChildren = false;
         addChild(this.m_ScrollMask);
         this.m_ScrollBar = new ScrollSetV(this.m_Container,this.m_ScrollMask);
         this.m_ScrollBar.x = this.m_Container.width - this.m_ScrollBar.width;
         addChild(this.m_ScrollBar);
      }
      
      public function Clear() : void
      {
         this.ClearFriendDisplays();
         removeChild(this.m_ScrollBar);
         removeChild(this.m_ScrollMask);
         removeChild(this.m_Container);
         this.m_ScrollBar = null;
         this.m_ScrollMask = null;
         this.m_Container = null;
         this.m_FriendsToDisplay = null;
      }
      
      internal function Refresh() : void
      {
         this.ClearFriendDisplays();
         this.CreateFriendDisplays();
         this.m_ScrollBar.checkResize();
      }
      
      private function CreateFriendDisplays() : void
      {
         var _loc4_:MapRoom3RelocatePopupItemDisplay = null;
         if(this.m_FriendsToDisplay == null)
         {
            return;
         }
         var _loc1_:int = 0;
         var _loc2_:uint = this.m_FriendsToDisplay.length;
         this.m_FriendItemDisplays = new Vector.<MapRoom3RelocatePopupItemDisplay>(_loc2_);
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new MapRoom3RelocatePopupItemDisplay(this.m_FriendsToDisplay[_loc3_]);
            this.m_FriendItemDisplays[_loc3_] = _loc4_;
            this.m_Container.addChild(_loc4_);
            _loc4_.x = 0;
            _loc4_.y = _loc1_;
            _loc1_ += _loc4_.height;
            _loc3_++;
         }
      }
      
      private function ClearFriendDisplays() : void
      {
         var _loc3_:MapRoom3RelocatePopupItemDisplay = null;
         if(this.m_FriendItemDisplays == null)
         {
            return;
         }
         var _loc1_:uint = this.m_FriendItemDisplays.length;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.m_FriendItemDisplays[_loc2_];
            _loc3_.Clear();
            this.m_Container.removeChild(_loc3_);
            _loc2_++;
         }
         this.m_FriendItemDisplays.length = 0;
         this.m_FriendItemDisplays = null;
      }
   }
}
