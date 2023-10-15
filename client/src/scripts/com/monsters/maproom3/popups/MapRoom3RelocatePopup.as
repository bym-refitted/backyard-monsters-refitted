package com.monsters.maproom3.popups
{
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom3.data.MapRoom3FriendData;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.events.MouseEvent;
   
   public class MapRoom3RelocatePopup extends MapRoom3RelocateMainYardPopup
   {
      
      private static var s_Instance:com.monsters.maproom3.popups.MapRoom3RelocatePopup = null;
      
      public static const k_RELOCATE_BUTTONINFO:String = "btn_relocateYard";
      
      private static const k_MAX_FRIEND_ITEMS_TO_DISPLAY:int = 6;
       
      
      private var m_LoadedFriendData:Vector.<MapRoom3FriendData>;
      
      private var m_DisplayList:com.monsters.maproom3.popups.MapRoom3RelocatePopupDisplayList;
      
      private var m_IsShowing:Boolean = false;
      
      public function MapRoom3RelocatePopup(param1:SingletonLock)
      {
         super();
         titleText.htmlText = KEYS.Get("mr3_relocate_main_yard_title");
         selectDescriptionText.htmlText = KEYS.Get("mr3_relocate_main_yard_description_select");
         randomDescriptionText.htmlText = KEYS.Get("mr3_relocate_main_yard_description_random");
         orText.htmlText = KEYS.Get("mr3_relocate_main_yard_or");
         levelTitleText.htmlText = "<b>" + KEYS.Get("mr3_relocate_main_yard_title_level") + "</b>";
         nameTitletext.htmlText = "<b>" + KEYS.Get("mr3_relocate_main_yard_title_name") + "</b>";
         worldtTitleText.htmlText = "<b>" + KEYS.Get("mr3_relocate_main_yard_title_world") + "</b>";
         randomButton.SetupKey("btn_random");
         randomButton.addEventListener(MouseEvent.CLICK,this.OnRandomButtonClicked,false,0,true);
         contentsFrame.mouseEnabled = false;
         contentsMask.mouseEnabled = false;
      }
      
      public static function get instance() : com.monsters.maproom3.popups.MapRoom3RelocatePopup
      {
         return s_Instance = s_Instance || new com.monsters.maproom3.popups.MapRoom3RelocatePopup(new SingletonLock());
      }
      
      public function Show() : void
      {
         if(this.m_IsShowing == true)
         {
            return;
         }
         POPUPS.Push(this);
         this.m_IsShowing = true;
         var _loc1_:* = MapRoomManager.instance.mapRoom3URL + "getfriendinfo";
         new URLLoaderApi().load(_loc1_,null,this.OnFriendInfoLoaded);
      }
      
      private function OnFriendInfoLoaded(param1:Object) : void
      {
         if(this.m_IsShowing == false)
         {
            return;
         }
         if(param1 == null || param1.hasOwnProperty("friends") == false || param1.friends.length == 0)
         {
            return;
         }
         var _loc2_:uint = uint(param1.friends.length);
         this.m_LoadedFriendData = new Vector.<MapRoom3FriendData>(_loc2_);
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            this.m_LoadedFriendData[_loc3_] = new MapRoom3FriendData(param1.friends[_loc3_]);
            _loc3_++;
         }
         this.m_DisplayList = new com.monsters.maproom3.popups.MapRoom3RelocatePopupDisplayList(this.m_LoadedFriendData,k_MAX_FRIEND_ITEMS_TO_DISPLAY);
         contentsContainer.addChild(this.m_DisplayList);
      }
      
      public function Hide() : void
      {
         if(this.m_IsShowing == false)
         {
            return;
         }
         POPUPS.Next();
         this.m_IsShowing = false;
         if(this.m_DisplayList != null)
         {
            contentsContainer.removeChild(this.m_DisplayList);
            this.m_DisplayList.Clear();
            this.m_DisplayList = null;
         }
         if(this.m_LoadedFriendData != null)
         {
            this.m_LoadedFriendData.length = 0;
            this.m_LoadedFriendData = null;
         }
      }
      
      private function OnRandomButtonClicked(param1:MouseEvent) : void
      {
         this.Relocate();
      }
      
      internal function Relocate(param1:int = -1) : void
      {
         if(GLOBAL._flags.nwm_relocate == "0")
         {
            GLOBAL.Message(KEYS.Get("mr3_relocate_confirmationOFF"),KEYS.Get("mr3_relocate_confirmation_OK"),this.ConfirmRelocation,[param1]);
         }
         else if(GLOBAL._flags.nwm_relocate == "1")
         {
            GLOBAL.Message(KEYS.Get("mr3_relocate_confirmation"),KEYS.Get("mr3_relocate_confirmation_yes"),this.ConfirmRelocation,[param1]);
         }
      }
      
      private function ConfirmRelocation(param1:int = -1) : void
      {
         this.Hide();
         PLEASEWAIT.Show(KEYS.Get("wait_relocating"));
         var url:* = MapRoomManager.instance.mapRoom3URL + "relocate";
         var _loc3_:Array = [];
         if(param1 != -1)
         {
            _loc3_.push(["userid",param1]);
         }
         new URLLoaderApi().load(url,_loc3_,this.OnRelocationSuccessful,this.OnRelocationFailed);
      }
      
      private function OnRelocationSuccessful(serverData:Object) : void
      {
         PLEASEWAIT.Hide();
         if(serverData.error != 0)
         {
            GLOBAL.ErrorMessage("Error relocating main base, MapRoom3RelocatePopup::OnRelocationSuccessful");
            LOGGER.Log("err","Error relocating main base, MapRoom3RelocatePopup::OnRelocationSuccessful " + serverData.error);
            return;
         }
         MapRoomManager.instance.OnMapRoom3RelocationSuccessful(serverData.mapheaderurl);
         BASE.LoadBase(null,0,0,GLOBAL.e_BASE_MODE.BUILD,false,EnumYardType.PLAYER);
      }
      
      private function OnRelocationFailed(param1:Object) : void
      {
         PLEASEWAIT.Hide();
         GLOBAL.ErrorMessage("Error relocating main base, MapRoom3RelocatePopup::OnRelocationFailed");
         LOGGER.Log("err","Error relocating main base, MapRoom3RelocatePopup::OnRelocationFailed " + param1.error);
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
