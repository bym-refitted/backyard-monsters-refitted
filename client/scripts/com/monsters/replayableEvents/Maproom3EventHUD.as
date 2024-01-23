package com.monsters.replayableEvents
{
   import com.monsters.chat.Chat;
   import com.monsters.display.ImageCache;
   import com.monsters.event_store.EventStorePopup;
   import com.monsters.maproom3.MapRoom3;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   
   public class Maproom3EventHUD extends MR3EventHUD_CLIP implements IReplayableEventUI
   {
      
      private static const k_preEventState:uint = 1;
      
      private static const k_duringEventState:uint = 2;
      
      private static const k_postEventState:uint = 3;
       
      
      private var m_state:uint;
      
      private var m_event:ReplayableEvent;
      
      private var m_HUDImage:Bitmap;
      
      public function Maproom3EventHUD()
      {
         super();
      }
      
      private function getCurrentState() : uint
      {
         if(this.m_event.hasEventEnded)
         {
            return k_postEventState;
         }
         if(this.m_event.hasEventStarted)
         {
            return k_duringEventState;
         }
         return k_preEventState;
      }
      
      public function get eventUI() : DisplayObject
      {
         return this;
      }
      
      public function setup(param1:ReplayableEvent) : void
      {
         this.m_event = param1;
         bInfo.Setup(KEYS.Get("btn_info"));
         this.updateState();
         this.update();
         mouseEnabled = false;
      }
      
      protected function clickedInfoButton(param1:MouseEvent) : void
      {
         EventStorePopup.instance.Show(0);
      }
      
      public function update() : void
      {
         if(this.m_state != this.getCurrentState())
         {
            this.updateState();
         }
         if(this.m_state >= k_duringEventState)
         {
            tExperience.text = ">" + GLOBAL.FormatNumber(ReplayableEventHandler.eventXP) + "XP";
            tCountdown.text = GLOBAL.ToTime(this.m_event.timeUntilNextDate,true,false,false);
         }
         else
         {
            tCountdown.text = GLOBAL.ToTime(this.m_event.timeUntilNextDate,true);
         }
         this.resize();
      }
      
      private function updateState() : void
      {
         this.m_state = this.getCurrentState();
         bInfo.addEventListener(MouseEvent.CLICK,this.clickedInfoButton,false,0,true);
         if(this.m_state >= k_duringEventState)
         {
            gotoAndStop(2);
            tExperience.visible = true;
            ImageCache.GetImageWithCallBack(this.m_event.eventHUDImageURL,this.loadedHUDImage);
         }
         else
         {
            gotoAndStop(1);
            tExperience.visible = false;
            ImageCache.GetImageWithCallBack(this.m_event.preEventHUDImageURL,this.loadedHUDImage);
         }
      }
      
      private function resize() : void
      {
         x = GLOBAL._SCREEN.x;
         if(Boolean(MapRoom3.mapRoom3WindowHUD) && Boolean(MapRoom3.mapRoom3WindowHUD.leftMenuButtonsBar))
         {
            y = MapRoom3.mapRoom3WindowHUD.leftMenuButtonsBar.y;
            y -= this.height;
         }
         else if(Chat._bymChat && Chat._bymChat.chatBox && Boolean(Chat._bymChat.chatBox.background))
         {
            y = Chat._bymChat.y + Chat._bymChat.chatBox.background.y;
            y -= this.height;
         }
         else
         {
            y = GLOBAL._SCREEN.y + (GLOBAL._SCREEN.height - this.height);
         }
      }
      
      private function loadedHUDImage(param1:String, param2:BitmapData) : void
      {
         if(this.m_HUDImage)
         {
            removeChild(this.m_HUDImage);
         }
         this.m_HUDImage = new Bitmap(param2);
         addChildAt(this.m_HUDImage,0);
      }
   }
}
