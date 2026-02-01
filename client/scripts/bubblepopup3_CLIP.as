package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="bubblepopup3_CLIP")]
   public dynamic class bubblepopup3_CLIP extends MovieClip
   {
       
      
      public var mcArrow:MovieClip;
      
      public var mcBG:MovieClip;
      
      public var mcText:TextField;
      
      public function bubblepopup3_CLIP()
      {
         super();
         if (mcArrow) mcArrow.stop();
         if (mcBG) mcBG.stop();
      }
   }
}
