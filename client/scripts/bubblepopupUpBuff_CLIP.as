package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="bubblepopupUpBuff_CLIP")]
   public dynamic class bubblepopupUpBuff_CLIP extends MovieClip
   {
       
      
      public var mcArrow:MovieClip;
      
      public var mcBG:MovieClip;
      
      public var mcTextDuration:TextField;
      
      public var mcText:TextField;
      
      public function bubblepopupUpBuff_CLIP()
      {
         super();
         if (mcArrow) mcArrow.stop();
         if (mcBG) mcBG.stop();
      }
   }
}
