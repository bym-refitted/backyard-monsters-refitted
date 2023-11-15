package com.monsters.maproom
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="com.monsters.maproom.WildMonsterBaseInfo")]
   public dynamic class WildMonsterBaseInfo extends MovieClip
   {
       
      
      public var info_txt:TextField;
      
      public var mcArrow:MovieClip;
      
      public var mcBG:MovieClip;
      
      public function WildMonsterBaseInfo()
      {
         super();
      }
   }
}
