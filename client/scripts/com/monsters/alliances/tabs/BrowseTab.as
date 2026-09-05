package com.monsters.alliances.tabs
{
   import com.monsters.alliances.ALLIANCES;
   import com.monsters.alliances.AllianceConstants;
   import com.monsters.alliances.AllianceTabBase;
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.display.MovieClip;
   import flash.events.IOErrorEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.ui.Keyboard;

   public class BrowseTab extends AllianceTabBase
   {
      private static const PAD:int = 10;
      private static const BTN_H:int = 36;
      private static const BTN_FILTER_W:int = 120;
      private static const INPUT_W:int = 260;
      private static const BTN_SEARCH_W:int = 110;
      private static const CTRL_Y:int = 10;
      private static const TABLE_Y:int = CTRL_Y + BTN_H + 12;
      private static const HEADER_H:int = 22;
      private static const ROW_H:int = 36;
      private static const TABLE_X:int = PAD;
      private static const TABLE_W:int = 788; // CONTENT_W - PAD * 2

      // Column proportions from the original browse table (alliance.v343.css),
      // scaled to TABLE_W.
      private static const C_RANK_X:int = 0;
      private static const C_RANK_W:int = 50;
      private static const C_NAME_X:int = 50;
      private static const C_NAME_W:int = 287;
      private static const C_MEM_X:int = 337;
      private static const C_MEM_W:int = 81;
      private static const C_EP_X:int = 418;
      private static const C_EP_W:int = 119;
      private static const C_LDR_X:int = 537;
      private static const C_LDR_W:int = 138;
      private static const C_ACT_X:int = 675;
      private static const C_ACT_W:int = 113;

      private static const ICON_W:int = ROW_H;

      // Original actions button is 97×25
      private static const ACT_BTN_W:int = 97;

      private static const POP_RIGHT_X:int = TABLE_X + C_ACT_X + C_ACT_W;
      private static const POP_X:int = POP_RIGHT_X - BrowseActionPopup.POPUP_W;

      private static const PAGE_BTN_SIZE:int = 30;
      private static const PAGE_BTN_GAP:int = 6;
      private static const PAGE_Y_GAP:int = 13;
      private static const PAGE_VISIBLE:int = 10;

      private static const ENDPOINT:String = "searchalliances";

      private var _filterMode:int = 0;
      private var _filterBtnAll:MovieClip;
      private var _filterBtnWorld:MovieClip;
      private var _activePopup:BrowseActionPopup;
      private var _currentPage:int = 1;
      private var _totalPages:int = 0;
      private var _searchTerm:String = "";
      private var _searchField:TextField;
      private var _resultsLayer:MovieClip;
      private var _loading:Boolean = false;

      public function BrowseTab()
      {
         super();
      }

      /**
       * Builds the static controls once, then loads the first page of results.
       * The results table and pagination live in their own layer so they can be
       * re-rendered on search / filter / page change without rebuilding controls.
       */
      override public function build():void
      {
         _buildControls();
         _resultsLayer = addChild(new MovieClip()) as MovieClip;
         _fetch();
      }

      /**
       * Requests the current page of alliances from the server for the active
       * search term and world filter. `page` is sent 0-indexed to match the
       * server; the client tracks it 1-indexed for display.
       */
      private function _fetch():void
      {
         if (_loading)
         {
            return;
         }
         _loading = true;
         _clearResults();

         var vars:Array = [
               ["search", _searchTerm],
               ["page", String(_currentPage - 1)],
               ["world", _filterMode == 1 ? "true" : "false"]
            ];
         var r:URLLoaderApi = new URLLoaderApi();
         r.load(GLOBAL._allianceURL + ENDPOINT, vars, _onSearchComplete, _onSearchFail);
      }

      /**
       * Renders the returned page. Server-sent errors arrive here (not _onSearchFail)
       * with an `error` field; an empty result set shows the no-results message.
       * @param {Object} response - Parsed { totalResults, pageSize, alliances[] } payload.
       */
      private function _onSearchComplete(response:Object):void
      {
         _loading = false;
         if (stage == null)
         {
            return;
         }
         _clearResults();

         if (response == null || response.error)
         {
            if (response && response.error)
            {
               GLOBAL.Message(String(response.error));
            }
            _showStatus(KEYS.Get("alliance_browse_no_results"));
            return;
         }

         var list:Array = response.alliances as Array;
         var pageSize:int = int(response.pageSize);
         var totalResults:int = int(response.totalResults);
         _totalPages = (pageSize > 0) ? Math.ceil(totalResults / pageSize) : 0;

         if (list == null || list.length == 0)
         {
            _showStatus(KEYS.Get("alliance_browse_no_results"));
            return;
         }

         _buildTable(_mapRows(list));
         _buildPagination();
      }

      private function _onSearchFail(e:IOErrorEvent):void
      {
         _loading = false;
         if (stage == null)
         {
            return;
         }
         _clearResults();
         _showStatus(KEYS.Get("alliance_browse_no_results"));
      }

      /**
       * Maps server rows onto the shape the table renderer expects, resolving the
       * diplomacy swatch colour and flagging the viewer's own alliance (the "me"
       * row, which is highlighted and has no actions button). leader_baseid is
       * carried through unrendered for the actions popup's Visit Leader button,
       * and is 0 when the leader has no main yard to visit.
       * @param {Array} list - Raw server alliance rows.
       * @returns {Array} Rows for _buildTable.
       */
      private function _mapRows(list:Array):Array
      {
         var out:Array = [];
         var i:int = 0;
         while (i < list.length)
         {
            var item:Object = list[i];
            var allianceId:int = int(item.alliance_id);
            out.push({
                  rank: int(item.rank),
                  name: String(item.name),
                  members: int(item.members),
                  ep: String(item.ep),
                  leader: String(item.leader_name),
                  leader_baseid: Number(item.leader_baseid),
                  color: _relationshipColor(int(item.relationship)),
                  alliance_id: allianceId,
                  image: int(item.image),
                  self: allianceId != 0 && allianceId == ALLIANCES._allianceID
               });
            i++;
         }
         return out;
      }

      /**
       * Loads an alliance shield icon into the row's icon box, centred and scaled
       * to fit inside the given inset (leaving the relationship-colour fill showing
       * as a border). IDs 1-20 use the _large asset, 21+ use _medium — matching
       * MyAllianceTab / AllianceFormPopup.
       * @param {MovieClip} container - The icon box (relationship-tinted).
       * @param {int} id - Shield id 1-41.
       * @param {int} inset - Padding between the box edge and the shield.
       */
      private function _loadShield(container:MovieClip, id:int, inset:int):void
      {
         if (id <= 0)
         {
            return;
         }
         var suffix:String = id <= 20 ? "_large" : "_medium";
         var key:String = "alliances/" + id + suffix + ".png";
         var box:int = ROW_H - inset * 2;
         ImageCache.GetImageWithCallBack(
               key,
               function(k:String, bmd:BitmapData, args:Array):void
               {
                  var bmp:Bitmap = new Bitmap(bmd);
                  bmp.smoothing = true;
                  var mc:MovieClip = args[0] as MovieClip;
                  var ins:int = int(args[1]);
                  var sz:int = int(args[2]);
                  if (bmd.width > 0 && bmd.height > 0)
                  {
                     var scale:Number = Math.min(sz / bmd.width, sz / bmd.height);
                     bmp.scaleX = bmp.scaleY = scale;
                     bmp.x = ins + int((sz - bmd.width * scale) / 2);
                     bmp.y = ins + int((sz - bmd.height * scale) / 2);
                  }
                  mc.addChild(bmp);
               },
               true, 4, "", [container, inset, box]
            );
      }

      /**
       * @param {int} relationship - Diplomacy value: -1 hostile, 0 neutral, 1 friendly.
       * @returns {uint} The swatch colour for the row's relationship column.
       */
      private function _relationshipColor(relationship:int):uint
      {
         if (relationship < 0)
         {
            return AllianceConstants.REL_HOSTILE;
         }
         if (relationship > 0)
         {
            return AllianceConstants.REL_FRIENDLY;
         }
         return AllianceConstants.REL_NEUTRAL;
      }

      /**
       * Draws a centered status message (loading / no results) in the results layer.
       */
      private function _showStatus(message:String):void
      {
         if (_resultsLayer == null)
         {
            return;
         }
         var tf:TextField = _resultsLayer.addChild(new TextField()) as TextField;
         tf.selectable = false;
         tf.mouseEnabled = false;
         tf.width = TABLE_W;
         tf.height = 24;
         tf.x = TABLE_X;
         tf.y = TABLE_Y + 12;
         var fmt:TextFormat = new TextFormat("Verdana", 13, 0x5A3B1E, true);
         fmt.align = TextFormatAlign.CENTER;
         tf.defaultTextFormat = fmt;
         tf.text = message;
      }

      /**
       * Clears the results layer (table, pagination, status text) and dismisses any
       * open actions popup, leaving the controls intact.
       */
      private function _clearResults():void
      {
         _dismissActivePopup();
         if (_resultsLayer == null)
         {
            return;
         }
         while (_resultsLayer.numChildren > 0)
         {
            _resultsLayer.removeChildAt(0);
         }
      }

      private function _buildControls():void
      {
         _filterBtnAll = addChild(new MovieClip()) as MovieClip;
         _filterBtnAll.x = PAD;
         _filterBtnAll.y = CTRL_Y;
         _filterBtnAll.buttonMode = true;
         _filterBtnAll.mouseChildren = false;
         _drawFilterBtn(_filterBtnAll, KEYS.Get("alliance_filter_all"), BTN_FILTER_W, BTN_H, _filterMode == 0);
         _filterBtnAll.addEventListener(MouseEvent.CLICK, _onFilterClick);

         _filterBtnWorld = addChild(new MovieClip()) as MovieClip;
         _filterBtnWorld.x = PAD + BTN_FILTER_W + 5;
         _filterBtnWorld.y = CTRL_Y;
         _filterBtnWorld.buttonMode = true;
         _filterBtnWorld.mouseChildren = false;
         _drawFilterBtn(_filterBtnWorld, KEYS.Get("alliance_filter_world"), BTN_FILTER_W, BTN_H, _filterMode == 1);
         _filterBtnWorld.addEventListener(MouseEvent.CLICK, _onFilterClick);

         if (!ALLIANCES._myAlliance)
         {
            var btnCreate:Button_CLIP = addChild(new Button_CLIP()) as Button_CLIP;
            btnCreate.Setup(KEYS.Get("alliance_btn_create"), false, 130, BTN_H);
            btnCreate.x = _filterBtnWorld.x + BTN_FILTER_W + 5;
            btnCreate.y = CTRL_Y;
            btnCreate.addEventListener(MouseEvent.CLICK, _onCreateAlliance);
         }

         const searchBtnX:int = CONTENT_W - PAD - BTN_SEARCH_W;
         const inputX:int = searchBtnX - 8 - INPUT_W;
         const INPUT_BOX_H:int = 32;
         // FIELD_H sized to one line — avoids Flash rendering typed text in the
         // corner of an oversized INPUT TextField
         const FIELD_H:int = 18;

         var inputBg:MovieClip = addChild(new MovieClip()) as MovieClip;
         inputBg.mouseEnabled = false;
         inputBg.graphics.beginFill(0xFFFFFF, 1);
         inputBg.graphics.lineStyle(1, 0x888888, 1);
         inputBg.graphics.drawRoundRect(0, 0, INPUT_W, INPUT_BOX_H, 2, 2);
         inputBg.graphics.endFill();
         inputBg.x = inputX;
         inputBg.y = CTRL_Y;

         _searchField = addChild(new TextField()) as TextField;
         _searchField.type = TextFieldType.INPUT;
         _searchField.background = false;
         _searchField.border = false;
         _searchField.selectable = true;
         _searchField.mouseEnabled = true;
         _searchField.maxChars = 30;
         _searchField.width = INPUT_W - 12;
         _searchField.height = FIELD_H;
         _searchField.x = inputX + 6;
         _searchField.y = CTRL_Y + int((INPUT_BOX_H - FIELD_H) / 2);
         var sfmt:TextFormat = new TextFormat("Verdana", 11, 0x333333, true);
         _searchField.defaultTextFormat = sfmt;
         _searchField.addEventListener(KeyboardEvent.KEY_DOWN, _onSearchKey);

         var btnSearch:Button_CLIP = addChild(new Button_CLIP()) as Button_CLIP;
         btnSearch.Setup(KEYS.Get("alliance_btn_search"), false, BTN_SEARCH_W, BTN_H);
         btnSearch.x = searchBtnX;
         btnSearch.y = CTRL_Y;
         btnSearch.addEventListener(MouseEvent.CLICK, _onSearch);
      }

      private function _onSearchKey(e:KeyboardEvent):void
      {
         if (e.keyCode == Keyboard.ENTER)
         {
            _onSearch(null);
         }
      }

      /**
       * Runs a search from the input field, resetting to the first page.
       */
      private function _onSearch(e:MouseEvent):void
      {
         SOUNDS.Play("click1");
         _searchTerm = (_searchField != null && _searchField.text != null) ? _searchField.text : "";
         _currentPage = 1;
         _fetch();
      }

      private function _buildTable(rows:Array):void
      {
         const totalH:int = HEADER_H + rows.length * ROW_H;

         var tableMC:MovieClip = _resultsLayer.addChild(new MovieClip()) as MovieClip;
         tableMC.x = TABLE_X;
         tableMC.y = TABLE_Y;

         tableMC.graphics.beginFill(AllianceConstants.HEADER_BG);
         tableMC.graphics.drawRect(0, 0, TABLE_W, HEADER_H);
         tableMC.graphics.endFill();

         var fi:int = 0;
         while (fi < rows.length)
         {
            var rowFill:uint = Boolean(rows[fi].self)
               ? AllianceConstants.ROW_ME
               : ((fi % 2 == 0) ? AllianceConstants.ROW_ALT0 : AllianceConstants.ROW_ALT1);
            tableMC.graphics.beginFill(rowFill);
            tableMC.graphics.drawRect(0, HEADER_H + fi * ROW_H, TABLE_W, ROW_H);
            tableMC.graphics.endFill();
            fi++;
         }

         tableMC.graphics.lineStyle(1, AllianceConstants.CELL_BORDER, 1);
         var vLineXs:Array = [C_NAME_X, C_MEM_X, C_EP_X, C_LDR_X, C_ACT_X];
         var vli:int = 0;
         while (vli < vLineXs.length)
         {
            tableMC.graphics.moveTo(int(vLineXs[vli]), 0);
            tableMC.graphics.lineTo(int(vLineXs[vli]), totalH);
            vli++;
         }
         tableMC.graphics.lineStyle(1, AllianceConstants.TABLE_BORDER, 1);
         tableMC.graphics.drawRect(0, 0, TABLE_W, totalH);

         _addLabel(tableMC, KEYS.Get("alliance_col_rank"), C_RANK_X, 0, C_RANK_W, HEADER_H, true, TextFormatAlign.CENTER);
         _addLabel(tableMC, KEYS.Get("alliance_col_name"), C_NAME_X + 5, 0, C_MEM_X - C_NAME_X - 5, HEADER_H, true, TextFormatAlign.LEFT);
         _addLabel(tableMC, KEYS.Get("alliance_col_members"), C_MEM_X, 0, C_MEM_W, HEADER_H, true, TextFormatAlign.CENTER);
         _addLabel(tableMC, KEYS.Get("alliance_col_ep"), C_EP_X, 0, C_EP_W, HEADER_H, true, TextFormatAlign.CENTER);
         _addLabel(tableMC, KEYS.Get("alliance_col_leader"), C_LDR_X + 5, 0, C_LDR_W - 5, HEADER_H, true, TextFormatAlign.LEFT);
         _addLabel(tableMC, KEYS.Get("alliance_col_actions"), C_ACT_X, 0, C_ACT_W, HEADER_H, true, TextFormatAlign.CENTER);

         var ri:int = 0;
         while (ri < rows.length)
         {
            var rowData:Object = rows[ri];
            var rowBaseY:int = HEADER_H + ri * ROW_H;

            _addLabel(tableMC, String(rowData.rank), C_RANK_X, rowBaseY, C_RANK_W, ROW_H, false, TextFormatAlign.CENTER);

            // The shield sits in a relationship-tinted frame (matching the
            // original's relation_div wrapper); the colour fill shows as a border
            // once the shield image loads inset on top of it.
            var iconMC:MovieClip = tableMC.addChild(new MovieClip()) as MovieClip;
            iconMC.mouseEnabled = false;
            iconMC.graphics.beginFill(rowData.color, 1);
            iconMC.graphics.drawRect(0, 0, ICON_W, ROW_H);
            iconMC.graphics.endFill();
            iconMC.graphics.lineStyle(1, AllianceConstants.CELL_BORDER, 1);
            iconMC.graphics.moveTo(ICON_W, 0);
            iconMC.graphics.lineTo(ICON_W, ROW_H);
            iconMC.x = C_NAME_X + 1;
            iconMC.y = rowBaseY;
            _loadShield(iconMC, int(rowData.image), 3);

            const nameX:int = C_NAME_X + 1 + ICON_W + 8;
            _addLabel(tableMC, rowData.name, nameX, rowBaseY, C_MEM_X - nameX - 5, ROW_H, false, TextFormatAlign.LEFT);
            _addLabel(tableMC, String(rowData.members), C_MEM_X, rowBaseY, C_MEM_W, ROW_H, false, TextFormatAlign.CENTER);
            _addLabel(tableMC, rowData.ep, C_EP_X, rowBaseY, C_EP_W, ROW_H, false, TextFormatAlign.CENTER);
            _addLabel(tableMC, rowData.leader, C_LDR_X + 5, rowBaseY, C_LDR_W - 5, ROW_H, false, TextFormatAlign.LEFT);

            // The viewer's own alliance has no actions to take on itself.
            if (!rowData.self)
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

         var gridOverlay:MovieClip = tableMC.addChild(new MovieClip()) as MovieClip;
         gridOverlay.mouseEnabled = false;
         gridOverlay.graphics.lineStyle(1, AllianceConstants.CELL_BORDER, 1);
         var hli:int = 0;
         while (hli < rows.length)
         {
            var hlineY:int = (hli == 0) ? HEADER_H : HEADER_H + hli * ROW_H;
            gridOverlay.graphics.moveTo(0, hlineY);
            gridOverlay.graphics.lineTo(TABLE_W, hlineY);
            hli++;
         }
         // Redraw the outer frame's bottom edge on top of the icon rects, which
         // otherwise hide it on the last/only row.
         gridOverlay.graphics.lineStyle(1, AllianceConstants.TABLE_BORDER, 1);
         gridOverlay.graphics.moveTo(0, totalH);
         gridOverlay.graphics.lineTo(TABLE_W, totalH);
      }

      /**
       * Builds the pagination row (<<, a sliding window of page numbers, >>). It
       * sits on the wooden frame at the bottom of the popup, just below the beige
       * inner section, right-aligned to the inner section's right edge. The window
       * shows up to PAGE_VISIBLE pages and slides as the current page advances
       * past it (e.g. 1–10, then 2–11, …). The current page and the arrows at the
       * first/last page are drawn non-clickable.
       */
      private function _buildPagination():void
      {
         const total:int = _totalPages;
         if (total <= 1)
         {
            return;
         }

         const visible:int = Math.min(PAGE_VISIBLE, total);
         var start:int = (_currentPage <= visible) ? 1 : _currentPage - visible + 1;
         if (start > total - visible + 1)
         {
            start = total - visible + 1;
         }
         if (start < 1)
         {
            start = 1;
         }
         const end:int = start + visible - 1;

         const count:int = visible + 2;
         const totalW:int = count * PAGE_BTN_SIZE + (count - 1) * PAGE_BTN_GAP;
         const py:int = CONTENT_H + PAGE_Y_GAP;
         const step:int = PAGE_BTN_SIZE + PAGE_BTN_GAP;
         var x:int = CONTENT_W - totalW;

         var prev:MovieClip = _makePageButton("<<", _currentPage - 1, _currentPage <= 1);
         prev.x = x;
         prev.y = py;
         _resultsLayer.addChild(prev);
         x += step;

         for (var p:int = start; p <= end; p++)
         {
            var num:MovieClip = _makePageButton(String(p), p, p == _currentPage);
            num.x = x;
            num.y = py;
            _resultsLayer.addChild(num);
            x += step;
         }

         var next:MovieClip = _makePageButton(">>", _currentPage + 1, _currentPage >= total);
         next.x = x;
         next.y = py;
         _resultsLayer.addChild(next);
      }

      /**
       * Creates a small square page button (a number or << / >>). When marked
       * active it is drawn with the hover colour and is non-interactive — used
       * for the current page number and for the << / >> arrows when already on
       * the first / last page. All other buttons are clickable.
       * @param {String} label - Button text (number or arrows)
       * @param {int} targetPage - Page to switch to on click
       * @param {Boolean} current - Whether this button is in the active/end state
       * @returns {MovieClip} The page button
       */
      private function _makePageButton(label:String, targetPage:int, current:Boolean):MovieClip
      {
         var mc:MovieClip = new MovieClip();
         _drawPageBtn(mc, current, false);

         var tf:TextField = mc.addChild(new TextField()) as TextField;
         tf.selectable = false;
         tf.mouseEnabled = false;
         tf.width = PAGE_BTN_SIZE;
         tf.height = 16;
         tf.x = 0;
         tf.y = int((PAGE_BTN_SIZE - 16) / 2);
         var fmt:TextFormat = new TextFormat("Verdana", 11, 0x333333, true);
         fmt.align = TextFormatAlign.CENTER;
         tf.defaultTextFormat = fmt;
         tf.text = label;

         if (current)
         {
            mc.mouseEnabled = false;
         }
         else
         {
            mc.buttonMode = true;
            mc.mouseChildren = false;
            mc.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void
               {
                  _drawPageBtn(mc, false, true);
               });
            mc.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void
               {
                  _drawPageBtn(mc, false, false);
               });
            mc.addEventListener(MouseEvent.CLICK, _makePageHandler(targetPage));
         }

         return mc;
      }

      /**
       * Draws (or redraws) a page button's background: gray gradient normally,
       * lighter on hover. The current page uses that same lighter hover colour.
       */
      private function _drawPageBtn(mc:MovieClip, current:Boolean, hover:Boolean):void
      {
         mc.graphics.clear();
         mc.graphics.lineStyle(1, 0x888888, 1);
         if (current || hover)
         {
            mc.graphics.beginFill(0xFAFAFA, 1);
         }
         else
         {
            var mtx:Matrix = new Matrix();
            mtx.createGradientBox(PAGE_BTN_SIZE, PAGE_BTN_SIZE, Math.PI / 2, 0, 0);
            mc.graphics.beginGradientFill(GradientType.LINEAR, [0xF4F5F2, 0xD9D9D9], [1, 1], [0, 255], mtx);
         }
         mc.graphics.drawRoundRect(0, 0, PAGE_BTN_SIZE, PAGE_BTN_SIZE, 4, 4);
         mc.graphics.endFill();
      }

      /**
       * Builds a click handler that loads the given page from the server.
       * @param {int} targetPage - Page to switch to
       * @returns {Function} MouseEvent handler
       */
      private function _makePageHandler(targetPage:int):Function
      {
         return function(e:MouseEvent):void
         {
            SOUNDS.Play("click1");
            if (targetPage < 1 || targetPage > _totalPages || targetPage == _currentPage)
            {
               return;
            }
            _currentPage = targetPage;
            _fetch();
         };
      }

      private function _makeActionsHandler(rowData:Object, rowBaseY:int):Function
      {
         return function(e:MouseEvent):void
         {
            SOUNDS.Play("click1");
            const popY:int = Math.min(
                  TABLE_Y + rowBaseY,
                  CONTENT_H - BrowseActionPopup.POPUP_H
               ) + 12;
            _showActionsPopup(rowData, POP_X - 30, popY);
         };
      }

      private function _showActionsPopup(rowData:Object, popX:int, popY:int):void
      {
         _dismissActivePopup();
         _activePopup = new BrowseActionPopup(rowData, _dismissActivePopup, _fetch);
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

      private function _onFilterClick(e:MouseEvent):void
      {
         SOUNDS.Play("click1");
         _filterMode = (e.currentTarget == _filterBtnAll) ? 0 : 1;
         _drawFilterBtn(_filterBtnAll, KEYS.Get("alliance_filter_all"), BTN_FILTER_W, BTN_H, _filterMode == 0);
         _drawFilterBtn(_filterBtnWorld, KEYS.Get("alliance_filter_world"), BTN_FILTER_W, BTN_H, _filterMode == 1);
         _currentPage = 1;
         _fetch();
      }

      private function _onCreateAlliance(e:MouseEvent):void
      {
         SOUNDS.Play("click1");
         new AllianceFormPopup().Show(AllianceFormPopup.MODE_CREATE);
      }

      /**
       * Draws (or redraws) a custom filter button.
       * Active state: top-to-bottom gradient (near-white → gray), dark text.
       * Inactive state: solid white background, dimmed text.
       */
      private function _drawFilterBtn(mc:MovieClip, label:String, w:int, h:int, active:Boolean):void
      {
         mc.graphics.clear();
         mc.graphics.lineStyle(1, 0x888888, 1);
         if (active)
         {
            var mtx:Matrix = new Matrix();
            mtx.createGradientBox(w, h, Math.PI / 2, 0, 0);
            mc.graphics.beginGradientFill(GradientType.LINEAR, [0xF4F5F2, 0xD9D9D9], [1, 1], [0, 255], mtx);
         }
         else
         {
            mc.graphics.beginFill(0xFFFFFF, 1);
         }
         mc.graphics.drawRoundRect(0, 0, w, h, 6, 6);
         mc.graphics.endFill();

         while (mc.numChildren > 0)
         {
            mc.removeChildAt(0);
         }

         var tf:TextField = mc.addChild(new TextField()) as TextField;
         tf.selectable = false;
         tf.mouseEnabled = false;
         tf.width = w;
         tf.height = 20;
         tf.x = 0;
         tf.y = int((h - 18) / 2);
         var fmt:TextFormat = new TextFormat("Verdana", 11, active ? 0x333333 : 0x666666, true);
         fmt.align = TextFormatAlign.CENTER;
         tf.defaultTextFormat = fmt;
         tf.text = label;
      }
   }
}
