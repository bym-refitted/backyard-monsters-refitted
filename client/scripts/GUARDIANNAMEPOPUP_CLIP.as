package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="GUARDIANNAMEPOPUP_CLIP")]
   public dynamic class GUARDIANNAMEPOPUP_CLIP extends MovieClip
   {
       
      
      public var mcGuard:MovieClip;
      
      public var mcBG:frame_CLIP;
      
      public var tInput:TextField;
      
      public var tTitle:TextField;
      
      public var tDescription:TextField;
      
      public var bAction:Button_CLIP;
      
      public function GUARDIANNAMEPOPUP_CLIP()
      {
         super();
      }
   }
}
