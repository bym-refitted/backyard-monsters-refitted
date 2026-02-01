package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="PopupInfoMine_CLIP")]
   public dynamic class PopupInfoMine_CLIP extends MovieClip
   {
       
      
      public var mMonstersMask:MovieClip;
      
      public var mcArrow:MovieClip;
      
      public var tName:TextField;
      
      public var bInviteMigrate:Button_CLIP;
      
      public var mMonsters:MovieClip;
      
      public var tHeight:TextField;
      
      public var tLabel1:TextField;
      
      public var bOpen:Button_CLIP;
      
      public var tLabel2:TextField;
      
      public var txtButtonInfo:TextField;
      
      public var tLabel3:TextField;
      
      public var tBonus:TextField;
      
      public var bMonsters:Button_CLIP;
      
      public var tLabel4:TextField;
      
      public var tLocation:TextField;
      
      public var scroll:MovieClip;
      
      public var mcFrame:frame_CLIP;
      
      public var bRelocate:Button_CLIP;
      
      public var bBookmark:Button_CLIP;
      
      public function PopupInfoMine_CLIP()
      {
         super();
         if (mcArrow) mcArrow.stop();
      }
   }
}
