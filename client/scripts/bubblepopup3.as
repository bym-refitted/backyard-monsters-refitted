package
{
   import flash.display.MovieClip;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import gs.TweenLite;
   import gs.easing.Elastic;

   public class bubblepopup3 extends bubblepopup3_CLIP
   {


      private var _dropShadow:DropShadowFilter;

      private var _fixedrowcount:int = 0;

      // iOS AIR interpreter leaves the embedded symbol's nested mcBG/mcText null (same
      // lossy-symbol pattern as ResourcePackage.mcDot). Without them, the original
      // constructor threw #1009 on `mcText.autoSize`, which aborted every caller that
      // builds a bubblepopup3 in its constructor — notably CREATUREBUTTON, so NO attack
      // fling buttons were created and the player could not deploy monsters. Recreate the
      // children with device fonts so the class never throws and the tooltip still shows.
      private var _fallback:Boolean = false;


      public function bubblepopup3()
      {
         super();
         this.ensureChildren();
         this._dropShadow = new DropShadowFilter();
         this._dropShadow.distance = 1;
         this._dropShadow.angle = 45;
         this._dropShadow.color = 0;
         this._dropShadow.alpha = 1;
         this._dropShadow.blurX = 3;
         this._dropShadow.blurY = 3;
         this._dropShadow.strength = 1;
         this._dropShadow.quality = 2;
         this.filters = new Array(this._dropShadow);
         if(mcText)
         {
            mcText.autoSize = TextFieldAutoSize.CENTER;
         }
      }

      private function ensureChildren() : void
      {
         var _bg:MovieClip = null;
         var _t:TextField = null;
         var _fmt:TextFormat = null;
         if(!mcBG)
         {
            this._fallback = true;
            _bg = new MovieClip();
            // Light "parchment" tooltip box matching the game's creature-description bubble,
            // so the (dark) description text stays readable. Registered at horizontal-center /
            // top so the original Update() math (mcBG.width/height + mcBG.y = -height/2) still
            // positions it correctly.
            _bg.graphics.lineStyle(2,0x7A5A2E,1);
            _bg.graphics.beginFill(0xFBEFCB,1);
            _bg.graphics.drawRoundRect(-50,0,100,40,14,14);
            _bg.graphics.endFill();
            _bg.mouseEnabled = false;
            _bg.mouseChildren = false;
            this.mcBG = _bg;
            addChildAt(_bg,0);
         }
         if(!mcText)
         {
            this._fallback = true;
            _t = new TextField();
            _fmt = new TextFormat();
            _fmt.font = "_sans";
            _fmt.size = 12;
            _fmt.color = 0x3A2A14;
            _fmt.bold = true;
            _fmt.align = TextFormatAlign.CENTER;
            _t.defaultTextFormat = _fmt;
            _t.embedFonts = false;
            _t.multiline = true;
            _t.wordWrap = false;
            _t.selectable = false;
            _t.mouseEnabled = false;
            _t.x = 0;
            _t.autoSize = TextFieldAutoSize.CENTER;
            this.mcText = _t;
            addChild(_t);
         }
      }

      public function Setup(param1:int, param2:int, param3:String, param4:int = 0) : void
      {
         this._fixedrowcount = param4;
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.x = param1;
         this.y = param2;
         this.Update(param3);
      }

      public function Update(param1:*) : void
      {
         if(!mcText)
         {
            return;
         }
         mcText.autoSize = TextFieldAutoSize.LEFT;
         mcText.htmlText = param1;
         // Embedded-font (Groboldov) fallback: if the symbol's own TextField couldn't
         // render the font on iOS (0 width), drop to the device font.
         if(mcText.textWidth < 1 && String(param1).length > 0)
         {
            mcText.embedFonts = false;
            mcText.htmlText = param1;
         }
         if(this._fixedrowcount > 0)
         {
            mcText.width = 80;
            while(mcText.height > 18 * this._fixedrowcount && mcText.width < 400)
            {
               mcText.width += 2;
            }
            if(mcBG)
            {
               mcBG.width = mcText.width + 12;
            }
         }
         if(mcBG)
         {
            mcBG.height = mcText.height + 10;
            mcBG.y = -int(mcBG.height * 0.5);
            if(this._fallback)
            {
               mcText.x = -int(mcText.width * 0.5);
            }
            mcText.y = mcBG.y + 5;
         }
      }

      public function Wobble() : void
      {
         rotation += 3;
         TweenLite.to(this,0.6,{
            "rotation":rotation - 3,
            "ease":Elastic.easeOut
         });
      }

      public function Nudge(param1:String) : void
      {
         if(param1 == "up")
         {
            y -= 3;
            TweenLite.to(this,0.6,{
               "y":y + 3,
               "ease":Elastic.easeOut
            });
         }
         else
         {
            x -= 3;
            TweenLite.to(this,0.6,{
               "y":x + 3,
               "ease":Elastic.easeOut
            });
         }
      }
   }
}
