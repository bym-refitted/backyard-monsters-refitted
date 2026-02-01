package
{
   import flash.display.MovieClip;
   import flash.events.Event;

   [Embed(source="/_assets/assets.swf", symbol="button_spinner")]
   public dynamic class button_spinner extends MovieClip
   {
      public function button_spinner()
      {
         super();
         addEventListener(Event.ENTER_FRAME, this.Tick);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
      }

      public function Tick(e:Event):void
      {
         rotation += 4;
      }

      private function onRemoved(e:Event):void
      {
         removeEventListener(Event.ENTER_FRAME, Tick);
         removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
      }
   }
}
