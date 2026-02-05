package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="UI_WILDMONSTERBAR_CLIP")]
   public dynamic class UI_WILDMONSTERBAR_CLIP extends MovieClip
   {
       
      
      public var tA:TextField;
      
      public var info:MovieClip;
      
      public var back:MovieClip;
      
      public var eta_txt:TextField;
      
      public function UI_WILDMONSTERBAR_CLIP()
      {
         super();
         if (info) info.stop();
      }
   }
}
