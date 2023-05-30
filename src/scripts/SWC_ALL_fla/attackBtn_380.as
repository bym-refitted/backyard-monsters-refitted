package SWC_ALL_fla
{
   import flash.display.MovieClip;
   
   public dynamic class attackBtn_380 extends MovieClip
   {
       
      
      public var sorter_mc:MovieClip;
      
      public function attackBtn_380()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}
