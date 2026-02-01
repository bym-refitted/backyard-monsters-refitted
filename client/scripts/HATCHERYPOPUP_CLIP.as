package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import com.monsters.utils.MovieClipUtils;
   
   [Embed(source="/_assets/assets.swf", symbol="HATCHERYPOPUP_CLIP")]
   public dynamic class HATCHERYPOPUP_CLIP extends MovieClip
   {
       
      
      public var mcCount4:MovieClip;
      
      public var monsterCanvas:MovieClip;
      
      public var mcRemove4:buttonClose_CLIP;
      
      public var tProgress:TextField;
      
      public var mcCount2:MovieClip;
      
      public var mcMonsterInfo:MovieClip;
      
      public var monsterMask:MovieClip;
      
      public var mcCount3:MovieClip;
      
      public var title_txt:TextField;
      
      public var mcCount1:MovieClip;
      
      public var bProgress:creatureBar;
      
      public var bContinue:Button_CLIP;
      
      public var slot0:HatcheryMonsterIcon_CLIP;
      
      public var txtGuide:TextField;
      
      public var bFinish:MovieClip;
      
      public var slot1:HatcheryMonsterIcon_CLIP;
      
      public var scroller:ScrollSet_CLIP;
      
      public var slot2:HatcheryMonsterIcon_CLIP;
      
      public var slot3:HatcheryMonsterIcon_CLIP;
      
      public var slot4:HatcheryMonsterIcon_CLIP;
      
      public var mcRemove3:buttonClose_CLIP;
      
      public var portrait1:MovieClip;
      
      public var mcRemove2:buttonClose_CLIP;
      
      public var mcFrame:frame_CLIP;
      
      public var mcOverdrive:MovieClip;
      
      public var mcRemove1:buttonClose_CLIP;
      
      public var mcMessage:MovieClip;
      
      public var mcRemove0:buttonClose_CLIP;
      
      public var bSpeedup:MovieClip;
      
      public function HATCHERYPOPUP_CLIP()
      {
         super();
         MovieClipUtils.stopAll(this);
      }
   }
}
