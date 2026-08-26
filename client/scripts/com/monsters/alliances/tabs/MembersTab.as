package com.monsters.alliances.tabs
{
   import com.monsters.alliances.ALLIANCES;
   import com.monsters.alliances.AllianceConstants;
   import com.monsters.alliances.AllianceTabBase;
   import com.monsters.display.ImageCache;
   import com.monsters.display.ScrollSetV;
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;

   public class MembersTab extends AllianceTabBase
   {
      private static const PAD:int = 10;

      private static const TITLE_SIZE:int = 24;
      private static const TITLE_H:int = 32;
      private static const TITLE_Y:int = 20;
      private static const TITLE_GAP:int = 12;

      private static const TABLE_Y:int = TITLE_Y + TITLE_H + TITLE_GAP;
      private static const TABLE_X:int = PAD;
      private static const SCROLLBAR_W:int = 16;
      private static const TABLE_W:int = 772;
      private static const HEADER_H:int = 24;
      private static const ROW_H:int = 36;

      private static const VIEW_H:int = 378;

      // Column proportions from the original members table (alliance.v343.css),
      // scaled to TABLE_W.
      private static const C_LVL_X:int = 0;
      private static const C_LVL_W:int = 59;
      private static const C_NAME_X:int = 59;
      private static const C_NAME_W:int = 201;
      private static const C_STATUS_X:int = 260;
      private static const C_STATUS_W:int = 79;
      private static const C_EP_X:int = 339;
      private static const C_EP_W:int = 131;
      private static const C_ATK_X:int = 470;
      private static const C_ATK_W:int = 171;
      private static const C_ACT_X:int = 641;
      private static const C_ACT_W:int = 131;

      // Original member pic is 25×25
      private static const AVATAR_SIZE:int = 25;

      // Original actions button is 97×25
      private static const ACT_BTN_W:int = 97;

      private static const POP_RIGHT_X:int = TABLE_X + C_ACT_X + C_ACT_W;
      private static const POP_X:int = POP_RIGHT_X - MemberActionPopup.POPUP_W;

      private var _activePopup:MemberActionPopup;

      protected var _members:Array;

      public function MembersTab()
      {
         super();
      }

      override public function build():void
      {
         if (_members == null)
         {
            _members = [];
            _load();
         }
         _buildTitle();
         _buildTable();
      }

      private function _buildTitle():void
      {
         var tTitle:TextField = addChild(new TextField()) as TextField;
         tTitle.selectable = false;
         tTitle.mouseEnabled = false;
         tTitle.embedFonts = true;
         tTitle.antiAliasType = AntiAliasType.NORMAL;
         tTitle.width = CONTENT_W - PAD * 2;
         tTitle.height = TITLE_H;
         var titleFmt:TextFormat = new TextFormat("Groboldov", TITLE_SIZE, 0xFFFFFF);
         titleFmt.align = TextFormatAlign.LEFT;
         tTitle.defaultTextFormat = titleFmt;
         tTitle.text = KEYS.Get(_titleKey);
         tTitle.filters = [new GlowFilter(0, 1, 3, 3, 9, 2), new DropShadowFilter(2, 45, 0, 0.55, 3, 3, 1, 2)];
         tTitle.x = PAD;
         tTitle.y = TITLE_Y;
      }

      /**
       * Localisation key for the tab's heading. Subclasses override to retitle
       * the same table layout.
       * @returns {String} KEYS key for the title text.
       */
      protected function get _titleKey():String
      {
         return "alliance_members_title";
      }

      /**
       * Background colour for a data row. The current player's own row is
       * highlighted yellow; every other row uses the beige alternating bands
       * shared with Browse Alliances.
       * @param {Object} rowData - The row's data object (self flag honoured)
       * @param {int} index - Zero-based row index
       * @returns {uint} Fill colour for the row
       */
      protected function _rowColor(rowData:Object, index:int):uint
      {
         if (rowData.self == true)
         {
            return AllianceConstants.ROW_ME;
         }
         return (index % 2 == 0) ? AllianceConstants.ROW_ALT0 : AllianceConstants.ROW_ALT1;
      }

      /**
       * Draws the roster from the store. Fetched on demand rather than warmed with
       * the window, since only this tab reads it.
       *
       * A warm store answers before load() returns, while build() is still partway
       * through drawing. Re-rendering from under it would leave a second table
       * stacked on the first, so an immediate answer only fills _members and lets
       * the build already in progress draw it.
       */
      protected function _load():void
      {
         var answeredDuringBuild:Boolean = true;

         ALLIANCES.LoadMembers(function(members:Array):void
            {
               _members = (members != null) ? _mapRows(members) : [];

               if (!answeredDuringBuild) _rerender();
            });

         answeredDuringBuild = false;
      }

      /**
       * Maps server roster rows onto the shape the table renderer expects.
       *
       * The player's own row is marked so it draws highlighted and without an
       * Actions button - there is nothing they can do to themselves.
       *
       * @param {Array} members - Raw server roster rows.
       * @returns {Array} Rows for _buildTable.
       */
      protected function _mapRows(members:Array):Array
      {
         var rows:Array = [];

         for each (var member:Object in members)
         {
            var status:Object = (member.status != null) ? member.status : {};

            rows.push({
                  user_id: int(member.user_id),
                  base_id: member.base_id,
                  level: int(member.level),
                  name: String(member.display_name),
                  pic_square: member.pic_square,
                  ep: String(member.points),
                  attacker: String(member.last_attacker),
                  online: status.online == true,
                  is_leader: member.is_leader == true,
                  self: int(member.user_id) == LOGIN._playerID
               });
         }

         return rows;
      }

      private function _buildTable():void
      {
         var data:Array = _members;
         const totalH:int = HEADER_H + data.length * ROW_H;

         var viewport:MovieClip = addChild(new MovieClip()) as MovieClip;
         viewport.x = TABLE_X;
         viewport.y = TABLE_Y;

         var tableMC:MovieClip = viewport.addChild(new MovieClip()) as MovieClip;

         tableMC.graphics.beginFill(AllianceConstants.HEADER_BG);
         tableMC.graphics.drawRect(0, 0, TABLE_W, HEADER_H);
         tableMC.graphics.endFill();

         var fi:int = 0;
         while (fi < data.length)
         {
            tableMC.graphics.beginFill(_rowColor(data[fi], fi));
            tableMC.graphics.drawRect(0, HEADER_H + fi * ROW_H, TABLE_W, ROW_H);
            tableMC.graphics.endFill();
            fi++;
         }

         tableMC.graphics.lineStyle(1, AllianceConstants.CELL_BORDER, 1);
         var vLineXs:Array = [C_NAME_X, C_STATUS_X, C_EP_X, C_ATK_X, C_ACT_X];
         var vli:int = 0;
         while (vli < vLineXs.length)
         {
            tableMC.graphics.moveTo(int(vLineXs[vli]), 0);
            tableMC.graphics.lineTo(int(vLineXs[vli]), totalH);
            vli++;
         }
         tableMC.graphics.lineStyle(1, AllianceConstants.TABLE_BORDER, 1);
         tableMC.graphics.drawRect(0, 0, TABLE_W, totalH);

         _addLabel(tableMC, KEYS.Get("alliance_col_level"), C_LVL_X, 0, C_LVL_W, HEADER_H, true, TextFormatAlign.CENTER);
         _addLabel(tableMC, KEYS.Get("alliance_col_name"), C_NAME_X + 6, 0, C_NAME_W - 6, HEADER_H, true, TextFormatAlign.LEFT);
         _addLabel(tableMC, KEYS.Get("alliance_col_status"), C_STATUS_X, 0, C_STATUS_W, HEADER_H, true, TextFormatAlign.CENTER);
         _addLabel(tableMC, KEYS.Get("alliance_col_ep"), C_EP_X, 0, C_EP_W, HEADER_H, true, TextFormatAlign.CENTER);
         _addLabel(tableMC, KEYS.Get("alliance_col_attacker"), C_ATK_X + 8, 0, C_ATK_W - 8, HEADER_H, true, TextFormatAlign.LEFT);
         _addLabel(tableMC, KEYS.Get("alliance_col_actions"), C_ACT_X, 0, C_ACT_W, HEADER_H, true, TextFormatAlign.CENTER);

         var ri:int = 0;
         while (ri < data.length)
         {
            var rowData:Object = data[ri];
            var rowBaseY:int = HEADER_H + ri * ROW_H;

            _addLabel(tableMC, String(rowData.level), C_LVL_X, rowBaseY, C_LVL_W, ROW_H, false, TextFormatAlign.CENTER);

            _drawAvatar(tableMC, rowData.pic_square,
                  C_NAME_X + 6, rowBaseY + int((ROW_H - AVATAR_SIZE) / 2));

            const nameX:int = C_NAME_X + 6 + AVATAR_SIZE + 8;
            _addLabel(tableMC, String(rowData.name), nameX, rowBaseY, C_NAME_X + C_NAME_W - nameX - 6, ROW_H, false, TextFormatAlign.LEFT);

            _drawStatusIcon(tableMC, C_STATUS_X + int(C_STATUS_W / 2), rowBaseY + int(ROW_H / 2), rowData.online == true);

            _addLabel(tableMC, String(rowData.ep), C_EP_X, rowBaseY, C_EP_W, ROW_H, false, TextFormatAlign.CENTER);
            _addLabel(tableMC, String(rowData.attacker), C_ATK_X + 8, rowBaseY, C_ATK_W - 8, ROW_H, false, TextFormatAlign.LEFT);

            if (rowData.self != true)
            {
               var actBtn:Button_CLIP = tableMC.addChild(new Button_CLIP()) as Button_CLIP;
               actBtn.Setup(KEYS.Get("alliance_col_actions"), false, ACT_BTN_W, ROW_H - 6);
               actBtn._txt.htmlText = "<b><font color=\"#000000\">" + KEYS.Get("alliance_col_actions") + "</font></b>";
               actBtn.x = C_ACT_X + int((C_ACT_W - ACT_BTN_W) / 2);
               actBtn.y = rowBaseY + 3;
               actBtn.addEventListener(MouseEvent.CLICK, _makeActionsHandler(rowData));
            }

            ri++;
         }

         var gridOverlay:MovieClip = tableMC.addChild(new MovieClip()) as MovieClip;
         gridOverlay.mouseEnabled = false;
         gridOverlay.graphics.lineStyle(1, AllianceConstants.CELL_BORDER, 1);
         var hli:int = 0;
         while (hli < data.length)
         {
            var hlineY:int = HEADER_H + hli * ROW_H;
            gridOverlay.graphics.moveTo(0, hlineY);
            gridOverlay.graphics.lineTo(TABLE_W, hlineY);
            hli++;
         }

         var maskMC:MovieClip = viewport.addChild(new MovieClip()) as MovieClip;
         maskMC.graphics.beginFill(0xFF0000, 1);
         maskMC.graphics.drawRect(0, 0, TABLE_W, VIEW_H);
         maskMC.graphics.endFill();
         tableMC.mask = maskMC;

         // ScrollSetV hides itself while the content fits, so a short roster keeps
         // the gutter empty rather than showing a full-length thumb.
         var scrollbar:ScrollSetV = viewport.addChild(new ScrollSetV(tableMC, maskMC, true)) as ScrollSetV;
         scrollbar.x = TABLE_W + 2;
         scrollbar.y = 0;
      }

      /**
       * Ordered list of actions for a row's popup, rendered top-to-bottom. Each
       * entry is { labelKey:String, handler:Function }.
       *
       * Kick and Promote are the leader's alone, as in the original, which served
       * an ordinary member the visit-only popup and the leader a taller one - so a
       * member sees a single-button popup rather than actions they cannot take.
       *
       * @param {Object} rowData - The row the actions apply to
       * @returns {Array} Action descriptors for MemberActionPopup
       */
      protected function _actionsFor(rowData:Object):Array
      {
         var actions:Array = [{labelKey: "alliance_btn_visit", handler: _onVisitBase}];

         if (!ALLIANCES._isLeader) return actions;

         actions.push({labelKey: "alliance_btn_kick", handler: _onKick});
         actions.push({labelKey: "alliance_btn_promote", handler: _onPromote});

         return actions;
      }

      /**
       * Builds a click handler for a row's Actions button.
       *
       * The popup is anchored to where the button actually is when clicked rather
       * than to the row's offset in the table, since the table scrolls underneath a
       * mask and the two stop agreeing as soon as it does.
       *
       * @param {Object} rowData - The row this button belongs to
       * @returns {Function} MouseEvent handler
       */
      protected function _makeActionsHandler(rowData:Object):Function
      {
         return function(e:MouseEvent):void
         {
            SOUNDS.Play("click1");

            var button:DisplayObject = e.currentTarget as DisplayObject;
            var anchor:Point = globalToLocal(button.localToGlobal(new Point(0, 0)));

            var popupH:int = MemberActionPopup.heightFor(_actionsFor(rowData).length);
            const popY:int = Math.min(int(anchor.y), CONTENT_H - popupH) + 12;

            _showActionsPopup(rowData, POP_X - 30, popY);
         };
      }

      private function _showActionsPopup(rowData:Object, popX:int, popY:int):void
      {
         _dismissActivePopup();
         _activePopup = new MemberActionPopup(rowData, _dismissActivePopup, _actionsFor(rowData));
         _activePopup.x = popX;
         _activePopup.y = popY;
         addChild(_activePopup);
         stage.addEventListener(MouseEvent.MOUSE_DOWN, _onStageMouseDown);
      }

      private function _dismissActivePopup():void
      {
         if (_activePopup == null)
         {
            return;
         }
         if (_activePopup.parent)
         {
            _activePopup.parent.removeChild(_activePopup);
         }
         _activePopup = null;
         if (stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, _onStageMouseDown);
         }
      }

      private function _onStageMouseDown(e:MouseEvent):void
      {
         if (_activePopup == null)
         {
            return;
         }
         var target:DisplayObject = e.target as DisplayObject;
         while (target != null)
         {
            if (target == _activePopup)
            {
               return;
            }
            target = target.parent as DisplayObject;
         }
         _dismissActivePopup();
      }

      /**
       * Opens the selected member's base, closing the alliance window the same way
       * the Browse tab's Visit Leader does.
       *
       * @param {Object} rowData - The row that was acted on
       */
      protected function _onVisitBase(rowData:Object):void
      {
         var baseId:Number = Number(rowData.base_id);

         if (!(baseId > 0)) return;
         if (BASE._saving || BASE._loading || BASE._saveCounterA != BASE._saveCounterB) return;
         if (BASE.isInfernoMainYardOrOutpost) return;

         _dismissActivePopup();
         ALLIANCEWINDOW.Hide();

         GLOBAL._currentCell = null;

         var yardType:int = MapRoomManager.instance.isInMapRoom3
            ? int(EnumYardType.PLAYER)
            : int(EnumYardType.MAIN_YARD);

         BASE.LoadBase(null, 0, baseId, GLOBAL.e_BASE_MODE.VIEW, true, yardType);
      }

      /**
       * Kicks the selected member from the alliance. Stubbed for now.
       * @param {Object} rowData - The row that was acted on
       */
      protected function _onKick(rowData:Object):void
      {
         // TODO: send kick request to server for rowData
      }

      /**
       * Promotes the selected member. Stubbed for now.
       * @param {Object} rowData - The row that was acted on
       */
      protected function _onPromote(rowData:Object):void
      {
         // TODO: send promote request to server for rowData
      }

      /**
       * Clears and rebuilds the tab's contents.
       */
      protected function _rerender():void
      {
         _dismissActivePopup();

         while (numChildren > 0)
         {
            removeChildAt(0);
         }
         build();
      }

      /**
       * Loads a member's profile picture, as the original row template did with
       * <img src="<%= pic_square %>" width="25" height="25">. Squashed to a square
       * the same way rather than letterboxed, so avatars line up down the column.
       *
       * pic_square is an external URL rather than a bundled asset, so it goes
       * through a Loader like the map room popup does instead of ImageCache. A
       * player without a picture, or one whose picture fails to load, simply has
       * no avatar - the name column starts at a fixed x either way.
       *
       * @param {MovieClip} parent - Container to draw into
       * @param {String} url - The member's pic_square URL, possibly empty
       * @param {int} x - Left edge of the avatar
       * @param {int} y - Top edge of the avatar
       */
      private function _drawAvatar(parent:MovieClip, url:String, x:int, y:int):void
      {
         if (url == null || url == "") return;

         var avatar:Loader = new Loader();
         var onLoad:Function = null;
         var onError:Function = null;

         onLoad = function(e:Event):void
         {
            avatar.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoad);
            avatar.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
            avatar.width = avatar.height = AVATAR_SIZE;
            avatar.x = x;
            avatar.y = y;
            avatar.mouseEnabled = false;
            avatar.mouseChildren = false;
            parent.addChild(avatar);
         };

         onError = function(e:IOErrorEvent):void
         {
            avatar.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoad);
            avatar.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
         };

         avatar.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
         avatar.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
         avatar.load(new URLRequest(url));
      }

      /**
       * Loads the online/offline status icon centred at (cx, cy) from the
       * existing alliance assets (online_1.png / offline_1.png) via ImageCache,
       * displayed at native size. Matches the original members table, which used
       * these same images for the Status column.
       *
       * TODO: the original appended a second icon when status.damage_protection was
       * set. The server already returns that flag, but damage_protection_1.png is not
       * among the alliance assets in the repo, so the icon cannot be drawn until the
       * art is recovered.
       *
       * @param {MovieClip} parent - Container to draw into
       * @param {int} cx - Centre x
       * @param {int} cy - Centre y
       * @param {Boolean} online - Whether the member is online
       */
      private function _drawStatusIcon(parent:MovieClip, cx:int, cy:int, online:Boolean):void
      {
         var container:MovieClip = parent.addChild(new MovieClip()) as MovieClip;
         container.mouseEnabled = false;
         container.x = cx;
         container.y = cy;

         var key:String = online ? "alliances/online_1.png" : "alliances/offline_1.png";
         ImageCache.GetImageWithCallBack(
               key,
               function(k:String, bmd:BitmapData, args:Array):void
               {
                  var bmp:Bitmap = new Bitmap(bmd);
                  bmp.smoothing = true;
                  bmp.x = -int(bmd.width / 2);
                  bmp.y = -int(bmd.height / 2);
                  (args[0] as MovieClip).addChild(bmp);
               },
               true, 4, "", [container]
            );
      }
   }
}
