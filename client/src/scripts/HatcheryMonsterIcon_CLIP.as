package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class HatcheryMonsterIcon_CLIP extends MovieClip
   {
       
      
      public var tLabel:TextField;
      
      public var mcImage:MovieClip;
      
      public var mcLoading:MovieClip;
      
      public function HatcheryMonsterIcon_CLIP()
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
