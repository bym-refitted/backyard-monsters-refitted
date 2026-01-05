package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="ui_buffIcon_CLIP")]
   public dynamic class ui_buffIcon_CLIP extends MovieClip
   {
       
      
      public function ui_buffIcon_CLIP()
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
