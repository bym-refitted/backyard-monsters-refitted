package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="koth_looted_marker")]
   public dynamic class koth_looted_marker extends MovieClip
   {
       
      
      public var mcBG:MovieClip;
      
      public var check:MovieClip;
      
      public function koth_looted_marker()
      {
         super();
         if (mcBG) mcBG.stop();
         if (check) check.stop();
      }
   }
}
