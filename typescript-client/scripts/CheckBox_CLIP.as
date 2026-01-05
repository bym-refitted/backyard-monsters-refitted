package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="CheckBox_CLIP")]
   public dynamic class CheckBox_CLIP extends MovieClip
   {
       
      
      public function CheckBox_CLIP()
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
