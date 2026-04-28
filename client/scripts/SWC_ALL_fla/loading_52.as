package SWC_ALL_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.getTimer;

   [Embed(source="/_assets/assets.swf", symbol="SWC_ALL_fla.loading_52")]
   public dynamic class loading_52 extends MovieClip
   {
      private var lastTick:int;

      public function loading_52()
      {
         super();
         addEventListener(Event.ENTER_FRAME, this.Tick);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
      }

      public function Tick(e:Event):void
      {
         var now:int = getTimer();
         if (this.lastTick)
         {
            rotation -= 12 * GLOBAL.LegacyVisualFrameScale(now - this.lastTick);
         }
         this.lastTick = now;
      }

      private function onRemoved(e:Event):void
      {
         removeEventListener(Event.ENTER_FRAME, Tick);
         removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
      }
   }
}
