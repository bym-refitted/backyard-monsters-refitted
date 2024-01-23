package com.monsters.maproom3.bookmarks
{
   import com.monsters.maproom3.MapRoom3;
   import com.monsters.maproom3.MapRoom3AssetCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   
   public class BookmarkDisplay extends MapRoom3BookmarkDisplay
   {
       
      
      private var m_BookmarkToDisplay:Bookmark;
      
      private var m_ThumbnailIcon:Bitmap;
      
      private var m_DamageBarIcon:Bitmap;
      
      public function BookmarkDisplay(param1:Bookmark, param2:String, param3:BitmapData)
      {
         super();
         this.m_BookmarkToDisplay = param1;
         background.gotoAndStop(param2);
         buttonMode = true;
         this.m_ThumbnailIcon = new Bitmap(param3);
         imageHolder.addChild(this.m_ThumbnailIcon);
         var _loc4_:BitmapData = MapRoom3AssetCache.instance.GetDamageBarSegmentAsset(param1.mapCell.damagePercentage);
         this.m_DamageBarIcon = new Bitmap(_loc4_);
         this.m_DamageBarIcon.y = this.m_ThumbnailIcon.height - _loc4_.height;
         imageHolder.addChild(this.m_DamageBarIcon);
         nameText.htmlText = "<b>" + this.m_BookmarkToDisplay.displayName + "</b>";
         descriptionText.htmlText = KEYS.Get("mr3_bookmark_coordinates_info",{
            "v1":param1.cellX,
            "v2":param1.cellY
         });
         addEventListener(MouseEvent.CLICK,this.OnSelected,false,0,true);
      }
      
      public function Clear() : void
      {
         removeEventListener(MouseEvent.CLICK,this.OnSelected);
         if(this.m_ThumbnailIcon != null)
         {
            imageHolder.removeChild(this.m_ThumbnailIcon);
            this.m_ThumbnailIcon.bitmapData = null;
            this.m_ThumbnailIcon = null;
         }
         if(this.m_DamageBarIcon != null)
         {
            imageHolder.removeChild(this.m_DamageBarIcon);
            this.m_DamageBarIcon.bitmapData = null;
            this.m_DamageBarIcon = null;
         }
         this.m_BookmarkToDisplay = null;
      }
      
      private function OnSelected(param1:MouseEvent) : void
      {
         if(this.m_BookmarkToDisplay != null)
         {
            MapRoom3.mapRoom3Window.NavigateToCell(this.m_BookmarkToDisplay.mapCell);
         }
      }
   }
}
