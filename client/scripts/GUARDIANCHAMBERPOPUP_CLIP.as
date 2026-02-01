package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="GUARDIANCHAMBERPOPUP_CLIP")]
   public dynamic class GUARDIANCHAMBERPOPUP_CLIP extends MovieClip
   {
       
      
      public var buff_txt:TextField;
      
      public var bSpeed:creatureBar;
      
      public var selectedImage:MovieClip;
      
      public var mcMask:MovieClip;
      
      public var bBuff:creatureBar;
      
      public var bDamage:creatureBar;
      
      public var health_txt:TextField;
      
      public var tTitle:TextField;
      
      public var tSpeed:TextField;
      
      public var tHealth:TextField;
      
      public var frame:frame_CLIP;
      
      public var tEvoDesc:TextField;
      
      public var tEvoStage:TextField;
      
      public var tBuff:TextField;
      
      public var mcBgCubes:MovieClip;
      
      public var tDamage:TextField;
      
      public var damage_txt:TextField;
      
      public var speed_txt:TextField;
      
      public var bHealth:creatureBar;
      
      public var mcBgBot:MovieClip;
      
      public function GUARDIANCHAMBERPOPUP_CLIP()
      {
         super();
         stop();
      }
   }
}
