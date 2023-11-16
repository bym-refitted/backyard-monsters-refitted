package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="MONSTERBUNKERPOPUP_CLIP")]
   public dynamic class MONSTERBUNKERPOPUP_CLIP extends MovieClip
   {
       
      
      public var transferCanvasBmask:MovieClip;
      
      public var transferCanvasA:MovieClip;
      
      public var transferCanvasAmask:MovieClip;
      
      public var tNoMonsters:TextField;
      
      public var title_txt:TextField;
      
      public var bHousing:Button_CLIP;
      
      public var bContinue:Button_CLIP;
      
      public var tStored:TextField;
      
      public var txtGuide:TextField;
      
      public var bSpecial:Button_CLIP;
      
      public var scrollerA:MovieClip;
      
      public var tCost:TextField;
      
      public var transferCanvasB:MovieClip;
      
      public var scrollerB:MovieClip;
      
      public var mcStorage:MovieClip;
      
      public var tCapacity:TextField;
      
      public var bTransfer:Button_CLIP;
      
      public function MONSTERBUNKERPOPUP_CLIP()
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
