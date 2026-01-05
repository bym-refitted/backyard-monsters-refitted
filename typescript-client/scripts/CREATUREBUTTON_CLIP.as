package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="CREATUREBUTTON_CLIP")]
   public dynamic class CREATUREBUTTON_CLIP extends MovieClip
   {
       
      
      public var _creatureImage:MovieClip;
      
      public var txtNumber:TextField;
      
      public var _bg:MovieClip;
      
      public var txtName:TextField;
      
      public var bLess:Button_CLIP;
      
      public var mcImage:MovieClip;
      
      public var bMore:Button_CLIP;
      
      public function CREATUREBUTTON_CLIP()
      {
         super();
      }
   }
}
