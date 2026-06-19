package com.monsters.alliances.tabs
{
   import com.monsters.alliances.AllianceConstants;
   import com.monsters.alliances.AllianceTabBase;
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;

   public class MembersTab extends AllianceTabBase
   {
      private static const PAD:int = 10;

      // Title block — Groboldov white/glow heading, left-aligned, matching the
      // "Edit Alliance" / "Join the Fellowship" titles used elsewhere.
      private static const TITLE_SIZE:int = 24;
      private static const TITLE_H:int = 32;
      private static const TITLE_Y:int = 20;
      private static const TITLE_GAP:int = 12;

      private static const TABLE_Y:int = TITLE_Y + TITLE_H + TITLE_GAP;
      private static const TABLE_X:int = PAD;
      private static const TABLE_W:int = 788; // CONTENT_W - PAD * 2
      private static const HEADER_H:int = 24;
      private static const ROW_H:int = 36;

      // Column layout — original proportions (alliance.v343.css members table:
      // Level45/Name165/Status60/EP100/Attacker130/Actions100) scaled to TABLE_W (788).
      private static const C_LVL_X:int = 0;
      private static const C_LVL_W:int = 59;
      private static const C_NAME_X:int = 59;
      private static const C_NAME_W:int = 217;
      private static const C_STATUS_X:int = 276;
      private static const C_STATUS_W:int = 79;
      private static const C_EP_X:int = 355;
      private static const C_EP_W:int = 131;
      private static const C_ATK_X:int = 486;
      private static const C_ATK_W:int = 171;
      private static const C_ACT_X:int = 657;
      private static const C_ACT_W:int = 131;

      // Original member pic is 25×25
      private static const AVATAR_SIZE:int = 25;

      // Actions button is narrower than its column and centred within it (original 97×25)
      private static const ACT_BTN_W:int = 97;

      // Popup is right-aligned to the Actions column's right edge
      private static const POP_RIGHT_X:int = TABLE_X + C_ACT_X + C_ACT_W;
      private static const POP_X:int = POP_RIGHT_X - MemberActionPopup.POPUP_W;

      private var _activePopup:MemberActionPopup;

      public function MembersTab()
      {
         super();
      }

      override public function build():void
      {
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
       * @returns {Array} Member rows. Falls back to mock data while the
       * server-side alliance roster payload is wired up.
       */
      protected function _memberData():Array
      {
         return [
               {level: 41, name: "Drake", online: true, ep: "59711744", attacker: "", self: true}
            ];
      }

      private function _buildTable():void
      {
         var data:Array = _memberData();
         const totalH:int = HEADER_H + data.length * ROW_H;

         var tableMC:MovieClip = addChild(new MovieClip()) as MovieClip;
         tableMC.x = TABLE_X;
         tableMC.y = TABLE_Y;

         // Pass 1: header + alternating row background fills
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

         // Pass 2: vertical column separators
         tableMC.graphics.lineStyle(1, AllianceConstants.CELL_BORDER, 1);
         var vLineXs:Array = [C_NAME_X, C_STATUS_X, C_EP_X, C_ATK_X, C_ACT_X];
         var vli:int = 0;
         while (vli < vLineXs.length)
         {
            tableMC.graphics.moveTo(int(vLineXs[vli]), 0);
            tableMC.graphics.lineTo(int(vLineXs[vli]), totalH);
            vli++;
         }
         // Outer table border
         tableMC.graphics.lineStyle(1, AllianceConstants.TABLE_BORDER, 1);
         tableMC.graphics.drawRect(0, 0, TABLE_W, totalH);

         // Pass 3: header labels
         // "Name" left-aligned with 6px padding so it sits over the avatar column
         _addLabel(tableMC, KEYS.Get("alliance_col_level"), C_LVL_X, 0, C_LVL_W, HEADER_H, true, TextFormatAlign.CENTER);
         _addLabel(tableMC, KEYS.Get("alliance_col_name"), C_NAME_X + 6, 0, C_NAME_W - 6, HEADER_H, true, TextFormatAlign.LEFT);
         _addLabel(tableMC, KEYS.Get("alliance_col_status"), C_STATUS_X, 0, C_STATUS_W, HEADER_H, true, TextFormatAlign.CENTER);
         _addLabel(tableMC, KEYS.Get("alliance_col_ep"), C_EP_X, 0, C_EP_W, HEADER_H, true, TextFormatAlign.CENTER);
         _addLabel(tableMC, KEYS.Get("alliance_col_attacker"), C_ATK_X + 8, 0, C_ATK_W - 8, HEADER_H, true, TextFormatAlign.LEFT);
         _addLabel(tableMC, KEYS.Get("alliance_col_actions"), C_ACT_X, 0, C_ACT_W, HEADER_H, true, TextFormatAlign.CENTER);

         // Pass 4: data rows
         var ri:int = 0;
         while (ri < data.length)
         {
            var rowData:Object = data[ri];
            var rowBaseY:int = HEADER_H + ri * ROW_H;

            _addLabel(tableMC, String(rowData.level), C_LVL_X, rowBaseY, C_LVL_W, ROW_H, false, TextFormatAlign.CENTER);

            // Avatar placeholder + player name in the Name column
            var avatar:MovieClip = tableMC.addChild(new MovieClip()) as MovieClip;
            avatar.mouseEnabled = false;
            avatar.graphics.beginFill(0x1A1A1A, 1);
            avatar.graphics.lineStyle(1, 0x000000, 1);
            avatar.graphics.drawRect(0, 0, AVATAR_SIZE, AVATAR_SIZE);
            avatar.graphics.endFill();
            avatar.x = C_NAME_X + 6;
            avatar.y = rowBaseY + int((ROW_H - AVATAR_SIZE) / 2);

            const nameX:int = C_NAME_X + 6 + AVATAR_SIZE + 8;
            _addLabel(tableMC, String(rowData.name), nameX, rowBaseY, C_NAME_X + C_NAME_W - nameX - 6, ROW_H, false, TextFormatAlign.LEFT);

            _drawStatusIcon(tableMC, C_STATUS_X + int(C_STATUS_W / 2), rowBaseY + int(ROW_H / 2), rowData.online == true);

            _addLabel(tableMC, String(rowData.ep), C_EP_X, rowBaseY, C_EP_W, ROW_H, false, TextFormatAlign.CENTER);
            _addLabel(tableMC, String(rowData.attacker), C_ATK_X + 8, rowBaseY, C_ATK_W - 8, ROW_H, false, TextFormatAlign.LEFT);

            // Actions button — reuses the standard gray Button_CLIP, centred in
            // the column. Hidden for the current player's own row.
            if (rowData.self != true)
            {
               var actBtn:Button_CLIP = tableMC.addChild(new Button_CLIP()) as Button_CLIP;
               actBtn.Setup(KEYS.Get("alliance_col_actions"), false, ACT_BTN_W, ROW_H - 6);
               actBtn._txt.htmlText = "<b><font color=\"#000000\">" + KEYS.Get("alliance_col_actions") + "</font></b>";
               actBtn.x = C_ACT_X + int((C_ACT_W - ACT_BTN_W) / 2);
               actBtn.y = rowBaseY + 3;
               actBtn.addEventListener(MouseEvent.CLICK, _makeActionsHandler(rowData, rowBaseY));
            }

            ri++;
         }

         // Overlay: horizontal row separators, drawn last so they sit over fills
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
      }

      /**
       * Ordered list of actions for a row's popup, rendered top-to-bottom. Each
       * entry is { labelKey:String, handler:Function }. Members can visit a
       * member's base, kick them, or promote them; Suggested overrides this to
       * offer a single Invite action.
       * @param {Object} rowData - The row the actions apply to
       * @returns {Array} Action descriptors for MemberActionPopup
       */
      protected function _actionsFor(rowData:Object):Array
      {
         return [
               {labelKey: "alliance_btn_visit", handler: _onVisitBase},
               {labelKey: "alliance_btn_kick", handler: _onKick},
               {labelKey: "alliance_btn_promote", handler: _onPromote}
            ];
      }

      /**
       * Builds a click handler for a row's Actions button, capturing that row's
       * data and screen position so the popup can be anchored to it.
       * @param {Object} rowData - The row this button belongs to
       * @param {int} rowBaseY - The row's y offset within the table
       * @returns {Function} MouseEvent handler
       */
      protected function _makeActionsHandler(rowData:Object, rowBaseY:int):Function
      {
         return function(e:MouseEvent):void
         {
            SOUNDS.Play("click1");
            var popupH:int = MemberActionPopup.heightFor(_actionsFor(rowData).length);
            const popY:int = Math.min(
                  TABLE_Y + rowBaseY,
                  CONTENT_H - popupH
               ) + 12;
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
       * Opens the selected member's base. Stubbed for now.
       * @param {Object} rowData - The row that was acted on
       */
      protected function _onVisitBase(rowData:Object):void
      {
         // TODO: navigate to rowData's base
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
       * Loads the online/offline status icon centred at (cx, cy) from the
       * existing alliance assets (online_1.png / offline_1.png) via ImageCache,
       * displayed at native size. Matches the original members table, which used
       * these same images for the Status column.
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
                  // Centre the icon on the container origin at (cx, cy)
                  bmp.x = -int(bmd.width / 2);
                  bmp.y = -int(bmd.height / 2);
                  (args[0] as MovieClip).addChild(bmp);
               },
               true, 4, "", [container]
            );
      }
   }
}
