package com.monsters.alliances.tabs
{
   import com.monsters.alliances.AllianceConstants;
   import com.monsters.alliances.AllianceTabBase;
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.GradientType;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;

   /**
    * Alliance Power-Ups tab. Lists the alliance power-ups (Armament, Conquest,
    * Declare War) as stacked rows inside a single white panel. Each row shows the
    * power-up icon, its name and description, a charging cooldown bar with the
    * remaining time, and a yellow "Speed Up" button.
    */
   public class PowerUpsTab extends AllianceTabBase
   {
      // CONTENT_W is an instance const on the base class; mirror it as a class
      // const so the static layout constants below can reference it. Declared
      // first because AS3 evaluates static initializers in textual order.
      private static const CONTENT_W_C:int = AllianceConstants.CONTENT_W;

      // Outer margin from the tab content edges
      private static const PAD:int = 14;

      // White panel holding the power-up rows
      private static const PANEL_X:int = PAD;
      private static const PANEL_Y:int = PAD;
      private static const PANEL_W:int = CONTENT_W_C - PAD * 2;

      private static const ROW_H:int = 104;
      private static const ROW_PAD:int = 8;

      // Icon fills almost the full row height
      private static const ICON_SIZE:int = 88;

      // Text block sits to the right of the icon
      private static const TEXT_X:int = ROW_PAD + ICON_SIZE + 12;
      private static const TITLE_Y:int = 4;
      private static const DESC_Y:int = 24;
      private static const DESC_H:int = 36;

      // Cooldown bar, anchored toward the bottom of the row
      private static const BAR_H:int = 22;
      private static const BAR_Y:int = ROW_H - 8 - BAR_H;

      // Yellow Speed Up button, right-aligned and vertically centred on the bar
      private static const BTN_W:int = 140;
      private static const BTN_H:int = 32;
      private static const BTN_GAP:int = 13;

      public function PowerUpsTab()
      {
         super();
      }

      /**
       * @returns {Array} The power-up rows. Cooldown strings are mock values
       * until the server-side power-up state is wired up.
       */
      private function _powerUpData():Array
      {
         return [
               {icon: "alliances/ap_armament_icon.jpg", nameKey: "ap_armament_name", descKey: "ap_armament_description", cooldown: "11days 23hrs 42mins", progress: 0.6},
               {icon: "alliances/ap_conquest_icon.jpg", nameKey: "ap_conquest_name", descKey: "ap_conquest_description", cooldown: "13days 23hrs 42mins", progress: 0.45},
               {icon: "alliances/ap_declarewar_icon.jpg", nameKey: "ap_declarewar_name", descKey: "ap_declarewar_description", cooldown: "27days 23hrs 42mins", progress: 0.18}
            ];
      }

      override public function build():void
      {
         var data:Array = _powerUpData();
         var panelH:int = ROW_H * data.length;

         // White rounded panel with a gray border
         var panel:MovieClip = addChild(new MovieClip()) as MovieClip;
         panel.mouseEnabled = false;
         panel.graphics.beginFill(0xFFFFFF, 1);
         panel.graphics.lineStyle(1, 0x333333, 1);
         panel.graphics.drawRect(0, 0, PANEL_W, panelH);
         panel.graphics.endFill();
         panel.x = PANEL_X;
         panel.y = PANEL_Y;

         var container:MovieClip = addChild(new MovieClip()) as MovieClip;
         container.x = PANEL_X;
         container.y = PANEL_Y;

         for (var i:int = 0; i < data.length; i++)
         {
            // Row separator above every row except the first — full width,
            // matching the 1px light-black border used elsewhere
            if (i > 0)
            {
               container.graphics.lineStyle(1, 0x333333, 1);
               container.graphics.moveTo(0, i * ROW_H);
               container.graphics.lineTo(PANEL_W, i * ROW_H);
            }
            _buildRow(container, i, data[i]);
         }
      }

      /**
       * Renders one power-up row into the container at the given index.
       * @param {MovieClip} container - Panel container to draw into
       * @param {int} index - Zero-based row index (drives the vertical offset)
       * @param {Object} data - Row data ({ icon, nameKey, descKey, cooldown })
       */
      private function _buildRow(container:MovieClip, index:int, data:Object):void
      {
         const rowY:int = index * ROW_H;
         const btnX:int = PANEL_W - ROW_PAD - BTN_W;
         const barX:int = TEXT_X;
         const barW:int = btnX - BTN_GAP - barX;

         // Icon (left), vertically centred in the row
         var iconMC:MovieClip = container.addChild(new MovieClip()) as MovieClip;
         iconMC.mouseEnabled = false;
         iconMC.x = ROW_PAD;
         iconMC.y = rowY + int((ROW_H - ICON_SIZE) / 2);
         _loadIcon(iconMC, String(data.icon), ICON_SIZE);

         // Title
         var tTitle:TextField = container.addChild(new TextField()) as TextField;
         tTitle.selectable = false;
         tTitle.mouseEnabled = false;
         tTitle.width = barW;
         tTitle.height = 20;
         tTitle.x = TEXT_X;
         tTitle.y = rowY + TITLE_Y;
         tTitle.defaultTextFormat = new TextFormat("Verdana", 13, 0x000000, true);
         tTitle.text = KEYS.Get(String(data.nameKey));

         // Description (wrapped, up to two lines)
         var tDesc:TextField = container.addChild(new TextField()) as TextField;
         tDesc.selectable = false;
         tDesc.mouseEnabled = false;
         tDesc.wordWrap = true;
         tDesc.multiline = true;
         tDesc.width = barW;
         tDesc.height = DESC_H;
         tDesc.x = TEXT_X;
         tDesc.y = rowY + DESC_Y;
         tDesc.defaultTextFormat = new TextFormat("Verdana", 13, 0x333333);
         tDesc.text = KEYS.Get(String(data.descKey));

         // Cooldown bar (gray) with centred charging text
         var bar:MovieClip = container.addChild(new MovieClip()) as MovieClip;
         bar.mouseEnabled = false;
         bar.graphics.beginFill(0x999999, 1);
         bar.graphics.lineStyle(1, 0x000000, 1);
         bar.graphics.drawRect(0, 0, barW, BAR_H);
         bar.graphics.endFill();
         bar.x = barX;
         bar.y = rowY + BAR_Y;

         // Turquoise progress fill over the gray track, inset 1px so the bar's
         // border stays visible
         var progress:Number = Math.max(0, Math.min(1, Number(data.progress)));
         var fillW:int = int((barW - 2) * progress);
         if (fillW > 0)
         {
            var barFill:MovieClip = container.addChild(new MovieClip()) as MovieClip;
            barFill.mouseEnabled = false;
            barFill.graphics.beginFill(0x40E0D0, 1);
            barFill.graphics.drawRect(0, 0, fillW, BAR_H - 2);
            barFill.graphics.endFill();
            barFill.x = barX + 1;
            barFill.y = rowY + BAR_Y + 1;
         }

         var tBar:TextField = container.addChild(new TextField()) as TextField;
         tBar.selectable = false;
         tBar.mouseEnabled = false;
         tBar.width = barW;
         tBar.height = 18;
         tBar.x = barX;
         tBar.y = rowY + BAR_Y + 1;
         var barFmt:TextFormat = new TextFormat("Verdana", 12, 0x000000, true);
         barFmt.align = TextFormatAlign.CENTER;
         tBar.defaultTextFormat = barFmt;
         tBar.text = KEYS.Get("powerup_ready_in") + " " + String(data.cooldown);

         // Yellow Speed Up button, bottom-aligned with the bar so it keeps the
         // same padding from the row bottom that the bar has
         var btn:MovieClip = _makeSpeedUpButton(KEYS.Get("button_speed_up"));
         btn.x = btnX;
         btn.y = rowY + BAR_Y + BAR_H - BTN_H;
         container.addChild(btn);
         btn.addEventListener(MouseEvent.CLICK, _makeSpeedUpHandler(data));
      }

      /**
       * Loads a power-up icon into a container via ImageCache, scaled to fit size.
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

      /**
       * Builds a click handler for a row's Speed Up button. Stubbed for now.
       * @param {Object} data - The power-up row the button belongs to
       * @returns {Function} MouseEvent handler
       */
      private function _makeSpeedUpHandler(data:Object):Function
      {
         return function(e:MouseEvent):void
         {
            SOUNDS.Play("click1");
            // TODO: open the Speed Up / reduce-cooldown flow for this power-up
         };
      }

      /**
       * Creates a yellow Speed Up button with a hover state, mirroring the
       * custom-drawn buttons used elsewhere in the alliance UI.
       * @param {String} label - Button text
       * @returns {MovieClip} The button clip
       */
      private function _makeSpeedUpButton(label:String):MovieClip
      {
         var mc:MovieClip = new MovieClip();
         mc.buttonMode = true;
         mc.mouseChildren = false;

         _drawSpeedUpBg(mc, false);

         var tf:TextField = mc.addChild(new TextField()) as TextField;
         tf.selectable = false;
         tf.mouseEnabled = false;
         tf.width = BTN_W;
         tf.height = 18;
         tf.x = 0;
         tf.y = int((BTN_H - 16) / 2);
         var fmt:TextFormat = new TextFormat("Verdana", 10, 0x4A3A00, true);
         fmt.align = TextFormatAlign.CENTER;
         tf.defaultTextFormat = fmt;
         tf.text = label;

         mc.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void
            {
               _drawSpeedUpBg(mc, true);
            });
         mc.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void
            {
               _drawSpeedUpBg(mc, false);
            });

         return mc;
      }

      /**
       * Draws (or redraws) the yellow button background in its normal or hover
       * state, preserving the text child.
       * @param {MovieClip} mc - The button clip
       * @param {Boolean} hover - Whether to draw the hover (lighter) state
       */
      private function _drawSpeedUpBg(mc:MovieClip, hover:Boolean):void
      {
         mc.graphics.clear();
         mc.graphics.lineStyle(1, 0x8A6D00, 1);
         var mtx:Matrix = new Matrix();
         mtx.createGradientBox(BTN_W, BTN_H, Math.PI / 2, 0, 0);
         // Top color at ratio 0, bottom color at ratio 255 (vertical axis)
         if (hover)
         {
            mc.graphics.beginGradientFill(GradientType.LINEAR, [0xFCFAC8, 0xF6F082], [1, 1], [0, 255], mtx);
         }
         else
         {
            mc.graphics.beginGradientFill(GradientType.LINEAR, [0xF7F5A3, 0xE6D63C], [1, 1], [0, 255], mtx);
         }
         mc.graphics.drawRoundRect(0, 0, BTN_W, BTN_H, 5, 5);
         mc.graphics.endFill();
      }
   }
}
