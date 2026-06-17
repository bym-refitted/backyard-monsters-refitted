package com.monsters.alliances.tabs
{
   import flash.display.GradientType;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;

   /**
    * Compact action popup for a member/suggested row. Mirrors the brown
    * BrowseActionPopup styling and stacks one or more action buttons supplied by
    * the calling tab (e.g. Visit Base / Kick / Promote for Members, Invite for
    * Suggested). Each action is an object { labelKey:String, handler:Function };
    * the handler is invoked with rowData when its button is clicked.
    */
   public class MemberActionPopup extends MovieClip
   {
      public static const POPUP_W:int = 150;
      private static const BTN_W:int = 134;
      private static const BTN_H:int = 32;
      private static const BTN_GAP:int = 6;
      private static const BTN_FONT_SIZE:int = 12;
      private static const PAD:int = 8;

      private var _rowData:Object;
      private var _dismiss:Function;
      private var _actions:Array;

      /**
       * @param {Object} rowData - The row this popup acts on
       * @param {Function} dismiss - Callback supplied by the tab to clean up popup state
       * @param {Array} actions - Ordered list of { labelKey:String, handler:Function },
       * rendered top-to-bottom. Each handler is invoked with rowData on click.
       */
      public function MemberActionPopup(rowData:Object, dismiss:Function, actions:Array)
      {
         super();
         _rowData = rowData;
         _dismiss = dismiss;
         _actions = actions;
         _build();
      }

      /**
       * Total popup height for a given number of stacked buttons. Lets the
       * calling tab clamp the popup's on-screen position before it is built.
       * @param {int} count - Number of action buttons
       * @returns {int} Popup height in pixels
       */
      public static function heightFor(count:int):int
      {
         return PAD + count * BTN_H + Math.max(0, count - 1) * BTN_GAP + PAD;
      }

      private function _build():void
      {
         var popupH:int = heightFor(_actions.length);

         var bg:MovieClip = addChild(new MovieClip()) as MovieClip;
         bg.mouseEnabled = false;
         bg.graphics.lineStyle(1, 0x333333, 1);
         bg.graphics.beginFill(0xAE8254, 1);
         bg.graphics.drawRoundRect(0, 0, POPUP_W, popupH, 8, 8);
         bg.graphics.endFill();

         for (var i:int = 0; i < _actions.length; i++)
         {
            var action:Object = _actions[i];
            var btn:MovieClip = _makeBtn(KEYS.Get(String(action.labelKey)));
            btn.x = int((POPUP_W - BTN_W) / 2);
            btn.y = PAD + i * (BTN_H + BTN_GAP);
            btn.addEventListener(MouseEvent.CLICK, _makeClickHandler(action.handler));
         }
      }

      /**
       * Builds a click handler that dismisses the popup, then fires the action's
       * handler with this popup's rowData.
       * @param {Function} handler - The action handler to invoke
       * @returns {Function} MouseEvent handler
       */
      private function _makeClickHandler(handler:Function):Function
      {
         return function(e:MouseEvent):void
         {
            SOUNDS.Play("click1");
            _dismiss();
            if (handler != null)
            {
               handler(_rowData);
            }
         };
      }

      private function _makeBtn(label:String):MovieClip
      {
         var mc:MovieClip = addChild(new MovieClip()) as MovieClip;
         mc.buttonMode = true;
         mc.mouseChildren = false;

         _drawBtnBg(mc, false);

         var tf:TextField = mc.addChild(new TextField()) as TextField;
         tf.selectable = false;
         tf.mouseEnabled = false;
         tf.width = BTN_W;
         tf.height = 18;
         tf.x = 0;
         tf.y = int((BTN_H - 16) / 2);
         var fmt:TextFormat = new TextFormat("Verdana", BTN_FONT_SIZE, 0x333333, true);
         fmt.align = TextFormatAlign.CENTER;
         tf.defaultTextFormat = fmt;
         tf.text = label;

         mc.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void
            {
               _drawBtnBg(mc, true);
            });
         mc.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void
            {
               _drawBtnBg(mc, false);
            });

         return mc;
      }

      private function _drawBtnBg(mc:MovieClip, hover:Boolean):void
      {
         mc.graphics.clear();
         mc.graphics.lineStyle(1, 0x888888, 1);
         if (hover)
         {
            mc.graphics.beginFill(0xF5F5F5, 1);
         }
         else
         {
            var mtx:Matrix = new Matrix();
            mtx.createGradientBox(BTN_W, BTN_H, Math.PI / 2, 0, 0);
            mc.graphics.beginGradientFill(GradientType.LINEAR, [0xF4F5F2, 0xD9D9D9], [1, 1], [0, 255], mtx);
         }
         mc.graphics.drawRoundRect(0, 0, BTN_W, BTN_H, 6, 6);
         mc.graphics.endFill();
      }
   }
}
