package com.monsters.maproom3.bookmarks
{
   import com.monsters.maproom3.MapRoom3;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BookmarksPopupMenuItem extends MapRoom3BookmarksPopupItemDisplay
   {
       
      
      private var m_BookmarkToDisplay:Bookmark;
      
      public function BookmarksPopupMenuItem(param1:Bookmark)
      {
         super();
         this.m_BookmarkToDisplay = param1;
         buttonMode = true;
         nameText.htmlText = param1.displayName;
         nameText.mouseEnabled = false;
         coordinatesText.htmlText = "(" + param1.cellX.toString() + "," + param1.cellY.toString() + ")";
         coordinatesText.mouseEnabled = false;
         background.gotoAndStop("default");
         addEventListener(MouseEvent.CLICK,this.OnMouseClicked,false,0,true);
         addEventListener(MouseEvent.MOUSE_OVER,this.OnMouseOver,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.OnMouseOut,false,0,true);
         removeButton.SetupKey("mr3_bookmarks_popup_remove_button_label");
         removeButton.addEventListener(MouseEvent.CLICK,this.OnRemoveBookmarkClicked,false,0,true);
         removeButton.buttonMode = true;
         if(param1.mapCell.isDataLoaded == false)
         {
            addEventListener(Event.ENTER_FRAME,this.WaitForDataToLoad,false,0,true);
            nameText.htmlText = KEYS.Get("msg_loading");
         }
      }
      
      private function WaitForDataToLoad(param1:Event) : void
      {
         if(this.m_BookmarkToDisplay == null)
         {
            removeEventListener(Event.ENTER_FRAME,this.WaitForDataToLoad);
            return;
         }
         if(this.m_BookmarkToDisplay.mapCell.isDataLoaded == true)
         {
            removeEventListener(Event.ENTER_FRAME,this.WaitForDataToLoad);
            nameText.htmlText = this.m_BookmarkToDisplay.displayName;
            return;
         }
      }
      
      public function Clear() : void
      {
         if(hasEventListener(Event.ENTER_FRAME))
         {
            removeEventListener(Event.ENTER_FRAME,this.WaitForDataToLoad);
         }
         removeEventListener(MouseEvent.CLICK,this.OnMouseClicked);
         removeEventListener(MouseEvent.CLICK,this.OnMouseOver);
         removeEventListener(MouseEvent.CLICK,this.OnMouseOut);
         removeButton.removeEventListener(MouseEvent.CLICK,this.OnRemoveBookmarkClicked);
         this.m_BookmarkToDisplay = null;
      }
      
      private function OnMouseClicked(param1:MouseEvent) : void
      {
         if(this.m_BookmarkToDisplay != null)
         {
            MapRoom3.mapRoom3Window.NavigateToCell(this.m_BookmarkToDisplay.mapCell);
         }
         if(MapRoom3.mapRoom3WindowHUD.bookmarksPopup.visible == true)
         {
            MapRoom3.mapRoom3WindowHUD.bookmarksPopup.Hide();
         }
      }
      
      private function OnMouseOver(param1:MouseEvent) : void
      {
         background.gotoAndStop("mouseover");
      }
      
      private function OnMouseOut(param1:MouseEvent) : void
      {
         background.gotoAndStop("default");
      }
      
      private function OnRemoveBookmarkClicked(param1:MouseEvent) : void
      {
         if(this.m_BookmarkToDisplay != null)
         {
            BookmarksManager.instance.RemoveBookmark(this.m_BookmarkToDisplay.mapCell);
         }
         if(MapRoom3.mapRoom3WindowHUD.bookmarksPopup.visible == true)
         {
            MapRoom3.mapRoom3WindowHUD.bookmarksPopup.Refresh();
         }
      }
   }
}
