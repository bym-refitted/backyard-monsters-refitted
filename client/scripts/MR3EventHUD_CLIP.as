package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="MR3EventHUD_CLIP")]
   public dynamic class MR3EventHUD_CLIP extends MovieClip
   {
       
      
      public var mcTitle:MovieClip;
      
      public var bInfo:Button_CLIP;
      
      public var tExperience:TextField;
      
      public var mcInfo:MovieClip;
      
      public var tCountdown:TextField;
      
      public var mcReward:MovieClip;
      
      public function MR3EventHUD_CLIP()
      {
         super();
      }
   }
}
