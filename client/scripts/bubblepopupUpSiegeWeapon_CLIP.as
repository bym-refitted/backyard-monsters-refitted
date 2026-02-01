package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="bubblepopupUpSiegeWeapon_CLIP")]
   public dynamic class bubblepopupUpSiegeWeapon_CLIP extends MovieClip
   {
       
      
      public var mcArrow:MovieClip;
      
      public var mcBG:MovieClip;
      
      public var tBody:TextField;
      
      public var tTitle:TextField;
      
      public function bubblepopupUpSiegeWeapon_CLIP()
      {
         super();
         if (mcArrow) mcArrow.stop();
         if (mcBG) mcBG.stop();
      }
   }
}
