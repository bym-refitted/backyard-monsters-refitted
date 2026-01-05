package SWC_ALL_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="SWC_ALL_fla.unreadBtn_50")]
   public dynamic class unreadBtn_50 extends MovieClip
   {
       
      
      public var sorter_mc:MovieClip;
      
      public function unreadBtn_50()
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
