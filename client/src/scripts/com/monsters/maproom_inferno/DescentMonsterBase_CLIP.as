package com.monsters.maproom_inferno
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   [Embed(source="/_assets/assets.swf", symbol="com.monsters.maproom_inferno.DescentMonsterBase_CLIP")]
   public dynamic class DescentMonsterBase_CLIP extends MovieClip
   {
       
      
      public var mediumhit:SimpleButton;
      
      public var smallhit:SimpleButton;
      
      public var mcBase:MovieClip;
      
      public var largehit:SimpleButton;
      
      public function DescentMonsterBase_CLIP()
      {
         super();
      }
   }
}
