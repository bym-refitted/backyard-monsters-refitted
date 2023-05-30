package
{
   import flash.filters.DropShadowFilter;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import gs.TweenLite;
   import gs.easing.Elastic;
   
   public class bubblepopupRight extends bubblepopupRight_CLIP
   {
       
      
      public var _dropShadow:DropShadowFilter;
      
      public function bubblepopupRight()
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
      
      public function Setup(param1:int, param2:int, param3:String = "", param4:int = 0) : void
      {
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.x = param1;
         this.y = param2;
         if(param3.length < 20)
         {
            this.mcBG.width = 80;
            this.mcText.width = 60;
         }
         else if(param3.length < 80)
         {
            this.mcBG.width = 150;
            this.mcText.width = 130;
         }
         if(param1 > 450)
         {
            mcBG.x = int(0 - (mcBG.width - 25));
         }
         else
         {
            mcBG.x = int(0 - mcBG.width / 2);
         }
         mcText.x = int(mcBG.x + 10);
         if(param3)
         {
            this.Update(param3);
         }
      }
      
      public function Update(param1:String, param2:int = 1) : void
      {
         var _loc5_:Rectangle = null;
         mcText.htmlText = param1;
         mcText.width = 20;
         while(mcText.height > 20 * param2)
         {
            mcText.width += 2;
         }
         mcBG.width = mcText.width + 16;
         mcText.y = int(0 - mcText.height / 2);
         mcBG.height = int(mcText.height + 6);
         mcBG.y = int(mcText.y - 3);
         mcBG.x = -int(mcBG.width + 8);
         var _loc3_:int = GLOBAL._ROOT.stage.stageWidth;
         var _loc4_:int = GLOBAL.GetGameHeight();
         _loc5_ = new Rectangle(0 - (_loc3_ - 760) / 2,0 - (_loc4_ - 520) / 2,_loc3_,_loc4_);
         if(x + mcBG.x < _loc5_.x + 10)
         {
            mcBG.x = int(_loc5_.x - x + 10);
         }
         if(x + mcBG.x + mcBG.width > _loc5_.x + _loc5_.width - 10)
         {
            mcBG.x = int(_loc5_.x + _loc5_.width - x - 10 - mcBG.width);
         }
         mcText.x = int(mcBG.x + 8);
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
      
      public function Clear() : void
      {
      }
   }
}
