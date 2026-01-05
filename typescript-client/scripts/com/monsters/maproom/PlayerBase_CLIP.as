package com.monsters.maproom
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="com.monsters.maproom.PlayerBase_CLIP")]
   public dynamic class PlayerBase_CLIP extends MovieClip
   {
       
      
      public var photoFrame_mc:MovieClip;
      
      public var name_txt:TextField;
      
      public var placeholder:MovieClip;
      
      public var frame_mc:MovieClip;
      
      public var box_mc:MovieClip;
      
      public function PlayerBase_CLIP()
      {
         super();
      }
   }
}
