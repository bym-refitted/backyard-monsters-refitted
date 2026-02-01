package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="bubblepopup_CLIP")]
   public dynamic class bubblepopup_CLIP extends MovieClip
   {
       
      
      public var mcArrow:MovieClip;
      
      public var mcBG:MovieClip;
      
      public var mcText:TextField;
      
      public function bubblepopup_CLIP()
      {
         super();
         if (mcArrow) mcArrow.stop();
         if (mcBG) mcBG.stop();
      }
   }
}
