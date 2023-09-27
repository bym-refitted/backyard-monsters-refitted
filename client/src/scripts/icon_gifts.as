package
{
   import flash.display.MovieClip;
   
   public dynamic class icon_gifts extends MovieClip
   {
       
      
      public var mcHit:MovieClip;
      
      public var mcSpinner:MovieClip;
      
      public var mcCounter:MovieClip;
      
      public function icon_gifts()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
