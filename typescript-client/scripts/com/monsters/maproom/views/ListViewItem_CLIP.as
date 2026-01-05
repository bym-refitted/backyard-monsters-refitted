package com.monsters.maproom.views
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="com.monsters.maproom.views.ListViewItem_CLIP")]
   public dynamic class ListViewItem_CLIP extends MovieClip
   {
       
      
      public var online_txt:TextField;
      
      public var name_txt:TextField;
      
      public var placeholder:MovieClip;
      
      public var userid_txt:TextField;
      
      public var levelStar:MovieClip;
      
      public var attackBtn:Button_CLIP;
      
      public var status_txt:TextField;
      
      public var dot:MovieClip;
      
      public var attacks_txt:TextField;
      
      public var helpBtn:Button_CLIP;
      
      public var msgBtn:Button_CLIP;
      
      public var truceBtn:Button_CLIP;
      
      public var extraStatus_txt:TextField;
      
      public function ListViewItem_CLIP()
      {
         super();
      }
   }
}
