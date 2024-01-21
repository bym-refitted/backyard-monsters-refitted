package com.monsters.maproom_inferno
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="com.monsters.maproom_inferno.DescentBaseInfo")]
   public dynamic class DescentBaseInfo extends MovieClip
   {
       
      
      public var info_txt:TextField;
      
      public var mcArrow:MovieClip;
      
      public var mcBG:MovieClip;
      
      public function DescentBaseInfo()
      {
         super();
      }
   }
}
