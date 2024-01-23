package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="icon_popups")]
   public dynamic class icon_popups extends MovieClip
   {
       
      
      public var mcHit:MovieClip;
      
      public var mcSpinner:MovieClip;
      
      public var mcCounter:MovieClip;
      
      public function icon_popups()
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
