package com.monsters.display
{
   import flash.events.Event;
   
   public class ScalableFrame extends frame
   {
       
      
      public function ScalableFrame()
      {
         addEventListener(Event.RESIZE,this.onResize);
         super(false);
      }
      
      protected function onResize(param1:Event) : void
      {
         resize();
      }
   }
}
