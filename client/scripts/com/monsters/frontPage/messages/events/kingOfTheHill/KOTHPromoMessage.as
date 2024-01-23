package com.monsters.frontPage.messages.events.kingOfTheHill
{
   import com.monsters.frontPage.messages.KeywordMessage;
   import com.monsters.frontPage.messages.Message;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class KOTHPromoMessage extends Message
   {
       
      
      private const _EVENT_PAGE_URL:String = "http://www.kixeye.com/hunt-for-krallen/";
      
      protected var _action:Function;
      
      public function KOTHPromoMessage(param1:String)
      {
         if(MapRoomManager.instance.isInMapRoom2or3)
         {
            this._action = this.rsvp;
            _buttonCopy = "btn_rsvp";
            body = param1;
         }
         else
         {
            body = param1 + "mr1";
            if(Boolean(GLOBAL._bMap) && GLOBAL.townHall._lvl.Get() >= 6)
            {
               this._action = this.upgradeMapRoom;
               _buttonCopy = "btn_upgradenow";
            }
         }
         super(KeywordMessage.PREFIX + param1 + "_title",KeywordMessage.PREFIX + body + "_desc",KeywordMessage.PREFIX + param1 + ".jpg",_buttonCopy);
      }
      
      override protected function onButtonClick() : void
      {
         this._action();
      }
      
      private function rsvp() : void
      {
         navigateToURL(new URLRequest(this._EVENT_PAGE_URL));
      }
      
      protected function upgradeMapRoom() : void
      {
         upgradeBuilding(MAPROOM.TYPE);
      }
   }
}
