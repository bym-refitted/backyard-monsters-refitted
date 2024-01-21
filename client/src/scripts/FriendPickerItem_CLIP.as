package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="FriendPickerItem_CLIP")]
   public dynamic class FriendPickerItem_CLIP extends MovieClip
   {
       
      
      public var background:MovieClip;
      
      public var name_txt:TextField;
      
      public var placeholder:MovieClip;
      
      public var userid_txt:TextField;
      
      public var photoRing:MovieClip;
      
      public function FriendPickerItem_CLIP()
      {
         super();
      }
   }
}
