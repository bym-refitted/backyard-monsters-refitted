package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.getTimer;

   [Embed(source="/_assets/assets.swf", symbol="button_spinner")]
   public dynamic class button_spinner extends MovieClip
   {
      private var lastTick:int;

      public function button_spinner()
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
            rotation += 4 * GLOBAL.LegacyVisualFrameScale(now - this.lastTick);
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
