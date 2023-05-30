package
{
   public dynamic class buttonSaving_CLIP extends buttonSaving
   {
       
      
      public function buttonSaving_CLIP()
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
