package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class HOUSINGPOPUP_CLIP extends MovieClip
   {
       
      
      public var juicefooter_desc_txt:TextField;
      
      public var footer_desc_txt:TextField;
      
      public var ascend_desc_txt:TextField;
      
      public var title_txt:TextField;
      
      public var bCancel:Button_CLIP;
      
      public var bJuice:Button_CLIP;
      
      public var bAll:Button_CLIP;
      
      public var bAscend:Button_CLIP;
      
      public var capacity_desc_txt:TextField;
      
      public var monsterContainerMask:MovieClip;
      
      public var tStorage:TextField;
      
      public var monsterContainer:MovieClip;
      
      public var mcStorage:MovieClip;
      
      public function HOUSINGPOPUP_CLIP()
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
