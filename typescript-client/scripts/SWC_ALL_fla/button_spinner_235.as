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
         addFrameScript(0,this.frame1);
      }
      
      public function Tick(param1:Event) : *
      {
         if(visible)
         {
            rotation += 4;
         }
      }
      
      internal function frame1() : *
      {
         addEventListener(Event.ENTER_FRAME,this.Tick);
      }
   }
}
