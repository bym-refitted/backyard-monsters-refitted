package
{
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import gs.TweenLite;
   import gs.easing.Elastic;
   
   public class bubblepopup3 extends bubblepopup3_CLIP
   {
       
      
      private var _dropShadow:DropShadowFilter;
      
      private var _fixedrowcount:int = 0;
      
      public function bubblepopup3()
      {
         super();
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
         mcText.autoSize = TextFieldAutoSize.CENTER;
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
         mcText.autoSize = TextFieldAutoSize.LEFT;
         mcText.htmlText = param1;
         if(this._fixedrowcount > 0)
         {
            mcText.width = 80;
            while(mcText.height > 18 * this._fixedrowcount)
            {
               mcText.width += 2;
            }
            mcBG.width = mcText.width + 12;
         }
         mcBG.height = mcText.height + 10;
         mcBG.y = -int(mcBG.height * 0.5);
         mcText.y = mcBG.y + 5;
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
