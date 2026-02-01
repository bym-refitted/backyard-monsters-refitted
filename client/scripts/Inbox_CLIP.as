package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import com.monsters.utils.MovieClipUtils;
   
   [Embed(source="/_assets/assets.swf", symbol="Inbox_CLIP")]
   public dynamic class Inbox_CLIP extends MovieClip
   {
       
      
      public var outBtn:Button_CLIP;
      
      public var bNext:BUILDINGSARROW;
      
      public var subjectBtn:MovieClip;
      
      public var noMessages_btn:MovieClip;
      
      public var bPrevious:BUILDINGSARROW;
      
      public var title_txt:TextField;
      
      public var dateBtn:MovieClip;
      
      public var fromBtn:MovieClip;
      
      public var mask_mc:MovieClip;
      
      public var unreadBtn:MovieClip;
      
      public var mcFrame:frame_CLIP;
      
      public var newBtn:Button_CLIP;
      
      public var inBtn:Button_CLIP;
      
      public function Inbox_CLIP()
      {
         super();
         MovieClipUtils.stopAll(this);
      }
   }
}
