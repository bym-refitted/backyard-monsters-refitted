package com.monsters.replayableEvents.attacking.hellRaisers.popups
{
   import com.monsters.display.ImageCache;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class HellRaisersBattleSummary
   {
      
      private static const k_winImageURL:String = "events/hellraisers/hellraisers_win.jpg";
      
      private static const k_loseImageURL:String = "events/hellraisers/hellraisers_lose.jpg";
       
      
      private var m_graphic:HellRaisersBattleSummary_CLIP;
      
      public function HellRaisersBattleSummary(param1:Boolean, param2:uint)
      {
         var _loc3_:String = null;
         super();
         this.m_graphic = new HellRaisersBattleSummary_CLIP();
         if(param1)
         {
            _loc3_ = k_winImageURL;
         }
         else
         {
            _loc3_ = k_loseImageURL;
         }
         ImageCache.GetImageWithCallBack(_loc3_,this.loadedImage);
         this.m_graphic.tBody.htmlText = ">YOU GOT SUM POINTS, LOL :" + param2;
         this.m_graphic.bAction.Setup(KEYS.Get("btn_openmap"));
         this.m_graphic.bAction.addEventListener(MouseEvent.CLICK,this.clickedActionButton);
      }
      
      protected function clickedActionButton(param1:Event) : void
      {
         MapRoomManager.instance.SetupAndShow();
      }
      
      private function loadedImage(param1:String, param2:BitmapData) : void
      {
         var _loc3_:Bitmap = new Bitmap(param2);
         this.m_graphic.mcImage.addChild(_loc3_);
      }
      
      public function get graphic() : MovieClip
      {
         return this.m_graphic;
      }
   }
}
