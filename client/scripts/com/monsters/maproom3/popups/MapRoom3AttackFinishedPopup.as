package com.monsters.maproom3.popups
{
   import com.monsters.maproom_manager.MapRoomManager;
   import config.singletonlock.SingletonLock;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MapRoom3AttackFinishedPopup extends popup_attackend_CLIP
   {
      
      private static var s_Instance:MapRoom3AttackFinishedPopup = null;
       
      
      public function MapRoom3AttackFinishedPopup(param1:SingletonLock)
      {
         super();
      }
      
      public static function get instance() : MapRoom3AttackFinishedPopup
      {
         return s_Instance = s_Instance || new MapRoom3AttackFinishedPopup(new SingletonLock());
      }
      
      public function Show(param1:Boolean) : void
      {
         if(param1)
         {
            this.tTitle.htmlText = KEYS.Get("newmap_destroyed");
            this.tMessage.htmlText = BASE.isOutpost ? KEYS.Get("newmap_des_pl1") : KEYS.Get("newmap_des_wm2");
         }
         else
         {
            this.tTitle.htmlText = KEYS.Get("popup_attackended_title");
            this.tMessage.htmlText = BASE.isOutpost ? KEYS.Get("mr3_popup_attackended_failedOutpost") : KEYS.Get("mr3_popup_attackended_failedWMYard");
         }
         this.tProcessing.htmlText = KEYS.Get("please_wait");
         this.mcFrame.Setup(false);
         this.bAction.Setup(KEYS.Get("btn_openmap"));
         this.bAction.Enabled = false;
         this.addEventListener(Event.ENTER_FRAME,this.OnEnterFrame);
         POPUPS.Push(this);
      }
      
      public function Hide() : void
      {
         POPUPS.Next();
      }
      
      private function OnEnterFrame(param1:Event) : void
      {
         if(BASE._saveCounterA != BASE._saveCounterB)
         {
            return;
         }
         this.bAction.Enabled = true;
         this.tProcessing.htmlText = "";
         this.bAction.addEventListener(MouseEvent.CLICK,this.OnActionButtonClicked);
         this.removeEventListener(Event.ENTER_FRAME,this.OnEnterFrame);
      }
      
      private function OnActionButtonClicked(param1:MouseEvent) : void
      {
         MapRoomManager.instance.SetupAndShow();
         POPUPS.Next();
      }
   }
}
