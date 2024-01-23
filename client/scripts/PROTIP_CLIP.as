package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="PROTIP_CLIP")]
   public dynamic class PROTIP_CLIP extends MovieClip
   {
       
      
      public var tTitle:TextField;
      
      public var tDesc:TextField;
      
      public var mcFrame:frame_CLIP;
      
      public var mcIcon:MovieClip;
      
      public function PROTIP_CLIP()
      {
         super();
      }
   }
}
