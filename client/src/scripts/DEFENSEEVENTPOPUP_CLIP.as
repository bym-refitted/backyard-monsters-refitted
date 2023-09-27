package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class DEFENSEEVENTPOPUP_CLIP extends MovieClip
   {
       
      
      public var mcBanner:MovieClip;
      
      public var mcText:TextField;
      
      public var rsvpBtn:Button_CLIP;
      
      public var mcImage:MovieClip;
      
      public var mcFrame:frame_CLIP;
      
      public function DEFENSEEVENTPOPUP_CLIP()
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
