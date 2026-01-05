package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="descentDebuff_info_CLIP")]
   public dynamic class descentDebuff_info_CLIP extends MovieClip
   {
       
      
      public var depthBar:MovieClip;
      
      public var tDepth:TextField;
      
      public var tDesc:TextField;
      
      public var tDepth2:TextField;
      
      public function descentDebuff_info_CLIP()
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
