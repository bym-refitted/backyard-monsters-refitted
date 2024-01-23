package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="frontpage_featuredItem_CLIP")]
   public dynamic class frontpage_featuredItem_CLIP extends MovieClip
   {
       
      
      public var tBody:TextField;
      
      public var tTitle:TextField;
      
      public var mcOverlay:MovieClip;
      
      public var mcImage:MovieClip;
      
      public var bAction:Button_CLIP;
      
      public function frontpage_featuredItem_CLIP()
      {
         super();
      }
   }
}
