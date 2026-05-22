package com.monsters.alliances.tabs
{
   import com.monsters.alliances.AllianceTabBase;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;

   public class PowerUpsTab extends AllianceTabBase
   {
      private static const TITLE_SIZE:int = 24;
      private static const PAD_TOP:int = 24;

      public function PowerUpsTab()
      {
         super();
      }

      override public function build():void
      {
         var tTitle:TextField = addChild(new TextField()) as TextField;
         tTitle.selectable = false;
         tTitle.mouseEnabled = false;
         tTitle.embedFonts = true;
         tTitle.antiAliasType = AntiAliasType.NORMAL;
         tTitle.width = CONTENT_W;
         tTitle.height = TITLE_SIZE + 8;
         var fmt:TextFormat = new TextFormat("Groboldov", TITLE_SIZE, 0xFFFFFF);
         fmt.align = TextFormatAlign.CENTER;
         tTitle.defaultTextFormat = fmt;
         tTitle.text = "COMING SOON";
         tTitle.filters = [new GlowFilter(0, 1, 3, 3, 9, 2), new DropShadowFilter(2, 45, 0, 0.55, 3, 3, 1, 2)];
         tTitle.x = 0;
         tTitle.y = PAD_TOP;
      }
   }
}
