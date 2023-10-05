package
{
   public dynamic class buttonFullscreen_CLIP extends buttonFullscreen
   {
       
      
      public function buttonFullscreen_CLIP()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame3() : *
      {
         stop();
      }
   }
}
