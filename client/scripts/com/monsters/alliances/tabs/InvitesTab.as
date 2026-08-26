package com.monsters.alliances.tabs
{
   import com.monsters.alliances.ALLIANCES;
   import com.monsters.alliances.AllianceConstants;
   import com.monsters.alliances.AllianceTabBase;
   import com.monsters.display.ImageCache;
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextFormatAlign;

   /**
    * Invites tab — the player's alliance inbox, in both directions.
    * Mirrors the original canvas.htm "tabs-messages" layout: a Check All / Delete
    * control bar above a checkbox / From / Subject / Date table.
    *
    * One list carries invites and join requests alike. A pending row is addressed
    * to whoever has to answer it, so a leader sees incoming requests here while an
    * ordinary player sees incoming invites; once answered the same row returns to
    * whoever opened it as an "accepted"/"declined" notice.
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

      // Column proportions from the original messages table (alliance.v343.css),
      // scaled to TABLE_W.
      private static const C_CHK_X:int = 0;
      private static const C_CHK_W:int = 44;
      private static const C_FROM_X:int = 44;
      private static const C_FROM_W:int = 213;
      private static const C_SUBJ_X:int = 257;
      private static const C_SUBJ_W:int = 406;
      private static const C_DATE_X:int = 663;
      private static const C_DATE_W:int = 125;

      // Original invite pic is 24×24
      private static const FLAG_SIZE:int = 24;
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
            _invites = [];
            _load();
         }
         _buildControls();
         _buildTable();
      }

      /**
       * Draws the inbox from the store, which the alliance window warms on open.
       * Rows arrive in server shape and are mapped onto what the table renderer
       * expects, the subject line being derived from the row's type and status
       * exactly as the original composed it.
       */
      private function _load():void
      {
         ALLIANCES.LoadMessages(function(messages:Array):void
            {
               _invites = (messages != null) ? _mapRows(messages) : [];
               _rerender();
            });
      }

      /**
       * Re-reads both stores after a mutation, redrawing the list and the tab strip
       * so the Invites and Members labels follow the change.
       *
       * Answering a request moves the roster as well as the inbox, and the store
       * layer drops both caches rather than refreshing them - so My Alliance has to
       * be re-read here too, or the Members label would redraw against a cleared
       * cache and read 0/0.
       */
      private function _refresh():void
      {
         ALLIANCES.LoadMessages(function(messages:Array):void
            {
               _invites = (messages != null) ? _mapRows(messages) : [];
               _rerender();
               ALLIANCEWINDOW.RefreshTabLabels();
            });

         ALLIANCES.LoadMyAlliance(ALLIANCEWINDOW.RefreshTabLabels);
      }

      /**
       * Maps server rows onto the shape the table renderer expects.
       *
       * The From column names the other party, which flips with the row: a pending
       * invite is from the alliance, a pending request is from the player who sent
       * it, and once resolved each returns to its originator showing the other side.
       * Each row keeps its own `checked` flag so selection survives a re-render.
       *
       * @param {Array} messages - Raw server message rows.
       * @returns {Array} Rows for _buildTable.
       */
      private function _mapRows(messages:Array):Array
      {
         var out:Array = [];
         var i:int = 0;
         while (i < messages.length)
         {
            var item:Object = messages[i];
            var isInvite:Boolean = String(item.type) == AllianceConstants.INVITE_TYPE_INVITE;
            var isPending:Boolean = String(item.status) == AllianceConstants.INVITE_PENDING;
            var fromAlliance:Boolean = isPending ? isInvite : !isInvite;

            out.push({
                  invite_id: int(item.invite_id),
                  type: String(item.type),
                  status: String(item.status),
                  alliance_name: String(item.alliance_name),
                  alliance_image: int(item.alliance_image),
                  leader_name: String(item.leader_name),
                  user_id: int(item.user_id),
                  user_name: String(item.user_name),
                  base_id: Number(item.base_id),
                  from: fromAlliance ? String(item.alliance_name) : String(item.user_name),
                  shield: fromAlliance ? int(item.alliance_image) : 0,
                  subject: _subjectFor(item, isInvite, isPending),
                  date: String(item.update_at_formatted),
                  checked: false
               });
            i++;
         }
         return out;
      }

      /**
       * Composes a row's subject the way the original did - one line per type and
       * status pairing, naming whichever side the reader is not.
       *
       * @param {Object} item - The raw server row.
       * @param {Boolean} isInvite - Whether the alliance opened the exchange.
       * @param {Boolean} isPending - Whether it is still unanswered.
       * @returns {String} The subject line.
       */
      private function _subjectFor(item:Object, isInvite:Boolean, isPending:Boolean):String
      {
         if (isPending)
         {
            return isInvite
               ? KEYS.Get("alliance_msg_subject_invite", {"v1": String(item.invited_by_name), "v2": String(item.alliance_name)})
               : KEYS.Get("alliance_msg_subject_request", {"v1": String(item.user_name), "v2": String(item.alliance_name)});
         }

         var accepted:Boolean = String(item.status) == AllianceConstants.INVITE_ACCEPTED;

         if (isInvite)
         {
            return KEYS.Get(accepted ? "alliance_msg_subject_invite_accepted" : "alliance_msg_subject_invite_declined");
         }
         return KEYS.Get(accepted ? "alliance_msg_subject_accepted" : "alliance_msg_subject_declined");
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

         tableMC.graphics.lineStyle(1, AllianceConstants.CELL_BORDER, 1);
         var vLineXs:Array = [C_FROM_X, C_SUBJ_X, C_DATE_X];
         var vli:int = 0;
         while (vli < vLineXs.length)
         {
            tableMC.graphics.moveTo(int(vLineXs[vli]), 0);
            tableMC.graphics.lineTo(int(vLineXs[vli]), totalH);
            vli++;
         }
         tableMC.graphics.lineStyle(1, AllianceConstants.TABLE_BORDER, 1);
         tableMC.graphics.drawRect(0, 0, TABLE_W, totalH);

         _addLabel(tableMC, KEYS.Get("alliance_col_from"), C_FROM_X + 6, 0, C_FROM_W - 6, HEADER_H, true, TextFormatAlign.LEFT);
         _addLabel(tableMC, KEYS.Get("alliance_col_subject"), C_SUBJ_X + 6, 0, C_SUBJ_W - 6, HEADER_H, true, TextFormatAlign.LEFT);
         _addLabel(tableMC, KEYS.Get("alliance_col_date"), C_DATE_X, 0, C_DATE_W, HEADER_H, true, TextFormatAlign.CENTER);

         var ri:int = 0;
         while (ri < _invites.length)
         {
            var rowData:Object = _invites[ri];
            var rowBaseY:int = HEADER_H + ri * ROW_H;

            // Hit-area over the From/Subject/Date cells (not the checkbox); added
            // before the flag/labels so they stay on top and it still catches clicks.
            var hit:MovieClip = tableMC.addChild(new MovieClip()) as MovieClip;
            hit.graphics.beginFill(0x000000, 0);
            hit.graphics.drawRect(0, 0, TABLE_W - C_FROM_X, ROW_H);
            hit.graphics.endFill();
            hit.x = C_FROM_X;
            hit.y = rowBaseY;
            hit.buttonMode = true;
            hit.mouseChildren = false;
            hit.addEventListener(MouseEvent.CLICK, _makeOpenHandler(rowData));

            var chk:MovieClip = _makeCheckbox(rowData);
            chk.x = C_CHK_X + int((C_CHK_W - CHK_SIZE) / 2);
            chk.y = rowBaseY + int((ROW_H - CHK_SIZE) / 2);
            tableMC.addChild(chk);

            // The original drew a bare 24x24 picture here, so nothing backs the
            // shield. Rows whose other party is a player carry no shield and leave
            // the slot empty rather than shifting, keeping the column aligned.
            var flag:MovieClip = tableMC.addChild(new MovieClip()) as MovieClip;
            flag.mouseEnabled = false;
            flag.x = C_FROM_X + 6;
            flag.y = rowBaseY + int((ROW_H - FLAG_SIZE) / 2);
            _loadShield(flag, int(rowData.shield));

            const fromX:int = C_FROM_X + 6 + FLAG_SIZE + 6;
            _addLabel(tableMC, String(rowData.from), fromX, rowBaseY, C_FROM_X + C_FROM_W - fromX - 6, ROW_H, false, TextFormatAlign.LEFT);
            _addLabel(tableMC, String(rowData.subject), C_SUBJ_X + 6, rowBaseY, C_SUBJ_W - 12, ROW_H, false, TextFormatAlign.LEFT);
            _addLabel(tableMC, String(rowData.date), C_DATE_X, rowBaseY, C_DATE_W, ROW_H, false, TextFormatAlign.CENTER);

            ri++;
         }

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
       * Draws the alliance shield over a row's From swatch. Rows whose other party
       * is a player carry no shield id, leaving the plain swatch the original used
       * for an avatar. IDs 1-20 use the _large asset, 21+ _medium.
       *
       * @param {MovieClip} container - The From swatch.
       * @param {int} id - Shield id 1-41, or 0 for none.
       */
      private function _loadShield(container:MovieClip, id:int):void
      {
         if (id <= 0) return;

         var suffix:String = id <= 20 ? "_large" : "_medium";

         ImageCache.GetImageWithCallBack(
               "alliances/" + id + suffix + ".png",
               function(k:String, bmd:BitmapData, args:Array):void
               {
                  var mc:MovieClip = args[0] as MovieClip;
                  if (bmd.width <= 0 || bmd.height <= 0) return;

                  var bmp:Bitmap = new Bitmap(bmd);
                  bmp.smoothing = true;
                  var scale:Number = Math.min(FLAG_SIZE / bmd.width, FLAG_SIZE / bmd.height);
                  bmp.scaleX = bmp.scaleY = scale;
                  bmp.x = int((FLAG_SIZE - bmd.width * scale) / 2);
                  bmp.y = int((FLAG_SIZE - bmd.height * scale) / 2);
                  mc.addChild(bmp);
               },
               true, 4, "", [container]
            );
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

         var ids:Array = [];
         for each (var row:Object in _invites)
         {
            if (row.checked == true)
            {
               ids.push(int(row.invite_id));
            }
         }

         if (ids.length == 0) return;

         PLEASEWAIT.Show(KEYS.Get("msg_loading"));

         // Sent comma-separated, as the original posted the checked boxes.
         ALLIANCES.DeleteMessages(ids.join(","), function(response:Object):void
            {
               PLEASEWAIT.Hide();

               if (response == null || response.error)
               {
                  GLOBAL.Message((response && response.error)
                     ? String(response.error)
                     : KEYS.Get("alliance_err_generic"));
                  return;
               }

               _refresh();
            });
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
                  rowData,
                  function():void
                  {
                     _acceptInvite(rowData);
                  },
                  function():void
                  {
                     _declineInvite(rowData);
                  },
                  function():void
                  {
                     _visitBase(rowData);
                  });
         };
      }

      /**
       * Scouts the base of the player asking to join, so a leader can judge the
       * request before answering it. Leaves the request pending and closes the
       * alliance window the same way the Browse tab's Visit Leader does.
       *
       * @param {Object} rowData - The request being scouted
       */
      private function _visitBase(rowData:Object):void
      {
         var baseId:Number = Number(rowData.base_id);

         if (!(baseId > 0)) return;
         if (BASE._saving || BASE._loading || BASE._saveCounterA != BASE._saveCounterB) return;
         if (BASE.isInfernoMainYardOrOutpost) return;

         ALLIANCEWINDOW.Hide();

         GLOBAL._currentCell = null;

         var yardType:int = MapRoomManager.instance.isInMapRoom3
            ? int(EnumYardType.PLAYER)
            : int(EnumYardType.MAIN_YARD);

         BASE.LoadBase(null, 0, baseId, GLOBAL.e_BASE_MODE.VIEW, true, yardType);
      }

      /**
       * Accepts a pending row: joining the alliance that invited the player, or
       * admitting the player who asked to join.
       * @param {Object} rowData - The row being accepted
       */
      private function _acceptInvite(rowData:Object):void
      {
         _answer(rowData, AllianceConstants.INVITE_ACCEPTED);
      }

      /**
       * Declines a pending row.
       * @param {Object} rowData - The row being declined
       */
      private function _declineInvite(rowData:Object):void
      {
         _answer(rowData, AllianceConstants.INVITE_DECLINED);
      }

      /**
       * Answers a pending row and reloads the inbox. The row is not dropped
       * locally - the server keeps it and hands it back to whoever opened it as an
       * outcome notice, so a refetch is what shows the correct list to both sides.
       *
       * @param {Object} rowData - The row being answered
       * @param {String} status - INVITE_ACCEPTED or INVITE_DECLINED
       */
      private function _answer(rowData:Object, status:String):void
      {
         PLEASEWAIT.Show(KEYS.Get("msg_loading"));

         ALLIANCES.ChangeInviteStatus(int(rowData.invite_id), status, function(response:Object):void
            {
               PLEASEWAIT.Hide();

               if (response == null || response.error)
               {
                  GLOBAL.Message((response && response.error)
                     ? String(response.error)
                     : KEYS.Get("alliance_err_generic"));
                  return;
               }

               _refresh();
            });
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
