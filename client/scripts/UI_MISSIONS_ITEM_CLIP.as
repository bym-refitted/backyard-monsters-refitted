package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import SWC_ALL_fla.loading_210;
   
   [Embed(source="/_assets/assets.swf", symbol="UI_MISSIONS_ITEM_CLIP")]
   public dynamic class UI_MISSIONS_ITEM_CLIP extends MovieClip
   {
       
      
      public var tName:TextField;
      
      public var tDesc:TextField;
      
      public var bg:MovieClip;
      
      public var mcImage:MovieClip;
      
      public var mcLoading:loading_210;
      
      public var mcCheck:MovieClip;
      
      public function UI_MISSIONS_ITEM_CLIP()
      {
         super();
      }
   }
}
