package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="ROUNDCOMPLETEPOPUP_CLIP")]
   public dynamic class ROUNDCOMPLETEPOPUP_CLIP extends MovieClip
   {
       
      
      public var mcTitle:TextField;
      
      public var mcBanner:MovieClip;
      
      public var rBtn:Button_CLIP;
      
      public var mcStats:TextField;
      
      public var mcText:TextField;
      
      public var mcImage:MovieClip;
      
      public var mcFrame:frame_CLIP;
      
      public var mBtn:Button_CLIP;
      
      public var lBtn:Button_CLIP;
      
      public var bragBtn:Button_CLIP;
      
      public function ROUNDCOMPLETEPOPUP_CLIP()
      {
         super();
         addFrameScript(1,this.frame2);
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}
