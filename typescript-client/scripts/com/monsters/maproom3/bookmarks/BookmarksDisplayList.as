package com.monsters.maproom3.bookmarks
{
   import com.monsters.display.ScrollSetV;
   import com.monsters.maproom3.MapRoom3;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class BookmarksDisplayList extends Sprite
   {
       
      
      private var m_BookmarksToDisplay:Vector.<Bookmark>;
      
      private var m_BookmarkDisplays:Vector.<Sprite>;
      
      private var m_BookmarkDisplayFactory:Function;
      
      private var m_Container:Sprite;
      
      private var m_ScrollMask:Sprite;
      
      private var m_ScrollBar:ScrollSetV;
      
      private var m_MaxDisplayListHeight:Number;
      
      private var m_LastSelectedBookmarkIndex:int = -1;
      
      public function BookmarksDisplayList(param1:Vector.<Bookmark>, param2:Function, param3:int = -1)
      {
         super();
         this.m_BookmarksToDisplay = param1;
         this.m_BookmarkDisplayFactory = param2;
         this.m_Container = new Sprite();
         addChild(this.m_Container);
         this.CreateBookmarkDisplays();
         this.m_MaxDisplayListHeight = this.m_Container.height;
         if(param3 != -1 && param3 < this.m_BookmarkDisplays.length)
         {
            this.m_MaxDisplayListHeight = param3 * this.m_BookmarkDisplays[0].height;
         }
         this.m_ScrollMask = new Sprite();
         this.m_ScrollMask.graphics.beginFill(16777215,0.01);
         this.m_ScrollMask.graphics.drawRect(0,0,this.m_Container.width,this.m_MaxDisplayListHeight);
         this.m_ScrollMask.graphics.endFill();
         this.m_ScrollMask.mouseEnabled = false;
         this.m_ScrollMask.mouseChildren = false;
         addChild(this.m_ScrollMask);
         this.m_ScrollBar = new ScrollSetV(this.m_Container,this.m_ScrollMask);
         this.m_ScrollBar.x = this.m_Container.width - this.m_ScrollBar.width;
         addChild(this.m_ScrollBar);
      }
      
      public function get maxDisplayListHeight() : Number
      {
         return this.m_MaxDisplayListHeight;
      }
      
      public function Clear() : void
      {
         this.ClearBookmarkDisplays();
         removeChild(this.m_ScrollBar);
         removeChild(this.m_ScrollMask);
         removeChild(this.m_Container);
         this.m_ScrollBar = null;
         this.m_ScrollMask = null;
         this.m_Container = null;
         this.m_BookmarksToDisplay = null;
         this.m_BookmarkDisplayFactory = null;
      }
      
      internal function Refresh() : void
      {
         this.ClearBookmarkDisplays();
         this.CreateBookmarkDisplays();
         this.m_ScrollBar.checkResize();
      }
      
      private function CreateBookmarkDisplays() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         if(this.m_BookmarksToDisplay == null)
         {
            return;
         }
         _loc1_ = 0;
         var _loc3_:uint = this.m_BookmarksToDisplay.length;
         this.m_BookmarkDisplays = new Vector.<Sprite>(_loc3_);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.m_BookmarkDisplayFactory(this.m_BookmarksToDisplay[_loc4_],_loc4_);
            this.m_BookmarkDisplays[_loc4_] = _loc2_;
            this.m_Container.addChild(_loc2_);
            _loc2_.x = 0;
            _loc2_.y = _loc1_;
            _loc1_ += _loc2_.height;
            _loc4_++;
         }
      }
      
      private function ClearBookmarkDisplays() : void
      {
         var _loc1_:Sprite = null;
         if(this.m_BookmarkDisplays == null)
         {
            return;
         }
         var _loc2_:uint = this.m_BookmarkDisplays.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.m_BookmarkDisplays[_loc3_];
            if(_loc1_.hasOwnProperty("Clear"))
            {
               _loc1_["Clear"]();
            }
            this.m_Container.removeChild(_loc1_);
            _loc3_++;
         }
         this.m_BookmarkDisplays.length = 0;
         this.m_BookmarkDisplays = null;
      }
      
      public function NavigateToNextBookmark(param1:Event = null) : void
      {
         var _loc2_:uint = this.m_BookmarksToDisplay.length;
         if(_loc2_ == 0)
         {
            return;
         }
         ++this.m_LastSelectedBookmarkIndex;
         if(this.m_LastSelectedBookmarkIndex >= this.m_BookmarksToDisplay.length)
         {
            this.m_LastSelectedBookmarkIndex = 0;
         }
         MapRoom3.mapRoom3Window.NavigateToCell(this.m_BookmarksToDisplay[this.m_LastSelectedBookmarkIndex].mapCell);
      }
   }
}
