package com.monsters.alliances.tabs
{
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;

   /**
    * Speed Up / reduce-cooldown dialog for an alliance power-up. Opened from the
    * Power-Ups tab when the player clicks a row's "Speed Up" button. Mirrors the
    * original HTML #speedup-powerup-dialog (alliance.v343.css:1213): a header, a
    * radio selection of cooldown reductions (1h / 2h / 4h / Finish now), each
    * priced in Shiny, and a gold Buy button.
    *
    * The original header used per-power-up artwork (speed_up_*.png) which is
    * missing from the asset set, so — like the rest of the alliance UI — we
    * substitute a Groboldov text title alongside the existing ap_*_icon.jpg.
    */
   public class SpeedUpPopup
   {
      // Frame
      private static const BG_W:int = 460;
      private static const BG_H:int = 360;
      private static const PAD_H:int = 28;
      private static const PAD_TOP:int = 22;
      private static const TITLE_SIZE:int = 24;
      private static const TITLE_H:int = 40;
      private static const PAD_BOTTOM:int = 20;

      // Selection panel (radio rows on the tan frame)
      private static const SEL_GAP:int = 14;
      private static const SEL_PAD:int = 12;
      private static const ROW_H:int = 38;
      private static const RADIO_SIZE:int = 16;
      private static const SHINY_SIZE:int = 18;

      // Buy button
      private static const BTN_W:int = 150;
      private static const BTN_H:int = 36;

      private var _mc:MovieClip;
      private var _data:Object;
      private var _rows:Array;
      private var _selectedValue:int = 1;

      public function SpeedUpPopup()
      {
         super();
      }

      /**
       * Opens the dialog for a power-up.
       * @param {Object} data - Power-up descriptor:
       *   { nameKey:String, icon:String, hourlyCost:int, remainingHrs:int }.
       *   Costs are computed as hourlyCost × hours; rows whose reduction exceeds
       *   the remaining time are shown disabled, matching the original.
       */
      public function Show(data:Object):void
      {
         _data = data;
         _rows = [];
         _selectedValue = 1;
         _mc = new MovieClip();

         const frameX:int = -int(BG_W * 0.5);
         const frameY:int = -int(BG_H * 0.5);
         const contentX:int = frameX + PAD_H;

         var frame:frame_CLIP = _mc.addChild(new frame_CLIP()) as frame_CLIP;
         frame.width = BG_W;
         frame.height = BG_H;
         frame.x = frameX;
         frame.y = frameY;
         frame.Setup(true, _onClose);

         // Title (Groboldov). The original header was a single per-power-up text
         // image (speed_up_<name>.png), reconstructed here as a centred
         // "Speed Up <Name>" title since that artwork is missing from the set.
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
         // Uppercased to match the other alliance popup titles (e.g.
         // "CREATE ALLIANCE"), which read larger in the Groboldov font.
         tTitle.text = KEYS.Get(String(_data.nameKey)).toUpperCase();
         tTitle.filters = [new GlowFilter(0, 1, 3, 3, 9, 2), new DropShadowFilter(2, 45, 0, 0.55, 3, 3, 1, 2)];
         tTitle.x = contentX;
         tTitle.y = frameY + PAD_TOP;

         // Selection panel
         const selX:int = contentX;
         const selY:int = frameY + PAD_TOP + TITLE_H + 8;
         const selW:int = BG_W - PAD_H * 2;
         const rows:Array = _buildRowDescriptors();

         // Rows sit directly on the tan frame as a left-aligned bullet list —
         // the original #selection had no panel/background of its own.
         for (var i:int = 0; i < rows.length; i++)
         {
            _buildRow(selX + SEL_PAD, selY + SEL_PAD + i * ROW_H, selW - SEL_PAD * 2, rows[i]);
         }

         // Buy button, bottom-centred. Highlight = true selects the gold button
         // frame — the same gold variant the building-upgrade "Speed Up" button
         // uses (BUILDINGINFO pushes "btn_speedup" with its highlight flag set),
         // matching the original dialog's goldButton.
         var buyBtn:Button_CLIP = _mc.addChild(new Button_CLIP()) as Button_CLIP;
         buyBtn.Setup(KEYS.Get("button_buy"), false, BTN_W, BTN_H);
         buyBtn.Highlight = true;
         buyBtn.x = int((BG_W - BTN_W) / 2) + frameX;
         buyBtn.y = frameY + BG_H - PAD_BOTTOM - BTN_H;
         buyBtn.addEventListener(MouseEvent.CLICK, _onBuy);

         GLOBAL.BlockerAdd(GLOBAL._layerTop);
         GLOBAL._layerTop.addChild(_mc);
         POPUPSETTINGS.AlignToCenter(_mc);
         POPUPSETTINGS.ScaleUp(_mc);
      }

      /**
       * Builds the ordered list of selectable reductions. Mirrors the original:
       * fixed 1h / 2h / 4h steps plus a "Finish now" option for the full
       * remaining time. Steps longer than the remaining cooldown are disabled.
       * @returns {Array} Row descriptors { value, hours, cost, labelKey, enabled, finish }
       */
      private function _buildRowDescriptors():Array
      {
         const hourly:int = int(_data.hourlyCost);
         const remaining:int = Math.max(1, int(_data.remainingHrs));
         var out:Array = [
               {value: 1, hours: 1, enabled: true, finish: false},
               {value: 2, hours: 2, enabled: remaining >= 2, finish: false},
               {value: 4, hours: 4, enabled: remaining >= 4, finish: false}
            ];
         // "Finish now" reduces the whole remaining cooldown; only meaningful
         // when there is more than the base hour left to remove.
         out.push({value: remaining, hours: remaining, enabled: remaining >= 2, finish: true});

         for each (var row:Object in out)
         {
            row.cost = hourly * int(row.hours);
         }
         return out;
      }

      /**
       * Renders one selectable radio row.
       * @param {int} x - Row left within the popup
       * @param {int} y - Row top within the popup
       * @param {int} w - Row width
       * @param {Object} row - Descriptor from _buildRowDescriptors
       */
      private function _buildRow(x:int, y:int, w:int, row:Object):void
      {
         const enabled:Boolean = Boolean(row.enabled);
         const textColor:uint = enabled ? 0x000000 : 0x999999;

         var radio:MovieClip = _mc.addChild(new MovieClip()) as MovieClip;
         radio.x = x;
         radio.y = y + int((ROW_H - RADIO_SIZE) / 2);
         _drawRadio(radio, int(row.value) == _selectedValue, enabled);

         var label:TextField = _mc.addChild(new TextField()) as TextField;
         label.selectable = false;
         label.mouseEnabled = false;
         label.autoSize = TextFieldAutoSize.LEFT;
         label.defaultTextFormat = new TextFormat("Verdana", 14, textColor);
         label.htmlText = _rowText(row);
         label.x = x + RADIO_SIZE + 10;
         label.y = y + int((ROW_H - 20) / 2);

         // Shiny cost icon, right after the label text
         var shiny:MovieClip = _mc.addChild(new MovieClip()) as MovieClip;
         shiny.mouseEnabled = false;
         shiny.x = int(label.x + label.width + 6);
         shiny.y = y + int((ROW_H - SHINY_SIZE) / 2);
         _loadIcon(shiny, "alliances/shiny-icon.png", SHINY_SIZE);
         if (!enabled)
         {
            shiny.alpha = 0.5;
         }

         if (enabled)
         {
            // Transparent full-row hit target so the whole line is clickable
            var hit:MovieClip = _mc.addChild(new MovieClip()) as MovieClip;
            hit.buttonMode = true;
            hit.mouseChildren = false;
            hit.graphics.beginFill(0, 0);
            hit.graphics.drawRect(0, 0, w, ROW_H);
            hit.graphics.endFill();
            hit.x = x;
            hit.y = y;
            hit.addEventListener(MouseEvent.CLICK, _makeSelectHandler(int(row.value)));
         }

         _rows.push({value: int(row.value), radio: radio, enabled: enabled});
      }

      /**
       * Localised, bold-formatted label for a reduction row.
       * @param {Object} row - Descriptor from _buildRowDescriptors
       * @returns {String} HTML text for the row label
       */
      private function _rowText(row:Object):String
      {
         var cost:String = _formatCost(int(row.cost));
         if (row.finish)
         {
            return KEYS.Get("finish_now", {v1: cost});
         }
         var key:String = int(row.hours) == 1 ? "reduce_cooldown_time_hour" : "reduce_cooldown_time_hours";
         return KEYS.Get(key, {v1: String(row.hours), v2: cost});
      }

      /**
       * Formats a Shiny cost with thousands separators.
       * @param {int} cost - Raw cost
       * @returns {String} Grouped number, e.g. "1,200"
       */
      private function _formatCost(cost:int):String
      {
         var s:String = String(cost);
         var out:String = "";
         var c:int = 0;
         for (var i:int = s.length - 1; i >= 0; i--)
         {
            out = s.charAt(i) + out;
            if (++c % 3 == 0 && i > 0)
            {
               out = "," + out;
            }
         }
         return out;
      }

      /**
       * Builds a click handler that selects the given row value and repaints all
       * radios to reflect the new selection.
       * @param {int} value - The row's value to select
       * @returns {Function} MouseEvent handler
       */
      private function _makeSelectHandler(value:int):Function
      {
         return function(e:MouseEvent):void
         {
            SOUNDS.Play("click1");
            _selectedValue = value;
            for each (var r:Object in _rows)
            {
               _drawRadio(r.radio as MovieClip, int(r.value) == _selectedValue, Boolean(r.enabled));
            }
         };
      }

      /**
       * Draws (or redraws) a radio bullet in its selected/unselected state.
       * @param {MovieClip} mc - The radio clip
       * @param {Boolean} selected - Whether to draw the filled inner dot
       * @param {Boolean} enabled - Disabled radios render greyed out
       */
      private function _drawRadio(mc:MovieClip, selected:Boolean, enabled:Boolean):void
      {
         const r:Number = RADIO_SIZE / 2;
         mc.graphics.clear();
         mc.graphics.lineStyle(1, enabled ? 0x4D4D4D : 0xAAAAAA, 1);
         mc.graphics.beginFill(0xFFFFFF, 1);
         mc.graphics.drawCircle(r, r, r);
         mc.graphics.endFill();
         if (selected)
         {
            mc.graphics.lineStyle(0, 0, 0);
            mc.graphics.beginFill(enabled ? 0x4A3A22 : 0xAAAAAA, 1);
            mc.graphics.drawCircle(r, r, r - 4);
            mc.graphics.endFill();
         }
      }

      /**
       * Loads an image into a container via ImageCache, scaled to fit size.
       * @param {MovieClip} container - Container to add the bitmap to
       * @param {String} key - ImageCache key (relative to GLOBAL._storageURL)
       * @param {int} size - Target square size in pixels
       */
      private function _loadIcon(container:MovieClip, key:String, size:int):void
      {
         ImageCache.GetImageWithCallBack(
               key,
               function(k:String, bmd:BitmapData, args:Array):void
               {
                  var bmp:Bitmap = new Bitmap(bmd);
                  bmp.smoothing = true;
                  var mc:MovieClip = args[0] as MovieClip;
                  var ts:int = int(args[1]);
                  if (bmd.width > 0 && bmd.height > 0)
                  {
                     var scale:Number = Math.min(ts / bmd.width, ts / bmd.height);
                     bmp.scaleX = bmp.scaleY = scale;
                     bmp.x = int((ts - bmd.width * scale) / 2);
                     bmp.y = int((ts - bmd.height * scale) / 2);
                  }
                  mc.addChild(bmp);
               },
               true, 4, "", [container, size]
            );
      }

      private function _onBuy(e:MouseEvent):void
      {
         SOUNDS.Play("click1");
         // TODO: send the cooldown-reduction purchase to the server using
         // _data plus _selectedValue (hours to remove), then surface the
         // success/not-enough-shiny result.
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
