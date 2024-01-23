package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="PLANNERPOPUP_CLIP")]
   public dynamic class PLANNERPOPUP_CLIP extends MovieClip
   {
       
      
      public var tName:TextField;
      
      public var mcMap:MovieClip;
      
      public var title_txt:TextField;
      
      public var bContinue:Button_CLIP;
      
      public var txtGuide:TextField;
      
      public var bExpand:Button_CLIP;
      
      public var mcNameBG:MovieClip;
      
      public var bZoom1:Button_CLIP;
      
      public var bRanges:Button_CLIP;
      
      public var bZoom2:Button_CLIP;
      
      public function PLANNERPOPUP_CLIP()
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
