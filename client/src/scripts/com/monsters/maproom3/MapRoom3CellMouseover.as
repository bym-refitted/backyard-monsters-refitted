package com.monsters.maproom3
{
   import com.monsters.alliances.ALLIANCES;
   import com.monsters.display.ImageCache;
   import com.monsters.mailbox.Message;
   import com.monsters.mailbox.model.Contact;
   import com.monsters.maproom3.bookmarks.BookmarksManager;
   import com.monsters.maproom3.data.MapRoom3AllianceData;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class MapRoom3CellMouseover extends Sprite
   {
      
      private static const PORTRAIT_WIDTH:int = 50;
      
      private static const PORTRAIT_HEIGHT:int = 50;
      
      private static const PORTRAIT_OFFSET_X:int = 2;
      
      private static const PORTRAIT_OFFSET_Y:int = 2;
      
      private static const ALLIANCE_ICON_OFFSET_X:int = 5;
      
      private static const ALLIANCE_ICON_OFFSET_Y:int = 2;
      
      private static const TRUCE_ICON_OFFSET_X:int = -10;
      
      private static const TRUCE_ICON_OFFSET_Y:int = -10;
      
      private static const INFO_DISPLAY_OFFSET_Y:int = 8;
      
      private static const INFO_TEXT_COLOR_DEFAULT:uint = 16777215;
      
      private static const INFO_TEXT_COLOR_BUFF_BLUE:uint = 42495;
      
      private static const INFO_TEXT_COLOR_BUFF_RED:uint = 16711680;
       
      
      private var m_InfoDisplay:Sprite;
      
      private var m_ButtonDisplay:Sprite;
      
      private var m_TextDisplay:Sprite;
      
      private var m_ScoutAttackButton:MapRoom3CellMouseoverButton;
      
      private var m_EnterOwnedCellButton:MapRoom3CellMouseoverButton;
      
      private var m_AddBookmarkButton:MapRoom3CellMouseoverButton;
      
      private var m_RemoveBookmarkButton:MapRoom3CellMouseoverButton;
      
      private var m_SendMessageButton:MapRoom3CellMouseoverButton;
      
      private var m_InviteToAllianceButton:MapRoom3CellMouseoverButton;
      
      private var m_RequestTruceButton:MapRoom3CellMouseoverButton;
      
      private var m_Portrait:Sprite;
      
      private var m_ProfilePicture:Loader;
      
      private var m_WildMonsterPortrait:Bitmap;
      
      private var m_DamageBarIcon:Bitmap;
      
      private var m_AllianceIcon:Bitmap;
      
      private var m_TruceIcon:Bitmap;
      
      private var m_InfoTextCellName:TextField;
      
      private var m_InfoTextAlliance:TextField;
      
      private var m_InfoTextCellType:TextField;
      
      private var m_InfoTextBuff1:TextField;
      
      private var m_InfoTextBuff2:TextField;
      
      private var m_SelectedCell:MapRoom3Cell = null;
      
      private var m_MailboxMessage:Message = null;
      
      public function MapRoom3CellMouseover()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
         this.m_InfoDisplay = new Sprite();
         this.m_InfoDisplay.addChild(new Bitmap(MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.MOUSEOVER_BACKGROUND)));
         this.m_InfoDisplay.x = -(this.m_InfoDisplay.width * 0.5);
         this.m_InfoDisplay.y = INFO_DISPLAY_OFFSET_Y - this.m_InfoDisplay.height;
         this.m_InfoDisplay.mouseEnabled = false;
         this.m_InfoDisplay.mouseChildren = false;
         addChild(this.m_InfoDisplay);
         this.m_ButtonDisplay = new Sprite();
         this.m_ButtonDisplay.mouseEnabled = false;
         addChild(this.m_ButtonDisplay);
         this.m_ScoutAttackButton = new MapRoom3CellMouseoverButton(MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.MOUSEOVER_BUTTON_SCOUT_ATTACK),MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.MOUSEOVER_BUTTON_SCOUT_ATTACK_ROLLOVER),"mr3_scout_attack_tool_tip");
         this.m_ScoutAttackButton.addEventListener(MouseEvent.CLICK,this.OnScoutAttackClicked);
         this.m_EnterOwnedCellButton = new MapRoom3CellMouseoverButton(MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.MOUSEOVER_BUTTON_ENTER),MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.MOUSEOVER_BUTTON_ENTER_ROLLOVER),"mr3_enter_owned_base_tool_tip");
         this.m_EnterOwnedCellButton.addEventListener(MouseEvent.CLICK,this.OnEnterOwnedCellClicked);
         this.m_AddBookmarkButton = new MapRoom3CellMouseoverButton(MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.MOUSEOVER_BUTTON_BOOKMARK_ADD),MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.MOUSEOVER_BUTTON_BOOKMARK_ADD_ROLLOVER),"mr3_add_bookmark_tool_tip");
         this.m_AddBookmarkButton.addEventListener(MouseEvent.CLICK,this.OnAddBookmarkClicked);
         this.m_RemoveBookmarkButton = new MapRoom3CellMouseoverButton(MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.MOUSEOVER_BUTTON_BOOKMARK_REMOVE),MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.MOUSEOVER_BUTTON_BOOKMARK_REMOVE_ROLLOVER),"mr3_remove_bookmark_tool_tip");
         this.m_RemoveBookmarkButton.addEventListener(MouseEvent.CLICK,this.OnRemoveBookmarkClicked);
         this.m_SendMessageButton = new MapRoom3CellMouseoverButton(MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.MOUSEOVER_BUTTON_SEND_MESSAGE),MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.MOUSEOVER_BUTTON_SEND_MESSAGE_ROLLOVER),"mr3_send_message_tool_tip");
         this.m_SendMessageButton.addEventListener(MouseEvent.CLICK,this.OnSendMessageClicked);
         this.m_InviteToAllianceButton = new MapRoom3CellMouseoverButton(MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.MOUSEOVER_BUTTON_INVITE_TO_ALLIANCE),MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.MOUSEOVER_BUTTON_INVITE_TO_ALLIANCE_ROLLOVER),"mr3_invite_to_alliance_tool_tip");
         this.m_InviteToAllianceButton.addEventListener(MouseEvent.CLICK,this.OnInviteToAllianceClicked);
         this.m_RequestTruceButton = new MapRoom3CellMouseoverButton(MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.MOUSEOVER_BUTTON_REQUEST_TRUCE),MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.MOUSEOVER_BUTTON_REQUEST_TRUCE_ROLLOVER),"mr3_request_truce_tool_tip");
         this.m_RequestTruceButton.addEventListener(MouseEvent.CLICK,this.OnRequestTruceClicked);
         this.m_Portrait = new Sprite();
         this.m_Portrait.x = PORTRAIT_OFFSET_X;
         this.m_Portrait.y = PORTRAIT_OFFSET_Y;
         this.m_InfoDisplay.addChild(this.m_Portrait);
         this.m_ProfilePicture = new Loader();
         this.m_ProfilePicture.visible = false;
         this.m_ProfilePicture.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.OnProfilePictureIOErrorEvent,false,0,true);
         this.m_Portrait.addChild(this.m_ProfilePicture);
         this.m_WildMonsterPortrait = new Bitmap();
         this.m_WildMonsterPortrait.visible = false;
         this.m_Portrait.addChild(this.m_WildMonsterPortrait);
         this.m_DamageBarIcon = new Bitmap(MapRoom3AssetCache.instance.GetDamageBarSegmentAsset(0));
         this.m_DamageBarIcon.visible = false;
         this.m_DamageBarIcon.x = (PORTRAIT_WIDTH - this.m_DamageBarIcon.width) * 0.5;
         this.m_DamageBarIcon.y = this.m_InfoDisplay.height - PORTRAIT_OFFSET_Y - this.m_DamageBarIcon.height;
         this.m_Portrait.addChild(this.m_DamageBarIcon);
         this.m_AllianceIcon = new Bitmap();
         this.m_AllianceIcon.visible = false;
         this.m_Portrait.addChild(this.m_AllianceIcon);
         this.m_TruceIcon = new Bitmap(MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.MOUSEOVER_ICON_TRUCE));
         this.m_TruceIcon.visible = false;
         this.m_TruceIcon.x = TRUCE_ICON_OFFSET_X;
         this.m_TruceIcon.y = TRUCE_ICON_OFFSET_Y;
         this.m_Portrait.addChild(this.m_TruceIcon);
         this.m_TextDisplay = new Sprite();
         this.m_TextDisplay.mouseEnabled = false;
         this.m_InfoDisplay.addChild(this.m_TextDisplay);
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.color = INFO_TEXT_COLOR_DEFAULT;
         _loc2_.font = "Verdana";
         _loc2_.size = 11;
         this.m_InfoTextCellName = new TextField();
         this.m_InfoTextCellName.defaultTextFormat = _loc2_;
         this.m_InfoTextCellName.x = 56;
         this.m_InfoTextCellName.width = 145;
         this.m_InfoTextCellName.height = 20;
         this.m_InfoTextCellName.filters = [_loc1_];
         this.m_InfoTextCellName.selectable = false;
         var _loc3_:TextFormat = new TextFormat();
         _loc3_.color = INFO_TEXT_COLOR_DEFAULT;
         _loc3_.font = "Verdana";
         _loc3_.size = 10;
         this.m_InfoTextAlliance = new TextField();
         this.m_InfoTextAlliance.defaultTextFormat = _loc3_;
         this.m_InfoTextAlliance.x = 56;
         this.m_InfoTextAlliance.width = 145;
         this.m_InfoTextAlliance.height = 20;
         this.m_InfoTextAlliance.filters = [_loc1_];
         this.m_InfoTextAlliance.selectable = false;
         this.m_InfoTextCellType = new TextField();
         this.m_InfoTextCellType.defaultTextFormat = _loc2_;
         this.m_InfoTextCellType.x = 56;
         this.m_InfoTextCellType.width = 145;
         this.m_InfoTextCellType.height = 20;
         this.m_InfoTextCellType.filters = [_loc1_];
         this.m_InfoTextCellType.selectable = false;
         var _loc4_:TextFormat;
         (_loc4_ = new TextFormat()).font = "Verdana";
         _loc4_.size = 10;
         this.m_InfoTextBuff1 = new TextField();
         this.m_InfoTextBuff1.defaultTextFormat = _loc4_;
         this.m_InfoTextBuff1.x = 56;
         this.m_InfoTextBuff1.width = 145;
         this.m_InfoTextBuff1.height = 20;
         this.m_InfoTextBuff1.filters = [_loc1_];
         this.m_InfoTextBuff1.selectable = false;
         this.m_InfoTextBuff1.textColor = INFO_TEXT_COLOR_BUFF_BLUE;
         this.m_InfoTextBuff2 = new TextField();
         this.m_InfoTextBuff2.defaultTextFormat = _loc4_;
         this.m_InfoTextBuff2.x = 56;
         this.m_InfoTextBuff2.width = 145;
         this.m_InfoTextBuff2.height = 20;
         this.m_InfoTextBuff2.filters = [_loc1_];
         this.m_InfoTextBuff2.selectable = false;
         this.m_InfoTextBuff2.textColor = INFO_TEXT_COLOR_BUFF_RED;
      }
      
      private static function MakeFacebookProfilePictureURL(param1:String) : String
      {
         return "http://graph.facebook.com/" + param1 + "/picture";
      }
      
      public function get selectedCell() : MapRoom3Cell
      {
         return this.m_SelectedCell;
      }
      
      public function get scoutAttackButton() : MapRoom3CellMouseoverButton
      {
         return this.m_ScoutAttackButton;
      }
      
      public function Clear() : void
      {
         this.Hide();
         this.m_InfoTextCellName = null;
         this.m_InfoTextAlliance = null;
         this.m_InfoTextCellType = null;
         this.m_InfoTextBuff1 = null;
         this.m_InfoTextBuff2 = null;
         this.m_Portrait.removeChild(this.m_TruceIcon);
         this.m_TruceIcon = null;
         this.m_Portrait.removeChild(this.m_AllianceIcon);
         this.m_AllianceIcon = null;
         this.m_Portrait.removeChild(this.m_DamageBarIcon);
         this.m_DamageBarIcon = null;
         this.m_Portrait.removeChild(this.m_WildMonsterPortrait);
         this.m_WildMonsterPortrait = null;
         this.m_ProfilePicture.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.OnProfilePictureIOErrorEvent);
         this.m_Portrait.removeChild(this.m_ProfilePicture);
         this.m_ProfilePicture = null;
         this.m_InfoDisplay.removeChild(this.m_Portrait);
         this.m_Portrait = null;
         this.m_InfoDisplay.removeChild(this.m_TextDisplay);
         this.m_TextDisplay = null;
         this.m_ScoutAttackButton = null;
         this.m_EnterOwnedCellButton = null;
         this.m_AddBookmarkButton = null;
         this.m_RemoveBookmarkButton = null;
         this.m_SendMessageButton = null;
         this.m_InviteToAllianceButton = null;
         this.m_RequestTruceButton = null;
         removeChild(this.m_ButtonDisplay);
         this.m_ButtonDisplay = null;
         var _loc1_:Bitmap = null;
         while(this.m_InfoDisplay.numChildren > 0)
         {
            _loc1_ = this.m_InfoDisplay.removeChildAt(0) as Bitmap;
            if(_loc1_ != null)
            {
               _loc1_.bitmapData = null;
            }
         }
         removeChild(this.m_InfoDisplay);
      }
      
      public function Show(param1:MapRoom3Cell, param2:Number, param3:Number, param4:Boolean) : void
      {
         this.SetInfo(param1);
         this.SetPosition(param2,param3);
         visible = true;
         this.ShowButtons(param4);
      }
      
      public function Hide() : void
      {
         this.ClearInfo();
         visible = false;
      }
      
      private function ShowButtons(param1:Boolean) : void
      {
         if(param1)
         {
            this.m_InfoDisplay.y = INFO_DISPLAY_OFFSET_Y - (this.m_InfoDisplay.height + this.m_ButtonDisplay.height);
            this.m_ButtonDisplay.visible = true;
            this.mouseEnabled = true;
            this.mouseChildren = true;
            this.m_ButtonDisplay.mouseEnabled = true;
         }
         else
         {
            this.m_InfoDisplay.y = INFO_DISPLAY_OFFSET_Y - this.m_InfoDisplay.height;
            this.m_ButtonDisplay.visible = false;
            this.mouseEnabled = false;
            this.mouseChildren = false;
            this.m_ButtonDisplay.mouseEnabled = false;
         }
      }
      
      private function SetPosition(param1:Number, param2:Number) : void
      {
         var _loc3_:int = GLOBAL.StageX;
         var _loc4_:int = GLOBAL.StageX + GLOBAL.StageWidth;
         var _loc5_:int = GLOBAL.StageY + 80;
         var _loc6_:int = this.m_InfoDisplay.width * 0.5;
         if(param1 - _loc6_ < _loc3_)
         {
            param1 = _loc3_ + _loc6_;
         }
         else if(param1 + _loc6_ > _loc4_)
         {
            param1 = _loc4_ - _loc6_;
         }
         x = param1;
         if(param2 - this.m_InfoDisplay.height < _loc5_)
         {
            y = param2 + MapRoom3CellGraphic.HEX_EDGE_LENGTH * MapRoom3.mapRoom3Window.scrollingCanvas.scaleY * 0.5 + this.m_InfoDisplay.height;
         }
         else
         {
            y = param2 - MapRoom3CellGraphic.HEX_EDGE_LENGTH * MapRoom3.mapRoom3Window.scrollingCanvas.scaleY * 0.5;
         }
      }
      
      private function SetInfo(param1:MapRoom3Cell) : void
      {
         var _loc6_:DisplayObject = null;
         var _loc11_:* = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:MapRoom3Cell = null;
         var _loc18_:int = 0;
         this.ClearInfo();
         this.m_SelectedCell = param1;
         if(this.m_SelectedCell == null)
         {
            return;
         }
         if(param1.isOwnedByWildMonster)
         {
            ImageCache.GetImageWithCallBack("worldmap/rollover/tribe_" + param1.name.toLowerCase() + ".png",this.OnWildMonsterPortraitLoaded,true,1);
            this.m_WildMonsterPortrait.visible = true;
         }
         else
         {
            this.m_ProfilePicture.load(new URLRequest(MakeFacebookProfilePictureURL(param1.facebookID)));
            this.m_ProfilePicture.visible = true;
         }
         this.m_DamageBarIcon.bitmapData = MapRoom3AssetCache.instance.GetDamageBarSegmentAsset(param1.damagePercentage);
         this.m_DamageBarIcon.visible = true;
         var _loc2_:int = param1.baseLevel;
         var _loc3_:int = !!param1.playerLevel ? param1.playerLevel : _loc2_;
         this.m_InfoTextCellName.htmlText = "<b>" + param1.name + " (" + _loc3_.toString() + ")</b>";
         this.m_TextDisplay.addChild(this.m_InfoTextCellName);
         var _loc4_:MapRoom3AllianceData;
         if((_loc4_ = param1.GetAllianceData()) != null)
         {
            this.m_InfoTextAlliance.htmlText = _loc4_.name;
            this.m_TextDisplay.addChild(this.m_InfoTextAlliance);
            _loc11_ = "alliances/" + _loc4_.imageId + "_small.png";
            ImageCache.GetImageWithCallBack(_loc11_,this.OnAllianceIconLoaded,true,1);
            this.m_AllianceIcon.visible = true;
         }
         this.m_InfoTextCellType.htmlText = param1.GetLocalisedCellTypeName() + " (" + _loc2_.toString() + ")";
         this.m_TextDisplay.addChild(this.m_InfoTextCellType);
         if(param1.isInRangeOfStronghold)
         {
            _loc12_ = 0;
            _loc13_ = 0;
            _loc14_ = 0;
            _loc15_ = param1.inRangeOfStrongholds.length;
            _loc16_ = 0;
            while(_loc16_ < _loc15_)
            {
               _loc17_ = param1.inRangeOfStrongholds[_loc16_];
               _loc18_ = this.GetPercentageBuffFromStrongholdLevel(_loc17_.baseLevel);
               if(_loc17_.isOwnedByPlayer)
               {
                  _loc12_ += _loc18_;
                  if(param1.isOwnedByPlayer)
                  {
                     _loc13_ += _loc18_;
                  }
               }
               else if(_loc17_.userID == param1.userID && _loc17_.wildMonsterTribeId == param1.wildMonsterTribeId)
               {
                  _loc14_ += _loc18_;
               }
               _loc16_++;
            }
            if(_loc12_ > 0 && _loc13_ > 0 && _loc12_ == _loc13_)
            {
               this.m_InfoTextBuff1.htmlText = KEYS.Get("mr3_shbuff_towermonster",{"v1":_loc12_});
               this.m_TextDisplay.addChild(this.m_InfoTextBuff1);
            }
            else if(_loc12_ > 0)
            {
               this.m_InfoTextBuff1.htmlText = KEYS.Get("mr3_shbuff_monster",{"v1":_loc12_});
               this.m_TextDisplay.addChild(this.m_InfoTextBuff1);
            }
            else if(_loc13_ > 0)
            {
               this.m_InfoTextBuff1.htmlText = KEYS.Get("mr3_shbuff_tower",{"v1":_loc13_});
               this.m_TextDisplay.addChild(this.m_InfoTextBuff1);
            }
            if(_loc14_ > 0)
            {
               this.m_InfoTextBuff2.htmlText = KEYS.Get("mr3_shbuff_tower",{"v1":_loc14_});
               this.m_TextDisplay.addChild(this.m_InfoTextBuff2);
            }
         }
         if(param1.isOwnedByPlayer)
         {
            this.m_ButtonDisplay.addChild(this.m_EnterOwnedCellButton);
         }
         else
         {
            this.m_ButtonDisplay.addChild(this.m_ScoutAttackButton);
            if(param1.isOwnedByWildMonster == false)
            {
               this.m_ButtonDisplay.addChild(this.m_SendMessageButton);
               if(ALLIANCES._myAlliance != null && param1.allianceID != ALLIANCES._allianceID)
               {
                  this.m_ButtonDisplay.addChild(this.m_InviteToAllianceButton);
               }
               if(param1.hasTruce == false)
               {
                  this.m_ButtonDisplay.addChild(this.m_RequestTruceButton);
               }
            }
         }
         if(BookmarksManager.instance.IsBookmarked(this.m_SelectedCell))
         {
            this.m_ButtonDisplay.addChild(this.m_RemoveBookmarkButton);
         }
         else
         {
            this.m_ButtonDisplay.addChild(this.m_AddBookmarkButton);
         }
         this.m_TruceIcon.visible = this.m_SelectedCell.hasTruce;
         var _loc5_:int = 0;
         var _loc7_:uint = uint(this.m_ButtonDisplay.numChildren);
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            (_loc6_ = this.m_ButtonDisplay.getChildAt(_loc8_)).x = _loc5_;
            _loc5_ += _loc6_.width;
            _loc8_++;
         }
         this.m_ButtonDisplay.x = -(this.m_ButtonDisplay.width * 0.5);
         this.m_ButtonDisplay.y = -this.m_ButtonDisplay.height;
         var _loc9_:uint;
         var _loc10_:int = (_loc9_ = uint(this.m_TextDisplay.numChildren)) <= 3 ? 6 : 0;
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            (_loc6_ = this.m_TextDisplay.getChildAt(_loc8_)).y = _loc10_;
            _loc10_ += 12;
            _loc8_++;
         }
      }
      
      private function GetPercentageBuffFromStrongholdLevel(param1:uint) : int
      {
         switch(param1)
         {
            case 30:
               return 10;
            case 40:
               return 20;
            case 50:
               return 30;
            default:
               return 0;
         }
      }
      
      private function OnProfilePictureIOErrorEvent(param1:IOErrorEvent) : void
      {
      }
      
      private function ClearInfo() : void
      {
         this.m_ButtonDisplay.visible = false;
         while(this.m_ButtonDisplay.numChildren > 0)
         {
            this.m_ButtonDisplay.removeChildAt(0);
         }
         while(this.m_TextDisplay.numChildren > 0)
         {
            this.m_TextDisplay.removeChildAt(0);
         }
         this.m_ProfilePicture.unload();
         this.m_ProfilePicture.visible = false;
         this.m_WildMonsterPortrait.bitmapData = null;
         this.m_WildMonsterPortrait.visible = false;
         this.m_DamageBarIcon.bitmapData = null;
         this.m_DamageBarIcon.visible = false;
         this.m_AllianceIcon.bitmapData = null;
         this.m_AllianceIcon.visible = false;
         this.m_TruceIcon.visible = false;
         this.m_InfoTextCellName.htmlText = "";
         this.m_InfoTextAlliance.htmlText = "";
         this.m_InfoTextCellType.htmlText = "";
         this.m_InfoTextBuff1.htmlText = "";
         this.m_InfoTextBuff2.htmlText = "";
         this.m_SelectedCell = null;
      }
      
      private function OnWildMonsterPortraitLoaded(param1:String, param2:BitmapData) : void
      {
         this.m_WildMonsterPortrait.bitmapData = param2;
         this.m_WildMonsterPortrait.width = PORTRAIT_WIDTH;
         this.m_WildMonsterPortrait.height = PORTRAIT_HEIGHT;
      }
      
      private function OnAllianceIconLoaded(param1:String, param2:BitmapData) : void
      {
         this.m_AllianceIcon.bitmapData = param2;
         this.m_AllianceIcon.x = PORTRAIT_WIDTH - this.m_AllianceIcon.width + ALLIANCE_ICON_OFFSET_X;
         this.m_AllianceIcon.y = PORTRAIT_HEIGHT - this.m_AllianceIcon.height + ALLIANCE_ICON_OFFSET_Y;
      }
      
      private function OnScoutAttackClicked(param1:MouseEvent) : void
      {
         if(this.m_SelectedCell != null)
         {
            this.m_SelectedCell.LoadForAttack();
         }
      }
      
      private function OnEnterOwnedCellClicked(param1:MouseEvent) : void
      {
         if(this.m_SelectedCell != null)
         {
            this.m_SelectedCell.LoadForBuild();
         }
      }
      
      private function OnAddBookmarkClicked(param1:MouseEvent) : void
      {
         if(this.m_SelectedCell == null)
         {
            return;
         }
         BookmarksManager.instance.AddBookmark(this.m_SelectedCell);
         var _loc2_:int = this.m_ButtonDisplay.getChildIndex(this.m_AddBookmarkButton);
         this.m_ButtonDisplay.addChildAt(this.m_RemoveBookmarkButton,_loc2_);
         this.m_RemoveBookmarkButton.x = this.m_AddBookmarkButton.x;
         this.m_RemoveBookmarkButton.y = this.m_AddBookmarkButton.y;
         this.m_ButtonDisplay.removeChild(this.m_AddBookmarkButton);
         param1.stopImmediatePropagation();
         param1.stopPropagation();
      }
      
      private function OnRemoveBookmarkClicked(param1:MouseEvent) : void
      {
         if(this.m_SelectedCell == null)
         {
            return;
         }
         BookmarksManager.instance.RemoveBookmark(this.m_SelectedCell);
         var _loc2_:int = this.m_ButtonDisplay.getChildIndex(this.m_RemoveBookmarkButton);
         this.m_ButtonDisplay.addChildAt(this.m_AddBookmarkButton,_loc2_);
         this.m_AddBookmarkButton.x = this.m_RemoveBookmarkButton.x;
         this.m_AddBookmarkButton.y = this.m_RemoveBookmarkButton.y;
         this.m_ButtonDisplay.removeChild(this.m_RemoveBookmarkButton);
         param1.stopImmediatePropagation();
         param1.stopPropagation();
      }
      
      private function OnInviteToAllianceClicked(param1:MouseEvent) : void
      {
         if(this.m_SelectedCell != null)
         {
            ALLIANCES.AllianceInvite(this.m_SelectedCell.userID);
         }
      }
      
      private function OnSendMessageClicked(param1:MouseEvent) : void
      {
         if(this.m_SelectedCell != null)
         {
            this.ShowMailboxMessage("message");
         }
      }
      
      private function OnRequestTruceClicked(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(this.m_SelectedCell != null)
         {
            _loc2_ = KEYS.Get("mr3_trucerequest",{"v1":this.m_SelectedCell.name});
            _loc3_ = KEYS.Get("map_trucemessage");
            this.ShowMailboxMessage("trucerequest",_loc2_,_loc3_);
         }
      }
      
      private function ShowMailboxMessage(param1:String, param2:String = "", param3:String = "") : void
      {
         if(this.m_MailboxMessage != null)
         {
            if(this.m_MailboxMessage.parent != null)
            {
               this.m_MailboxMessage.parent.removeChild(this.m_MailboxMessage);
            }
            this.m_MailboxMessage = null;
         }
         var _loc4_:Object = {
            "first_name":this.m_SelectedCell.name,
            "last_name":"",
            "pic_square":MakeFacebookProfilePictureURL(this.m_SelectedCell.facebookID)
         };
         var _loc5_:Contact = new Contact(this.m_SelectedCell.userID.toString(),_loc4_);
         this.m_MailboxMessage = new Message();
         this.m_MailboxMessage.picker.preloadSelection(_loc5_);
         this.m_MailboxMessage.requestType = param1;
         this.m_MailboxMessage.subject_txt.htmlText = param2;
         this.m_MailboxMessage.body_txt.htmlText = param3;
         GLOBAL.BlockerAdd();
         GLOBAL._layerWindows.addChild(this.m_MailboxMessage);
      }
   }
}
