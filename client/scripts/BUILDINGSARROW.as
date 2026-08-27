package
{
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.geom.Rectangle;

   [Embed(source="/_assets/assets.swf", symbol="BUILDINGSARROW")]
   public class BUILDINGSARROW extends MovieClip
   {


      public var mcArrow:MovieClip;

      public var offsetX:*;

      public var offsetY:*;

      public var wobbleCountdown:int = 0;

      public var active:Boolean = false;

      public function BUILDINGSARROW()
      {
         super();
         this.addEventListener(Event.ENTER_FRAME,this.Wobble);
         // iOS: the arrow graphic (mcArrow) nested child is null, so next/previous nav arrows in
         // the Academy/Buildings/Inbox menus were invisible. Draw a stand-in arrow. bPrevious is
         // the same symbol flipped (scaleX < 0) so a right-pointing arrow points left there.
         if(GLOBAL._iosViewport && !this.mcArrow)
         {
            this.DrawIosArrow();
         }
      }

      private function DrawIosArrow() : void
      {
         var pb:Rectangle = this.getBounds(this);
         var cx:Number = pb.width > 2 ? pb.x + pb.width / 2 : 0;
         var cy:Number = pb.height > 2 ? pb.y + pb.height / 2 : 0;
         GLOBAL.DrawArrowFallback(this,cx,cy,12,16);
      }
      
      public function Trigger(param1:Boolean = false) : *
      {
         this.active = param1;
         if(this.active)
         {
            buttonMode = true;
            if(this.mcArrow) this.mcArrow.gotoAndStop(2);
         }
         else
         {
            buttonMode = false;
            if(this.mcArrow) this.mcArrow.gotoAndStop(1);
         }
      }
      
      public function Wobble(param1:Event) : *
      {
         if(this.active)
         {
            if(this.wobbleCountdown == 0)
            {
               this.wobbleCountdown = 80;
            }
            --this.wobbleCountdown;
         }
      }
      
      private function WobbleB() : *
      {
      }
   }
}
