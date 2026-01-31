package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import com.monsters.utils.MovieClipUtils;
   
   [Embed(source="/_assets/assets.swf", symbol="bubblepopup5")]
   public dynamic class bubblepopup5 extends MovieClip
   {
       
      
      public var mcBG:MovieClip;
      
      public var mcText:TextField;
      
      public function bubblepopup5()
      {
         super();
         MovieClipUtils.stopAll(this);
      }
   }
}
