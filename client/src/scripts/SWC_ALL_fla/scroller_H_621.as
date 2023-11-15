package SWC_ALL_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="SWC_ALL_fla.scroller_H_621")]
   public dynamic class scroller_H_621 extends MovieClip
   {
       
      
      public function scroller_H_621()
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
