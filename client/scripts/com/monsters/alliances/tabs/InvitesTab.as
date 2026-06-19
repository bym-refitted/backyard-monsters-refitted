package com.monsters.alliances.tabs
{
   import com.monsters.alliances.AllianceConstants;
   import com.monsters.alliances.AllianceTabBase;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextFormatAlign;

   /**
    * Invites tab — lists pending alliance invitations addressed to the player.
    * Mirrors the original canvas.htm "tabs-messages" layout: a Check All / Delete
    * control bar above a checkbox / From / Subject / Date table. Data is mock
    * until the server-side invite payload is wired up.
    */
   public class InvitesTab extends AllianceTabBase
   {
      private static const PAD:int = 10;
      private static const BTN_H:int = 36;
      private static const CTRL_Y:int = 20;
      private static const BTN_CHECK_W:int = 150;
      private static const BTN_DELETE_W:int = 140;
      private static const BTN_GAP:int = 8;

      private static const TABLE_Y:int = CTRL_Y + BTN_H + 11;
      private static const HEADER_H:int = 22;
      private static const ROW_H:int = 36;
      private static const TABLE_X:int = PAD;
      private static const TABLE_W:int = 788; // CONTENT_W - PAD * 2

      // Column layout — original proportions (alliance.v343.css messages table:
      // Checkbox35/From170/Subject325/Date100) scaled to TABLE_W (788).
      private static const C_CHK_X:int = 0;
      private static const C_CHK_W:int = 44;
      private static const C_FROM_X:int = 44;
      private static const C_FROM_W:int = 213;
      private static const C_SUBJ_X:int = 257;
      private static const C_SUBJ_W:int = 406;
      private static const C_DATE_X:int = 663;
      private static const C_DATE_W:int = 125;

      // Original invite pic is 24×24, sat at the left of the From cell
      private static const FLAG_SIZE:int = 24;
      // Interactive checkbox square
      private static const CHK_SIZE:int = 16;

      private var _invites:Array;

      public function InvitesTab()
      {
         super();
      }

      override public function build():void
      {
         if (_invites == null)
         {
            _invites = _inviteData();
         }
         _buildControls();
         _buildTable();
      }

      /**
       * @returns {Array} Pending invite rows. Mock data until the server-side
       * invite payload is wired up. Each row carries its own `checked` flag so
       * selection survives a re-render.
       */
      private function _inviteData():Array
      {
         return [
               {from: "A.P.A", inviter: "David", subject: "David has invited you to join A.P.A.", date: "08/11/2011", color: 0x2A4B9B, checked: false}
            ];
      }

      private function _buildControls():void
      {
         var btnCheckAll:Button_CLIP = addChild(new Button_CLIP()) as Button_CLIP;
         btnCheckAll.Setup(KEYS.Get("alliance_btn_check_all"), false, BTN_CHECK_W, BTN_H);
         btnCheckAll.x = PAD;
         btnCheckAll.y = CTRL_Y;
         btnCheckAll.addEventListener(MouseEvent.CLICK, _onCheckAll);

         var btnDelete:Button_CLIP = addChild(new Button_CLIP()) as Button_CLIP;
         btnDelete.Setup(KEYS.Get("alliance_btn_delete"), false, BTN_DELETE_W, BTN_H);
         btnDelete.x = PAD + BTN_CHECK_W + BTN_GAP;
         btnDelete.y = CTRL_Y;
         btnDelete.addEventListener(MouseEvent.CLICK, _onDelete);
      }

      private function _buildTable():void
      {
         const totalH:int = HEADER_H + _invites.length * ROW_H;

         var tableMC:MovieClip = addChild(new MovieClip()) as MovieClip;
         tableMC.x = TABLE_X;
         tableMC.y = TABLE_Y;

         // Pass 1: header + alternating row background fills
         tableMC.graphics.beginFill(AllianceConstants.HEADER_BG);
         tableMC.graphics.drawRect(0, 0, TABLE_W, HEADER_H);
         tableMC.graphics.endFill();

         var fi:int = 0;
         while (fi < _invites.length)
         {
            tableMC.graphics.beginFill((fi % 2 == 0) ? AllianceConstants.ROW_ALT0 : AllianceConstants.ROW_ALT1);
            tableMC.graphics.drawRect(0, HEADER_H + fi * ROW_H, TABLE_W, ROW_H);
            tableMC.graphics.endFill();
            fi++;
         }

         // Pass 2: vertical column separators
         tableMC.graphics.lineStyle(1, AllianceConstants.CELL_BORDER, 1);
         var vLineXs:Array = [C_FROM_X, C_SUBJ_X, C_DATE_X];
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

         // Pass 3: header labels (checkbox column header is intentionally blank)
         _addLabel(tableMC, KEYS.Get("alliance_col_from"), C_FROM_X + 6, 0, C_FROM_W - 6, HEADER_H, true, TextFormatAlign.LEFT);
         _addLabel(tableMC, KEYS.Get("alliance_col_subject"), C_SUBJ_X + 6, 0, C_SUBJ_W - 6, HEADER_H, true, TextFormatAlign.LEFT);
         _addLabel(tableMC, KEYS.Get("alliance_col_date"), C_DATE_X, 0, C_DATE_W, HEADER_H, true, TextFormatAlign.CENTER);

         // Pass 4: data rows
         var ri:int = 0;
         while (ri < _invites.length)
         {
            var rowData:Object = _invites[ri];
            var rowBaseY:int = HEADER_H + ri * ROW_H;

            // Transparent hit-area over the From/Subject/Date cells (not the
            // checkbox column) — clicking it opens the invite dialog. Added
            // first so the non-interactive flag/labels sit on top of it.
            var hit:MovieClip = tableMC.addChild(new MovieClip()) as MovieClip;
            hit.graphics.beginFill(0x000000, 0);
            hit.graphics.drawRect(0, 0, TABLE_W - C_FROM_X, ROW_H);
            hit.graphics.endFill();
            hit.x = C_FROM_X;
            hit.y = rowBaseY;
            hit.buttonMode = true;
            hit.mouseChildren = false;
            hit.addEventListener(MouseEvent.CLICK, _makeOpenHandler(rowData));

            // Checkbox, centred in its column
            var chk:MovieClip = _makeCheckbox(rowData);
            chk.x = C_CHK_X + int((C_CHK_W - CHK_SIZE) / 2);
            chk.y = rowBaseY + int((ROW_H - CHK_SIZE) / 2);
            tableMC.addChild(chk);

            // Inviter flag/pic placeholder at the left of the From cell
            var flag:MovieClip = tableMC.addChild(new MovieClip()) as MovieClip;
            flag.mouseEnabled = false;
            flag.graphics.beginFill(uint(rowData.color), 1);
            flag.graphics.lineStyle(1, 0x000000, 1);
            flag.graphics.drawRect(0, 0, FLAG_SIZE, FLAG_SIZE);
            flag.graphics.endFill();
            flag.x = C_FROM_X + 6;
            flag.y = rowBaseY + int((ROW_H - FLAG_SIZE) / 2);

            const fromX:int = C_FROM_X + 6 + FLAG_SIZE + 6;
            _addLabel(tableMC, String(rowData.from), fromX, rowBaseY, C_FROM_X + C_FROM_W - fromX - 6, ROW_H, false, TextFormatAlign.LEFT);
            _addLabel(tableMC, String(rowData.subject), C_SUBJ_X + 6, rowBaseY, C_SUBJ_W - 12, ROW_H, false, TextFormatAlign.LEFT);
            _addLabel(tableMC, String(rowData.date), C_DATE_X, rowBaseY, C_DATE_W, ROW_H, false, TextFormatAlign.CENTER);

            ri++;
         }

         // Overlay: horizontal row lines drawn last so they render on top of fills
         var gridOverlay:MovieClip = tableMC.addChild(new MovieClip()) as MovieClip;
         gridOverlay.mouseEnabled = false;
         gridOverlay.graphics.lineStyle(1, AllianceConstants.CELL_BORDER, 1);
         var hli:int = 0;
         while (hli < _invites.length)
         {
            var hlineY:int = (hli == 0) ? HEADER_H : HEADER_H + hli * ROW_H;
            gridOverlay.graphics.moveTo(0, hlineY);
            gridOverlay.graphics.lineTo(TABLE_W, hlineY);
            hli++;
         }
      }

      /**
       * Builds an interactive checkbox bound to a row's `checked` flag. Clicking
       * toggles the flag and redraws the box (ticked / empty).
       * @param {Object} rowData - The invite row this checkbox controls
       * @returns {MovieClip} The checkbox clip
       */
      private function _makeCheckbox(rowData:Object):MovieClip
      {
         var mc:MovieClip = new MovieClip();
         mc.buttonMode = true;
         mc.mouseChildren = false;
         _drawCheckbox(mc, rowData.checked == true);
         mc.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
            {
               SOUNDS.Play("click1");
               rowData.checked = !(rowData.checked == true);
               _drawCheckbox(mc, rowData.checked == true);
            });
         return mc;
      }

      /**
       * Draws (or redraws) a checkbox: a white square with a grey border, plus a
       * green tick when checked.
       * @param {MovieClip} mc - Checkbox clip to draw into
       * @param {Boolean} checked - Whether to draw the tick
       */
      private function _drawCheckbox(mc:MovieClip, checked:Boolean):void
      {
         mc.graphics.clear();
         mc.graphics.lineStyle(1, 0x888888, 1);
         mc.graphics.beginFill(0xFFFFFF, 1);
         mc.graphics.drawRect(0, 0, CHK_SIZE, CHK_SIZE);
         mc.graphics.endFill();
         if (checked)
         {
            mc.graphics.lineStyle(2, 0x2F9700, 1);
            mc.graphics.moveTo(3, 8);
            mc.graphics.lineTo(6, 12);
            mc.graphics.lineTo(13, 3);
         }
      }

      private function _onCheckAll(e:MouseEvent):void
      {
         SOUNDS.Play("click1");
         // Toggle: if everything is already ticked, clear all; otherwise tick all
         var allChecked:Boolean = _invites.length > 0;
         for each (var row:Object in _invites)
         {
            if (row.checked != true)
            {
               allChecked = false;
               break;
            }
         }
         for each (var r:Object in _invites)
         {
            r.checked = !allChecked;
         }
         _rerender();
      }

      private function _onDelete(e:MouseEvent):void
      {
         SOUNDS.Play("click1");
         var remaining:Array = [];
         for each (var row:Object in _invites)
         {
            if (row.checked != true)
            {
               remaining.push(row);
            }
         }
         if (remaining.length == _invites.length)
         {
            // Nothing selected — no-op
            return;
         }
         // TODO: send the accepted/declined invite IDs to the server here; for
         // now the deletion is local to the mock list.
         _invites = remaining;
         _rerender();
      }

      /**
       * Builds a click handler that opens the invite dialog for a row.
       * @param {Object} rowData - The invite the dialog should describe
       * @returns {Function} MouseEvent handler
       */
      private function _makeOpenHandler(rowData:Object):Function
      {
         return function(e:MouseEvent):void
         {
            SOUNDS.Play("click1");
            new InviteDialogPopup().Show(
                  String(rowData.inviter),
                  String(rowData.from),
                  String(rowData.date),
                  function():void
                  {
                     _acceptInvite(rowData);
                  },
                  function():void
                  {
                     _declineInvite(rowData);
                  });
         };
      }

      /**
       * Accepts an invite. Mock behaviour: drops it from the list and re-renders.
       * @param {Object} rowData - The invite being accepted
       */
      private function _acceptInvite(rowData:Object):void
      {
         // TODO: GET /alliance/changeinvitestatus?invite_id=<id>&status=accepted,
         // then (per the original) switch to the Members tab and reload the
         // roster. For now the acceptance is local to the mock list.
         _removeInvite(rowData);
      }

      /**
       * Declines an invite. Mock behaviour: drops it from the list and re-renders.
       * @param {Object} rowData - The invite being declined
       */
      private function _declineInvite(rowData:Object):void
      {
         // TODO: GET /alliance/changeinvitestatus?invite_id=<id>&status=declined.
         _removeInvite(rowData);
      }

      /**
       * Removes an invite from the mock list and re-renders.
       * @param {Object} rowData - The invite to remove
       */
      private function _removeInvite(rowData:Object):void
      {
         var idx:int = _invites.indexOf(rowData);
         if (idx >= 0)
         {
            _invites.splice(idx, 1);
            _rerender();
         }
      }

      /**
       * Clears and rebuilds the tab's contents (used after a selection change).
       */
      private function _rerender():void
      {
         while (numChildren > 0)
         {
            removeChildAt(0);
         }
         build();
      }
   }
}
