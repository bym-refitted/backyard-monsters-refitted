package
{
   import com.monsters.display.ImageCache;
   import com.monsters.inventory.InventoryManager;
   import com.monsters.managers.InstanceManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class BUILDINGBUTTON extends BUILDINGBUTTON_CLIP
   {
      
      private static var s_LockedCallbacks:Array = [];
       
      
      public var _buildingProps:Object;
      
      public var _id:int;
      
      public function BUILDINGBUTTON()
      {
         super();
      }
      
      public static function setOnClickedWhenLockedCallback(param1:int, param2:Function) : void
      {
         s_LockedCallbacks[param1] = param2;
      }
      
      public function Setup(param1:int, param2:Boolean = true) : void
      {
         var _loc7_:BFOUNDATION = null;
         var _loc8_:* = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         this._id = param1;
         this._buildingProps = GLOBAL._buildingProps[this._id - 1];
         mouseChildren = false;
         if(param2)
         {
            if(this.isLocked)
            {
               addEventListener(MouseEvent.CLICK,this.ShowLockedInfo);
            }
            else
            {
               addEventListener(MouseEvent.CLICK,this.ShowInfo);
            }
            buttonMode = true;
         }
         tName.htmlText = "<b>" + KEYS.Get(this._buildingProps.name) + "</b>";
         mcSale.visible = this._buildingProps.sale == 1;
         mcSale.t.htmlText = "<b>" + KEYS.Get("ui_building_sale") + "</b>";
         mcNew.t.htmlText = "<b>" + KEYS.Get("str_new_caps") + "</b>";
         var _loc3_:int = GLOBAL.GetBuildingTownHallLevel(this._buildingProps);
         var _loc4_:int = _loc3_ < this._buildingProps.quantity.length ? int(this._buildingProps.quantity[_loc3_]) : int(this._buildingProps.quantity[this._buildingProps.quantity.length - 1]);
         var _loc5_:int = 0;
         var _loc6_:Vector.<Object> = InstanceManager.getInstancesByClass(!!this._buildingProps.cls ? this._buildingProps.cls : BFOUNDATION);
         for each(_loc7_ in _loc6_)
         {
            if(_loc7_._type === this._id)
            {
               _loc5_++;
            }
         }
         if(this.isLocked)
         {
            tQuantity.htmlText = "";
         }
         else if(this._buildingProps.type == "decoration")
         {
            if((_loc10_ = InventoryManager.buildingStorageCount(this._id)) > 0)
            {
               tQuantity.htmlText = "<font color=\"#0000CC\"><b>" + KEYS.Get("bdg_numinstorage",{"v1":_loc10_}) + "</b></font>";
            }
            else
            {
               tQuantity.htmlText = "<font color=\"#333333\"><b>" + STORE._storeItems["BUILDING" + this._id].c[0] + " " + KEYS.Get("#r_shiny#") + "</b></font>";
            }
         }
         else if(_loc5_ >= _loc4_)
         {
            tQuantity.htmlText = "<b><font color=\"#CC0000\">" + _loc5_ + " / " + _loc4_ + "</font></b>";
         }
         else
         {
            tQuantity.htmlText = "<b>" + _loc5_ + " / " + _loc4_ + "</b>";
         }
         if(_loc5_ <= 0 && Boolean(this._buildingProps.upgradeImgData))
         {
            _loc11_ = int.MAX_VALUE;
            for(_loc12_ in this._buildingProps.upgradeImgData)
            {
               if(!isNaN(Number(_loc12_)))
               {
                  _loc11_ = Math.min(_loc11_,Number(_loc12_));
               }
            }
            if(_loc11_ != int.MAX_VALUE && this._buildingProps.upgradeImgData[_loc11_].silhouette_img && !BASE.HasRequirements(this._buildingProps.costs[0]) && !this._buildingProps.rewarded)
            {
               _loc8_ = String(this._buildingProps.upgradeImgData.baseurl + this._buildingProps.upgradeImgData[_loc11_].silhouette_img);
            }
         }
         if(!_loc8_)
         {
            if(Boolean(this._buildingProps.buildingbuttons) && Boolean(BASE._buildingsStored["bl" + this._id]) && this._buildingProps.buildingbuttons.length >= BASE._buildingsStored["bl" + this._id].Get())
            {
               _loc8_ = "buildingbuttons/" + this._buildingProps.buildingbuttons[BASE._buildingsStored["bl" + this._id].Get() - 1] + ".jpg";
            }
            else if(Boolean(this._buildingProps.buildingbuttons) && this._buildingProps.buildingbuttons.length > 0)
            {
               _loc8_ = "buildingbuttons/" + this._buildingProps.buildingbuttons[0] + ".jpg";
            }
            else
            {
               _loc8_ = "buildingbuttons/" + this._id + ".jpg";
            }
         }
         var _loc9_:int = Math.max.apply(Math,this._buildingProps.quantity);
         mcShroud.visible = _loc5_ >= _loc4_ && _loc4_ > 0;
         mcCheck.visible = _loc5_ >= _loc9_ && _loc9_ > 0;
         mcNew.visible = false;
         if(GLOBAL._newThings && Boolean(this._buildingProps.isNew))
         {
            mcNew.visible = true;
         }
         ImageCache.GetImageWithCallBack(_loc8_,this.ImageLoaded);
         if(this.isLocked)
         {
            mcShroud.visible = true;
            if(this._buildingProps["lockedButtonOverlay"])
            {
               ImageCache.GetImageWithCallBack(this._buildingProps["lockedButtonOverlay"],this.OnLockedOverlayLoaded);
            }
         }
      }
      
      public function ImageLoaded(param1:String, param2:BitmapData) : void
      {
         mcBG.addChild(new Bitmap(param2));
      }
      
      private function OnLockedOverlayLoaded(param1:String, param2:BitmapData) : void
      {
         mcShroud.addChild(new Bitmap(param2));
      }
      
      public function ShowInfo(param1:MouseEvent) : void
      {
         SOUNDS.Play("click1");
         MovieClip(parent.parent).ShowInfo(this._id);
      }
      
      private function ShowLockedInfo(param1:MouseEvent) : void
      {
         var _loc2_:Function = s_LockedCallbacks[this._id];
         if(_loc2_ == null)
         {
            return;
         }
         SOUNDS.Play("click1");
         _loc2_();
      }
      
      private function get isLocked() : Boolean
      {
         return Boolean(this._buildingProps) && Boolean(this._buildingProps["locked"]);
      }
      
      public function Update() : void
      {
      }
   }
}
