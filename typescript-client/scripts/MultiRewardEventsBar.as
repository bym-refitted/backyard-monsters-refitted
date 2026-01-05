package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="MultiRewardEventsBar")]
   public dynamic class MultiRewardEventsBar extends MovieClip
   {
       
      
      public var mcBackground:MovieClip;
      
      public var progressBarOverlay:MovieClip;
      
      public var buttonAction:MovieClip;
      
      public var reward0:EventRewardRibbon;
      
      public var reward1:EventRewardRibbon;
      
      public var reward2:EventRewardRibbon;
      
      public var buttonActionLabel:TextField;
      
      public var timeLabel:TextField;
      
      public var buttonHelp:MovieClip;
      
      public var eventImage:MovieClip;
      
      public var progressBarFill:MovieClip;
      
      public var logoImage:MovieClip;
      
      public var tScore:TextField;
      
      public var progressBarFillMask:MovieClip;
      
      public function MultiRewardEventsBar()
      {
         super();
      }
   }
}
