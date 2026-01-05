package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="STOREITEM")]
   public dynamic class STOREITEM extends MovieClip
   {
       
      
      public var tA:TextField;
      
      public var tB:TextField;
      
      public var tC:TextField;
      
      public var bBuy:Button_CLIP;
      
      public var mcIcon:store_icon_CLIP;
      
      public var mcScreen:MovieClip;
      
      public function STOREITEM()
      {
         super();
      }
   }
}
