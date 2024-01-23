package com.monsters.maproom_inferno
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="com.monsters.maproom_inferno.MiniMapDescent_CLIP")]
   public dynamic class MiniMapDescent_CLIP extends MovieClip
   {
       
      
      public var background_mc:MiniMapBackgroundDescent_CLIP;
      
      public var mask_mc:MovieClip;
      
      public var fow_mc:MovieClip;
      
      public function MiniMapDescent_CLIP()
      {
         super();
      }
   }
}
