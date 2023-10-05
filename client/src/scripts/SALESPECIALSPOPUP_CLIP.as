package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class SALESPECIALSPOPUP_CLIP extends MovieClip
   {
       
      
      public var bAction2:Button_CLIP;
      
      public var bAction3:MovieClip;
      
      public var bInfo:MovieClip;
      
      public var tTitle:TextField;
      
      public var tDesc:TextField;
      
      public var mcFrame:frame_CLIP;
      
      public var bAction:Button_CLIP;
      
      public var bAction4:MovieClip;
      
      public function SALESPECIALSPOPUP_CLIP()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}
