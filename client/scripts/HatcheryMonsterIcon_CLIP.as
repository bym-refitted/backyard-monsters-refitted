package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="HatcheryMonsterIcon_CLIP")]
   public dynamic class HatcheryMonsterIcon_CLIP extends MovieClip
   {
       
      
      public var tLabel:TextField;
      
      public var mcImage:MovieClip;
      
      public var mcLoading:MovieClip;
      
      public function HatcheryMonsterIcon_CLIP()
      {
         super();
         stop();
         if (mcLoading) mcLoading.stop();
      }
   }
}
