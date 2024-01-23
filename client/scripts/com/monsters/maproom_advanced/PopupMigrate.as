package com.monsters.maproom_advanced
{
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PopupMigrate extends MapRoomPopup_Migrate_CLIP
   {
      
      private static var instance:PopupMigrate;
       
      
      private var _closeHandler:Function;
      
      public function PopupMigrate(param1:Function = null)
      {
         var _loc5_:icon_costs = null;
         super();
         this._closeHandler = param1;
         var _loc2_:int = GLOBAL._bMap.InstantUpgradeCost();
         var _loc3_:Object = GLOBAL._bMap.UpgradeCost();
         tTitle.htmlText = KEYS.Get("msg_mr2pop_title");
         tDescription.htmlText = KEYS.Get("msg_mr2pop_desc");
         ImageCache.GetImageWithCallBack("popups/outpost-takeover.png",this.onAssetLoaded);
         mcInstant.tDescription.htmlText = KEYS.Get("buildoptions_upgradeinstant");
         mcInstant.bAction.Setup("<b>" + KEYS.Get("btn_useshiny",{"v1":_loc2_}) + "</b>");
         mcInstant.bAction.Highlight = true;
         mcInstant.bAction.addEventListener(MouseEvent.CLICK,this.InstantUpgrade,false,0,true);
         mcInstant.gCoin.mouseEnabled = false;
         mcInstant.gCoin.mouseChildren = false;
         mcResources.bAction.SetupKey("buildoptions_resources");
         mcResources.bAction.addEventListener(MouseEvent.CLICK,this.Upgrade,false,0,true);
         var _loc4_:Array = GLOBAL._resourceNames;
         var _loc6_:int = 1;
         while(_loc6_ < 5)
         {
            (_loc5_ = mcResources["mcR" + _loc6_] as icon_costs).tTitle.htmlText = "<b>" + KEYS.Get(_loc4_[_loc6_ - 1]) + "</b>";
            _loc5_.tValue.htmlText = "<b>" + GLOBAL.FormatNumber(_loc3_["r" + _loc6_]) + "</b>";
            if(Boolean(BASE._resources["r" + _loc6_]) && BASE._resources["r" + _loc6_].Get() < _loc3_["r" + _loc6_])
            {
               _loc5_.tValue.htmlText = "<font color=\"#FF0000\">" + _loc5_.tValue.htmlText + "</font>";
            }
            _loc5_.gotoAndStop(_loc6_);
            _loc6_++;
         }
         _loc5_ = mcResources.mcTime;
         mcResources.mcTime.tTitle.htmlText = "<b>" + KEYS.Get(_loc4_[5]) + "</b>";
         mcResources.mcTime.tValue.htmlText = "<b>" + GLOBAL.ToTime(_loc3_.time,true,false) + "</b>";
         mcResources.mcTime.gotoAndStop(_loc6_);
      }
      
      public static function Show(param1:Function = null) : void
      {
         if(instance)
         {
            Hide();
         }
         instance = new PopupMigrate(param1);
         GLOBAL._layerWindows.addChild(instance);
         POPUPSETTINGS.AlignToCenter(instance);
         POPUPSETTINGS.ScaleUp(instance);
      }
      
      public static function Hide() : void
      {
         if(!instance)
         {
            return;
         }
         GLOBAL._layerWindows.removeChild(instance);
         instance = null;
      }
      
      public function Hide() : void
      {
         if(Boolean(this._closeHandler))
         {
            this._closeHandler();
         }
         PopupMigrate.Hide();
      }
      
      private function onAssetLoaded(param1:String, param2:BitmapData) : void
      {
         mcImage.addChild(new Bitmap(param2));
      }
      
      private function InstantUpgrade(param1:Event) : void
      {
         this.Hide();
         GLOBAL._bMap.DoInstantUpgrade();
      }
      
      private function Upgrade(param1:Event) : void
      {
         this.Hide();
         GLOBAL._bMap.Upgrade();
      }
   }
}
