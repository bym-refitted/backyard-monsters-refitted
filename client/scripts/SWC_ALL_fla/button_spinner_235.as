package SWC_ALL_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;

   [Embed(source="/_assets/assets.swf", symbol="SWC_ALL_fla.button_spinner_235")]
   public dynamic class button_spinner_235 extends MovieClip
   {
      public function button_spinner_235()
      {
         super();
         addEventListener(Event.ENTER_FRAME, this.Tick);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
      }

      public function Tick(e:Event):void
      {
         if (visible)
         {
            rotation += 4;
         }
      }

      private function onRemoved(e:Event):void
      {
         removeEventListener(Event.ENTER_FRAME, Tick);
         removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
      }
   }
}
