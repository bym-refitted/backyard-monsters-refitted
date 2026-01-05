package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="PopupNewBookmark")]
   public dynamic class PopupNewBookmark extends MovieClip
   {
       
      
      public var tName:TextField;
      
      public var bSave:Button_CLIP;
      
      public var mcFrame:frame_CLIP;
      
      public var tMessage:TextField;
      
      public function PopupNewBookmark()
      {
         super();
      }
   }
}
