package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="popup_error")]
   public dynamic class popup_error extends MovieClip
   {
       
      
      public var blocker:popup_bg;
      
      public var tA:TextField;
      
      public var tB:TextField;
      
      public var mcFrame:frame_CLIP;
      
      public var bAction:Button_CLIP;
      
      public function popup_error()
      {
         super();
      }
   }
}
