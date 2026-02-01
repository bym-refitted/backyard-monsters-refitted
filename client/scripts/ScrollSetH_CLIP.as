package
{
   import flash.display.MovieClip;
   import com.monsters.utils.MovieClipUtils;
   
   [Embed(source="/_assets/assets.swf", symbol="ScrollSetH_CLIP")]
   public dynamic class ScrollSetH_CLIP extends MovieClip
   {
       
      
      public var mcBG:MovieClip;
      
      public var mcScroller:MovieClip;
      
      public function ScrollSetH_CLIP()
      {
         super();
         MovieClipUtils.stopAll(this);
      }
   }
}
