package
{
   import com.monsters.ai.WMBASE;
   import com.monsters.interfaces.ICoreBuilding;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BUILDING14 extends BSTORAGE implements ICoreBuilding
   {
      
      public static const k_TYPE:uint = 14;
      
      public static const UNDERHALL_LEVEL:String = "underhalLevel";
       
      
      public function BUILDING14()
      {
         super();
         _type = 14;
         _footprint = BASE.isInfernoMainYardOrOutpost ? [new Rectangle(0,0,160,160)] : [new Rectangle(0,0,130,130)];
         _gridCost = BASE.isInfernoMainYardOrOutpost ? [[new Rectangle(0,0,160,160),10],[new Rectangle(10,10,140,140),200]] : [[new Rectangle(0,0,130,130),10],[new Rectangle(10,10,110,110),200]];
         _spoutPoint = new Point(1,-67);
         _spoutHeight = 135;
         SetProps();
      }
      
      override public function Repair() : void
      {
         super.Repair();
      }
      
      override public function Place(param1:MouseEvent = null) : void
      {
         if(!MAP._dragged)
         {
            super.Place(param1);
            _hasResources = true;
         }
      }
      
      override public function Cancel() : void
      {
         GLOBAL.setTownHall(null);
         super.Cancel();
      }
      
      override public function Recycle() : void
      {
         GLOBAL.Message(KEYS.Get("msg_cantrecycleth",{"v1":GLOBAL.townHall._buildingProps.name}));
      }
      
      override public function RecycleB(param1:MouseEvent = null) : void
      {
         GLOBAL.Message(KEYS.Get("msg_cantrecycleth",{"v1":GLOBAL.townHall._buildingProps.name}));
      }
      
      override public function RecycleC() : void
      {
         GLOBAL.Message(KEYS.Get("msg_cantrecycleth",{"v1":GLOBAL.townHall._buildingProps.name}));
      }
      
      override public function Destroyed(param1:Boolean = true) : void
      {
         super.Destroyed(param1);
         if(!MapRoomManager.instance.isInMapRoom2or3 && GLOBAL.mode == "wmattack")
         {
            WMBASE._destroyed = true;
         }
      }
      
      override public function Description() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Object = null;
         var _loc13_:Array = null;
         super.Description();
         _buildingDescription = KEYS.Get("th_upgradedesc");
         if(_lvl.Get() == 1)
         {
            _recycleDescription = KEYS.Get("th_recycledesc");
         }
         if(_lvl.Get() > 0 && _lvl.Get() < _buildingProps.costs.length)
         {
            _loc1_ = [];
            _loc2_ = [];
            _loc3_ = [];
            for each(_loc4_ in GLOBAL._buildingProps)
            {
               if(_loc4_.id != 14)
               {
                  _loc5_ = _loc4_.quantity.length - 1;
                  _loc6_ = _lvl.Get();
                  _loc7_ = Math.min(_loc6_,_loc5_);
                  _loc8_ = Math.min(_loc6_ + 1,_loc5_);
                  _loc9_ = int(_loc4_.quantity[_loc7_]);
                  _loc11_ = (_loc10_ = int(_loc4_.quantity[_loc8_])) - _loc9_;
                  if(_loc9_ == 0 && _loc10_ > 0 && !_loc4_.block)
                  {
                     _loc1_.push([0,KEYS.Get(_loc4_.name)]);
                  }
                  else if(_loc11_ > 0 && !_loc4_.block)
                  {
                     _loc2_.push([0,KEYS.Get(_loc4_.name) + "s"]);
                  }
                  _loc9_ = 0;
                  _loc10_ = 0;
                  for each(_loc12_ in _loc4_.costs)
                  {
                     for each(_loc13_ in _loc12_.re)
                     {
                        if(_loc13_[0] == 14)
                        {
                           if(_loc13_[2] <= _lvl.Get())
                           {
                              _loc9_ = 1;
                           }
                           if(_loc13_[2] == _lvl.Get() + 1)
                           {
                              _loc10_ = 1;
                           }
                        }
                     }
                  }
                  if(_loc9_ > 0 && _loc10_ > 0 && !_loc4_.block)
                  {
                     _loc3_.push([0,KEYS.Get(_loc4_.name)]);
                  }
               }
            }
            if(_loc1_.length > 0)
            {
               _upgradeDescription += KEYS.Get("th_willunlockthe",{"v1":GLOBAL.Array2StringB(_loc1_)}) + "<br><br>";
            }
            if(_loc2_.length > 0)
            {
               _upgradeDescription += "<b>" + KEYS.Get("th_willbuildmore") + "</b><br>" + GLOBAL.Array2StringB(_loc2_) + "<br><br>";
            }
            if(_loc3_.length > 0)
            {
               _upgradeDescription += "<b>" + KEYS.Get("th_willupgrade") + "</b><br>" + GLOBAL.Array2StringB(_loc3_);
            }
            if(Boolean(GLOBAL._buildingProps[_type - 1].additionalUpgradeInfo) && Boolean(GLOBAL._buildingProps[_type - 1].additionalUpgradeInfo[_lvl.Get() - 1]))
            {
               _upgradeDescription += "<br><br><b>" + KEYS.Get(GLOBAL._buildingProps[_type - 1].additionalUpgradeInfo[_lvl.Get() - 1]) + "</b>";
            }
         }
      }
      
      override public function Update(param1:Boolean = false) : void
      {
         super.Update(param1);
      }
      
      override public function Constructed() : void
      {
         GLOBAL.setTownHall(this);
         ACHIEVEMENTS.Check("thlevel",_lvl.Get());
         ACHIEVEMENTS.Check(ACHIEVEMENTS.UNDERHALL_LEVEL,_lvl.Get());
         super.Constructed();
      }
      
      override public function UpgradeB() : void
      {
         super.UpgradeB();
         if(_lvl.Get() >= 2 && _countdownUpgrade.Get() > 0 && _countdownUpgrade.Get() * (20 / 60 / 60) > BASE._credits.Get())
         {
            POPUPS.DisplayPleaseBuy("TH");
         }
      }
      
      override public function Upgraded() : void
      {
         LOGGER.KongStat([2,_lvl.Get()]);
         ACHIEVEMENTS.Check("thlevel",_lvl.Get());
         ACHIEVEMENTS.Check(ACHIEVEMENTS.UNDERHALL_LEVEL,_lvl.Get());
         super.Upgraded();
         this.UnlockBuildings();
      }
      
      private function UnlockBuildings() : void
      {
         var _loc1_:int = 0;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            _loc1_ = _lvl.Get();
            if(BASE.isInfernoMainYardOrOutpost)
            {
               GLOBAL.StatSet(UNDERHALL_LEVEL,_loc1_);
            }
            else
            {
               GLOBAL.attackingPlayer.townHallLevel = _loc1_;
            }
         }
      }
      
      override public function Setup(param1:Object) : void
      {
         super.Setup(param1);
         GLOBAL.setTownHall(this);
         if(_destroyed && Boolean(UI2._top))
         {
            UI2._top.validateSiegeWeapon();
         }
         this.UnlockBuildings();
         ACHIEVEMENTS.Check("thlevel",_lvl.Get());
         ACHIEVEMENTS.Check(ACHIEVEMENTS.UNDERHALL_LEVEL,_lvl.Get());
      }
   }
}
