package com.monsters.frontPage.messages.events.kingOfTheHill
{
   import com.monsters.maproom_manager.MapRoomManager;
   
   public class KOTHStartMessage extends KOTHPromoMessage
   {
       
      
      public function KOTHStartMessage()
      {
         super("event_kothstart");
         if(MapRoomManager.instance.isInMapRoom2or3)
         {
            _action = this.openMapRoom;
            _buttonCopy = KEYS.Get("btn_openmap");
         }
         else if(Boolean(GLOBAL._bMap) && GLOBAL.townHall._lvl.Get() >= 6)
         {
            _buttonCopy = KEYS.Get("btn_upgradenow");
            _action = upgradeMapRoom;
         }
         var _loc1_:Boolean = false;
         if(_loc1_)
         {
            videoURL = "assets/popups/front_page/fp_event_kothstart.flv";
         }
         else
         {
            imageURL = "popups/front_page/fp_event_kothstart.v2.jpg";
         }
      }
      
      private function openMapRoom() : void
      {
         GLOBAL.ShowMap();
      }
   }
}
