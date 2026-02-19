package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import com.monsters.utils.MovieClipUtils;
   
   [Embed(source="/_assets/assets.swf", symbol="MonsterBunkerPopup_Persistent_CLIP")]
   public dynamic class MonsterBunkerPopup_Persistent_CLIP extends MovieClip
   {
       
      
      public var mcHousing:MovieClip;
      
      public var transferCanvasBmask:MovieClip;
      
      public var transferCanvasA:MovieClip;
      
      public var transferCanvasAmask:MovieClip;
      
      public var tNoMonsters:TextField;
      
      public var tSize1:TextField;
      
      public var title_txt:TextField;
      
      public var tTransfer2:TextField;
      
      public var tSize2:TextField;
      
      public var bContinue:Button_CLIP;
      
      public var tStored:TextField;
      
      public var tTransfer1:TextField;
      
      public var txtGuide:TextField;
      
      public var tHoused:TextField;
      
      public var tHousing:TextField;
      
      public var scrollerA:MovieClip;
      
      public var tAvailable1:TextField;
      
      public var tAvailable2:TextField;
      
      public var transferCanvasB:MovieClip;
      
      public var scrollerB:MovieClip;
      
      public var mcStorage:MovieClip;
      
      public var tCapacity:TextField;
      
      public function MonsterBunkerPopup_Persistent_CLIP()
      {
         super();
         MovieClipUtils.stopAll(this);
      }
   }
}
