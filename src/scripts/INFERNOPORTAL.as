package
{
   import com.cc.utils.SecNum;
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.siege.SiegeFactory;
   import com.monsters.siege.SiegeLab;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class INFERNOPORTAL extends BFOUNDATION
   {
      
      public static const ENTER_BUTTON:String = "btn_entercavern";
      
      public static const ASCENSION_BUTTON:String = "btn_ascendmonsters";
      
      public static const EXIT_BUTTON:String = "btn_exitcavern";
      
      private static var _ascensionMc:INFERNO_ASCENSION_POPUP;
      
      public static var building:INFERNOPORTAL;
      
      public static var _descentPassed:Boolean = false;
      
      public static var _ascensionData:Object;
      
      private static var _ogInfernoData:Object;
      
      private static var _ogAscensionData:Object;
       
      
      private var _popup:popup_horse;
      
      public function INFERNOPORTAL()
      {
         super();
         _type = 127;
         _footprint = [new Rectangle(0,0,190,160)];
         _gridCost = [[new Rectangle(0,0,190,160),200]];
         SetProps();
      }
      
      public static function GetMaxLevel() : Number
      {
         if(!building)
         {
            throw new Error("FUCK");
         }
         return building._buildingProps.costs.length;
      }
      
      public static function EnterPortal(param1:Boolean = false) : void
      {
         if(MAPROOM_DESCENT.DescentPassed)
         {
            ToggleYard();
         }
         else
         {
            EnterDescent();
         }
      }
      
      public static function AscendMonsters() : void
      {
         var loader:URLLoaderApi;
         var onLoad:Function = null;
         var onError:Function = null;
         onLoad = function(param1:Object):void
         {
            var _loc2_:String = null;
            PLEASEWAIT.Hide();
            _ogInfernoData = param1.imonsters;
            _ascensionData = {};
            _ogAscensionData = {};
            for(_loc2_ in param1.imonsters)
            {
               if(_loc2_.substr(0,2) == "IC")
               {
                  _ascensionData[_loc2_] = new SecNum(int(param1.imonsters[_loc2_] is Number ? param1.imonsters[_loc2_] : numHealthyCreeps(_loc2_,param1.imonsters[_loc2_])));
                  _ogAscensionData[_loc2_] = _ascensionData[_loc2_].Get();
               }
            }
            ShowAscendMonstersDialog();
         };
         onError = function():void
         {
            LOGGER.Log("err","INFERNOPORTAL.AscendMonsters No inferno monster data");
            GLOBAL.ErrorMessage("INFERNOPORTAL.AscendMonsters No inferno monster data");
         };
         if(!BASE.isMainYard)
         {
            return;
         }
         PLEASEWAIT.Show(KEYS.Get("msg_loading"));
         loader = new URLLoaderApi();
         loader.load(GLOBAL._infBaseURL + "infernomonsters",[["type","get"]],onLoad,onError);
      }
      
      private static function numHealthyCreeps(param1:String, param2:Array) : int
      {
         var _loc3_:int = int(param2.length);
         var _loc4_:int = CREATURES.GetProperty(param1,"health");
         var _loc5_:int = _loc3_ - 1;
         while(_loc5_ >= 0)
         {
            if(param2[_loc5_].health < _loc4_)
            {
               _loc3_--;
            }
            _loc5_--;
         }
         return _loc3_;
      }
      
      public static function PageAscensionData() : void
      {
         var result:Object;
         var s:String = null;
         var loader:URLLoaderApi = null;
         var onLoad:Function = null;
         var onError:Function = null;
         var dif:int = 0;
         onLoad = function(param1:Object):void
         {
            PLEASEWAIT.Hide();
            BASE.Save();
         };
         onError = function():void
         {
            LOGGER.Log("err","INFERNOPORTAL.PageAscensionData Could not save inferno monster changes");
            GLOBAL.ErrorMessage("INFERNOPORTAL.PageAscensionData Could not save inferno monster changes");
         };
         PLEASEWAIT.Show(KEYS.Get("msg_loading"));
         result = {};
         if(MapRoomManager.instance.isInMapRoom3)
         {
            dif = 0;
            for(s in _ascensionData)
            {
               dif = 0;
               if(s.substr(0,2) == "IC")
               {
                  destroyCreep(s,_ogAscensionData[s] - _ascensionData[s].Get());
               }
            }
            result = _ogInfernoData;
         }
         else
         {
            for(s in _ascensionData)
            {
               if(s.substr(0,2) == "IC" && _ascensionData[s].Get() > 0)
               {
                  result[s] = int(_ascensionData[s].Get());
               }
            }
         }
         _ascensionData = null;
         loader = new URLLoaderApi();
         loader.load(GLOBAL._infBaseURL + "infernomonsters",[["type","set"],["imonsters",JSON.encode(result)]],onLoad,onError);
      }
      
      private static function destroyCreep(param1:String, param2:int) : void
      {
         var _loc5_:int = 0;
         var _loc3_:int = CREATURES.GetProperty(param1,"health");
         var _loc4_:int = 0;
         while(_loc4_ < param2)
         {
            _loc5_ = _ogInfernoData[param1].length - 1;
            while(_loc5_ >= 0)
            {
               if(_ogInfernoData[param1][_loc5_].health == _loc3_)
               {
                  _ogInfernoData[param1].splice(_loc5_,1);
                  break;
               }
               _loc5_--;
            }
            _loc4_++;
         }
      }
      
      public static function ShowAscendMonstersDialog() : void
      {
         GLOBAL.BlockerAdd();
         GLOBAL._layerWindows.addChild(_ascensionMc = new INFERNO_ASCENSION_POPUP());
         _ascensionMc.Center();
         _ascensionMc.ScaleUp();
      }
      
      public static function HideAscendMonstersDialog() : void
      {
         if(_ascensionMc)
         {
            GLOBAL.BlockerRemove();
            SOUNDS.Play("close");
            GLOBAL._layerWindows.removeChild(_ascensionMc);
            _ascensionMc = null;
         }
      }
      
      public static function EnterDescent() : void
      {
         MAPROOM_DESCENT.Setup(true);
      }
      
      public static function ToggleYard() : void
      {
         var _loc1_:int = 0;
         if(BASE._saving || BASE._loading || BASE._saveCounterA != BASE._saveCounterB)
         {
            GLOBAL._toggleYardWaiting = 1;
            return;
         }
         MapRoomManager.instance.mapRoomVersion = MapRoomManager.MAP_ROOM_VERSION_1;
         if(BASE.isInfernoMainYardOrOutpost)
         {
            _loc1_ = MapRoomManager.instance.isInMapRoom3 ? int(EnumYardType.PLAYER) : int(EnumYardType.MAIN_YARD);
            BASE.LoadBase(null,0,0,GLOBAL.e_BASE_MODE.BUILD,false,_loc1_);
         }
         else
         {
            BASE.LoadBase(GLOBAL._infBaseURL,0,0,"ibuild",false,EnumYardType.INFERNO_YARD);
         }
      }
      
      public static function AddPortal(param1:uint = 0) : INFERNOPORTAL
      {
         var _loc2_:Point = new Point(-1200,-150);
         var _loc3_:Point = GRID.ToISO(_loc2_.x,_loc2_.y,0);
         var _loc4_:INFERNOPORTAL = BASE.addBuildingC(127) as INFERNOPORTAL;
         building = _loc4_;
         ++BASE._buildingCount;
         _loc4_.Setup({
            "X":_loc2_.x,
            "Y":_loc2_.y,
            "t":127,
            "id":BASE._buildingCount,
            "l":param1
         });
         _loc4_.SetLevel(param1);
         return _loc4_;
      }
      
      public static function isAboveMaxLevel() : Boolean
      {
         return Boolean(building) && building._lvl.Get() >= GetMaxLevel();
      }
      
      override public function Click(param1:MouseEvent = null) : void
      {
         if(isAboveMaxLevel() && (BASE.isInfernoMainYardOrOutpost || GLOBAL.townHall && GLOBAL.townHall._lvl.Get() >= INFERNO_EMERGENCE_EVENT.TOWN_HALL_LEVEL_REQUIREMENT))
         {
            super.Click(param1);
         }
         else if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && !INFERNO_EMERGENCE_EVENT.isAttackActive)
         {
            INFERNO_EMERGENCE_POPUPS.ShowRSVP(building._lvl.Get());
         }
      }
      
      public function SetLevel(param1:uint) : void
      {
         param1 = Math.min(param1,_buildingProps.costs.length);
         var _loc2_:int = _lvl.Get();
         var _loc3_:uint = uint(_buildingProps.costs.length);
         this.checkBuildingUnlocks();
         if(param1 == _loc2_)
         {
            return;
         }
         var _loc4_:int = param1 - _loc2_;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            Upgraded();
            _loc5_++;
         }
         RenderClear();
         Update(true);
         Render();
      }
      
      private function checkBuildingUnlocks() : void
      {
         if(isAboveMaxLevel() && BASE.isMainYard)
         {
            GLOBAL._buildingProps[INFERNO_MAGMA_TOWER.ID - 1].block = false;
            GLOBAL._buildingProps[INFERNOQUAKETOWER.TYPE - 1].block = false;
            GLOBAL._buildingProps[SiegeFactory.ID - 1].block = false;
            GLOBAL._buildingProps[SiegeLab.ID - 1].block = false;
         }
      }
      
      public function Hide() : void
      {
         _mc.visible = false;
         _mcBase.visible = false;
      }
      
      public function Show() : void
      {
         _mc.visible = true;
         _mcBase.visible = true;
      }
      
      override public function Export() : Object
      {
         return false;
      }
   }
}
