package
{
   import com.monsters.alliances.ALLIANCES;
   import com.monsters.events.BuildingEvent;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BUILDING11 extends BFOUNDATION
   {
      
      public static const CHANGED_TO_MR2:String = "changedToMR2";
       
      
      private var callPending:Boolean;
      
      public function BUILDING11()
      {
         super();
         _type = 11;
         _footprint = [new Rectangle(0,0,90,90)];
         _gridCost = [[new Rectangle(0,0,90,90),10],[new Rectangle(10,10,70,70),200]];
         SetProps();
      }
      
      override public function Tick(param1:int) : void
      {
         if(_countdownBuild.Get() > 0 || health < maxHealth * 0.5)
         {
            _canFunction = false;
         }
         else
         {
            _canFunction = true;
            MAPROOM.initMaproomSetup = true;
         }
         if(MapRoomManager.instance.isInMapRoom3)
         {
            GLOBAL.StatSet("mrl",3);
         }
         else
         {
            if(_lvl.Get() < 2 && GLOBAL.StatGet("mrl") == 2)
            {
               GLOBAL.StatSet("mrl",1); // Comment: Previously set to 1
            }
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && _lvl.Get() == 1 && GLOBAL.StatGet("mrl") != 2 && BASE._saveCounterA == BASE._saveCounterB && !BASE._saving)
            {
               //this.NewWorld();
            }
         }
         if(!GLOBAL._catchup && GLOBAL._render && _countdownUpgrade.Get() && _countdownUpgrade.Get() < 60 * 60 * 24 * 2)
         {
            this.PopupUpgrade(2);
         }
         super.Tick(param1);
      }
      
      private function NewWorld() : void
      {
         var _loc1_:Array = null;
         if(!MapRoomManager.instance.isInMapRoom3 && GLOBAL.mode == GLOBAL._loadmode && GLOBAL._flags.maproom2)
         {
            ACHIEVEMENTS.Check("map2",1);
            if(this.callPending)
            {
               return;
            }
            this.callPending = true;
            _loc1_ = [["version",2]];
            new URLLoaderApi().load(GLOBAL._mapURL + "setmapversion",_loc1_,this.NewWorldSuccess,this.NewWorldFail);
         }
      }
      
      private function NewWorldSuccess(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(param1.error == 0)
         {
            if(GLOBAL.mode != GLOBAL._loadmode)
            {
               return;
            }
            GLOBAL.StatSet(CHANGED_TO_MR2,1);
            GLOBAL.StatSet("mrl",2,true);
            MapRoomManager.instance.mapRoomVersion = MapRoomManager.MAP_ROOM_VERSION_2;
            GLOBAL._baseURL = param1.baseurl;
            GLOBAL._homeBaseID = param1.homebaseid;
            BASE._loadedBaseID = param1.homebaseid;
            BASE._baseID = 0;
            BASE._loadedFriendlyBaseID = GLOBAL._homeBaseID;
            MapRoomManager.instance.BookmarksClear();
            LOGGER.StatB({"st1":"NWM"},"migration");
            if(param1.basesaveid != 1)
            {
               BASE._lastSaveID = param1.basesaveid;
            }
            if(param1.homebase.length == 2 && param1.homebase[0] > -1 && param1.homebase[1] > -1)
            {
               if(param1.worldsize)
               {
                  MapRoomManager.instance.mapWidth = param1.worldsize[0];
                  MapRoomManager.instance.mapHeight = param1.worldsize[1];
               }
               GLOBAL._mapHome = new Point(param1.homebase[0],param1.homebase[1]);
               if(param1.outposts)
               {
                  GLOBAL._mapOutpost = [];
                  _loc2_ = 0;
                  while(_loc2_ < param1.outposts.length)
                  {
                     if(param1.outposts[_loc2_].length == 2)
                     {
                        GLOBAL._mapOutpost.push(new Point(param1.outposts[_loc2_][0],param1.outposts[_loc2_][1]));
                     }
                     _loc2_++;
                  }
               }
               GLOBAL.eventDispatcher.dispatchEvent(new BuildingEvent(BuildingEvent.ENTER_MR2,this));
            }
            else
            {
               LOGGER.Log("err","BUILDING11.NewWorldSuccess Invalid home base coordinate. " + param1.homebase);
               GLOBAL.ErrorMessage("BUILDING11 1");
            }
         }
         else
         {
            this.callPending = true;
            GLOBAL._flags.discordOldEnough = false;
            //LOGGER.Log("err",param1.error);
            //GLOBAL.ErrorMessage("BUILDING11 2");
         }
         this.callPending = false;
         PLEASEWAIT.Hide();
      }
      
      private function NewWorldFail(param1:IOErrorEvent) : void
      {
         this.callPending = false;
         LOGGER.Log("err","BUILDING11.NewWorld HTTP");
         GLOBAL.ErrorMessage("BUILDING11.NewWorld HTTP");
         PLEASEWAIT.Hide();
      }
      
      override public function PlaceB() : void
      {
         super.PlaceB();
         GLOBAL._bMap = this;
      }
      
      override public function Constructed() : void
      {
         GLOBAL._bMap = this;
         super.Constructed();
      }
      
      override public function UpgradeB() : void
      {
         super.UpgradeB();
         this.PopupUpgrade(1);
      }
      
      public function PopupUpgrade(param1:int) : void
      {
         var Speedup:Function = null;
         var popupMC:popup_generic = null;
         var n:int = param1;
         Speedup = function(param1:MouseEvent = null):void
         {
            POPUPS.Next();
            STORE.SpeedUp("SP4");
         };
         if(GLOBAL.StatGet("mrp") < n && !STORE._open)
         {
            GLOBAL.StatSet("mrp",n);
            GLOBAL._selectedBuilding = GLOBAL._bMap;
            popupMC = new popup_generic();
            popupMC.tA.htmlText = KEYS.Get("popup_upgrademaproomtitle");
            popupMC.tB.htmlText = KEYS.Get("popup_upgrademaproom");
            popupMC.bAction.SetupKey("btn_speedup");
            popupMC.bAction.addEventListener(MouseEvent.CLICK,Speedup);
            popupMC.mcImage.x = -200;
            popupMC.mcImage.y = -95;
            POPUPS.Push(popupMC,null,null,null,"mapv2.jpg",true,"now");
         }
      }
      
      override public function Upgraded() : void
      {
         var Brag:Function;
         if(!MapRoomManager.instance.isInMapRoom3)
         {
            Brag = function():void
            {
               GLOBAL.CallJS("sendFeed",["upgrade-mr",KEYS.Get("newmap_upgraded3"),KEYS.Get("newmap_upgraded1"),"build-maproom.png"]);
               POPUPS.Next();
            };
            POPUPS.DisplayGeneric(KEYS.Get("newmap_upgraded1"),KEYS.Get("newmap_upgraded2"),KEYS.Get("btn_brag"),"building-map.png",Brag);
            PLEASEWAIT.Show(KEYS.Get("wait_newworld"));
         }
         super.Upgraded();
      }
      
      override public function Recycle() : void
      {
         if(MapRoomManager.instance.isInMapRoom2)
         {
            if(ALLIANCES._myAlliance != null)
            {
               GLOBAL.Message(KEYS.Get("map_alliance_recycle",{"v1":ALLIANCES._myAlliance.name}));
               return;
            }
            GLOBAL._mapOutpostIDs.length = 0;
            GLOBAL.Message(KEYS.Get("newmap_recycle1"),KEYS.Get("btn_recycle"),this.RecycleD);
         }
         else
         {
            if(MapRoomManager.instance.isInMapRoom3 && !GLOBAL._aiDesignMode)
            {
               GLOBAL.Message(KEYS.Get("map_cannot_recycle_map_room3"));
               return;
            }
            GLOBAL.Message(KEYS.Get("newmap_recycle2"),KEYS.Get("btn_recycle"),this.RecycleD);
         }
         GLOBAL.eventDispatcher.dispatchEvent(new BuildingEvent(BuildingEvent.ATTEMPT_RECYCLE,this));
      }
      
      private function RecycleD() : void
      {
         if(GLOBAL.mode != GLOBAL._loadmode)
         {
            return;
         }
         var _loc1_:Array = [["version",1]];
         if(MapRoomManager.instance.isInMapRoom3)
         {
            RecycleB();
            return;
         }
         new URLLoaderApi().load(GLOBAL._mapURL + "setmapversion",_loc1_,this.RecycleDSuccess,this.RecycleDFail);
         // PLEASEWAIT.Show(KEYS.Get("wait_processing"));
      }
      
      private function RecycleDSuccess(param1:Object) : void
      {
         var _loc2_:int = 0;
         PLEASEWAIT.Hide();
         if(param1.error == 0 && GLOBAL.mode == GLOBAL._loadmode)
         {
            LOGGER.StatB({
               "st1":"world_map",
               "st2":"leave"
            },MapRoomManager.instance.worldID);
            if(!MapRoomManager.instance.isInMapRoom3)
            {
               GLOBAL.StatSet("mrl",1,true);
            }
            GLOBAL._bMap = null;
            MapRoomManager.instance.mapRoomVersion = MapRoomManager.MAP_ROOM_VERSION_1;
            GLOBAL._baseURL = param1.baseurl;
            BASE._baseID = 0;
            BASE._loadedFriendlyBaseID = 0;
            _loc2_ = 1;
            while(_loc2_ < 5)
            {
               BASE._GIP["r" + _loc2_].Set(0);
               _loc2_++;
            }
            BASE._lastProcessedGIP = GLOBAL.Timestamp();
            BASE._rawGIP = {"t":BASE._lastProcessedGIP};
            BASE._processedGIP = {"t":BASE._lastProcessedGIP};
            GLOBAL._mapOutpost = [];
            if(param1.basesaveid != 1)
            {
               BASE._lastSaveID = param1.basesaveid;
            }
            MapRoomManager.instance.BookmarksClear();
            RecycleB();
            if(_lvl.Get() == 2)
            {
               GLOBAL.Message(KEYS.Get("newmap_return"));
            }
            GLOBAL.eventDispatcher.dispatchEvent(new BuildingEvent(BuildingEvent.DESTROY_MAPROOM,this));
         }
         else
         {
            LOGGER.Log("err",param1.error);
            GLOBAL.ErrorMessage("BUILDING11 RecycleD 1");
         }
      }
      
      private function RecycleDFail(param1:IOErrorEvent) : void
      {
         PLEASEWAIT.Hide();
         LOGGER.Log("err","BUILDING11.Recycle HTTP");
         GLOBAL.ErrorMessage("BUILDING11 RecycleD 2");
      }
      
      override public function Setup(param1:Object) : void
      {
         super.Setup(param1);
         if(_lvl.Get() > 1)
         {
            ACHIEVEMENTS.Check("map2",1);
         }
         if(_countdownBuild.Get() == 0)
         {
            GLOBAL._bMap = this;
         }
      }
   }
}
