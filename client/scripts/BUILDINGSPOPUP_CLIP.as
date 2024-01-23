package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="BUILDINGSPOPUP_CLIP")]
   public dynamic class BUILDINGSPOPUP_CLIP extends MovieClip
   {
       
      
      public var bNext:BUILDINGSARROW;
      
      public var bClose:buttonClose_CLIP;
      
      public var bPrevious:BUILDINGSARROW;
      
      public var b1:Button_CLIP;
      
      public var b2:Button_CLIP;
      
      public var b3:Button_CLIP;
      
      public var b4:Button_CLIP;
      
      public var mcNew:MovieClip;
      
      public function BUILDINGSPOPUP_CLIP()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
