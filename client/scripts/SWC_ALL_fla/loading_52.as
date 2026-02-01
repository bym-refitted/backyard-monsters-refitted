package SWC_ALL_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;

   [Embed(source="/_assets/assets.swf", symbol="SWC_ALL_fla.loading_52")]
   public dynamic class loading_52 extends MovieClip
   {
      public function loading_52()
      {
         super();
         addEventListener(Event.ENTER_FRAME, this.Tick);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
      }

      public function Tick(e:Event):void
      {
         rotation -= 12;
      }

      private function onRemoved(e:Event):void
      {
         removeEventListener(Event.ENTER_FRAME, Tick);
         removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
      }
   }
}
