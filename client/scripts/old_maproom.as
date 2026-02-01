package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="old_maproom")]
   public dynamic class old_maproom extends MovieClip
   {
       
      
      public var mcHolder:MovieClip;
      
      public var mvBtn:Button_CLIP;
      
      public var lvBtn:Button_CLIP;
      
      public var background_mc:frame_CLIP;
      
      public function old_maproom()
      {
         super();
         stop();
      }
   }
}
