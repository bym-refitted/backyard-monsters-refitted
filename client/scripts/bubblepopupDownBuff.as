package
{
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import gs.TweenLite;
   import gs.easing.Elastic;
   
   public class bubblepopupDownBuff extends bubblepopupDownBuff_CLIP
   {
       
      
      public var _dropShadow:DropShadowFilter;
      
      public function bubblepopupDownBuff()
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
      
      public function Setup(param1:int, param2:int, param3:String = "", param4:String = "", param5:int = 0) : void
      {
         this.mouseEnabled = false;
         this.mouseChildren = false;
         if(param3)
         {
            this.Update(param3,param4);
         }
      }
      
      public function Update(param1:String, param2:String, param3:int = 1) : void
      {
         mcText.htmlText = param1;
         mcTextDuration.htmlText = param2;
      }
      
      public function Resize(param1:Number = 0) : void
      {
         mcBG.height -= param1;
         mcBG.y += param1;
         if(param1 > 50)
         {
            param1 -= 5;
         }
         mcText.y += param1;
         mcTextDuration.y += param1;
      }
      
      public function Wobble() : void
      {
         rotation += 3;
         TweenLite.to(this,0.6,{
            "rotation":this.rotation - 3,
            "ease":Elastic.easeOut
         });
      }
      
      public function Nudge(param1:String) : void
      {
         if(param1 == "up")
         {
            this.y -= 3;
            TweenLite.to(this,0.6,{
               "y":this.y + 3,
               "ease":Elastic.easeOut
            });
         }
         else if(param1 == "left")
         {
            this.x += 3;
            TweenLite.to(this,0.6,{
               "y":this.y - 3,
               "ease":Elastic.easeOut
            });
         }
         else
         {
            this.x -= 3;
            TweenLite.to(this,0.6,{
               "y":this.x + 3,
               "ease":Elastic.easeOut
            });
         }
      }
      
      public function Cleanup() : void
      {
         if(this._dropShadow)
         {
            this.filters = [];
            this._dropShadow = null;
         }
      }
      
      public function Clear() : void
      {
      }
   }
}
