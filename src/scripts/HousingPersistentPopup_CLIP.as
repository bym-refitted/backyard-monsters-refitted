package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class HousingPersistentPopup_CLIP extends MovieClip
   {
       
      
      public var tTitleBunkers:TextField;
      
      public var title_txt:TextField;
      
      public var tHealthText:TextField;
      
      public var tCapacityText:TextField;
      
      public var m_bgWhite:MovieClip;
      
      public var bJuice:Button_CLIP;
      
      public var m_line:MovieClip;
      
      public var tJuicingText:TextField;
      
      public var bHealAll:Button_CLIP;
      
      public var bClear:Button_CLIP;
      
      public var tTitleHousing:TextField;
      
      public var capacity_desc_txt:TextField;
      
      public var monsterContainerMask:MovieClip;
      
      public var tStorage:TextField;
      
      public var tAscendText:TextField;
      
      public var tTitleHealing:TextField;
      
      public var monsterContainer:MovieClip;
      
      public var mcStorage:MovieClip;
      
      public var bTransfer:Button_CLIP;
      
      public function HousingPersistentPopup_CLIP()
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
