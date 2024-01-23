package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="icon_mail")]
   public dynamic class icon_mail extends MovieClip
   {
       
      
      public var mcHit:MovieClip;
      
      public var mcSpinner:MovieClip;
      
      public var mcCounter:MovieClip;
      
      public function icon_mail()
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
