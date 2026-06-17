package com.monsters.alliances.tabs
{
   import com.monsters.alliances.AllianceConstants;
   import com.monsters.alliances.tabs.AllianceRelationPopup;
   import flash.display.GradientType;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;

   public class BrowseActionPopup extends MovieClip
   {
      // Larger than the original #actionsBox (103×25 / 9px) for readability in
      // the Flash client; colours/border/radius still match the original.
      public static const POPUP_W:int = 150;
      private static const BTN_W:int = 134;
      private static const BTN_H:int = 32;
      private static const BTN_FONT_SIZE:int = 12;
      private static const PAD:int = 8;
      private static const BTN_GAP:int = 6;
      private static const ICON_ROW_GAP:int = 8;
      // Swatch size matches the larger (readable) popup; colours match the
      // original foe/neutral/ally relationship colours below.
      private static const ICON_W:int = 37;
      private static const ICON_H:int = 35;
      private static const ICON_GAP:int = 8;
      // Foe / Neutral / Ally — original relationship colours
      private static const RELATION_COLORS:Array = [
            AllianceConstants.REL_HOSTILE,
            AllianceConstants.REL_NEUTRAL,
            AllianceConstants.REL_FRIENDLY
         ];
      private static const RELATION_KEYS:Array = [
            "alliance_relation_foe",
            "alliance_relation_neutral",
            "alliance_relation_ally"
         ];

      // Pre-computed so BrowseTab can use it for clamping popup position
      public static const POPUP_H:int =
         PAD + BTN_H + BTN_GAP + BTN_H + ICON_ROW_GAP + ICON_H + PAD;

      private var _rowData:Object;
      private var _dismiss:Function;

      /**
       * @param {Object} rowData - Alliance row data for this popup's row
       * @param {Function} dismiss - Callback supplied by BrowseTab to clean up popup state
       */
      public function BrowseActionPopup(rowData:Object, dismiss:Function)
      {
         super();
         _rowData = rowData;
         _dismiss = dismiss;
         _build();
      }

      private function _build():void
      {
         var bg:MovieClip = addChild(new MovieClip()) as MovieClip;
         bg.mouseEnabled = false;
         bg.graphics.lineStyle(1, AllianceConstants.CELL_BORDER, 1);
         bg.graphics.beginFill(AllianceConstants.ACTION_BG, 1);
         bg.graphics.drawRoundRect(0, 0, POPUP_W, POPUP_H, 3, 3);
         bg.graphics.endFill();

         const btnX:int = int((POPUP_W - BTN_W) / 2);

         var visitBtn:MovieClip = _makeBtn(KEYS.Get("alliance_btn_visit_leader"));
         visitBtn.x = btnX;
         visitBtn.y = PAD;
         visitBtn.addEventListener(MouseEvent.CLICK, _onVisitLeader);

         var joinBtn:MovieClip = _makeBtn(KEYS.Get("alliance_btn_request_join"));
         joinBtn.x = btnX;
         joinBtn.y = PAD + BTN_H + BTN_GAP;
         joinBtn.addEventListener(MouseEvent.CLICK, _onRequestJoin);

         const iconsY:int = PAD + BTN_H + BTN_GAP + BTN_H + ICON_ROW_GAP;
         const startX:int = PAD;

         var ci:int = 0;
         while (ci < RELATION_COLORS.length)
         {
            var box:MovieClip = addChild(new MovieClip()) as MovieClip;
            box.buttonMode = true;
            box.mouseChildren = false;
            box.graphics.lineStyle(1, AllianceConstants.CELL_BORDER, 1);
            box.graphics.beginFill(uint(RELATION_COLORS[ci]), 1);
            box.graphics.drawRect(0, 0, ICON_W, ICON_H);
            box.graphics.endFill();
            box.x = startX + ci * (ICON_W + ICON_GAP);
            box.y = iconsY;
            box.addEventListener(MouseEvent.CLICK, _makeRelationHandler(ci));
            ci++;
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

      private function _makeRelationHandler(idx:int):Function
      {
         return function(e:MouseEvent):void
         {
            SOUNDS.Play("click1");
            var name:String = (_rowData && _rowData.name) ? String(_rowData.name) : "";
            var body:String = KEYS.Get(String(RELATION_KEYS[idx]), {"v1": name});
            _dismiss();
            new AllianceRelationPopup().Show(KEYS.Get("alliance_relation_title"), body);
         };
      }

      private function _onVisitLeader(e:MouseEvent):void
      {
         SOUNDS.Play("click1");
         // TODO: navigate to leader's base
         _dismiss();
      }

      private function _onRequestJoin(e:MouseEvent):void
      {
         SOUNDS.Play("click1");
         _dismiss();
         // TODO: send join request to server, then show this on the success response
         new AllianceRelationPopup().Show(
               KEYS.Get("alliance_join_request_title"),
               KEYS.Get("alliance_join_request_body")
            );
      }
   }
}
