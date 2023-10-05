package
{
   import com.monsters.configs.BYMDevConfig;
   import com.monsters.display.ImageCache;
   import com.monsters.inventory.InventoryManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.external.ExternalInterface;
   import flash.net.*;
   import gs.TweenLite;
   
   public class BUY
   {
      
      public static var forceNCP:Boolean = false;
      
      public static var cacheNCPAvailable:String;
       
      
      public function BUY()
      {
         super();
      }
      
      public static function Show(param1:MouseEvent = null) : void
      {
         LOGGER.Stat([22]);
         GLOBAL.CallJS("cc.showTopup",[{
            "type":"fbc",
            "callback":"fbcAdd"
         }]);
      }
      
      public static function Offers(param1:String) : void
      {
         switch(param1)
         {
            case "daily":
               GLOBAL.CallJS("cc.showTopup",[{
                  "type":"daily",
                  "callback":"fbcOfferDaily"
               }]);
               break;
            case "earn":
               GLOBAL.CallJS("cc.showTopup",[{
                  "type":"offers",
                  "callback":"fbcOfferEarn"
               }]);
         }
      }
      
      public static function FBCAdd(param1:String) : void
      {
         var _loc2_:Object = JSON.decode(param1);
         if(!_loc2_.status)
         {
            LOGGER.Log("err","FBCAdd " + param1);
         }
      }
      
      public static function FBCOfferEarn(param1:String) : void
      {
         var _loc2_:Object = JSON.decode(param1);
         if(_loc2_.status)
         {
            if(_loc2_.status != "settled")
            {
               if(_loc2_.status != "failed")
               {
                  if(_loc2_.status == "canceled")
                  {
                  }
               }
            }
         }
         else
         {
            LOGGER.Log("err","FBCDailyEarn " + param1);
         }
      }
      
      public static function FBCOfferDaily(param1:String) : void
      {
         var _loc2_:Object = JSON.decode(param1);
         if(_loc2_.status)
         {
            if(_loc2_.status != "settled")
            {
               if(_loc2_.status != "failed")
               {
                  if(_loc2_.status == "canceled")
                  {
                  }
               }
            }
         }
         else
         {
            LOGGER.Log("err","FBCDailyEarn " + param1);
         }
      }
      
      public static function FBCNcpCheckEligibility() : Boolean
      {
         if(GLOBAL._fbcncp > 0 && (GLOBAL._flags && GLOBAL._flags.fbcncpshow != -1))
         {
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard && TUTORIAL._stage > 200 && GLOBAL._sessionCount >= 5)
            {
               if(!GLOBAL._flags.viximo && !GLOBAL._flags.kongregate && ExternalInterface.available)
               {
                  if(cacheNCPAvailable)
                  {
                     BUY.FBCNcp(cacheNCPAvailable);
                  }
                  else
                  {
                     if(BYMDevConfig.instance.USE_CLIENT_WITH_CALLBACK)
                     {
                        GLOBAL.CallJSWithClient("cc.ncp","fbcNcp",["checkEligibility"]);
                     }
                     else
                     {
                        GLOBAL.CallJS("cc.ncp",["checkEligibility","fbcNcp"]);
                     }
                     FBCNcpUpgradeTimeout();
                  }
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function FBCNcpUpgradeTimeout() : void
      {
         TweenLite.killDelayedCallsTo(BUY.FBCNcpCancelled);
         TweenLite.delayedCall(5,BUY.FBCNcpCancelled,["timeout",false]);
      }
      
      public static function FBCNcp(param1:String) : void
      {
         var _loc2_:MovieClip = null;
         print("|BUY| - FBCNCP CallBack");
         TweenLite.killDelayedCallsTo(BUY.FBCNcpCancelled);
         if(param1 == "1" || param1 == "2")
         {
            cacheNCPAvailable = param1;
            _loc2_ = new FACEBOOK_NCP_CLIP();
            _loc2_.bYes.buttonMode = true;
            _loc2_.bYes.useHandCursor = true;
            _loc2_.bYes.mouseChildren = false;
            _loc2_.bYes.alpha = 0;
            _loc2_.bYes.addEventListener(MouseEvent.CLICK,FBCNcp_Click);
            _loc2_.bNo.buttonMode = true;
            _loc2_.bNo.useHandCursor = true;
            _loc2_.bNo.mouseChildren = false;
            _loc2_.bNo.alpha = 0;
            _loc2_.bNo.addEventListener(MouseEvent.CLICK,BUY.FBCNcpCancelled);
            FBCNcpRender("upgrade",_loc2_.imageHolder);
            POPUPS.Push(_loc2_,null,null,null,null,false);
         }
         else
         {
            if(param1 == "0")
            {
               cacheNCPAvailable = param1;
            }
            LOGGER.Log("log","FBCNcp Not Elligible" + param1);
            FBCNcpUpgradeCB();
         }
      }
      
      public static function FBCNcp_Click(param1:MouseEvent) : void
      {
         if(BYMDevConfig.instance.USE_CLIENT_WITH_CALLBACK)
         {
            GLOBAL.CallJSWithClient("cc.ncp","fbcNcpConfirm",["showPaymentDialog"]);
         }
         else
         {
            GLOBAL.CallJS("cc.ncp",["showPaymentDialog","fbcNcpConfirm"]);
         }
         POPUPS.Next();
      }
      
      public static function FBCNcpConfirm(param1:String) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc2_:BFOUNDATION = GLOBAL.townHall;
         if(param1 == "1")
         {
            _loc3_ = BASE.CanUpgrade(_loc2_);
            if(Boolean(_loc3_.error) && !_loc3_.needResource)
            {
               GLOBAL.Message(_loc3_.errorMessage);
            }
            else
            {
               _loc4_ = _loc2_.InstantUpgradeCost();
               _loc2_.Upgraded();
               BASE.Purchase("NCP",1,"upgrade");
               cacheNCPAvailable = null;
            }
         }
      }
      
      public static function FBCNcpCancelled(param1:String = "", param2:Boolean = true) : void
      {
         if(param2)
         {
            if(BYMDevConfig.instance.USE_CLIENT_WITH_CALLBACK)
            {
               GLOBAL.CallJSWithClient("cc.ncp","fbcNcpConfirm",["showPaymentDialog"]);
            }
            else
            {
               GLOBAL.CallJS("cc.ncp",["userCancelled"]);
            }
         }
         POPUPS.Next();
         FBCNcpUpgradeCB();
      }
      
      public static function FBCNcpUpgradeCB() : void
      {
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && !GLOBAL.isMapOpen())
         {
            GLOBAL._selectedBuilding = GLOBAL.townHall;
            BUILDINGOPTIONS.Show(GLOBAL.townHall,"upgrade");
         }
      }
      
      private static function FBCNcpRender(param1:String, param2:MovieClip) : String
      {
         var FortifyImageLoaded:Function;
         var ImageLoaded:Function;
         var numImageElements:Function;
         var DefaultImageLoaded:Function;
         var img:String = null;
         var nextFortifyLevel:int = 0;
         var imageDataA:Object = null;
         var imageDataB:Object = null;
         var imageLevel:int = 0;
         var thlvl:int = 0;
         var lowestLevel:int = 0;
         var n:String = null;
         var upgradeImgLen:int = 0;
         var i:int = 0;
         var j:int = 0;
         var str:String = param1;
         var imageContainer:MovieClip = param2;
         var _building:BFOUNDATION = GLOBAL.townHall;
         var buildingProps:Object = GLOBAL._buildingProps[_building._type - 1];
         if(str == "fortify")
         {
            FortifyImageLoaded = function(param1:String, param2:BitmapData):void
            {
               imageContainer.addChild(new Bitmap(param2));
            };
            nextFortifyLevel = _building._fortification.Get() + 1;
            if(nextFortifyLevel > 4)
            {
               nextFortifyLevel = 4;
            }
            img = "fortifybuttons/" + "fort" + nextFortifyLevel + ".png";
            ImageCache.GetImageWithCallBack(img,FortifyImageLoaded);
         }
         else if(buildingProps.upgradeImgData)
         {
            ImageLoaded = function(param1:String, param2:BitmapData):void
            {
               imageContainer.addChild(new Bitmap(param2));
            };
            imageDataA = buildingProps.upgradeImgData;
            thlvl = GLOBAL.GetBuildingTownHallLevel(buildingProps);
            if(buildingProps.upgradeImgData)
            {
               lowestLevel = int.MAX_VALUE;
               for(n in buildingProps.upgradeImgData)
               {
                  if(!isNaN(Number(n)))
                  {
                     lowestLevel = Math.min(lowestLevel,Number(n));
                  }
               }
               if(lowestLevel != int.MAX_VALUE && buildingProps.upgradeImgData[lowestLevel].silhouette_img && !BASE.HasRequirements(buildingProps.costs[0]))
               {
                  img = String(buildingProps.upgradeImgData.baseurl + buildingProps.upgradeImgData[lowestLevel].silhouette_img);
               }
            }
            if(!img)
            {
               if(_building._lvl.Get() == 0)
               {
                  imageDataB = imageDataA[1];
                  imageLevel = 1;
               }
               else
               {
                  numImageElements = function(param1:Object):int
                  {
                     var _loc3_:String = null;
                     var _loc2_:int = 0;
                     for(_loc3_ in param1)
                     {
                        _loc2_++;
                     }
                     return _loc2_;
                  };
                  upgradeImgLen = numImageElements(imageDataA);
                  if(Boolean(imageDataA[_building._lvl.Get()]) && imageDataA[_building._lvl.Get()] >= _building._buildingProps.hp.length)
                  {
                     imageDataB = imageDataA[_building._lvl.Get()];
                     imageLevel = _building._lvl.Get();
                  }
                  else
                  {
                     i = _building._lvl.Get();
                     if(str == "upgrade")
                     {
                        i += 1;
                     }
                     if(Boolean(imageDataA[i]) && i > _building._lvl.Get())
                     {
                        imageDataB = imageDataA[i];
                        imageLevel = i;
                     }
                     else
                     {
                        j = _building._lvl.Get();
                        while(j > 0)
                        {
                           if(imageDataA[j])
                           {
                              imageDataB = imageDataA[j];
                              imageLevel = j;
                              break;
                           }
                           if(j == 1)
                           {
                              imageDataB = imageDataB[1];
                              imageLevel = 1;
                              break;
                           }
                           j--;
                        }
                     }
                  }
               }
               img = String(buildingProps.upgradeImgData.baseurl + buildingProps.upgradeImgData[imageLevel].img);
            }
            ImageCache.GetImageWithCallBack(img,ImageLoaded);
         }
         else
         {
            DefaultImageLoaded = function(param1:String, param2:BitmapData):void
            {
               imageContainer.addChild(new Bitmap(param2));
            };
            if(Boolean(buildingProps.buildingbuttons) && Boolean(BASE._buildingsStored["bl" + _building._type]) && buildingProps.buildingbuttons.length >= BASE._buildingsStored["bl" + _building._type].Get())
            {
               img = "buildingbuttons/" + buildingProps.buildingbuttons[BASE._buildingsStored["bl" + _building._type].Get() - 1] + ".jpg";
            }
            else if(Boolean(buildingProps.buildingbuttons) && buildingProps.buildingbuttons.length >= _building._lvl.Get())
            {
               img = "buildingbuttons/" + buildingProps.buildingbuttons[_building._lvl.Get() - 1] + ".jpg";
            }
            else if(Boolean(buildingProps.buildingbuttons) && buildingProps.buildingbuttons.length > 0)
            {
               img = "buildingbuttons/" + buildingProps.buildingbuttons[0] + ".jpg";
            }
            else
            {
               img = "buildingbuttons/" + _building._type + ".jpg";
            }
            ImageCache.GetImageWithCallBack(img,DefaultImageLoaded);
         }
         return img;
      }
      
      public static function MidGameOffers(param1:String) : void
      {
         switch(param1)
         {
            case "text":
               GLOBAL.CallJS("cc.showTopup",[{
                  "type":"fbc",
                  "callback":"fbcAdd"
               }]);
               break;
            case "gift":
               GLOBAL.CallJS("cc.showTopup",[{
                  "special":"gift",
                  "callback":"fbcAdd"
               }]);
               break;
            case "shinydiscount":
               GLOBAL.CallJS("cc.showTopup",[{
                  "special":"discount",
                  "callback":"fbcAdd"
               }]);
               break;
            case "shinybonus":
               GLOBAL.CallJS("cc.showTopup",[{
                  "special":"bonus",
                  "callback":"fbcAdd"
               }]);
         }
      }
      
      public static function purchaseReceive(param1:String) : void
      {
         POPUPS.Next();
         var _loc2_:Object = JSON.decode(param1);
         if(_loc2_.error == 0)
         {
            if(LOGIN.checkHash(param1))
            {
               BUY.purchaseProcess(_loc2_.items);
               BUY.purchaseComplete(param1);
               BASE._pendingPromo = 1;
               BASE.Save();
            }
            else
            {
               LOGGER.Log("err","BUY.purchaseReceive " + param1);
            }
         }
      }
      
      public static function purchaseComplete(param1:String) : void
      {
         if(param1 == "biggulp")
         {
            SALESPECIALSPOPUP.Show("biggulp");
         }
         else
         {
            SALESPECIALSPOPUP.EndSale();
            SALESPECIALSPOPUP.Show("giftconfirm");
         }
         BASE.Save();
      }
      
      public static function startPromo(param1:String) : void
      {
         var _loc2_:Object = JSON.decode(param1);
         if(_loc2_.endtime)
         {
            SALESPECIALSPOPUP.StartSale(_loc2_.endtime);
         }
         else
         {
            LOGGER.Log("err","startPromo " + _loc2_.endtime);
         }
      }
      
      public static function purchaseProcess(param1:Array) : void
      {
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = String(param1[_loc2_][0]);
            _loc4_ = Number(param1[_loc2_][1]);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               if(_loc3_ == "BIGGULP")
               {
                  InventoryManager.buildingStorageAdd(120);
               }
               else
               {
                  STORE.AddInventory(_loc3_);
               }
               _loc5_++;
            }
            _loc2_++;
         }
      }
      
      public static function logPromoShown(param1:String = null) : void
      {
         LOGGER.Log("pro","POPUPS.CallbackShiny " + param1);
      }
      
      public static function logFB711PromoShown(param1:String = null) : void
      {
         LOGGER.Stat([74,"popupshow"]);
      }
      
      public static function logFB711RedeemShown(param1:String = null) : void
      {
         if(TUTORIAL._stage < 200)
         {
            LOGGER.Stat([77,TUTORIAL._stage]);
         }
         else
         {
            LOGGER.Stat([78,"claimed"]);
         }
      }
   }
}
