package com.monsters.alliances.tabs
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;

   public class AllianceRelationPopup
   {
      private static const BG_W:int = 500;
      private static const PAD_H:int = 28;
      private static const PAD_TOP:int = 29;
      private static const PAD_BTN:int = 71;
      private static const TITLE_SIZE:int = 24;
      private static const BODY_SIZE:int = 15;
      private static const TITLE_GAP:int = 11;
      private static const CONTENT_W:int = BG_W - PAD_H * 2;

      private var _mc:MovieClip;

      public function Show(title:String, body:String):void
      {
         _mc = new MovieClip();

         var tBody:TextField = new TextField();
         tBody.wordWrap = true;
         tBody.multiline = true;
         tBody.width = CONTENT_W;
         var bodyFmt:TextFormat = new TextFormat("Verdana", BODY_SIZE, 0x000000);
         bodyFmt.align = TextFormatAlign.CENTER;
         tBody.defaultTextFormat = bodyFmt;
         tBody.htmlText = body;

         const titleH:int = TITLE_SIZE + 8;
         const bodyH:int = int(tBody.textHeight) + 6;
         const totalH:int = PAD_TOP + titleH + TITLE_GAP + bodyH + PAD_BTN + 16;
         const frameX:int = -int(BG_W * 0.5);
         const frameY:int = -int(totalH * 0.5);
         const contentX:int = frameX + PAD_H;

         var frame:frame_CLIP = _mc.addChild(new frame_CLIP()) as frame_CLIP;
         frame.width = BG_W;
         frame.height = totalH;
         frame.x = frameX;
         frame.y = frameY;
         frame.Setup(true, _onOk);

         var tTitle:TextField = _mc.addChild(new TextField()) as TextField;
         tTitle.selectable = false;
         tTitle.mouseEnabled = false;
         tTitle.embedFonts = true;
         tTitle.antiAliasType = AntiAliasType.NORMAL;
         tTitle.width = CONTENT_W;
         tTitle.height = titleH;
         var titleFmt:TextFormat = new TextFormat("Groboldov", TITLE_SIZE, 0xFFFFFF);
         titleFmt.align = TextFormatAlign.CENTER;
         tTitle.defaultTextFormat = titleFmt;
         tTitle.text = title;
         tTitle.filters = [new GlowFilter(0, 1, 3, 3, 9, 2), new DropShadowFilter(2, 45, 0, 0.55, 3, 3, 1, 2)];
         tTitle.x = contentX;
         tTitle.y = frameY + PAD_TOP;

         tBody.selectable = false;
         tBody.mouseEnabled = false;
         _mc.addChild(tBody);
         tBody.x = contentX;
         tBody.y = tTitle.y + titleH + TITLE_GAP;

         var btn:Button_CLIP = _mc.addChild(new Button_CLIP()) as Button_CLIP;
         btn.Setup(KEYS.Get("alliance_btn_ok"), false, 140, 36);
         btn.x = -int(btn.width * 0.5);
         btn.y = frameY + totalH - PAD_BTN;
         btn.addEventListener(MouseEvent.CLICK, _onOk);

         GLOBAL.BlockerAdd(GLOBAL._layerTop);
         GLOBAL._layerTop.addChild(_mc);
         POPUPSETTINGS.AlignToCenter(_mc);
         POPUPSETTINGS.ScaleUp(_mc);
      }

      private function _onOk(e:MouseEvent = null):void
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
