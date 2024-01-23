package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="AIATTACKPOPUP_CLIP")]
   public dynamic class AIATTACKPOPUP_CLIP extends MovieClip
   {
       
      
      public var waitBtn:Button_CLIP;
      
      public var name_txt:TextField;
      
      public var title_txt:TextField;
      
      public var c1:HousingPopupMonster_CLIP;
      
      public var c2:HousingPopupMonster_CLIP;
      
      public var c3:HousingPopupMonster_CLIP;
      
      public var sendNow:Button_CLIP;
      
      public var mcImage:MovieClip;
      
      public var mcFrame:frame_CLIP;
      
      public function AIATTACKPOPUP_CLIP()
      {
         super();
      }
   }
}
