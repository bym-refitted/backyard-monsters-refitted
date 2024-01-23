package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="popup_sign_view")]
   public dynamic class popup_sign_view extends MovieClip
   {
       
      
      public var subject_txt:TextField;
      
      public var bClose:buttonClose_CLIP;
      
      public var placeholder:MovieClip;
      
      public var name_txt:TextField;
      
      public var bg_mc:MovieClip;
      
      public var photoRing:MovieClip;
      
      public function popup_sign_view()
      {
         super();
      }
   }
}
