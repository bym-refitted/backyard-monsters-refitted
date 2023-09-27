package com.monsters.maproom3.bookmarks
{
   public class BookmarksPopup extends MapRoom3BookmarksPopup
   {
      
      private static const MAX_BOOKMARKS_DISPLAY_LIST_LENGTH:uint = 10;
       
      
      private var m_BookmarkDisplayList:com.monsters.maproom3.bookmarks.BookmarksDisplayList;
      
      public function BookmarksPopup()
      {
         super();
         titleText.text = KEYS.Get("mr3_bookmarks_popup_title");
         contentsFrame.mouseEnabled = false;
         contentsMask.mouseEnabled = false;
      }
      
      public function Show(param1:Vector.<Bookmark>) : void
      {
         this.Hide();
         this.m_BookmarkDisplayList = new com.monsters.maproom3.bookmarks.BookmarksDisplayList(param1,this.CreateNewBookmarksPopupMenuItem,MAX_BOOKMARKS_DISPLAY_LIST_LENGTH);
         contentsContainer.addChild(this.m_BookmarkDisplayList);
         POPUPS.Push(this);
      }
      
      private function CreateNewBookmarksPopupMenuItem(param1:Bookmark, param2:int) : BookmarksPopupMenuItem
      {
         return new BookmarksPopupMenuItem(param1);
      }
      
      public function Hide() : void
      {
         POPUPS.Next();
         if(this.m_BookmarkDisplayList != null)
         {
            contentsContainer.removeChild(this.m_BookmarkDisplayList);
            this.m_BookmarkDisplayList = null;
         }
      }
      
      internal function Refresh() : void
      {
         if(this.m_BookmarkDisplayList != null)
         {
            this.m_BookmarkDisplayList.Refresh();
         }
      }
   }
}
