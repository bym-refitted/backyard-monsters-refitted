package
{
   import flash.display.MovieClip;
   
   public dynamic class icon_invite extends MovieClip
   {
       
      
      public var mcHit:MovieClip;
      
      public var mcSpinner:MovieClip;
      
      public function icon_invite()
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
