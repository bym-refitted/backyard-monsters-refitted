package com.monsters.alliances.tabs
{
   import com.monsters.display.ImageCache;
   import com.monsters.display.ScrollSetV;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;

   public class AllianceFormPopup
   {
      public static const MODE_CREATE:int = 0;
      public static const MODE_EDIT:int = 1;

      // Frame
      private static const BG_W:int = 580;
      private static const BG_H:int = 500;
      private static const PAD_H:int = 28;
      private static const PAD_TOP:int = 22;
      private static const TITLE_SIZE:int = 24;
      private static const TITLE_H:int = 32;
      private static const TITLE_GAP:int = 12;
      private static const PAD_BOTTOM:int = 20;
      // CONTENT_Y_OFFSET = PAD_TOP + TITLE_H + TITLE_GAP = 66
      private static const CONTENT_Y_OFFSET:int = 66;
      // CONTENT_H = BG_H - CONTENT_Y_OFFSET - PAD_BOTTOM = 414
      private static const CONTENT_H:int = 414;

      // Shield grid (left, wider column)
      private static const GRID_COLS:int = 4;
      // CELL_SIZE = 67 → 4×67 + 6px left inset = 274, leaving 6px right padding within 280
      private static const CELL_SIZE:int = 67;
      private static const GRID_CONTENT_W:int = 280;
      // Space reserved for the ScrollSetV widget to the right of grid content
      private static const SCROLLBAR_ALLOC:int = 16;
      // GRID_H = CONTENT_H - 10 (10px margin at bottom of shield column)
      private static const GRID_H:int = 404;

      // Form (right, narrower column)
      private static const COL_GAP:int = 10;
      // RIGHT_FORM_W = BG_W - PAD_H*2 - GRID_CONTENT_W - SCROLLBAR_ALLOC - COL_GAP = 218
      private static const RIGHT_FORM_W:int = 218;

      // 41 icons → 11 rows × 70px = 770 > 404 → scrollable
      private static const SHIELD_IDS:Array = [
            1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
            11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
            21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
            31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41
         ];

      private var _mc:MovieClip;
      private var _mode:int;
      private var _selectedIdx:int = 0;
      private var _cells:Array;
      private var _previewCells:Array;
      private var _scrollContent:MovieClip;
      private var _allianceName:String;

      public function AllianceFormPopup()
      {
         super();
      }

      public function Show(mode:int, allianceName:String = null):void
      {
         _mode = mode;
         _allianceName = allianceName;
         _mc = new MovieClip();
         _cells = [];
         _selectedIdx = 0;

         const frameX:int = -int(BG_W * 0.5);
         const frameY:int = -int(BG_H * 0.5);
         const contentX:int = frameX + PAD_H;
         const contentY:int = frameY + CONTENT_Y_OFFSET;

         var frame:frame_CLIP = _mc.addChild(new frame_CLIP()) as frame_CLIP;
         frame.width = BG_W;
         frame.height = BG_H;
         frame.x = frameX;
         frame.y = frameY;
         frame.Setup(true, _onClose);

         // Title
         var tTitle:TextField = _mc.addChild(new TextField()) as TextField;
         tTitle.selectable = false;
         tTitle.mouseEnabled = false;
         tTitle.embedFonts = true;
         tTitle.antiAliasType = AntiAliasType.NORMAL;
         tTitle.width = BG_W - PAD_H * 2;
         tTitle.height = TITLE_H;
         var titleFmt:TextFormat = new TextFormat("Groboldov", TITLE_SIZE, 0xFFFFFF);
         titleFmt.align = TextFormatAlign.CENTER;
         tTitle.defaultTextFormat = titleFmt;
         tTitle.text = KEYS.Get(mode == MODE_CREATE ? "alliance_create_title" : "alliance_edit_title");
         tTitle.filters = [new GlowFilter(0, 1, 3, 3, 9, 2), new DropShadowFilter(2, 45, 0, 0.55, 3, 3, 1, 2)];
         tTitle.x = contentX;
         tTitle.y = frameY + PAD_TOP;

         // Left column background (beige)
         var leftBg:MovieClip = _mc.addChild(new MovieClip()) as MovieClip;
         leftBg.mouseEnabled = false;
         leftBg.graphics.beginFill(0xF0DCC0, 1);
         leftBg.graphics.lineStyle(1, 0x888888, 1);
         leftBg.graphics.drawRect(0, 0, GRID_CONTENT_W + SCROLLBAR_ALLOC, GRID_H);
         leftBg.graphics.endFill();
         leftBg.x = contentX;
         leftBg.y = contentY;

         _buildShieldGrid(contentX, contentY);

         const rightColX:int = contentX + GRID_CONTENT_W + SCROLLBAR_ALLOC + COL_GAP;
         _buildFormColumn(rightColX, contentY);

         GLOBAL.BlockerAdd(GLOBAL._layerTop);
         GLOBAL._layerTop.addChild(_mc);
         POPUPSETTINGS.AlignToCenter(_mc);
         POPUPSETTINGS.ScaleUp(_mc);
      }

      private function _buildShieldGrid(leftX:int, leftY:int):void
      {
         // Container placed at the left column origin — content and mask share this space
         var gridContainer:MovieClip = _mc.addChild(new MovieClip()) as MovieClip;
         gridContainer.x = leftX;
         gridContainer.y = leftY;

         // Scrollable content
         _scrollContent = gridContainer.addChild(new MovieClip()) as MovieClip;
         _scrollContent.x = 6;
         for (var i:int = 0; i < SHIELD_IDS.length; i++)
         {
            var cell:MovieClip = _scrollContent.addChild(new MovieClip()) as MovieClip;
            cell.buttonMode = true;
            cell.mouseChildren = false;
            cell.focusRect = false;
            cell.x = (i % GRID_COLS) * CELL_SIZE;
            cell.y = int(i / GRID_COLS) * CELL_SIZE + 5;
            _drawCell(cell, i == _selectedIdx);
            _loadIcon(cell, int(SHIELD_IDS[i]), CELL_SIZE - 2, 2);
            cell.addEventListener(MouseEvent.CLICK, _makeShieldClickHandler(i));
            _cells.push(cell);
         }

         // Viewport mask
         var maskMC:MovieClip = gridContainer.addChild(new MovieClip()) as MovieClip;
         maskMC.graphics.beginFill(0xFF0000, 1);
         maskMC.graphics.drawRect(0, 0, GRID_CONTENT_W, GRID_H);
         maskMC.graphics.endFill();
         _scrollContent.mask = maskMC;

         // Game's native scrollbar — positioned to the right of the grid content
         var scrollBar:ScrollSetV = gridContainer.addChild(new ScrollSetV(_scrollContent, maskMC, true)) as ScrollSetV;
         scrollBar.x = GRID_CONTENT_W;
         scrollBar.y = 0;
      }

      private function _buildFormColumn(x:int, y:int):void
      {
         const gap:int = 10;
         const inputH:int = 36;
         const textareaH:int = 80;
         const btnH:int = 36;
         const btnW:int = 150;
         const BOTTOM_PAD:int = 10;
         const colBottom:int = y + CONTENT_H;

         // --- TOP: description text ---
         var tDesc:TextField = new TextField();
         tDesc.wordWrap = true;
         tDesc.multiline = true;
         tDesc.width = RIGHT_FORM_W;
         tDesc.defaultTextFormat = new TextFormat("Verdana", 15, 0x333333);
         tDesc.htmlText = KEYS.Get(_mode == MODE_CREATE ? "alliance_create_desc" : "alliance_edit_desc");
         tDesc.height = int(tDesc.textHeight) + 6;
         tDesc.selectable = false;
         tDesc.mouseEnabled = false;
         tDesc.x = x;
         tDesc.y = y;
         _mc.addChild(tDesc);

         // --- BOTTOM: inputs and button pinned to bottom of column ---

         // Action button
         const btnY:int = colBottom - BOTTOM_PAD - btnH;
         var actBtn:Button_CLIP = _mc.addChild(new Button_CLIP()) as Button_CLIP;
         actBtn.Setup(KEYS.Get(_mode == MODE_CREATE ? "alliance_btn_create" : "alliance_btn_save"), false, btnW, btnH);
         actBtn.x = x + int((RIGHT_FORM_W - btnW) / 2);
         actBtn.y = btnY;
         actBtn.addEventListener(MouseEvent.CLICK, _onAction);

         // Description textarea (above button)
         const textareaY:int = btnY - gap - textareaH;
         var descBg:MovieClip = _mc.addChild(new MovieClip()) as MovieClip;
         descBg.mouseEnabled = false;
         descBg.graphics.beginFill(0xFFFFFF, 1);
         descBg.graphics.lineStyle(1, 0x888888, 1);
         descBg.graphics.drawRoundRect(0, 0, RIGHT_FORM_W, textareaH, 4, 4);
         descBg.graphics.endFill();
         descBg.x = x;
         descBg.y = textareaY;

         var descField:TextField = _mc.addChild(new TextField()) as TextField;
         descField.type = TextFieldType.INPUT;
         descField.selectable = true;
         descField.mouseEnabled = true;
         descField.background = false;
         descField.border = false;
         descField.wordWrap = true;
         descField.multiline = true;
         descField.width = RIGHT_FORM_W - 12;
         descField.height = textareaH - 8;
         descField.x = x + 6;
         descField.y = textareaY + 4;
         descField.defaultTextFormat = new TextFormat("Verdana", 11, 0x333333);
         _applyPlaceholder(descField, KEYS.Get("alliance_desc_placeholder"));

         // Shield preview — three sizes side by side, top-aligned, 8px gap between each,
         // pinned just above the name input
         _previewCells = [];
         const previewSizes:Array = [60, 36, 20];
         const nameInputY:int = textareaY - gap - inputH;
         const previewY:int = nameInputY - gap - 60;
         var previewX:int = x;
         for (var i:int = 0; i < previewSizes.length; i++)
         {
            var sz:int = int(previewSizes[i]);
            var pCell:MovieClip = _mc.addChild(new MovieClip()) as MovieClip;
            pCell.mouseEnabled = false;
            pCell.graphics.beginFill(0, 0);
            pCell.graphics.drawRect(0, 0, sz, sz);
            pCell.graphics.endFill();
            pCell.x = previewX;
            pCell.y = previewY;
            previewX += sz + 8;
            _loadIcon(pCell, int(SHIELD_IDS[_selectedIdx]), sz);
            _previewCells.push(pCell);
         }

         var nameBg:MovieClip = _mc.addChild(new MovieClip()) as MovieClip;
         nameBg.mouseEnabled = false;
         nameBg.graphics.beginFill(0xFFFFFF, 1);
         nameBg.graphics.lineStyle(1, 0x888888, 1);
         nameBg.graphics.drawRoundRect(0, 0, RIGHT_FORM_W, inputH, 4, 4);
         nameBg.graphics.endFill();
         nameBg.x = x;
         nameBg.y = nameInputY;

         var nameField:TextField = _mc.addChild(new TextField()) as TextField;
         nameField.background = false;
         nameField.border = false;
         nameField.width = RIGHT_FORM_W - 12;
         nameField.height = 18;
         nameField.x = x + 6;
         nameField.y = nameInputY + int((inputH - 18) / 2);
         nameField.defaultTextFormat = new TextFormat("Verdana", 11, 0x333333);
         if (_mode == MODE_CREATE)
         {
            nameField.type = TextFieldType.INPUT;
            nameField.selectable = true;
            nameField.mouseEnabled = true;
            _applyPlaceholder(nameField, KEYS.Get("alliance_name_placeholder"));
         }
         else
         {
            nameField.type = TextFieldType.DYNAMIC;
            nameField.selectable = false;
            nameField.mouseEnabled = false;
            nameField.text = (_allianceName != null) ? _allianceName : "";
         }
      }

      /**
       * Returns the ImageCache key for a shield icon (relative to GLOBAL._storageURL).
       * IDs 1–20 use the _large suffix; 21–41 use _medium.
       */
      private function _iconKey(id:int):String
      {
         var suffix:String = id <= 20 ? "_large" : "_medium";
         return "alliances/" + id + suffix + ".png";
      }

      /**
       * Loads a shield icon into a container via ImageCache, scaling it to fit targetSize.
       * Subsequent calls for the same icon are served from the in-memory BitmapData cache.
       */
      private function _loadIcon(container:MovieClip, id:int, targetSize:int, padding:int = 0):void
      {
         var inner:int = targetSize - padding * 2;
         ImageCache.GetImageWithCallBack(
               _iconKey(id),
               function(key:String, bmd:BitmapData, args:Array):void
               {
                  var bmp:Bitmap = new Bitmap(bmd);
                  bmp.smoothing = true;
                  var mc:MovieClip = args[0] as MovieClip;
                  var ts:int = int(args[1]);
                  var inn:int = int(args[2]);
                  if (bmd.width > 0 && bmd.height > 0)
                  {
                     var scale:Number = Math.min(inn / bmd.width, inn / bmd.height);
                     bmp.scaleX = bmp.scaleY = scale;
                     bmp.x = int((ts - bmd.width * scale) / 2);
                     bmp.y = int((ts - bmd.height * scale) / 2);
                  }
                  mc.addChild(bmp);
               },
               true, 4, "", [container, targetSize, inner]
            );
      }

      /**
       * Wires placeholder text (light gray) to a TextField, clearing on focus and
       * restoring on blur when empty.
       */
      private function _applyPlaceholder(field:TextField, placeholder:String):void
      {
         field.htmlText = "<font color=\"#AAAAAA\">" + placeholder + "</font>";
         field.addEventListener(FocusEvent.FOCUS_IN, function(e:FocusEvent):void
            {
               if (field.text == placeholder)
               {
                  field.text = "";
               }
            });
         field.addEventListener(FocusEvent.FOCUS_OUT, function(e:FocusEvent):void
            {
               if (field.text == "")
               {
                  field.htmlText = "<font color=\"#AAAAAA\">" + placeholder + "</font>";
               }
            });
      }

      private function _drawCell(cell:MovieClip, selected:Boolean = false):void
      {
         const BG_PAD:int = 2;
         cell.graphics.clear();
         // Full-size transparent rect keeps the hit area intact
         cell.graphics.beginFill(0, 0);
         cell.graphics.drawRect(0, 0, CELL_SIZE - 2, CELL_SIZE - 2);
         cell.graphics.endFill();
         if (selected)
         {
            cell.graphics.beginFill(0x333333, 1);
            cell.graphics.drawRect(BG_PAD, BG_PAD, CELL_SIZE - 2 - BG_PAD * 2, CELL_SIZE - 2 - BG_PAD * 2);
            cell.graphics.endFill();
         }
      }

      private function _makeShieldClickHandler(idx:int):Function
      {
         return function(e:MouseEvent):void
         {
            SOUNDS.Play("click1");
            _drawCell(_cells[_selectedIdx] as MovieClip, false);
            _selectedIdx = idx;
            _drawCell(_cells[_selectedIdx] as MovieClip, true);
            _updatePreview();
         };
      }

      private function _updatePreview():void
      {
         if (_previewCells == null)
         {
            return;
         }
         var previewSizes:Array = [60, 36, 20];
         for (var i:int = 0; i < _previewCells.length; i++)
         {
            var pc:MovieClip = _previewCells[i] as MovieClip;
            // Remove previous loader, keeping only the border graphics
            while (pc.numChildren > 0)
            {
               pc.removeChildAt(0);
            }
            _loadIcon(pc, int(SHIELD_IDS[_selectedIdx]), int(previewSizes[i]));
         }
      }

      private function _onAction(e:MouseEvent):void
      {
         SOUNDS.Play("click1");
         // TODO: send create/edit request to server
         _onClose();
      }

      private function _onClose(e:MouseEvent = null):void
      {
         SOUNDS.Play("close");
         GLOBAL.BlockerRemove();
         if (_mc && _mc.parent)
         {
            _mc.parent.removeChild(_mc);
         }
         _mc = null;
      }
   }
}
