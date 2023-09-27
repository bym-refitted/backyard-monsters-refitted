package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public dynamic class button_spinner extends MovieClip
   {
       
      
      public function button_spinner()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Tick(param1:Event) : *
      {
         rotation += 4;
      }
      
      internal function frame1() : *
      {
         addEventListener(Event.ENTER_FRAME,this.Tick);
      }
   }
}
