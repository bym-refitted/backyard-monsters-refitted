package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class BUILDINGSARROW extends MovieClip
   {
       
      
      public var mcArrow:MovieClip;
      
      public var offsetX;
      
      public var offsetY;
      
      public var wobbleCountdown:int = 0;
      
      public var active:Boolean = false;
      
      public function BUILDINGSARROW()
      {
         super();
         this.addEventListener(Event.ENTER_FRAME,this.Wobble);
      }
      
      public function Trigger(param1:Boolean = false) : *
      {
         this.active = param1;
         if(this.active)
         {
            buttonMode = true;
            this.mcArrow.gotoAndStop(2);
         }
         else
         {
            buttonMode = false;
            this.mcArrow.gotoAndStop(1);
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
