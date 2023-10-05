package com.monsters.maproom3.popups
{
   import com.monsters.maproom3.data.MapRoom3FriendData;
   import flash.display.Loader;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class MapRoom3RelocatePopupItemDisplay extends MapRoom3RelocateMainYardPopupFriendItemDisplay
   {
      
      private static const PORTRAIT_WIDTH:int = 50;
      
      private static const PORTRAIT_HEIGHT:int = 50;
       
      
      private var m_FriendToDisplay:MapRoom3FriendData;
      
      private var m_ProfilePicture:Loader;
      
      public function MapRoom3RelocatePopupItemDisplay(param1:MapRoom3FriendData)
      {
         super();
         this.m_FriendToDisplay = param1;
         this.m_ProfilePicture = new Loader();
         this.m_ProfilePicture.load(new URLRequest("http://graph.facebook.com/" + this.m_FriendToDisplay.facebookId + "/picture"));
         this.m_ProfilePicture.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.OnProfilePictureIOErrorEvent,false,0,true);
         imageHolder.addChild(this.m_ProfilePicture);
         levelIcon.lv_txt.htmlText = "<b>" + this.m_FriendToDisplay.level + "</b>";
         nameText.htmlText = "<b>" + param1.name + "</b>";
         nameText.mouseEnabled = false;
         var _loc2_:String = param1.isInPlayersWorld ? KEYS.Get("mr3_relocate_main_yard_same") : KEYS.Get("mr3_relocate_main_yard_world",{"v1":param1.world});
         worldText.htmlText = "<b>" + _loc2_ + "</b>";
         worldText.mouseEnabled = false;
         coordinatesText.htmlText = "(" + param1.baseX.toString() + "," + param1.baseY.toString() + ")";
         coordinatesText.mouseEnabled = false;
         if(!param1.isInPlayersWorld)
         {
            worldText.y = nameText.y;
            coordinatesText.visible = false;
         }
         relocateButton.SetupKey("btn_moveHere");
         relocateButton.addEventListener(MouseEvent.CLICK,this.OnRelocateButtonClicked,false,0,true);
         relocateButton.buttonMode = true;
      }
      
      private function OnProfilePictureIOErrorEvent(param1:IOErrorEvent) : void
      {
      }
      
      public function Clear() : void
      {
         relocateButton.removeEventListener(MouseEvent.CLICK,this.OnRelocateButtonClicked);
         this.m_ProfilePicture.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.OnProfilePictureIOErrorEvent);
         imageHolder.removeChild(this.m_ProfilePicture);
         this.m_FriendToDisplay = null;
      }
      
      private function OnRelocateButtonClicked(param1:MouseEvent) : void
      {
         if(this.m_FriendToDisplay != null)
         {
            MapRoom3RelocatePopup.instance.Relocate(this.m_FriendToDisplay.userId);
         }
      }
   }
}
