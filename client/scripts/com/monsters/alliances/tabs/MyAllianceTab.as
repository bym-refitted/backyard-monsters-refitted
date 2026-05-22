package com.monsters.alliances.tabs
{
   import com.monsters.alliances.AllianceTabBase;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import com.monsters.alliances.ALLIANCES;

   public class MyAllianceTab extends AllianceTabBase
   {
      private static const TITLE_SIZE:int = 24;
      private static const BODY_SIZE:int = 15;
      private static const CONTENT_W_INNER:int = 500;
      private static const BTN_W:int = 200;
      private static const BTN_H:int = 36;
      private static const PAD_TOP:int = 24;
      private static const TITLE_GAP:int = 14;
      private static const BTN_GAP:int = 24;

      public function MyAllianceTab()
      {
         super();
      }

      override public function build():void
      {
         if (ALLIANCES._myAlliance)
         {
            return;
         }

         const titleH:int = TITLE_SIZE + 8;
         const innerX:int = int((CONTENT_W - CONTENT_W_INNER) / 2);

         // Measure body height before layout so we can vertically center the block
         var tBody:TextField = new TextField();
         tBody.wordWrap = true;
         tBody.multiline = true;
         tBody.selectable = false;
         tBody.mouseEnabled = false;
         tBody.width = CONTENT_W_INNER;
         var bodyFmt:TextFormat = new TextFormat("Verdana", BODY_SIZE, 0x333333);
         bodyFmt.align = TextFormatAlign.CENTER;
         tBody.defaultTextFormat = bodyFmt;
         tBody.text = KEYS.Get("alliance_no_alliance_desc");
         tBody.height = int(tBody.textHeight) + 6;

         const startY:int = PAD_TOP;

         var tTitle:TextField = addChild(new TextField()) as TextField;
         tTitle.selectable = false;
         tTitle.mouseEnabled = false;
         tTitle.embedFonts = true;
         tTitle.antiAliasType = AntiAliasType.NORMAL;
         tTitle.width = CONTENT_W_INNER;
         tTitle.height = titleH;
         var titleFmt:TextFormat = new TextFormat("Groboldov", TITLE_SIZE, 0xFFFFFF);
         titleFmt.align = TextFormatAlign.CENTER;
         tTitle.defaultTextFormat = titleFmt;
         tTitle.text = KEYS.Get("alliance_no_alliance_title");
         tTitle.filters = [new GlowFilter(0, 1, 3, 3, 9, 2), new DropShadowFilter(2, 45, 0, 0.55, 3, 3, 1, 2)];
         tTitle.x = innerX;
         tTitle.y = startY;

         tBody.x = innerX;
         tBody.y = startY + titleH + TITLE_GAP;
         addChild(tBody);

         var btn:Button_CLIP = addChild(new Button_CLIP()) as Button_CLIP;
         btn.Setup(KEYS.Get("alliance_no_alliance_btn"), false, BTN_W, BTN_H);
         btn.x = int((CONTENT_W - BTN_W) / 2);
         btn.y = tBody.y + tBody.height + BTN_GAP;
         btn.addEventListener(MouseEvent.CLICK, _onCreateAlliance);
      }

      private function _onCreateAlliance(e:MouseEvent):void
      {
         SOUNDS.Play("click1");
         new AllianceFormPopup().Show(AllianceFormPopup.MODE_CREATE);
      }
   }
}
