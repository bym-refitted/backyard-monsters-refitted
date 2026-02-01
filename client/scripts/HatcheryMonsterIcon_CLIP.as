package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import SWC_ALL_fla.loading_210;
   
   [Embed(source="/_assets/assets.swf", symbol="HatcheryMonsterIcon_CLIP")]
   public dynamic class HatcheryMonsterIcon_CLIP extends MovieClip
   {
       
      
      public var tLabel:TextField;
      
      public var mcImage:MovieClip;
      
      public var mcLoading:loading_210;
      
      public function HatcheryMonsterIcon_CLIP()
      {
         super();
         stop();
         if (mcLoading) mcLoading.stop();
      }
   }
}
