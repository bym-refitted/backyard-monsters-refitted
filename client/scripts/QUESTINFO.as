package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import com.monsters.utils.MovieClipUtils;
   
   [Embed(source="/_assets/assets.swf", symbol="QUESTINFO")]
   public dynamic class QUESTINFO extends MovieClip
   {
       
      
      public var mcArrow:MovieClip;
      
      public var R1:icon_costs_short;
      
      public var R2:icon_costs_short;
      
      public var tHint:TextField;
      
      public var R3:icon_costs_short;
      
      public var R4:icon_costs_short;
      
      public var bCollect:Button_CLIP;
      
      public var R5:icon_costs_short;
      
      public var mcImage:MovieClip;
      
      public var tReward:TextField;
      
      public var tDescription:TextField;
      
      public function QUESTINFO()
      {
         super();
         MovieClipUtils.stopAll(this);
      }
   }
}
