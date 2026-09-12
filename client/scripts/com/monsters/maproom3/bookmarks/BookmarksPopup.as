package com.monsters.maproom3.bookmarks
{
   import com.bymrefitted.ui.interfaces.IHideActionHandler;
   import flash.events.MouseEvent;
   public class BookmarksPopup extends MapRoom3BookmarksPopup implements IHideActionHandler
   {
      
      private static const MAX_BOOKMARKS_DISPLAY_LIST_LENGTH:uint = 10;
       
      
      private var m_BookmarkDisplayList:BookmarksDisplayList;
      
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
         this.m_BookmarkDisplayList = new BookmarksDisplayList(param1,this.CreateNewBookmarksPopupMenuItem,MAX_BOOKMARKS_DISPLAY_LIST_LENGTH);
         contentsContainer.addChild(this.m_BookmarkDisplayList);
         POPUPS.Push(this);
      }
      
      private function CreateNewBookmarksPopupMenuItem(param1:Bookmark, param2:int) : BookmarksPopupMenuItem
      {
         return new BookmarksPopupMenuItem(param1);
      }
      
      public function Hide(param1:MouseEvent = null) : void
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
