package SWC_ALL_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public dynamic class loading_52 extends MovieClip
   {
       
      
      public function loading_52()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function Tick(param1:Event) : *
      {
         rotation -= 12;
      }
      
      internal function frame1() : *
      {
         addEventListener(Event.ENTER_FRAME,this.Tick);
      }
   }
}
