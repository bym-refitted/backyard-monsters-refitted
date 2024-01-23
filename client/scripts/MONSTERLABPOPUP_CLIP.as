package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="MONSTERLABPOPUP_CLIP")]
   public dynamic class MONSTERLABPOPUP_CLIP extends MovieClip
   {
       
      
      public var tStatusDesc:TextField;
      
      public var tStatusTitle:TextField;
      
      public var tStatsPBarLabel:TextField;
      
      public var tProgress:TextField;
      
      public var tStatsPBar:TextField;
      
      public var title_txt:TextField;
      
      public var bContinue:Button_CLIP;
      
      public var mcList:MovieClip;
      
      public var txtGuide:TextField;
      
      public var tStatsWarning:TextField;
      
      public var mcInstant:MovieClip;
      
      public var tIdle:TextField;
      
      public var mcResources:MovieClip;
      
      public var mcPBarStatus:creatureBarAdv;
      
      public var mcPBarStats:creatureBarAdv;
      
      public var mcStatusIcon:MovieClip;
      
      public var mcFrame:frame_CLIP;
      
      public var tStatsTitle:TextField;
      
      public var bAction:Button_CLIP;
      
      public var mcPortraitIcon:MovieClip;
      
      public function MONSTERLABPOPUP_CLIP()
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
