package SWC_ALL_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="SWC_ALL_fla.PointsBar_882")]
   public dynamic class PointsBar_882 extends MovieClip
   {
       
      
      public var tInfo:TextField;
      
      public var tName:TextField;
      
      public var mcStar:MovieClip;
      
      public var mcLevel:TextField;
      
      public var mcBar:MovieClip;
      
      public function PointsBar_882()
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
