package com.monsters.maproom3
{
   import com.monsters.chat.Chat;
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom3.bookmarks.Bookmark;
   import com.monsters.maproom3.bookmarks.BookmarkDisplay;
   import com.monsters.maproom3.bookmarks.BookmarksDisplayList;
   import com.monsters.maproom3.bookmarks.BookmarksExpandableFrame;
   import com.monsters.maproom3.bookmarks.BookmarksManager;
   import com.monsters.maproom3.bookmarks.BookmarksPopup;
   import com.monsters.maproom3.popups.Maproom3JumpPopup;
   import com.monsters.ui.UI_BOTTOM;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import org.bytearray.display.ScaleBitmap;
   
   public class MapRoom3WindowHUD extends Sprite
   {
      
      private static const MENU_BUTTONS_BAR_MARGIN_WIDTH:uint = 10;
      
      private static const MENU_BUTTONS_BAR_BUTTON_SPACING:uint = 10;
      
      private static const OPTION_BUTTONS_BAR_PADDING_RIGHT:uint = 10;
      
      private static const OPTION_BUTTONS_BAR_PADDING_TOP:uint = 10;
      
      private static const OPTION_BUTTONS_BAR_BUTTON_SPACING:uint = 5;
      
      private static const BOOKMARKS_BAR_SPACING:uint = 10;
      
      private static const MAX_BOOKMARKS_DISPLAY_LIST_LENGTH:uint = 3;
      
      private static const REOURCE_BAR_WIDTH:uint = 90;
      
      private static const ZOOM_TIME:Number = 1;
       
      
      private var m_ResourcesDisplay:MapRoom3ResourcesDisplay;
      
      private var m_OptionButtonsBar:Sprite;
      
      private var m_ZoomOutButton:Sprite;
      
      private var m_ZoomInButton:Sprite;
      
      private var m_FullscreenButton:Sprite;
      
      private var m_OptionButtonToolTip:bubblepopup5;
      
      private var m_LeftMenuButtonsBar:Sprite;
      
      private var m_LeftMenuButtonsContainerBackground:ScaleBitmap;
      
      private var m_BookmarksButton:StoneButton;
      
      private var m_JumpButton:StoneButton;
      
      private var m_CoordinatesPanel:Sprite;
      
      private var m_CoordinatesBackground:Bitmap;
      
      private var m_CoordinatesLabel:TextField;
      
      private var m_RightMenuButtonsBar:Sprite;
      
      private var m_RightMenuButtonsContainerBackground:ScaleBitmap;
      
      private var m_FindBaseButton:StoneButton;
      
      private var m_EnterBaseButton:StoneButton;
      
      private var m_BookmarksBar:Sprite;
      
      private var m_ResourceBookmarksBar:BookmarksExpandableFrame;
      
      private var m_ResourceBookmarksDisplayList:BookmarksDisplayList;
      
      private var m_StrongholdBookmarksBar:BookmarksExpandableFrame;
      
      private var m_StrongholdBookmarksDisplayList:BookmarksDisplayList;
      
      private var m_BookmarksPopup:BookmarksPopup;
      
      public function MapRoom3WindowHUD()
      {
         var _loc1_:BitmapData = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Vector.<Bookmark> = null;
         var _loc9_:Vector.<Bookmark> = null;
         this.m_BookmarksPopup = new BookmarksPopup();
         super();
         this.m_ResourcesDisplay = new MapRoom3ResourcesDisplay();
         this.m_ResourcesDisplay.mouseEnabled = false;
         this.m_ResourcesDisplay.mouseChildren = false;
         this.m_ResourcesDisplay.gotoAndStop(BASE.isInfernoMainYardOrOutpost ? 2 : 1);
         addChild(this.m_ResourcesDisplay);
         this.m_OptionButtonsBar = new Sprite();
         this.m_OptionButtonsBar.buttonMode = true;
         addChild(this.m_OptionButtonsBar);
         this.m_ZoomOutButton = new Sprite();
         this.m_ZoomOutButton.addChild(new Bitmap(MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.HUD_BUTTON_ZOOM_OUT)));
         this.m_ZoomOutButton.addEventListener(MouseEvent.CLICK,this.OnZoomOutButtonClicked,false,0,true);
         this.m_ZoomOutButton.addEventListener(MouseEvent.MOUSE_OVER,this.OnZoomOutButtonMouseOver,false,0,true);
         this.m_ZoomOutButton.addEventListener(MouseEvent.MOUSE_OUT,this.OnZoomOutButtonMouseOut,false,0,true);
         this.m_OptionButtonsBar.addChild(this.m_ZoomOutButton);
         this.m_ZoomInButton = new Sprite();
         this.m_ZoomInButton.addChild(new Bitmap(MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.HUD_BUTTON_ZOOM_IN)));
         this.m_ZoomInButton.addEventListener(MouseEvent.CLICK,this.OnZoomInButtonClicked,false,0,true);
         this.m_ZoomInButton.addEventListener(MouseEvent.MOUSE_OVER,this.OnZoomInButtonMouseOver,false,0,true);
         this.m_ZoomInButton.addEventListener(MouseEvent.MOUSE_OUT,this.OnZoomInButtonMouseOut,false,0,true);
         this.m_ZoomInButton.visible = false;
         this.m_OptionButtonsBar.addChild(this.m_ZoomInButton);
         this.m_FullscreenButton = new Sprite();
         this.m_FullscreenButton.addChild(new Bitmap(MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.HUD_BUTTON_FULL_SCREEN)));
         this.m_FullscreenButton.x = this.m_ZoomInButton.width + OPTION_BUTTONS_BAR_BUTTON_SPACING;
         this.m_FullscreenButton.addEventListener(MouseEvent.CLICK,this.OnFullscreenButtonClicked,false,0,true);
         this.m_FullscreenButton.addEventListener(MouseEvent.MOUSE_OVER,this.OnFullscreenButtonMouseOver,false,0,true);
         this.m_FullscreenButton.addEventListener(MouseEvent.MOUSE_OUT,this.OnFullscreenButtonMouseOut,false,0,true);
         this.m_OptionButtonsBar.addChild(this.m_FullscreenButton);
         this.m_OptionButtonToolTip = new bubblepopup5();
         this.m_OptionButtonToolTip.visible = false;
         this.m_OptionButtonToolTip.mouseEnabled = false;
         this.m_OptionButtonToolTip.mouseChildren = false;
         this.m_OptionButtonToolTip.mcText.autoSize = TextFieldAutoSize.LEFT;
         addChild(this.m_OptionButtonToolTip);
         _loc1_ = MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.HUD_BUTTONS_BAR_BACKGROUND);
         this.m_LeftMenuButtonsBar = new Sprite();
         addChild(this.m_LeftMenuButtonsBar);
         this.m_LeftMenuButtonsContainerBackground = new ScaleBitmap(_loc1_);
         this.m_LeftMenuButtonsBar.addChild(this.m_LeftMenuButtonsContainerBackground);
         this.m_BookmarksButton = new StoneButton();
         this.m_BookmarksButton.SetupKey("mr3_bookmarks_button",12);
         this.m_BookmarksButton.addEventListener(MouseEvent.CLICK,this.OnBookmarksButtonClicked);
         this.m_LeftMenuButtonsBar.addChild(this.m_BookmarksButton);
         this.m_JumpButton = new StoneButton();
         this.m_JumpButton.SetupKey("btn_jump",12);
         this.m_JumpButton.addEventListener(MouseEvent.CLICK,this.OnJumpButtonClicked);
         this.m_LeftMenuButtonsBar.addChild(this.m_JumpButton);
         this.m_CoordinatesPanel = new Sprite();
         this.m_LeftMenuButtonsBar.addChild(this.m_CoordinatesPanel);
         this.m_CoordinatesBackground = new Bitmap(MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.HUD_COORDINATES_BACKGROUND));
         this.m_CoordinatesPanel.addChild(this.m_CoordinatesBackground);
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.color = 16777215;
         _loc2_.font = "Verdana";
         _loc2_.size = 12;
         _loc2_.align = TextFormatAlign.CENTER;
         this.m_CoordinatesLabel = new TextField();
         this.m_CoordinatesLabel.defaultTextFormat = _loc2_;
         this.m_CoordinatesLabel.selectable = false;
         this.m_CoordinatesLabel.y = 10;
         this.m_CoordinatesLabel.width = this.m_CoordinatesBackground.width;
         this.m_CoordinatesLabel.height = this.m_CoordinatesBackground.height;
         this.m_CoordinatesPanel.addChild(this.m_CoordinatesLabel);
         this.m_RightMenuButtonsBar = new Sprite();
         addChild(this.m_RightMenuButtonsBar);
         this.m_RightMenuButtonsContainerBackground = new ScaleBitmap(_loc1_);
         this.m_RightMenuButtonsBar.addChild(this.m_RightMenuButtonsContainerBackground);
         this.m_FindBaseButton = new StoneButton();
         this.m_FindBaseButton.SetupKey("mr3_find_base",12);
         this.m_FindBaseButton.addEventListener(MouseEvent.CLICK,this.OnFindBaseButtonClicked);
         this.m_RightMenuButtonsBar.addChild(this.m_FindBaseButton);
         this.m_EnterBaseButton = new StoneButton();
         this.m_EnterBaseButton.SetupKey("mr3_exit_to_base",12);
         this.m_EnterBaseButton.addEventListener(MouseEvent.CLICK,this.OnEnterBaseButtonClicked);
         this.m_RightMenuButtonsBar.addChild(this.m_EnterBaseButton);
         _loc3_ = this.m_LeftMenuButtonsContainerBackground.height * 0.5;
         _loc4_ = this.m_BookmarksButton.getButtonHeight() * 0.5;
         _loc5_ = _loc3_ - _loc4_;
         _loc6_ = int(MENU_BUTTONS_BAR_MARGIN_WIDTH);
         this.m_BookmarksButton.x = _loc6_;
         this.m_BookmarksButton.y = _loc5_;
         _loc6_ += this.m_BookmarksButton.getButtonWidth() + MENU_BUTTONS_BAR_BUTTON_SPACING;
         this.m_JumpButton.x = _loc6_;
         this.m_JumpButton.y = _loc5_;
         _loc6_ += this.m_JumpButton.getButtonWidth() + MENU_BUTTONS_BAR_BUTTON_SPACING;
         this.m_CoordinatesPanel.x = _loc6_;
         this.m_CoordinatesPanel.y = _loc5_;
         _loc6_ += this.m_CoordinatesPanel.width + MENU_BUTTONS_BAR_MARGIN_WIDTH;
         this.m_LeftMenuButtonsContainerBackground.width = _loc6_;
         _loc6_ = int(MENU_BUTTONS_BAR_MARGIN_WIDTH);
         this.m_FindBaseButton.x = _loc6_;
         this.m_FindBaseButton.y = _loc5_;
         _loc6_ += this.m_FindBaseButton.getButtonWidth() + MENU_BUTTONS_BAR_BUTTON_SPACING;
         this.m_EnterBaseButton.x = _loc6_;
         this.m_EnterBaseButton.y = _loc5_;
         _loc6_ += this.m_EnterBaseButton.getButtonWidth() + MENU_BUTTONS_BAR_MARGIN_WIDTH;
         this.m_RightMenuButtonsContainerBackground.width = _loc6_;
         this.m_BookmarksBar = new Sprite();
         addChild(this.m_BookmarksBar);
         _loc7_ = BookmarksManager.instance.GetBookmarksOfType(BookmarksManager.TYPE_PLAYER_RESOURCES);
         var _loc8_:String = KEYS.Get("mr3_resource_bookmarks_header",{"v1":_loc7_.length});
         this.m_ResourceBookmarksDisplayList = new BookmarksDisplayList(_loc7_,this.CreateNewResourceBookmarkDisplay,MAX_BOOKMARKS_DISPLAY_LIST_LENGTH);
         this.m_ResourceBookmarksBar = new BookmarksExpandableFrame(this.m_ResourceBookmarksDisplayList,_loc8_,this.m_ResourceBookmarksDisplayList.maxDisplayListHeight);
         this.m_ResourceBookmarksBar.frameHeader.addEventListener(MouseEvent.CLICK,this.m_ResourceBookmarksDisplayList.NavigateToNextBookmark,false,0,true);
         this.m_BookmarksBar.addChild(this.m_ResourceBookmarksBar);
         _loc9_ = BookmarksManager.instance.GetBookmarksOfType(BookmarksManager.TYPE_PLAYER_STRONGHOLDS);
         var _loc10_:String = KEYS.Get("mr3_stronghold_bookmarks_header",{"v1":_loc9_.length});
         this.m_StrongholdBookmarksDisplayList = new BookmarksDisplayList(_loc9_,this.CreateNewStrongholdBookmarkDisplay,MAX_BOOKMARKS_DISPLAY_LIST_LENGTH);
         this.m_StrongholdBookmarksBar = new BookmarksExpandableFrame(this.m_StrongholdBookmarksDisplayList,_loc10_,this.m_StrongholdBookmarksDisplayList.maxDisplayListHeight);
         this.m_StrongholdBookmarksBar.frameHeader.addEventListener(MouseEvent.CLICK,this.m_StrongholdBookmarksDisplayList.NavigateToNextBookmark,false,0,true);
         this.m_StrongholdBookmarksBar.x = this.m_ResourceBookmarksBar.width + BOOKMARKS_BAR_SPACING;
         this.m_BookmarksBar.addChild(this.m_StrongholdBookmarksBar);
         this.UpdateResourcesDisplay();
         this.PositionHUDElements();
      }
      
      public function get bookmarksPopup() : BookmarksPopup
      {
         return this.m_BookmarksPopup;
      }
      
      private function CreateNewResourceBookmarkDisplay(param1:Bookmark, param2:int) : BookmarkDisplay
      {
         var _loc3_:String = !!(param2 % 2) ? "bgDark" : "bgLight";
         return new BookmarkDisplay(param1,_loc3_,MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.HUD_BOOKMARK_THUMBNAIL_RESOURCE));
      }
      
      private function CreateNewStrongholdBookmarkDisplay(param1:Bookmark, param2:int) : BookmarkDisplay
      {
         var _loc3_:String = !!(param2 % 2) ? "bgDark" : "bgLight";
         return new BookmarkDisplay(param1,_loc3_,MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.HUD_BOOKMARK_THUMBNAIL_STRONGHOLD));
      }
      
      public function Clear() : void
      {
         this.m_BookmarksPopup.Hide();
         this.m_BookmarksPopup = null;
         this.m_BookmarksBar.removeChild(this.m_StrongholdBookmarksBar);
         this.m_BookmarksBar.removeChild(this.m_ResourceBookmarksBar);
         removeChild(this.m_BookmarksBar);
         this.m_StrongholdBookmarksBar.frameHeader.removeEventListener(MouseEvent.CLICK,this.m_StrongholdBookmarksDisplayList.NavigateToNextBookmark);
         this.m_ResourceBookmarksBar.frameHeader.removeEventListener(MouseEvent.CLICK,this.m_ResourceBookmarksDisplayList.NavigateToNextBookmark);
         this.m_StrongholdBookmarksBar.Clear();
         this.m_ResourceBookmarksBar.Clear();
         this.m_StrongholdBookmarksBar = null;
         this.m_ResourceBookmarksBar = null;
         this.m_BookmarksBar = null;
         this.m_RightMenuButtonsBar.removeChild(this.m_RightMenuButtonsContainerBackground);
         this.m_RightMenuButtonsBar.removeChild(this.m_EnterBaseButton);
         this.m_RightMenuButtonsBar.removeChild(this.m_FindBaseButton);
         removeChild(this.m_RightMenuButtonsBar);
         this.m_EnterBaseButton = null;
         this.m_FindBaseButton = null;
         this.m_RightMenuButtonsContainerBackground = null;
         this.m_RightMenuButtonsBar = null;
         this.m_CoordinatesPanel.removeChild(this.m_CoordinatesLabel);
         this.m_CoordinatesPanel.removeChild(this.m_CoordinatesBackground);
         this.m_LeftMenuButtonsBar.removeChild(this.m_CoordinatesPanel);
         this.m_LeftMenuButtonsBar.removeChild(this.m_BookmarksButton);
         removeChild(this.m_LeftMenuButtonsBar);
         this.m_CoordinatesLabel = null;
         this.m_CoordinatesBackground = null;
         this.m_CoordinatesPanel = null;
         this.m_BookmarksButton = null;
         this.m_JumpButton = null;
         this.m_LeftMenuButtonsContainerBackground = null;
         this.m_LeftMenuButtonsBar = null;
         this.m_ZoomOutButton.removeEventListener(MouseEvent.CLICK,this.OnZoomOutButtonClicked);
         this.m_ZoomOutButton.removeEventListener(MouseEvent.CLICK,this.OnZoomOutButtonMouseOver);
         this.m_ZoomOutButton.removeEventListener(MouseEvent.CLICK,this.OnZoomOutButtonMouseOut);
         this.m_ZoomInButton.removeEventListener(MouseEvent.CLICK,this.OnZoomInButtonClicked);
         this.m_ZoomInButton.removeEventListener(MouseEvent.CLICK,this.OnZoomInButtonMouseOver);
         this.m_ZoomInButton.removeEventListener(MouseEvent.CLICK,this.OnZoomInButtonMouseOut);
         this.m_FullscreenButton.removeEventListener(MouseEvent.CLICK,this.OnFullscreenButtonClicked);
         this.m_FullscreenButton.removeEventListener(MouseEvent.CLICK,this.OnFullscreenButtonMouseOver);
         this.m_FullscreenButton.removeEventListener(MouseEvent.CLICK,this.OnFullscreenButtonMouseOut);
         this.RemoveAllChildren(this.m_ZoomOutButton);
         this.RemoveAllChildren(this.m_ZoomInButton);
         this.RemoveAllChildren(this.m_FullscreenButton);
         this.m_OptionButtonsBar.removeChild(this.m_ZoomOutButton);
         this.m_OptionButtonsBar.removeChild(this.m_ZoomInButton);
         this.m_OptionButtonsBar.removeChild(this.m_FullscreenButton);
         removeChild(this.m_OptionButtonToolTip);
         removeChild(this.m_OptionButtonsBar);
         this.m_ZoomOutButton = null;
         this.m_ZoomInButton = null;
         this.m_FullscreenButton = null;
         this.m_OptionButtonToolTip = null;
         this.m_OptionButtonsBar = null;
      }
      
      private function RemoveAllChildren(param1:Sprite) : void
      {
         var _loc2_:Bitmap = null;
         while(param1.numChildren > 0)
         {
            _loc2_ = param1.removeChildAt(0) as Bitmap;
            if(_loc2_ != null)
            {
               _loc2_.bitmapData = null;
            }
         }
      }
      
      private function UpdateResourcesDisplay() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc1_:uint = 1;
         while(_loc1_ <= 4)
         {
            _loc2_ = Number(GLOBAL._resources["r" + _loc1_].Get());
            _loc3_ = Number(GLOBAL._resources["r" + _loc1_ + "max"]);
            _loc4_ = Math.max(0,Math.min(1,_loc2_ / _loc3_));
            this.m_ResourcesDisplay["resourceDisplay" + _loc1_].tR.htmlText = "<b>" + GLOBAL.FormatNumber(_loc2_) + "</b>";
            this.m_ResourcesDisplay["resourceDisplay" + _loc1_].mcBar.width = REOURCE_BAR_WIDTH * _loc4_;
            _loc1_++;
         }
      }
      
      private function PositionHUDElements() : void
      {
         this.PositionResourcesDisplay();
         this.PositionBookmarksBar();
         this.PositionOptionsButtonBar();
         this.PositionLeftMenuButtonsBar();
         this.PositionRightMenuButtonsBar();
      }
      
      private function PositionResourcesDisplay() : void
      {
         this.m_ResourcesDisplay.x = GLOBAL._SCREEN.x;
         this.m_ResourcesDisplay.y = GLOBAL._SCREEN.y;
      }
      
      private function PositionBookmarksBar() : void
      {
         this.m_BookmarksBar.x = GLOBAL._SCREEN.x + GLOBAL._SCREEN.width * 0.5 - this.m_BookmarksBar.width * 0.5;
         this.m_BookmarksBar.y = GLOBAL._SCREEN.y;
         if(this.m_BookmarksBar.x < this.m_ResourcesDisplay.x + this.m_ResourcesDisplay.width)
         {
            this.m_BookmarksBar.x = this.m_ResourcesDisplay.x + this.m_ResourcesDisplay.width;
         }
      }
      
      private function PositionOptionsButtonBar() : void
      {
         this.m_OptionButtonsBar.x = GLOBAL._SCREEN.x + GLOBAL._SCREEN.width - this.m_OptionButtonsBar.width - OPTION_BUTTONS_BAR_PADDING_RIGHT;
         this.m_OptionButtonsBar.y = GLOBAL._SCREEN.y + OPTION_BUTTONS_BAR_PADDING_TOP;
      }
      
      public function PositionLeftMenuButtonsBar() : void
      {
         if(this.m_LeftMenuButtonsContainerBackground == null)
         {
            return;
         }
         this.m_LeftMenuButtonsBar.x = int(GLOBAL._SCREEN.x);
         if(Chat._bymChat != null && Chat._bymChat.chatBox != null && Chat._bymChat.chatBox.background != null)
         {
            this.m_LeftMenuButtonsBar.y = int(Chat._bymChat.y + Chat._bymChat.chatBox.y + Chat._bymChat.chatBox.background.y - this.m_LeftMenuButtonsContainerBackground.height);
         }
      }
      
      public function PositionRightMenuButtonsBar() : void
      {
         if(this.m_RightMenuButtonsContainerBackground == null)
         {
            return;
         }
         this.m_RightMenuButtonsBar.x = int(GLOBAL._SCREEN.x + GLOBAL._SCREEN.width - this.m_RightMenuButtonsContainerBackground.width);
         if(UI_BOTTOM._missions != null && UI_BOTTOM._missions.frame != null)
         {
            this.m_RightMenuButtonsBar.y = int(UI_BOTTOM._missions.y + UI_BOTTOM._missions.frame.y - this.m_RightMenuButtonsContainerBackground.height + 1);
         }
      }
      
      private function OnBookmarksButtonClicked(param1:MouseEvent) : void
      {
         this.m_BookmarksPopup.Show(BookmarksManager.instance.GetBookmarksOfType(BookmarksManager.TYPE_CUSTOM));
      }
      
      protected function OnJumpButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:Maproom3JumpPopup = new Maproom3JumpPopup();
         _loc2_.addEventListener(Maproom3JumpPopup.k_clickedJump,this.clickedJump);
         POPUPS.Push(_loc2_);
      }
      
      protected function clickedJump(param1:Event) : void
      {
         var _loc2_:Maproom3JumpPopup = param1.target as Maproom3JumpPopup;
         _loc2_.removeEventListener(Maproom3JumpPopup.k_clickedJump,this.clickedJump);
         _loc2_.Hide();
         var _loc3_:MapRoom3Cell = _loc2_.targetCell as MapRoom3Cell;
         MapRoom3.mapRoom3Window.NavigateToCell(_loc3_);
         this.DisplayCoordinatesOfCell(_loc3_);
      }
      
      private function OnFindBaseButtonClicked(param1:MouseEvent) : void
      {
         if(GLOBAL._mapHome != null)
         {
            MapRoom3.mapRoom3Window.NavigateToIndex(GLOBAL._mapHome);
         }
      }
      
      private function OnEnterBaseButtonClicked(param1:MouseEvent) : void
      {
         BASE.LoadBase(null,0,GLOBAL._homeBaseID,GLOBAL.e_BASE_MODE.BUILD,false,EnumYardType.PLAYER);
      }
      
      private function OnZoomOutButtonClicked(param1:MouseEvent) : void
      {
         this.m_ZoomOutButton.visible = false;
         this.m_ZoomInButton.visible = true;
         MapRoom3.mapRoom3Window.Zoom(0.5,ZOOM_TIME);
      }
      
      private function OnZoomInButtonClicked(param1:MouseEvent) : void
      {
         this.m_ZoomInButton.visible = false;
         this.m_ZoomOutButton.visible = true;
         MapRoom3.mapRoom3Window.Zoom(1,ZOOM_TIME);
      }
      
      private function OnFullscreenButtonClicked(param1:MouseEvent) : void
      {
         GLOBAL.goFullScreen();
      }
      
      private function OnZoomOutButtonMouseOver(param1:MouseEvent) : void
      {
         this.ShowOptionButtonToolTip("settings_zoomout",param1.target.x,param1.target.y);
      }
      
      private function OnZoomOutButtonMouseOut(param1:MouseEvent) : void
      {
         this.HideOptionButtonToolTip();
      }
      
      private function OnZoomInButtonMouseOver(param1:MouseEvent) : void
      {
         this.ShowOptionButtonToolTip("settings_zoomin",param1.target.x,param1.target.y);
      }
      
      private function OnZoomInButtonMouseOut(param1:MouseEvent) : void
      {
         this.HideOptionButtonToolTip();
      }
      
      private function OnFullscreenButtonMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:String = GLOBAL._ROOT.stage.displayState == StageDisplayState.FULL_SCREEN || GLOBAL._ROOT.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE ? "settings_fullscreenexit" : "settings_fullscreenenter";
         this.ShowOptionButtonToolTip(_loc2_,param1.target.x,param1.target.y);
      }
      
      private function OnFullscreenButtonMouseOut(param1:MouseEvent) : void
      {
         this.HideOptionButtonToolTip();
      }
      
      private function ShowOptionButtonToolTip(param1:String, param2:Number, param3:Number) : void
      {
         this.m_OptionButtonToolTip.visible = true;
         this.m_OptionButtonToolTip.mcText.htmlText = "<b>" + KEYS.Get(param1) + "</b>";
         this.m_OptionButtonToolTip.x = this.m_OptionButtonsBar.x + param2 + 12;
         this.m_OptionButtonToolTip.y = this.m_OptionButtonsBar.y + param3 + 20;
         this.m_OptionButtonToolTip.mcText.x = 10 - this.m_OptionButtonToolTip.mcText.width;
         this.m_OptionButtonToolTip.mcBG.x = this.m_OptionButtonToolTip.mcText.x - 5;
         this.m_OptionButtonToolTip.mcBG.width = this.m_OptionButtonToolTip.mcText.width + 10;
      }
      
      private function HideOptionButtonToolTip() : void
      {
         this.m_OptionButtonToolTip.visible = false;
      }
      
      public function Resize() : void
      {
         this.PositionHUDElements();
      }
      
      public function DisplayCoordinatesOfCell(param1:MapRoom3Cell) : void
      {
         if(param1 != null && param1.isBorder == false)
         {
            this.m_CoordinatesLabel.text = param1.cellX.toString() + "," + param1.cellY.toString();
         }
         else
         {
            this.m_CoordinatesLabel.text = "";
         }
      }
      
      public function get leftMenuButtonsBar() : Sprite
      {
         return this.m_LeftMenuButtonsBar;
      }
   }
}
