package
{
   import com.monsters.managers.InstanceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class MARKETING
   {
       
      
      public function MARKETING()
      {
         super();
      }
      
      public static function Show(param1:String) : Boolean
      {
         var found:Boolean = false;
         var pTitle:String = null;
         var pBody:String = null;
         var pImage:String = null;
         var pImagePosition:Point = null;
         var pButton:String = null;
         var pAction:Function = null;
         var popupMC:MovieClip = null;
         var tmpBuilding:BFOUNDATION = null;
         var tmpCountA:int = 0;
         var tmpCountB:int = 0;
         var buildingInstances:Vector.<Object> = null;
         var hatCount:int = 0;
         var siloCount:int = 0;
         var quantityIndex:int = 0;
         var canbuild:Boolean = false;
         var tmpr1:Boolean = false;
         var tmpr2:Boolean = false;
         var tmpr3:Boolean = false;
         var tmpr4:Boolean = false;
         var sc:int = 0;
         var tgtb:BFOUNDATION = null;
         var storageInstances:Vector.<Object> = null;
         var laser:Boolean = false;
         var tesla:Boolean = false;
         var key:String = param1;
         if(GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD)
         {
            return false;
         }
         if(BASE._showingWhatsNew)
         {
            return false;
         }
         if(BASE.isInfernoMainYardOrOutpost)
         {
            return false;
         }
         try
         {
            switch(key)
            {
               case "upgradeapult":
                  if(GLOBAL._bCatapult && GLOBAL._bCatapult._lvl.Get() == 1 && GLOBAL.townHall._lvl.Get() >= 5 && GLOBAL.Timestamp() - GLOBAL.StatGet("CM2") > 60 * 60 * 24 * 5)
                  {
                     GLOBAL.StatSet("CM2",GLOBAL.Timestamp());
                     pTitle = KEYS.Get("mkting_upgradeapult_title");
                     pBody = KEYS.Get("mkting_upgradeapult_body");
                     pImage = "building-catapult.png";
                     pImagePosition = new Point(-270,-65);
                     pButton = KEYS.Get("mkting_upgradeapult_btn");
                     pAction = function fcatapult(param1:MouseEvent):void
                     {
                        BUILDINGOPTIONS.Show(GLOBAL._bCatapult,"upgrade");
                        POPUPS.Next();
                     };
                     found = true;
                  }
                  break;
               case "fillapult":
                  if(GLOBAL._bCatapult && BASE._resources.r1.Get() < BASE._resources.r1max * 0.5 && GLOBAL.Timestamp() - GLOBAL.StatGet("CM4") > 60 * 60 * 24 * 5)
                  {
                     GLOBAL.StatSet("CM4",GLOBAL.Timestamp());
                     pTitle = KEYS.Get("mkting_fillapult_title");
                     pBody = KEYS.Get("mkting_fillapult_body");
                     pImage = "building-catapult.png";
                     pImagePosition = new Point(-270,-65);
                     pButton = KEYS.Get("mkting_fillapult_btn");
                     pAction = function fcatapult(param1:MouseEvent):void
                     {
                        if(!BASE.isInfernoMainYardOrOutpost)
                        {
                           STORE.ShowB(2,0,["BR11","BR12","BR13","BR21","BR22","BR23","BR31","BR32","BR33","BR41","BR42","BR43"]);
                        }
                        else
                        {
                           STORE.ShowB(2,0,["BR11I","BR12I","BR13I","BR21I","BR22I","BR23I","BR31I","BR32I","BR33I","BR41I","BR42I","BR43I"]);
                        }
                        POPUPS.Next();
                     };
                     found = true;
                  }
                  break;
               case "train":
                  break;
               case "overdrive":
                  tmpCountA = 0;
                  tmpCountB = 0;
                  buildingInstances = InstanceManager.getInstancesByClass(BFOUNDATION);
                  for each(tmpBuilding in buildingInstances)
                  {
                     if(tmpBuilding._type == 13)
                     {
                        tmpCountA += 1;
                        if((tmpBuilding as BUILDING13)._producing)
                        {
                           tmpCountB += 1;
                        }
                     }
                  }
                  if(tmpCountA > 1 && tmpCountA == tmpCountB && GLOBAL.Timestamp() - GLOBAL.StatGet("CM6") > 60 * 60 * 24 * 2)
                  {
                     GLOBAL.StatSet("CM6",GLOBAL.Timestamp());
                     pTitle = KEYS.Get("mkting_overdrive_title");
                     pBody = KEYS.Get("mkting_overdrive_body");
                     pImage = "building-hatchery.png";
                     pImagePosition = new Point(-270,-65);
                     pButton = KEYS.Get("mkting_overdrive_btn");
                     pAction = function fcatapult(param1:MouseEvent):void
                     {
                        if(!BASE.isInfernoMainYardOrOutpost)
                        {
                           STORE.ShowB(3,1,["HOD","HOD2","HOD3"]);
                        }
                        else
                        {
                           STORE.ShowB(3,1,["HODI","HOD2I","HOD3I"]);
                        }
                        POPUPS.Next();
                     };
                     found = true;
                  }
                  break;
               case "planner":
                  break;
               case "hcc":
                  hatCount = int(InstanceManager.getInstancesByClass(BUILDING13).length);
                  if(!GLOBAL._bHatcheryCC && hatCount == 3 && GLOBAL.Timestamp() - GLOBAL.StatGet("CM8") > 60 * 60 * 24 * 5)
                  {
                     GLOBAL.StatSet("CM8",GLOBAL.Timestamp());
                     pTitle = KEYS.Get("mkting_hcc_title");
                     pBody = KEYS.Get("mkting_hcc_body");
                     pImage = "building-hcc.png";
                     pImagePosition = new Point(-270,-65);
                     pButton = KEYS.Get("mkting_hcc_btn");
                     pAction = function fcatapult(param1:MouseEvent):void
                     {
                        BUILDINGS._menuA = 2;
                        BUILDINGS._menuB = 1;
                        BUILDINGS._page = 0;
                        BUILDINGS._buildingID = 16;
                        BUILDINGS.Show();
                        POPUPS.Next();
                     };
                     found = true;
                  }
                  break;
               case "storagemore":
                  siloCount = int(InstanceManager.getInstancesByClass(BUILDING6).length);
                  quantityIndex = GLOBAL.townHall._lvl.Get() - 1 < GLOBAL._buildingProps[5].quantity.length ? int(GLOBAL.townHall._lvl.Get() - 1) : int(GLOBAL._buildingProps[5].quantity.length - 1);
                  canbuild = siloCount < GLOBAL._buildingProps[5].quantity[quantityIndex];
                  tmpr1 = BASE._resources.r1.Get() >= 0.8 * BASE._resources.r1max;
                  tmpr2 = BASE._resources.r2.Get() >= 0.8 * BASE._resources.r2max;
                  tmpr3 = BASE._resources.r3.Get() >= 0.8 * BASE._resources.r3max;
                  tmpr4 = BASE._resources.r4.Get() >= 0.8 * BASE._resources.r4max;
                  if(canbuild && (tmpr1 || tmpr2 || tmpr3 || tmpr4) && GLOBAL.Timestamp() - GLOBAL.StatGet("CM9") > 60 * 60 * 24 * 5)
                  {
                     GLOBAL.StatSet("CM9",GLOBAL.Timestamp());
                     pTitle = KEYS.Get("mkting_silo_title");
                     pBody = BASE.isInfernoMainYardOrOutpost ? KEYS.Get("inf_mkting_silo_body") : KEYS.Get("mkting_silo_body");
                     pImage = "building-storage.png";
                     pButton = KEYS.Get("mkting_silo_btn");
                     pAction = function fcatapult(param1:MouseEvent):void
                     {
                        BUILDINGS._menuA = 1;
                        BUILDINGS._menuB = 1;
                        BUILDINGS._page = 0;
                        BUILDINGS._buildingID = 6;
                        BUILDINGS.Show();
                        POPUPS.Next();
                     };
                     found = true;
                  }
                  break;
               case "storageupgrade":
                  sc = 0;
                  storageInstances = InstanceManager.getInstancesByClass(BUILDING6);
                  for each(tmpBuilding in storageInstances)
                  {
                     if(!BASE.CanUpgrade(tmpBuilding).error && !tmpBuilding._repairing && tmpBuilding._countdownUpgrade.Get() == 0)
                     {
                        tgtb = tmpBuilding;
                        sc++;
                        break;
                     }
                  }
                  quantityIndex = GLOBAL.townHall._lvl.Get() - 1 < GLOBAL._buildingProps[5].quantity.length ? int(GLOBAL.townHall._lvl.Get() - 1) : int(GLOBAL._buildingProps[5].quantity.length - 1);
                  canbuild = sc < GLOBAL._buildingProps[5].quantity[quantityIndex];
                  tmpr1 = BASE._resources.r1.Get() >= 0.8 * BASE._resources.r1max;
                  tmpr2 = BASE._resources.r2.Get() >= 0.8 * BASE._resources.r2max;
                  tmpr3 = BASE._resources.r3.Get() >= 0.8 * BASE._resources.r3max;
                  tmpr4 = BASE._resources.r4.Get() >= 0.8 * BASE._resources.r4max;
                  if(!canbuild && tgtb && (tmpr1 || tmpr2 || tmpr3 || tmpr4) && GLOBAL.Timestamp() - GLOBAL.StatGet("CM10") > 60 * 60 * 24 * 5)
                  {
                     GLOBAL.StatSet("CM10",GLOBAL.Timestamp());
                     pTitle = KEYS.Get("mkting_siloupgrade_title");
                     pBody = KEYS.Get("mkting_siloupgrade_body");
                     pButton = KEYS.Get("mkting_siloupgrade_btn");
                     pImage = "building-storage.png";
                     pAction = function fcatapult(param1:MouseEvent):void
                     {
                        BUILDINGOPTIONS.Show(tgtb,"upgrade");
                        POPUPS.Next();
                     };
                     found = true;
                  }
                  break;
               case "mushroompick":
                  break;
               case "laser":
                  laser = InstanceManager.getInstancesByClass(BUILDING23).length > 0;
                  if(GLOBAL.townHall._lvl.Get() >= 4 && !laser && GLOBAL.Timestamp() - GLOBAL.StatGet("CM11") > 60 * 60 * 24 * 5)
                  {
                     GLOBAL.StatSet("CM11",GLOBAL.Timestamp());
                     pTitle = KEYS.Get("mkting_laser_title");
                     pBody = KEYS.Get("mkting_laser_body");
                     pButton = KEYS.Get("mkting_laser_btn");
                     pImage = "building-laser.png";
                     pAction = function fcatapult(param1:MouseEvent):void
                     {
                        BUILDINGS._menuA = 3;
                        BUILDINGS._menuB = 1;
                        BUILDINGS._page = 0;
                        BUILDINGS._buildingID = 23;
                        BUILDINGS.Show();
                        POPUPS.Next();
                     };
                     found = true;
                  }
                  break;
               case "tesla":
                  tesla = InstanceManager.getInstancesByClass(BUILDING25).length > 0;
                  if(GLOBAL.townHall._lvl.Get() >= 4 && !tesla && GLOBAL.Timestamp() - GLOBAL.StatGet("CM12") > 60 * 60 * 24 * 5)
                  {
                     GLOBAL.StatSet("CM12",GLOBAL.Timestamp());
                     pTitle = KEYS.Get("mkting_tesla_title");
                     pBody = KEYS.Get("mkting_tesla_body");
                     pButton = KEYS.Get("mkting_tesla_btn");
                     pImage = "building-tesla.png";
                     pAction = function fcatapult(param1:MouseEvent):void
                     {
                        BUILDINGS._menuA = 3;
                        BUILDINGS._menuB = 1;
                        BUILDINGS._page = 0;
                        BUILDINGS._buildingID = 25;
                        BUILDINGS.Show();
                        POPUPS.Next();
                     };
                     found = true;
                  }
            }
            if(found)
            {
               GLOBAL.StatSet("CM",GLOBAL.Timestamp());
               POPUPS.DisplayGeneric(pTitle,pBody,pButton,pImage,pAction);
               LOGGER.Stat([36,key]);
            }
         }
         catch(e:Error)
         {
            LOGGER.Log("err","MARKETING.Show " + key + " " + e.getStackTrace());
         }
         return found;
      }
      
      public static function Process() : void
      {
         var done:Boolean = false;
         try
         {
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && TUTORIAL._stage > 200 && GLOBAL._sessionCount > 10 && GLOBAL.Timestamp() - GLOBAL.StatGet("CM") > 60 * 60 * 24 * 1)
            {
               GLOBAL.StatSet("CM",GLOBAL.Timestamp());
               done = Show("unlock");
               if(!done)
               {
                  done = Show("catapult");
               }
               if(!done)
               {
                  done = Show("upgradeapult");
               }
            }
         }
         catch(e:Error)
         {
            LOGGER.Log("err","MARKETING.Process " + e.getStackTrace());
         }
      }
   }
}
