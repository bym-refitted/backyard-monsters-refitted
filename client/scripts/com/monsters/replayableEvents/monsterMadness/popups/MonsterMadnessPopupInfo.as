package com.monsters.replayableEvents.monsterMadness.popups
{
   import com.monsters.display.ImageCache;
   import com.monsters.replayableEvents.attacking.monsterMadness.MonsterMadness;
   import com.monsters.utils.VideoUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.NetStatusEvent;
   import flash.media.Video;
   import flash.net.NetStream;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class MonsterMadnessPopupInfo extends EventDispatcher
   {
      
      internal static const KOGOTH_SPINNING_VIDEO:String = "assets/specialevent/monstermadness/mc_promo_walk.flv";
      
      internal static const KOGOTH_SPINNING_STOMP_VIDEO:String = "assets/specialevent/monstermadness/mc_promo_attack.flv";
      
      internal static const KOGOTH_SPINNING_FIREBALL_VIDEO:String = "assets/specialevent/monstermadness/mc_promo_fireball.flv";
      
      internal static const KOGOTH_BRAG_IMAGE1:String = "G4_P1-90.png";
      
      internal static const KOGOTH_BRAG_IMAGE2:String = "G4_P2-90.png";
      
      internal static const KOGOTH_BRAG_IMAGE3:String = "G4_P3-90.png";
      
      public static const BANNER_IMAGE_LOCATION:String = "specialevent/monstermadness/bym_mm_banner_600x82.png";
      
      internal static const REMOVE_LOADING_CIRCLE:String = "removeLoadingCircle";
       
      
      public var isOnlySeenOnce:Boolean = false;
      
      private const _RSVP_URL:String = "https://www.facebook.com/events/193849810724330/";
      
      private var _videoStream:NetStream;
      
      public function MonsterMadnessPopupInfo()
      {
         super();
      }
      
      public function getBanner(param1:int) : String
      {
         return BANNER_IMAGE_LOCATION;
      }
      
      public function getCopy(param1:int) : String
      {
         return "";
      }
      
      public function getMedia(param1:int) : DisplayObject
      {
         return null;
      }
      
      public function setupButton(param1:Button, param2:int) : void
      {
      }
      
      public function setupButton2(param1:Button, param2:int) : void
      {
         param1.visible = false;
      }
      
      protected function setupVideo(param1:String) : Video
      {
         var _loc2_:Video = new Video(MonsterMadnessPopup._MEDIA_DIMENTIONS_X,MonsterMadnessPopup._MEDIA_DIMENTIONS_Y);
         this._videoStream = VideoUtils.getVideoStream(_loc2_,param1);
         this._videoStream.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatusUpdate);
         VideoUtils.loopStream(this._videoStream);
         return _loc2_;
      }
      
      private function onNetStatusUpdate(param1:NetStatusEvent) : void
      {
         if(param1.info.code == "NetStream.Play.Start")
         {
            dispatchEvent(new Event(REMOVE_LOADING_CIRCLE));
         }
      }
      
      protected function setupImage(param1:String) : Bitmap
      {
         var _loc2_:Bitmap = new Bitmap();
         ImageCache.GetImageWithCallBack(param1,this.onImageLoad,true,4,"",[_loc2_]);
         return _loc2_;
      }
      
      private function onImageLoad(param1:String, param2:BitmapData, param3:Array = null) : void
      {
         Bitmap(param3[0]).bitmapData = param2;
      }
      
      protected function setupUpgradeButton(param1:Button) : void
      {
         var _loc3_:Function = null;
         if(BASE.isInfernoMainYardOrOutpost)
         {
            this.setupRSVPButton(param1);
            return;
         }
         var _loc2_:BFOUNDATION = GLOBAL.townHall;
         var _loc4_:String = "btn_upgradenow";
         if(_loc2_._lvl.Get() >= 6)
         {
            if(GLOBAL._bMap)
            {
               _loc3_ = this.onClickUpgradeMaproom;
            }
            else
            {
               _loc3_ = this.onClickBuildMaproom;
               _loc4_ = "btn_buildnow";
            }
         }
         else
         {
            _loc3_ = this.onClickUpgradeTownhall;
         }
         param1.Setup(KEYS.Get(_loc4_));
         param1.addEventListener(MouseEvent.CLICK,_loc3_);
         param1.Highlight = true;
      }
      
      protected function onClickBuildMaproom(param1:MouseEvent) : void
      {
         this.close();
         param1.target.removeEventListener(MouseEvent.CLICK,this.onClickBuildMaproom);
         BUILDINGS._buildingID = 11;
         BUILDINGS.Show();
      }
      
      protected function onClickUpgradeMaproom(param1:MouseEvent) : void
      {
         this.close();
         param1.target.removeEventListener(MouseEvent.CLICK,this.onClickUpgradeMaproom);
         GLOBAL._selectedBuilding = GLOBAL._bMap;
         BUILDINGOPTIONS.Show(GLOBAL._bMap,"upgrade");
      }
      
      protected function onClickUpgradeTownhall(param1:MouseEvent) : void
      {
         this.close();
         param1.target.removeEventListener(MouseEvent.CLICK,this.onClickUpgradeTownhall);
         GLOBAL._selectedBuilding = GLOBAL.townHall;
         BUILDINGOPTIONS.Show(GLOBAL.townHall,"upgrade");
      }
      
      protected function setupRSVPButton(param1:Button) : void
      {
         if(MonsterMadness.hasEventStarted)
         {
            param1.visible = false;
            return;
         }
         param1.Setup(KEYS.Get("btn_rsvp"));
         param1.addEventListener(MouseEvent.CLICK,this.onClickRSVPButton);
         param1.Highlight = true;
      }
      
      private function onClickRSVPButton(param1:MouseEvent) : void
      {
         this.close();
         param1.target.removeEventListener(MouseEvent.CLICK,this.onClickRSVPButton);
         navigateToURL(new URLRequest(this._RSVP_URL));
      }
      
      protected function setupMapButtton(param1:Button) : void
      {
         if(BASE.isInfernoMainYardOrOutpost)
         {
            this.setupExitButton(param1);
            return;
         }
         param1.Setup(KEYS.Get("btn_openmap"));
         param1.addEventListener(MouseEvent.CLICK,this.onClickMapButton);
      }
      
      private function setupExitButton(param1:Button) : void
      {
         param1.Setup(KEYS.Get("btn_exitcavern"));
         param1.addEventListener(MouseEvent.CLICK,this.onClickExitButton);
      }
      
      protected function onClickExitButton(param1:MouseEvent) : void
      {
         this.close();
         INFERNOPORTAL.ToggleYard();
      }
      
      private function onClickMapButton(param1:MouseEvent) : void
      {
         this.close();
         param1.target.removeEventListener(MouseEvent.CLICK,this.onClickMapButton);
         GLOBAL.ShowMap();
      }
      
      protected function setupCloseButtton(param1:Button) : void
      {
         param1.Setup(KEYS.Get("btn_close"));
         param1.addEventListener(MouseEvent.CLICK,this.onClickCloseButton);
      }
      
      private function onClickCloseButton(param1:MouseEvent) : void
      {
         param1.target.removeEventListener(MouseEvent.CLICK,this.onClickCloseButton);
         this.close();
      }
      
      protected function ShowBrag(param1:String, param2:String, param3:String, param4:String) : void
      {
         GLOBAL.CallJS("sendFeed",[param1,KEYS.Get(param2),KEYS.Get(param3),param4]);
         this.close();
      }
      
      protected function close() : void
      {
         POPUPS.Next();
         if(this._videoStream)
         {
            this._videoStream.close();
         }
      }
   }
}
