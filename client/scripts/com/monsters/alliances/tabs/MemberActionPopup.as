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
    * BrowseActionPopup styling but holds a single action button whose label and
    * behaviour are supplied by the calling tab (e.g. "Kick" for Members,
    * "Invite" for Suggested).
    */
   public class MemberActionPopup extends MovieClip
   {
      public static const POPUP_W:int = 150;
      private static const BTN_W:int = 134;
      private static const BTN_H:int = 32;
      private static const BTN_FONT_SIZE:int = 12;
      private static const PAD:int = 8;

      // Pre-computed so the tab can clamp the popup's on-screen position
      public static const POPUP_H:int = PAD + BTN_H + PAD;

      private var _rowData:Object;
      private var _dismiss:Function;
      private var _labelKey:String;
      private var _onAction:Function;

      /**
       * @param {Object} rowData - The row this popup acts on
       * @param {Function} dismiss - Callback supplied by the tab to clean up popup state
       * @param {String} labelKey - KEYS key for the button label
       * @param {Function} onAction - Invoked with rowData when the button is clicked
       */
      public function MemberActionPopup(rowData:Object, dismiss:Function, labelKey:String, onAction:Function)
      {
         super();
         _rowData = rowData;
         _dismiss = dismiss;
         _labelKey = labelKey;
         _onAction = onAction;
         _build();
      }

      private function _build():void
      {
         var bg:MovieClip = addChild(new MovieClip()) as MovieClip;
         bg.mouseEnabled = false;
         bg.graphics.lineStyle(1, 0x333333, 1);
         bg.graphics.beginFill(0xAE8254, 1);
         bg.graphics.drawRoundRect(0, 0, POPUP_W, POPUP_H, 8, 8);
         bg.graphics.endFill();

         var btn:MovieClip = _makeBtn(KEYS.Get(_labelKey));
         btn.x = int((POPUP_W - BTN_W) / 2);
         btn.y = PAD;
         btn.addEventListener(MouseEvent.CLICK, _onClick);
      }

      private function _onClick(e:MouseEvent):void
      {
         SOUNDS.Play("click1");
         _dismiss();
         if (_onAction != null)
         {
            _onAction(_rowData);
         }
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
