package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="meterBar_rounded_blue_CLIP")]
   public dynamic class meterBar_rounded_blue_CLIP extends MovieClip
   {
       
      
      public var mcFill:MovieClip;
      
      public var mcBG:MovieClip;
      
      public var mcFillMask:MovieClip;
      
      public function meterBar_rounded_blue_CLIP()
      {
         super();
         if (mcFill) mcFill.stop();
         if (mcBG) mcBG.stop();
      }
   }
}
