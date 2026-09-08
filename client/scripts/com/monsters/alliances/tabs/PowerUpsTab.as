package com.monsters.alliances.tabs
{
   import com.monsters.alliances.ALLIANCES;
   import com.monsters.alliances.AllianceConstants;
   import com.monsters.alliances.AllianceTabBase;
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;

   /**
    * Alliance Power-Ups tab. Lists the alliance power-ups (Armament, Conquest,
    * Declare War) as stacked rows inside a single white panel. Each row shows the
    * power-up icon, its name and description, a progress bar, and an action.
    *
    * A row is in one of three states, matching the original:
    *
    *   Active   - green bar draining over the run, no action
    *   Ready    - full bar, Activate (leader only)
    *   Charging - cyan bar filling, Speed Up (any member)
    *
    * The bar is redrawn locally every second so the countdown reads true. There
    * is no interval poll: the original needed one because its rows persisted
    * across tab switches and went stale, whereas ALLIANCEPOPUP rebuilds this tab
    * from scratch every time it is opened, so opening it is the refresh.
    */
   public class PowerUpsTab extends AllianceTabBase
   {
      // Mirrors the base class's instance CONTENT_W as a class const so the
      // static layout constants can reference it; must be declared first as AS3
      // evaluates static initializers in textual order.
      private static const CONTENT_W_C:int = AllianceConstants.CONTENT_W;

      private static const PAD:int = 14;

      private static const PANEL_X:int = PAD;
      private static const PANEL_Y:int = PAD;
      private static const PANEL_W:int = CONTENT_W_C - PAD * 2;

      private static const ROW_H:int = 104;
      private static const ROW_PAD:int = 8;

      private static const ICON_SIZE:int = 88;

      private static const TEXT_X:int = ROW_PAD + ICON_SIZE + 12;
      private static const TITLE_Y:int = 4;
      private static const DESC_Y:int = 24;
      private static const DESC_H:int = 36;

      private static const BAR_H:int = 22;
      private static const BAR_Y:int = ROW_H - 8 - BAR_H;

      private static const BTN_W:int = 140;
      private static const BTN_H:int = 32;
      private static const BTN_GAP:int = 13;

      private static const BAR_CHARGING:uint = 0x00FDFC;
      private static const BAR_ACTIVE:uint = 0x13DD05;

      private static const STATE_ACTIVE:String = "active";
      private static const STATE_READY:String = "ready";
      private static const STATE_CHARGING:String = "charging";

      private var _data:Array;
      private var _rows:Array = [];
      private var _timer:Timer;

      public function PowerUpsTab()
      {
         super();
         addEventListener(Event.REMOVED_FROM_STAGE, _onRemoved);
      }

      override public function build():void
      {
         _fetch();
      }

      /**
       * Pulls the alliance's power-ups and repaints. Runs on open, and again
       * whenever a run ends - the server is what decides when the next charge
       * lands, so the tab cannot derive that transition on its own.
       */
      private function _fetch():void
      {
         ALLIANCES.LoadPowerups(function(rows:Array):void
            {
               if (rows == null) return;
               _data = rows;
               _render();
               _startTimer();
            });
      }

      private function _startTimer():void
      {
         if (_timer != null) return;
         _timer = new Timer(1000);
         _timer.addEventListener(TimerEvent.TIMER, _onTick);
         _timer.start();
      }

      private function _onRemoved(e:Event):void
      {
         if (_timer == null) return;
         _timer.removeEventListener(TimerEvent.TIMER, _onTick);
         _timer.stop();
         _timer = null;
      }

      /**
       * Repaints each row's bar from the clock, and rebuilds a row's action only
       * when its state actually changes - the buttons are the expensive part and
       * a charge crossing zero is the only thing that moves them.
       */
      private function _onTick(e:TimerEvent):void
      {
         for each (var row:Object in _rows)
         {
            if (row.data.active && int(row.data.endTime) - GLOBAL.Timestamp() <= 0)
            {
               _fetch();
               return;
            }

            var state:String = _stateOf(row.data);
            _paintBar(row, state);
            if (state != row.state)
            {
               row.state = state;
               _buildAction(row);
            }
         }
      }

      private function _stateOf(data:Object):String
      {
         if (data.active) return STATE_ACTIVE;
         return (int(data.endTime) - GLOBAL.Timestamp() <= 0) ? STATE_READY : STATE_CHARGING;
      }

      private function _render():void
      {
         while (numChildren > 0)
         {
            removeChildAt(0);
         }
         _rows = [];

         var panelH:int = ROW_H * _data.length;

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

         for (var i:int = 0; i < _data.length; i++)
         {
            if (i > 0)
            {
               container.graphics.lineStyle(1, 0x333333, 1);
               container.graphics.moveTo(0, i * ROW_H);
               container.graphics.lineTo(PANEL_W, i * ROW_H);
            }
            _buildRow(container, i, _data[i]);
         }
      }

      /**
       * Renders one power-up row and records the pieces the tick updates.
       *
       * @param {MovieClip} container - Panel container to draw into
       * @param {int} index - Zero-based row index (drives the vertical offset)
       * @param {Object} data - One getpowerups row
       */
      private function _buildRow(container:MovieClip, index:int, data:Object):void
      {
         const rowY:int = index * ROW_H;
         const btnX:int = PANEL_W - ROW_PAD - BTN_W;
         const barX:int = TEXT_X;
         const barW:int = btnX - BTN_GAP - barX;
         const type:String = String(data.type);

         var iconMC:MovieClip = container.addChild(new MovieClip()) as MovieClip;
         iconMC.mouseEnabled = false;
         iconMC.x = ROW_PAD;
         iconMC.y = rowY + int((ROW_H - ICON_SIZE) / 2);
         _loadIcon(iconMC, "alliances/" + type + "_icon.jpg", ICON_SIZE);

         var tTitle:TextField = container.addChild(new TextField()) as TextField;
         tTitle.selectable = false;
         tTitle.mouseEnabled = false;
         tTitle.width = barW;
         tTitle.height = 20;
         tTitle.x = TEXT_X;
         tTitle.y = rowY + TITLE_Y;
         tTitle.defaultTextFormat = new TextFormat("Verdana", 13, 0x000000, true);
         tTitle.text = KEYS.Get(type + "_name");

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
         tDesc.text = KEYS.Get(type + "_description");

         var bar:MovieClip = container.addChild(new MovieClip()) as MovieClip;
         bar.mouseEnabled = false;
         bar.graphics.beginFill(0x999999, 1);
         bar.graphics.lineStyle(1, 0x000000, 1);
         bar.graphics.drawRect(0, 0, barW, BAR_H);
         bar.graphics.endFill();
         bar.x = barX;
         bar.y = rowY + BAR_Y;

         var barFill:MovieClip = container.addChild(new MovieClip()) as MovieClip;
         barFill.mouseEnabled = false;
         barFill.x = barX + 1;
         barFill.y = rowY + BAR_Y + 1;

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

         var actionMC:MovieClip = container.addChild(new MovieClip()) as MovieClip;
         actionMC.x = btnX;
         actionMC.y = rowY + BAR_Y + BAR_H - BTN_H;

         var row:Object = {
               data: data,
               barFill: barFill,
               barW: barW,
               tBar: tBar,
               actionMC: actionMC,
               state: null
            };
         _rows.push(row);

         row.state = _stateOf(data);
         _paintBar(row, row.state);
         _buildAction(row);
      }

      /**
       * Draws the fill and caption for one row's bar.
       *
       * Charging fills as the wait shortens; an active power-up drains as its run
       * is spent, which is why the two use opposite fractions.
       *
       * @param {Object} row - Row record built by _buildRow
       * @param {String} state - One of the STATE_* constants
       */
      private function _paintBar(row:Object, state:String):void
      {
         const data:Object = row.data;
         const remaining:int = int(data.endTime) - GLOBAL.Timestamp();

         var fraction:Number;
         var colour:uint;
         var caption:String;

         if (state == STATE_ACTIVE)
         {
            fraction = Number(remaining) / Number(data.total_running_time);
            colour = BAR_ACTIVE;
            caption = KEYS.Get("powerup_active") + " " + _formatTime(remaining) + " " + KEYS.Get("powerup_remaining");
         }
         else if (state == STATE_READY)
         {
            fraction = 1;
            colour = BAR_CHARGING;
            caption = KEYS.Get("powerup_ready");
         }
         else
         {
            fraction = (Number(data.total_recharge_time) - Number(remaining)) / Number(data.total_recharge_time);
            colour = BAR_CHARGING;
            caption = KEYS.Get("powerup_ready_in") + " " + _formatTime(remaining);
         }

         if (fraction < 0) fraction = 0;
         if (fraction > 1) fraction = 1;

         var fillW:int = int((int(row.barW) - 2) * fraction);

         row.barFill.graphics.clear();
         if (fillW > 0)
         {
            row.barFill.graphics.beginFill(colour, 1);
            row.barFill.graphics.drawRect(0, 0, fillW, BAR_H - 2);
            row.barFill.graphics.endFill();
         }

         row.tBar.text = caption;
      }

      /**
       * Rebuilds a row's action for its current state: nothing while active,
       * Activate once charged, Speed Up while charging.
       *
       * A member sees the Activate button greyed rather than hidden, carrying the
       * reason on click - the original's treatment for this one action.
       *
       * @param {Object} row - Row record built by _buildRow
       */
      private function _buildAction(row:Object):void
      {
         var actionMC:MovieClip = row.actionMC as MovieClip;
         while (actionMC.numChildren > 0)
         {
            actionMC.removeChildAt(0);
         }

         if (row.state == STATE_ACTIVE) return;

         if (row.state == STATE_CHARGING)
         {
            var speedBtn:Button_CLIP = actionMC.addChild(new Button_CLIP()) as Button_CLIP;
            speedBtn.Setup(KEYS.Get("button_speed_up"), false, BTN_W, BTN_H);
            speedBtn.Highlight = true;
            speedBtn.addEventListener(MouseEvent.CLICK, _makeSpeedUpHandler(row.data));
            return;
         }

         var activateBtn:Button_CLIP = actionMC.addChild(new Button_CLIP()) as Button_CLIP;
         activateBtn.Setup(KEYS.Get("button_activate"), false, BTN_W, BTN_H);

         if (ALLIANCES._isLeader)
         {
            activateBtn.Highlight = true;
            activateBtn.addEventListener(MouseEvent.CLICK, _makeActivateHandler(row.data));
            return;
         }

         activateBtn.Enabled = false;

         var blocker:MovieClip = actionMC.addChild(new MovieClip()) as MovieClip;
         blocker.buttonMode = true;
         blocker.graphics.beginFill(0xFFFFFF, 0);
         blocker.graphics.drawRect(0, 0, BTN_W, BTN_H);
         blocker.graphics.endFill();
         blocker.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
            {
               SOUNDS.Play("click1");
               GLOBAL.Message(KEYS.Get("alliance_err_powerup_leader_only"));
            });
      }

      /**
       * Formats a duration the way the original's progress bar did - days, hours
       * and minutes, with minutes rounded up and held below a full hour.
       *
       * @param {int} seconds - Seconds remaining; negatives read as zero.
       * @returns {String} e.g. "11days 23hrs 42mins"
       */
      private function _formatTime(seconds:int):String
      {
         var left:int = seconds > 0 ? seconds : 0;

         var days:int = int(left / 86400);
         left -= days * 86400;

         var hrs:int = int(left / 3600);
         left -= hrs * 3600;

         var mins:int = Math.ceil(left / 60);
         if (mins >= 60) mins = 59;

         var out:String = "";
         if (days > 0) out += days + (days == 1 ? "day" : "days");
         if (days > 0 || hrs > 0) out += (out.length > 0 ? " " : "") + hrs + (hrs == 1 ? "hr" : "hrs");
         out += (out.length > 0 ? " " : "") + mins + (mins == 1 ? "min" : "mins");

         return out;
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
       * Builds a click handler for a row's Speed Up button - opens the
       * reduce-cooldown dialog for that power-up.
       * @param {Object} data - The getpowerups row the button belongs to
       * @returns {Function} MouseEvent handler
       */
      private function _makeSpeedUpHandler(data:Object):Function
      {
         return function(e:MouseEvent):void
         {
            SOUNDS.Play("click1");
            var remaining:int = int(data.endTime) - GLOBAL.Timestamp();
            new SpeedUpPopup().Show({
                  nameKey: String(data.type) + "_name",
                  icon: "alliances/" + String(data.type) + "_icon.jpg",
                  hourlyCost: int(data.hourly_cost),
                  remainingHrs: Math.ceil(remaining / 3600)
               });
         };
      }

      /**
       * Builds a click handler for a row's Activate button. The server answers
       * with the refreshed rows, so a success repaints from those rather than
       * costing a second request.
       * @param {Object} data - The getpowerups row the button belongs to
       * @returns {Function} MouseEvent handler
       */
      private function _makeActivateHandler(data:Object):Function
      {
         return function(e:MouseEvent):void
         {
            SOUNDS.Play("click1");
            PLEASEWAIT.Show(KEYS.Get("msg_loading"));

            ALLIANCES.ActivatePowerup(int(data.powerup_id), function(response:Object):void
               {
                  PLEASEWAIT.Hide();

                  if (response == null || response.error)
                  {
                     GLOBAL.Message((response && response.error)
                        ? String(response.error)
                        : KEYS.Get("alliance_err_generic"));
                     return;
                  }

                  if (response.powerups != null)
                  {
                     _data = response.powerups as Array;
                     _render();
                  }
               });
         };
      }
   }
}
