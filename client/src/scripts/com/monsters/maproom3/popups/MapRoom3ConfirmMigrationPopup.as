package com.monsters.maproom3.popups
{
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.events.MouseEvent;
   
   public class MapRoom3ConfirmMigrationPopup extends popup_new_map_confirm
   {
      
      private static var s_Instance:com.monsters.maproom3.popups.MapRoom3ConfirmMigrationPopup = null;
       
      
      private var m_IsShowing:Boolean = false;
      
      public function MapRoom3ConfirmMigrationPopup(param1:SingletonLock)
      {
         super();
      }
      
      public static function get instance() : com.monsters.maproom3.popups.MapRoom3ConfirmMigrationPopup
      {
         return s_Instance = s_Instance || new com.monsters.maproom3.popups.MapRoom3ConfirmMigrationPopup(new SingletonLock());
      }
      
      public function Show(param1:Boolean = false) : void
      {
         if(this.m_IsShowing == true)
         {
            return;
         }
         tfTitle.htmlText = KEYS.Get("nwm_confirm_title");
         tfBody.htmlText = KEYS.Get("nwm_confirm");
         btnJuice.SetupKey("btn_joinnow");
         btnJuice.addEventListener(MouseEvent.CLICK,this.OnConfirmButtonClicked,false,0,true);
         btnJuice.Highlight = true;
         btnCancel.SetupKey("btn_cancel");
         btnCancel.addEventListener(MouseEvent.CLICK,this.OnCancelButtonClicked,false,0,true);
         if(param1)
         {
            tfBody.htmlText = KEYS.Get("nwm_confirm_force");
            btnJuice.SetupKey("btn_ok");
            btnJuice.x = 0;
            btnCancel.visible = false;
            mcFrame.Setup(false);
         }
         POPUPS.Push(this);
         this.m_IsShowing = true;
      }
      
      public function Hide() : void
      {
         btnJuice.removeEventListener(MouseEvent.CLICK,this.OnConfirmButtonClicked);
         btnCancel.removeEventListener(MouseEvent.CLICK,this.OnCancelButtonClicked);
         SOUNDS.Play("close");
         POPUPS.Next();
         this.m_IsShowing = false;
      }
      
      public function Resize() : void
      {
         this.x = GLOBAL._SCREENCENTER.x;
         this.y = GLOBAL._SCREENCENTER.y;
      }
      
      private function OnConfirmButtonClicked(param1:MouseEvent) : void
      {
         this.Hide();
         MapRoomManager.instance.UpgradeToMapRoom3();
      }
      
      private function OnCancelButtonClicked(param1:MouseEvent) : void
      {
         this.Hide();
      }
   }
}

class SingletonLock
{
    
   
   public function SingletonLock()
   {
      super();
   }
}
