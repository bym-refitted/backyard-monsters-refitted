package com.monsters.maproom_inferno.views
{
   import com.monsters.maproom.views.ListViewArrow_CLIP;
   import flash.events.Event;
   import gs.TweenLite;
   import gs.easing.Bounce;
   import gs.easing.Expo;
   
   public class ListViewArrow extends ListViewArrow_CLIP
   {
       
      
      public var offsetX:Number;
      
      public var offsetY:Number;
      
      public var wobbleCountdown:int = 0;
      
      public var active:Boolean = false;
      
      public function ListViewArrow()
      {
         super();
         this.addEventListener(Event.ENTER_FRAME,this.Wobble);
      }
      
      public function Trigger(param1:Boolean = false) : void
      {
         this.active = param1;
         if(this.active)
         {
            buttonMode = true;
            if(mcArrow) mcArrow.gotoAndStop(2);
         }
         else
         {
            buttonMode = false;
            if(mcArrow) mcArrow.gotoAndStop(1);
         }
      }
      
      public function Wobble(param1:Event) : void
      {
         if(this.active)
         {
            if(this.wobbleCountdown == 0)
            {
               this.wobbleCountdown = 80;
               if(mcArrow)
               {
                  mcArrow.x = -15;
                  TweenLite.to(mcArrow,0.6,{
                     "x":-20,
                     "ease":Expo.easeInOut,
                     "onComplete":this.WobbleB
                  });
               }
            }
            --this.wobbleCountdown;
         }
      }

      private function WobbleB() : void
      {
         if(!mcArrow) return;
         TweenLite.to(mcArrow,0.6,{
            "x":-15,
            "ease":Bounce.easeOut
         });
      }
   }
}
