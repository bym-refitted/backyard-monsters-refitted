package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="popup_new_map_confirm")]
   public dynamic class popup_new_map_confirm extends MovieClip
   {
       
      
      public var tfBody:TextField;
      
      public var btnJuice:Button_CLIP;
      
      public var btnCancel:Button_CLIP;
      
      public var tfTitle:TextField;
      
      public var mcFrame:frame_CLIP;
      
      public function popup_new_map_confirm()
      {
         super();
      }
   }
}
