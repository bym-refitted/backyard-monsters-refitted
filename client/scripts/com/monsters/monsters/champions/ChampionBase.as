package com.monsters.monsters.champions
{
   import com.cc.utils.SecNum;
   import com.monsters.configs.BYMConfig;
   import com.monsters.interfaces.ILootable;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.managers.InstanceManager;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.CModifiableProperty;
   import com.monsters.monsters.components.modifiers.AdditionPropertyModifier;
   import com.monsters.pathing.PATHING;
   import com.monsters.rendering.RasterData;
   import com.monsters.siege.SiegeWeapons;
   import com.monsters.siege.weapons.Decoy;
   import com.monsters.siege.weapons.SiegeWeapon;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import gs.*;
   import gs.easing.*;
   
   public class ChampionBase extends MonsterBase
   {
      
      public static const k_CHAMPION_STATUS_NORMAL:int = 0;
      
      public static const k_CHAMPION_STATUS_FROZEN:int = 1;
      
      public static const k_CHAMPION_STATUS_JUICED:int = 2;
      
      public static const k_CHAMPION_STATUS_DESTROYED:int = 3;
      
      public static const k_CHAMPION_STATUS_REFUND:int = 4;
      
      public static const k_CHAMPION_STATUS_MIGRATED:int = 5;
       
      
      public var _behaviourMode:String = "defend";
      
      public var _attackType:String = "melee";
      
      public var _feeds:SecNum;
      
      public var _feedTime:SecNum;
      
      public var _level:SecNum;
      
      public var _foodBonus:SecNum;
      
      public var _powerLevel:SecNum;
      
      public var _warned:Boolean = false;
      
      public var _warnStarve:Boolean = false;
      
      public var _spriteID:String;
      
      public var _name:String;
      
      public var _regen:int;
      
      public var _buff:Number = 0;
      
      public var _buffRadius:Number = 0;
      
      public var _helpCreep:*;
      
      public var _type:int = 1;
      
      public var _lastHeal:int = 0;
      
      public const DEFENSE_RANGE:int = 30;
      
      public const DEFENSE_MODIFIER:Number = 1;
      
      public var m_status:int;
      
      public function ChampionBase(param1:String, param2:Point, param3:Number, param4:Point = null, param5:Boolean = false, param6:BFOUNDATION = null, param7:int = 1, param8:int = 0, param9:int = 0, param10:int = 1, param11:int = 20000, param12:int = 0, param13:int = 0)
      {
         super();
         var _loc14_:int = getTimer();
         _friendly = param5;
         setInitialFriendlyFlags(_friendly);
         if(param7 < 1)
         {
            param7 = 1;
         }
         this._level = new SecNum(param7);
         this.m_status = k_CHAMPION_STATUS_NORMAL;
         _middle = param7 * 5;
         _creatureID = "G" + param10;
         this._feeds = new SecNum(param8);
         if(param9 > 0)
         {
            this._feedTime = new SecNum(param9);
         }
         else
         {
            this._feedTime = new SecNum(int(GLOBAL.Timestamp() + CHAMPIONCAGE.GetGuardianProperty(_creatureID,param7,"feedTime")));
         }
         if(param12)
         {
            this._foodBonus = new SecNum(param12);
         }
         else
         {
            this._foodBonus = new SecNum(0);
         }
         if(param13)
         {
            this._powerLevel = new SecNum(param13);
         }
         else
         {
            this._powerLevel = new SecNum(0);
         }
         this._lastHeal = GLOBAL.Timestamp();
         _house = param6;
         _hits = 0;
         this._type = param10;
         _pathing = "";
         _spawnTime = GLOBAL.Timestamp();
         _spawnPoint = new Point(int(param2.x / 100) * 100,int(param2.y / 100) * 100);
         _targetGroup = 3;
         _waypoints = [];
         _targetCreeps = [];
         _targetCreep = null;
         graphic.mouseEnabled = false;
         graphic.mouseChildren = false;
         _speed = 0;
         if(this._foodBonus.Get() > 0)
         {
            moveSpeedProperty.value = (CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"speed") + CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._foodBonus.Get(),"bonusSpeed")) / 2;
         }
         else
         {
            moveSpeedProperty.value = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"speed") / 2;
         }
         if(this._foodBonus.Get() > 0)
         {
            maxHealthProperty.value = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"health") + CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._foodBonus.Get(),"bonusHealth");
         }
         else
         {
            maxHealthProperty.value = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"health");
         }
         this._regen = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"healtime");
         if(param11 > 0 && param11 <= maxHealth)
         {
            setHealth(param11);
         }
         else if(param11 >= maxHealth)
         {
            setHealth(maxHealth);
         }
         else
         {
            setHealth(1);
         }
         if(this._foodBonus.Get() > 0)
         {
            damageProperty.value = int(CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"damage")) + int(CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._foodBonus.Get(),"bonusDamage"));
            m_range = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"range") + CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._foodBonus.Get(),"bonusRange");
         }
         else
         {
            damageProperty.value = int(CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"damage"));
            m_range = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"range");
         }
         _movement = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"movement");
         if(this._foodBonus.Get() > 0)
         {
            this._buff = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"buffs") + CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._foodBonus.Get(),"bonusBuffs");
         }
         else
         {
            this._buff = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"buffs");
         }
         if(CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"buffRadius"))
         {
            this._buffRadius = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"buffRadius");
         }
         _behaviour = param1;
         attackDelayProperty.value = 56;
         _targetPosition = param2;
         _targetCenter = param4;
         graphic.x = _targetPosition.x;
         graphic.y = _targetPosition.y;
         _tmpPoint.x = x;
         _tmpPoint.y = y;
         if(param3)
         {
            _targetRotation = param3;
         }
         else
         {
            _targetRotation = 0;
         }
         m_rotation = _targetRotation;
         _attacking = false;
         attackFlags |= Targeting.k_TARGETS_GROUND;
         this.setupSprite();
         if(_movement == "fly")
         {
            _altitude = 108;
            defenseFlags |= Targeting.k_TARGETS_FLYING;
         }
         else
         {
            _altitude = 0;
            defenseFlags |= Targeting.k_TARGETS_GROUND;
         }
         if(_behaviour == "bounce")
         {
            if(GLOBAL._render && _movement != "fly")
            {
               _graphicMC.y -= 90;
               TweenLite.to(_graphicMC,0.6,{
                  "y":_graphicMC.y + 90,
                  "ease":Bounce.easeOut,
                  "onComplete":this.changeModeAttack
               });
            }
            else
            {
               if(_movement == "fly")
               {
                  _graphicMC.y -= _altitude;
               }
               else
               {
                  _altitude = 0;
               }
               this.changeModeAttack();
            }
         }
         else if(_behaviour == "defend")
         {
            _altitude = 0;
            this.changeModeDefend();
         }
         else if(_behaviour == "decoy")
         {
            this.changeModeDecoy();
         }
         if(_behaviour == "juice")
         {
            this.changeModeJuice();
         }
         render();
         graphic.mouseEnabled = false;
         graphic.mouseChildren = false;
         CModifiableProperty(getComponentByName(k_LOOT_PROPERTY)).addModifier(new AdditionPropertyModifier(1.5));
      }
      
      public static function show() : void
      {
      }
      
      protected function setupSprite() : void
      {
         _frameNumber = Math.random() * 7;
         this._spriteID = _creatureID + "_" + Math.min(this._level.Get(),CHAMPIONCAGE.GetGuardianProperties(_creatureID,"health").length);
         SPRITES.SetupSprite(this._spriteID);
         if(_movement == "fly")
         {
            SPRITES.SetupSprite("bigshadow");
            _shadow = new BitmapData(52,50,true,16777215);
            _shadowMC = BYMConfig.instance.RENDERER_ON ? new Bitmap(_shadow) : graphic.addChild(new Bitmap(_shadow));
            _shadowMC.x = -21;
            _shadowMC.y = -26;
            _frameNumber = int(Math.random() * 1000);
         }
         var _loc1_:Object = SPRITES.GetSpriteDescriptor(this._spriteID);
         _graphic = new BitmapData(_loc1_.width,_loc1_.height,true,16777215);
         _graphicMC = BYMConfig.instance.RENDERER_ON ? new Bitmap(_graphic) : graphic.addChild(new Bitmap(_graphic)) as Bitmap;
         _graphicMC.x = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"offset_x");
         _graphicMC.y = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"offset_y");
         if(BYMConfig.instance.RENDERER_ON)
         {
            _rasterData = new RasterData(_graphicMC,_rasterPt,int.MAX_VALUE);
            if(_movement === "fly")
            {
               _shadowData = new RasterData(_shadow,_shadowPt,MAP.DEPTH_SHADOW,null,true);
            }
         }
      }
      
      override public function changeModeJuice() : void
      {
         _behaviour = "juice";
         changeMode();
         _targetBuilding = GLOBAL._bJuicer;
         if(_movement == "fly" && _altitude < 60)
         {
            if(BYMConfig.instance.RENDERER_ON)
            {
               TweenLite.to(_rasterPt,2,{
                  "y":_rasterPt.y - (108 - _altitude),
                  "ease":Sine.easeIn,
                  "onComplete":this.flyerTakeOff
               });
            }
            else
            {
               TweenLite.to(_graphicMC,2,{
                  "y":_graphicMC.y - (108 - _altitude),
                  "ease":Sine.easeIn,
                  "onComplete":this.flyerTakeOff
               });
            }
         }
         ++CREATURES._creatureID;
         ++CREATURES._creatureCount;
         CREATURES._creatures[CREATURES._creatureID] = this;
         var _loc1_:int = BASE.getGuardianIndex(CREATURES._guardian._type);
         BASE._guardianData[_loc1_].status = ChampionBase.k_CHAMPION_STATUS_JUICED;
         BASE._guardianData[_loc1_].log += "," + ChampionBase.k_CHAMPION_STATUS_JUICED.toString();
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            _loc1_ = GLOBAL.getPlayerGuardianIndex(CREATURES._guardian._type);
            if(_loc1_ != -1)
            {
               GLOBAL._playerGuardianData[_loc1_].status = ChampionBase.k_CHAMPION_STATUS_JUICED;
               GLOBAL._playerGuardianData[_loc1_].log += "," + ChampionBase.k_CHAMPION_STATUS_JUICED.toString();
            }
         }
         CREATURES._guardian = null;
         BASE.Save();
         PATHING.GetPath(_tmpPoint,new Rectangle(_targetBuilding._mc.x,_targetBuilding._mc.y,80,80),this.setWaypoints,true);
      }
      
      override public function changeModeAttack() : void
      {
         changeMode();
         _behaviour = GLOBAL.e_BASE_MODE.ATTACK;
         _targetCreep = null;
         this.findTarget(0);
      }
      
      public function changeModeCage() : void
      {
         changeMode();
         _behaviour = "cage";
         _attacking = false;
         var _loc1_:Point = new Point(_house._mc.x + 50,_house._mc.y + 60);
         _targetCenter = GRID.FromISO(GLOBAL._bCage._mc.x,GLOBAL._bCage._mc.y);
         PATHING.GetPath(_tmpPoint,new Rectangle(_loc1_.x,_loc1_.y,10,10),this.setWaypoints,true);
         _house = GLOBAL._bCage;
      }
      
      public function changeModeFreeze() : void
      {
         changeMode();
         _behaviour = "freeze";
         _attacking = false;
         ++CREATURES._creatureID;
         ++CREATURES._creatureCount;
         CREATURES._creatures[CREATURES._creatureID] = this;
         PATHING.GetPath(_tmpPoint,new Rectangle(GLOBAL._bChamber._mc.x,GLOBAL._bChamber._mc.y,80,80),this.setWaypoints,true);
      }
      
      public function changeModeDefend() : void
      {
         changeMode();
         _behaviour = k_sBHVR_DEFEND;
      }
      
      public function changeModeDecoy() : void
      {
         var _loc2_:Decoy = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Point = null;
         var _loc1_:SiegeWeapon = SiegeWeapons.activeWeapon;
         if(Boolean(_loc1_) && _loc1_ is Decoy)
         {
            changeMode();
            _behaviour = "decoy";
            _attacking = false;
            _targetCreep = null;
            _loc2_ = _loc1_ as Decoy;
            _loc3_ = new Rectangle(_loc2_.x,_loc2_.y + _loc2_.decoyGraphic.height / 2,40,40);
            _targetCenter = new Point(_loc3_.x,_loc3_.y);
            if(_movement == "burrow")
            {
               _hasTarget = true;
               _hasPath = true;
               _loc7_ = GRID.FromISO(_loc3_.x,_loc3_.y);
               _loc8_ = int(Math.random() * 4);
               _loc9_ = _loc3_.height;
               _loc10_ = _loc3_.width;
               if(_loc8_ == 0)
               {
                  _loc7_.x += Math.random() * _loc9_;
                  _loc7_.y += _loc10_;
               }
               else if(_loc8_ == 1)
               {
                  _loc7_.x += _loc9_;
                  _loc7_.y += _loc10_;
               }
               else if(_loc8_ == 2)
               {
                  _loc7_.x += _loc9_ - Math.random() * _loc9_ / 2;
                  _loc7_.y -= _loc10_ / 4;
               }
               else if(_loc8_ == 3)
               {
                  _loc7_.x -= _loc9_ / 4;
                  _loc7_.y += _loc10_ - Math.random() * _loc10_ / 2;
               }
               _waypoints = [GRID.ToISO(_loc7_.x,_loc7_.y,0)];
               _targetPosition = _waypoints[0];
            }
            else if(_movement == "fly")
            {
               _hasTarget = true;
               _hasPath = true;
               if(GLOBAL.QuickDistance(_tmpPoint,_targetCenter) < 50)
               {
                  _atTarget = true;
                  _hasPath = true;
                  _targetPosition = _targetCenter;
               }
               else
               {
                  _loc5_ = (_loc5_ = (_loc5_ = Math.atan2(_tmpPoint.y - _targetCenter.y,_tmpPoint.x - _targetCenter.x) * 57.2957795) + (Math.random() * 90 - 45)) / (180 / Math.PI);
                  _loc4_ = 10 + Math.random() * 10;
                  _loc6_ = new Point(_targetCenter.x + Math.cos(_loc5_) * _loc4_ * 1.7,_targetCenter.y + Math.sin(_loc5_) * _loc4_);
                  _waypoints = [_loc6_];
                  _targetPosition = _waypoints[0];
               }
            }
            else
            {
               _loc5_ = (_loc5_ = (_loc5_ = Math.atan2(_tmpPoint.y - _targetCenter.y,_tmpPoint.x - _targetCenter.x) * 57.2957795) + (Math.random() * 90 - 45)) / (180 / Math.PI);
               _loc4_ = 10 + Math.random() * 10;
               _loc11_ = new Point(_targetCenter.x + Math.cos(_loc5_) * _loc4_ * 1.7,_targetCenter.y + Math.sin(_loc5_) * _loc4_);
               _loc11_.x += Math.random() * -10 + 5;
               _loc11_.y += Math.random() * -10 + 5;
               _targetPosition = _targetCenter;
               WaypointTo(_loc11_);
            }
         }
         else
         {
            _hasTarget = false;
            this.FindDefenseTargets();
         }
      }
      
      public function click(param1:MouseEvent) : void
      {
         if(GLOBAL.mode == "build")
         {
            show();
         }
      }
      
      override public function canShootCreep() : Boolean
      {
         if(_targetCreep == null)
         {
            return false;
         }
         if(_targetCreep._movement == "fly")
         {
            return false;
         }
         var _loc1_:Number = GLOBAL.QuickDistance(_targetCreep._tmpPoint,_tmpPoint);
         if(_loc1_ > m_range)
         {
            return false;
         }
         if(_movement == "fly")
         {
            return true;
         }
         if(PATHING.LineOfSight(_tmpPoint.x,_tmpPoint.y,_targetCreep._tmpPoint.x,_targetCreep._tmpPoint.y))
         {
            return true;
         }
         return false;
      }
      
      protected function canHitBuilding() : Boolean
      {
         if(_targetBuilding == null)
         {
            return false;
         }
         var _loc1_:Number = GLOBAL.QuickDistance(_targetBuilding._position,_tmpPoint);
         if(_loc1_ > m_range)
         {
            return false;
         }
         if(_movement == "fly")
         {
            return true;
         }
         if(PATHING.LineOfSight(_tmpPoint.x,_tmpPoint.y,_targetBuilding._position.x,_targetBuilding._position.y,_targetBuilding))
         {
            return true;
         }
         return false;
      }
      
      public function clearRasterData() : void
      {
         if(!BYMConfig.instance.RENDERER_ON)
         {
            return;
         }
         if(_rasterData)
         {
            _rasterData.clear();
         }
         _rasterData = null;
         _rasterPt = null;
      }
      
      override public function clear() : void
      {
         if(CREATURES._guardian == this)
         {
            CREATURES._guardian = null;
         }
         if(CREEPS._guardian == this)
         {
            CREEPS._guardian = null;
         }
         super.clear();
      }
      
      public function interceptTarget() : void
      {
         _intercepting = false;
         _looking = true;
         if(_movement == "fly" && _altitude < 60)
         {
            if(BYMConfig.instance.RENDERER_ON)
            {
               TweenLite.to(_rasterPt,2,{
                  "y":_rasterPt.y - (108 - _altitude),
                  "ease":Sine.easeIn,
                  "onComplete":this.flyerTakeOff
               });
            }
            else
            {
               TweenLite.to(_graphicMC,2,{
                  "y":_graphicMC.y - (108 - _altitude),
                  "ease":Sine.easeIn,
                  "onComplete":this.flyerTakeOff
               });
            }
            _altitude = 61;
         }
         if(GLOBAL.QuickDistance(_targetCreep._tmpPoint,_tmpPoint) < m_range)
         {
            _atTarget = true;
            _looking = false;
         }
         else if(_noDefensePath || GLOBAL.QuickDistance(_targetCreep._tmpPoint,_tmpPoint) < m_range * 2 || _movement == "fly")
         {
            _waypoints = [_targetCreep._tmpPoint];
            _targetPosition = _targetCreep._tmpPoint;
         }
         else if(_targetCreep._atTarget || _targetCreep._waypoints.length < 8 || GLOBAL.QuickDistance(_targetCreep._tmpPoint,_tmpPoint) < 250)
         {
            WaypointTo(_targetCreep._tmpPoint,null);
         }
         else
         {
            WaypointTo(_targetCreep._waypoints[7],null);
            _intercepting = true;
         }
         _hasTarget = true;
      }
      
      protected function getTargetCreeps() : void
      {
         _targetCreeps = Targeting.getCreepsInRange(800,_tmpPoint,attackFlags);
      }
      
      public function FindDefenseTargets() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Boolean = true;
         this.getTargetCreeps();
         if(_targetCreeps.length > 0)
         {
            _targetCreeps.sortOn(["dist"],Array.NUMERIC);
            while(_targetCreeps.length > 0 && (_targetCreeps[0].creep._behaviour == "retreat" || _movement != "fly" && _targetCreeps[0].creep._creatureID == "C5"))
            {
               _targetCreeps.splice(0,1);
            }
         }
         if(_targetCreeps.length > 0)
         {
            _targetCreep = _targetCreeps[0].creep;
            this.interceptTarget();
            if(_movement == "fly" && _altitude < 60)
            {
               if(BYMConfig.instance.RENDERER_ON)
               {
                  TweenLite.to(_rasterPt,2,{
                     "y":_rasterPt.y - (108 - _altitude),
                     "ease":Sine.easeIn,
                     "onComplete":this.flyerTakeOff
                  });
               }
               else
               {
                  TweenLite.to(_graphicMC,2,{
                     "y":_graphicMC.y - (108 - _altitude),
                     "ease":Sine.easeIn,
                     "onComplete":this.flyerTakeOff
                  });
               }
            }
            _behaviour = "defend";
         }
         else if(Boolean(_targetCreep) && _targetCreep.health > 0)
         {
            if(_movement == "fly")
            {
               this.interceptTarget();
            }
            _behaviour = "defend";
         }
         else if(_behaviour != "cage" && _behaviour != "pen")
         {
            _atTarget = false;
            this.changeModeCage();
         }
      }
      
      override public function findTarget(param1:int = 0) : void
      {
         var _loc3_:Object = null;
         var _loc4_:BFOUNDATION = null;
         var _loc5_:BFOUNDATION = null;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:Object = null;
         var _loc13_:Vector.<Object> = null;
         var _loc14_:Vector.<Object> = null;
         var _loc15_:int = 0;
         var _loc16_:Point = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Point = null;
         var _loc2_:int = getTimer();
         _loc10_ = [];
         _looking = true;
         _loc7_ = PATHING.FromISO(_tmpPoint);
         var _loc12_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         for each(_loc4_ in _loc12_)
         {
            if(_loc4_.health > 0 && (_loc4_._class == "resource" || _loc4_._type == 6 || _loc4_._type == 14 || _loc4_._type == 112))
            {
               _loc8_ = GRID.FromISO(_loc4_._mc.x,_loc4_._mc.y + _loc4_._middle);
               _loc9_ = GLOBAL.QuickDistance(_loc7_,_loc8_) - _loc4_._middle;
               _loc10_.push({
                  "building":_loc4_,
                  "distance":_loc9_
               });
            }
         }
         _loc13_ = InstanceManager.getInstancesByClass(BTOWER);
         for each(_loc4_ in _loc13_)
         {
            if(_loc4_.health > 0 && !(_loc4_ as BTOWER).isJard)
            {
               _loc8_ = GRID.FromISO(_loc4_._mc.x,_loc4_._mc.y + _loc4_._middle);
               _loc9_ = GLOBAL.QuickDistance(_loc7_,_loc8_) - _loc4_._middle;
               _loc10_.push({
                  "building":_loc4_,
                  "distance":_loc9_,
                  "expand":false
               });
            }
         }
         _loc14_ = InstanceManager.getInstancesByClass(Bunker);
         for each(_loc4_ in _loc14_)
         {
            if((_loc11_ = _loc4_).health > 0 && (_loc11_._used > 0 || _loc11_._monstersDispatchedTotal > 0))
            {
               _loc8_ = GRID.FromISO(_loc4_._mc.x,_loc4_._mc.y + _loc4_._middle);
               _loc9_ = GLOBAL.QuickDistance(_loc7_,_loc8_) - _loc4_._middle;
               _loc10_.push({
                  "building":_loc4_,
                  "distance":_loc9_,
                  "expand":false
               });
            }
         }
         if(_loc10_.length == 0)
         {
            for each(_loc4_ in BASE._buildingsMain)
            {
               if(_loc4_ is BMUSHROOM === false && _loc4_._class != "decoration" && _loc4_._class != "immovable" && _loc4_.health > 0 && _loc4_._class != "enemy")
               {
                  if(_loc4_._class == "tower" && _loc4_ is Bunker === false)
                  {
                     if((_loc4_ as BTOWER).isJard)
                     {
                        continue;
                     }
                  }
                  _loc8_ = GRID.FromISO(_loc4_._mc.x,_loc4_._mc.y + _loc4_._middle);
                  _loc9_ = GLOBAL.QuickDistance(_loc7_,_loc8_) - _loc4_._middle;
                  _loc10_.push({
                     "building":_loc4_,
                     "distance":_loc9_,
                     "expand":true
                  });
               }
            }
         }
         if(_loc10_.length == 0)
         {
            changeModeRetreat();
         }
         else
         {
            _loc10_.sortOn("distance",Array.NUMERIC);
            _loc15_ = 0;
            if(_movement == "burrow")
            {
               _hasTarget = true;
               _hasPath = true;
               _loc16_ = GRID.FromISO(_loc10_[_loc15_].building._mc.x,_loc10_[_loc15_].building._mc.y);
               _loc17_ = int(Math.random() * 4);
               _loc18_ = int(_loc10_[_loc15_].building._footprint[0].height);
               _loc19_ = int(_loc10_[_loc15_].building._footprint[0].width);
               if(_loc17_ == 0)
               {
                  _loc16_.x += Math.random() * _loc18_;
                  _loc16_.y += _loc19_;
               }
               else if(_loc17_ == 1)
               {
                  _loc16_.x += _loc18_;
                  _loc16_.y += _loc19_;
               }
               else if(_loc17_ == 2)
               {
                  _loc16_.x += _loc18_ - Math.random() * _loc18_ / 2;
                  _loc16_.y -= _loc19_ / 4;
               }
               else if(_loc17_ == 3)
               {
                  _loc16_.x -= _loc18_ / 4;
                  _loc16_.y += _loc19_ - Math.random() * _loc19_ / 2;
               }
               _waypoints = [GRID.ToISO(_loc16_.x,_loc16_.y,0)];
               _targetPosition = _waypoints[0];
               _targetBuilding = _loc10_[_loc15_].building;
            }
            else if(_movement == "fly")
            {
               _hasTarget = true;
               _hasPath = true;
               _targetBuilding = _loc10_[_loc15_].building;
               _targetCenter = _targetBuilding._position;
               if(GLOBAL.QuickDistance(_tmpPoint,_targetCenter) < 170)
               {
                  _atTarget = true;
                  _hasPath = true;
                  _targetPosition = _targetCenter;
               }
               else
               {
                  _loc20_ = (_loc20_ = (_loc20_ = Math.atan2(_tmpPoint.y - _targetCenter.y,_tmpPoint.x - _targetCenter.x) * 57.2957795) + (Math.random() * 40 - 20)) / (180 / Math.PI);
                  _loc21_ = 120 + Math.random() * 10;
                  _loc22_ = new Point(_targetCenter.x + Math.cos(_loc20_) * _loc21_ * 1.7,_targetCenter.y + Math.sin(_loc20_) * _loc21_);
                  _waypoints = [_loc22_];
                  _targetPosition = _waypoints[0];
               }
            }
            else if(GLOBAL._catchup)
            {
               WaypointTo(new Point(_loc10_[0].building._mc.x,_loc10_[0].building._mc.y),_loc10_[0].building);
            }
            else
            {
               _loc15_ = 0;
               while(_loc15_ < 2)
               {
                  if(_loc10_.length > _loc15_)
                  {
                     WaypointTo(new Point(_loc10_[_loc15_].building._mc.x,_loc10_[_loc15_].building._mc.y),_loc10_[_loc15_].building);
                  }
                  _loc15_++;
               }
            }
         }
      }
      
      override public function setWaypoints(param1:Array, param2:BFOUNDATION = null, param3:Boolean = false) : void
      {
         var _loc4_:Boolean = false;
         if(param3)
         {
            if(_behaviour == GLOBAL.e_BASE_MODE.ATTACK)
            {
               this.findTarget();
            }
            if(_behaviour == "cage")
            {
               this.changeModeCage();
            }
            if(_behaviour == "retreat")
            {
               changeModeRetreat();
            }
         }
         else
         {
            _loc4_ = false;
            if(param1.length < _waypoints.length)
            {
               _loc4_ = true;
            }
            if(_loc4_ && param2 && param2._class == "wall" && _targetGroup != 2)
            {
               _loc4_ = false;
            }
            if(!_hasTarget)
            {
               _loc4_ = true;
            }
            if(_behaviour == "defend")
            {
               _loc4_ = true;
            }
            if(_loc4_)
            {
               _hasTarget = true;
               _atTarget = false;
               _hasPath = true;
               _waypoints = param1;
               _targetPosition = _waypoints[0];
               if(param2)
               {
                  _targetBuilding = param2;
               }
            }
            _looking = false;
         }
      }
      
      public function levelSet(param1:int, param2:int = 0) : void
      {
         var _loc3_:Object = null;
         if(param1 != this._level.Get())
         {
            this._level = new SecNum(param1);
            if(this is Krallen)
            {
               this._spriteID = _creatureID + "_" + this._powerLevel.Get();
            }
            else
            {
               this._spriteID = _creatureID + "_" + param1;
            }
            if(_graphicMC.parent)
            {
               _graphicMC.parent.removeChild(_graphicMC);
            }
            SPRITES.SetupSprite(this._spriteID);
            _loc3_ = SPRITES.GetSpriteDescriptor(this._spriteID);
            _graphic = new BitmapData(_loc3_.width,_loc3_.height,true,16777215);
            _graphicMC = !BYMConfig.instance.RENDERER_ON ? graphic.addChild(new Bitmap(_graphic)) as Bitmap : new Bitmap(_graphic);
            if(BYMConfig.instance.RENDERER_ON && Boolean(_rasterData))
            {
               _rasterData.data = _graphic;
            }
            if(this is Krallen)
            {
               _graphicMC.x = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._powerLevel.Get(),"offset_x");
               _graphicMC.y = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._powerLevel.Get(),"offset_y");
            }
            else
            {
               _graphicMC.x = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"offset_x");
               _graphicMC.y = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"offset_y");
            }
            this._feeds = new SecNum(0);
            this._feedTime = new SecNum(int(GLOBAL.Timestamp() + CHAMPIONCAGE.GetGuardianProperty(_creatureID,param1,"feedTime")));
            LOGGER.Log("fed","level " + this._level.Get());
            maxHealthProperty.value = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"health");
            moveSpeedProperty.value = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"speed") / 2;
            this._regen = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"healtime");
            setHealth(maxHealth);
            damageProperty.value = int(CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"damage"));
            m_range = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"range");
            _movement = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"movement");
            if(param1 >= 6)
            {
               QUESTS.Check("upgrade_champ" + _creatureID.substr(1,1),1);
            }
            LOGGER.Stat([57,_creatureID,param2,this._level.Get()]);
            BASE.Save();
         }
      }
      
      protected function tickBAttack() : void
      {
         if(health <= 0)
         {
            Targeting.CreepCellDelete(_id,node);
            var activeEvent:* = SPECIALEVENT.getActiveSpecialEvent();
            if(!activeEvent.active) {
               changeModeRetreat();
               ATTACK.Log(_creatureID,LOGIN._playerName + "\'s Level " + this._level.Get() + " " + CHAMPIONCAGE._guardians[_creatureID].name + " retreated.");
               SOUNDS.Play("monsterland" + (1 + int(Math.random() * 3)));
               if(GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK)
               {
                  LOGGER.Stat([54,_creatureID,1,this._level.Get()]);
               }
            }
            BASE.Save();
            return;
         }
         if(_hasTarget)
         {
            if(!_targetCreep)
            {
               if(_targetBuilding == null || _targetBuilding.health <= 0 || _targetBuilding._class == "tower" && !MONSTERBUNKER.isBunkerBuilding(_targetBuilding._type) && (_targetBuilding as BTOWER).isJard)
               {
                  loseTarget();
                  this.findTarget();
               }
            }
            else if(_targetCreep.health <= 0)
            {
               loseTarget();
               this.findTarget();
            }
         }
         if(!_looking && !_attacking && _frameNumber % (GLOBAL._catchup ? 200 : 100) == 0)
         {
            this.findTarget(0);
         }
         if(_atTarget)
         {
            _attacking = true;
            if(attackCooldown <= 0)
            {
               attackCooldown += int(attackDelay);
               this.doAttackDamage();
               SOUNDS.Play("hit" + int(4 + Math.random() * 1),0.1 + Math.random() * 0.1);
            }
            else
            {
               --attackCooldown;
            }
         }
         else
         {
            _attacking = false;
         }
      }
      
      protected function doAttackDamage() : void
      {
         var _loc1_:Number = 1;
         if(Boolean(_targetBuilding) && _targetBuilding._fortification.Get() > 0)
         {
            ATTACK.Damage(_tmpPoint.x,_tmpPoint.y - 5,damage * _loc1_ * (100 - (_targetBuilding._fortification.Get() * 10 + 10)) / 100,_mc.visible);
         }
         else
         {
            ATTACK.Damage(_tmpPoint.x,_tmpPoint.y - 5,damage * _loc1_,_mc.visible);
         }
         if(_targetCreep)
         {
            _targetCreep.modifyHealth(-(damage * _loc1_));
         }
         else if(_targetBuilding)
         {
            _targetBuilding.modifyHealth(damage * _loc1_,this);
            if(_creatureID === "G5" && _targetBuilding is ILootable)
            {
               if(_targetBuilding._looted)
               {
                  this.findTarget();
               }
            }
         }
         else
         {
            this.findTarget();
         }
      }
      
      override public function modifyHealth(param1:Number, param2:ITargetable = null) : Number
      {
         return super.modifyHealth(param1,param2);
      }
      
      protected function tickBDefend() : void
      {
         if(health <= 0)
         {
            ATTACK.Log(_creatureID,KEYS.Get("attacklog_champ_injured",{
               "v1":BASE._ownerName,
               "v2":this._level.Get(),
               "v3":CHAMPIONCAGE._guardians[_creatureID].name
            }));
            changeModeRetreat();
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK)
            {
               LOGGER.Stat([56,_creatureID,1,this._level.Get()]);
            }
            BASE.Save();
            return;
         }
         if(_hasTarget)
         {
            if(_targetCreep.health <= 0)
            {
               _hasTarget = false;
               _atTarget = false;
               _hasPath = false;
               _attacking = false;
               this.FindDefenseTargets();
            }
            else if(GLOBAL.QuickDistance(_targetCreep._tmpPoint,_tmpPoint) < m_range)
            {
               _atTarget = true;
            }
            else if(_creatureID == "G4" && _targetCreep._movement == "fly" && GLOBAL.QuickDistance(_targetCreep._tmpPoint,_tmpPoint) < m_range * 2)
            {
               _atTarget = true;
            }
            else if(!_attacking && _frameNumber % 60 == 0)
            {
               this.FindDefenseTargets();
            }
            else if(_attacking && GLOBAL.QuickDistance(_targetCreep._tmpPoint,_tmpPoint) > m_range * 2)
            {
               _attacking = false;
               _atTarget = false;
               _hasPath = false;
               this.FindDefenseTargets();
            }
         }
         if(_atTarget)
         {
            _attacking = true;
            _intercepting = false;
            if(_movement != "fly" || _targetCreep._creatureID == "C14" || _targetCreep._creatureID == "C12" && _targetCreep.poweredUp() || _targetCreep._creatureID == "G3" || _targetCreep._creatureID == "G4" || _targetCreep._creatureID == "IC7" || _targetCreep._creatureID == "IC5")
            {
               if(_targetCreep._behaviour != "heal")
               {
                  _targetCreep._targetCreep = this;
                  if(_targetCreep._creatureID == "C14" || _targetCreep._creatureID == "IC7" || _targetCreep._creatureID == "C12" && _targetCreep.poweredUp() || _targetCreep._creatureID == "G3" || _targetCreep._creatureID == "G4" || (GLOBAL.QuickDistance(_targetCreep._tmpPoint,_tmpPoint) < 50 || _targetCreep._creatureID.substr(0,1) == "G") && _movement != "fly")
                  {
                     _targetCreep._atTarget = true;
                  }
                  else
                  {
                     _targetCreep._atTarget = false;
                     _targetCreep._waypoints = [_tmpPoint];
                  }
                  _targetCreep._hasTarget = true;
                  _targetCreep._looking = false;
               }
            }
            if(attackCooldown <= 0)
            {
               attackCooldown += int(attackDelay);
               this.doDefenseDamage();
               this.aggro();
            }
            else
            {
               --attackCooldown;
            }
         }
         else
         {
            _attacking = false;
         }
      }
      
      protected function aggro() : void
      {
         if(Targeting.canHitCreep(_targetCreep.attackFlags,defenseFlags))
         {
            if(!_targetCreep._explode && !_targetCreep._targetCreep && _targetCreep._behaviour != "heal")
            {
               _targetCreep._targetCreep = this;
               if(_targetCreep.canShootCreep() || GLOBAL.QuickDistance(_targetCreep._tmpPoint,_tmpPoint) < 50)
               {
                  _targetCreep._atTarget = true;
               }
               else
               {
                  _targetCreep._atTarget = false;
                  _targetCreep._waypoints = [_tmpPoint];
               }
               _targetCreep._hasTarget = true;
               _targetCreep._looking = false;
            }
         }
         var _loc1_:Array = Targeting.getCreepsInRange(50,_tmpPoint,Targeting.getOldStyleTargets(0));
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < 5 && _loc3_ < _loc2_)
         {
            if(Targeting.canHitCreep(_loc1_[_loc3_].creep.attackFlags,defenseFlags) && (_loc1_[_loc3_].creep.canShootCreep() || GLOBAL.QuickDistance(_targetCreep._tmpPoint,_tmpPoint) < 50))
            {
               if(!_loc1_[_loc3_].creep._explode && _loc1_[_loc3_].creep._behaviour != "heal")
               {
                  _loc1_[_loc3_].creep._targetCreep = this;
                  if(_loc1_[_loc3_].creep.canShootCreep() || GLOBAL.QuickDistance(_loc1_[_loc3_].creep._tmpPoint,_tmpPoint) < 50 || _loc1_[_loc3_].creep._creatureID == "C14")
                  {
                     _loc1_[_loc3_].creep._atTarget = true;
                  }
                  _loc1_[_loc3_].creep._hasTarget = true;
               }
            }
            _loc3_++;
         }
      }
      
      protected function doDefenseDamage() : void
      {
         var _loc1_:Point = null;
         if(_creatureID == "G3")
         {
            _loc1_ = Point.interpolate(_tmpPoint.add(new Point(0,-_altitude)),_targetCreep._tmpPoint,0.8);
            FIREBALLS.Spawn2(_loc1_,_targetCreep._tmpPoint,_targetCreep,8,damage,0,FIREBALLS.TYPE_FIREBALL,1,this);
            FIREBALLS._fireballs[FIREBALLS._id - 1]._graphic.gotoAndStop(3);
         }
         else
         {
            ATTACK.Damage(_tmpPoint.x,_tmpPoint.y - 5,damage,_mc.visible);
            _targetCreep.modifyHealth(-damage);
         }
      }
      
      public function tickBJuice(param1:int) : Boolean
      {
         if(health <= 0)
         {
            setHealth(0);
            Targeting.CreepCellDelete(_id,node);
            changeModeRetreat();
            return false;
         }
         if(_atTarget)
         {
            if(_movement == "fly")
            {
               if(!dying)
               {
                  _dying = true;
                  if(BYMConfig.instance.RENDERER_ON)
                  {
                     TweenLite.to(_rasterPt,0.9,{
                        "y":_rasterPt.y + _altitude,
                        "ease":Sine.easeOut,
                        "onComplete":flyerJuice
                     });
                  }
                  else
                  {
                     TweenLite.to(_graphicMC,0.9,{
                        "y":_graphicMC.y + _altitude,
                        "ease":Sine.easeOut,
                        "onComplete":flyerJuice
                     });
                  }
               }
               if(!m_juiceReady)
               {
                  return false;
               }
            }
            GLOBAL._bJuicer.BlendGuardian(100 * 10 ^ this._level.Get() / 2);
            return true;
         }
         return false;
      }
      
      public function tickBFreeze(param1:int) : Boolean
      {
         if(_atTarget)
         {
            return true;
         }
         return false;
      }
      
      public function tickBDecoy() : Boolean
      {
         if(health <= 0)
         {
            ATTACK.Log(_creatureID,KEYS.Get("attacklog_champ_injured",{
               "v1":BASE._ownerName,
               "v2":this._level.Get(),
               "v3":CHAMPIONCAGE._guardians[_creatureID].name
            }));
            changeModeRetreat();
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK)
            {
               LOGGER.Stat([56,_creatureID,1,this._level.Get()]);
            }
            BASE.Save();
            return false;
         }
         if(!(SiegeWeapons.activeWeapon && SiegeWeapons.activeWeapon is Decoy))
         {
            _hasTarget = false;
            _atTarget = false;
            _attacking = false;
            _hasPath = false;
            this.FindDefenseTargets();
         }
         return false;
      }
      
      public function flyerLanded() : void
      {
         _altitude = 0;
      }
      
      public function flyerTakeOff() : void
      {
         _altitude = 108;
      }
      
      override public function poweredUp() : Boolean
      {
         return false;
      }
      
      public function tickBPen(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         if(health < maxHealth)
         {
            if(this._lastHeal <= GLOBAL.Timestamp() - 5 || GLOBAL._catchup && BASE.firstBaseLoaded)
            {
               this.modifyHealth(int(maxHealth * 5 / this._regen) * param1);
               setHealth(Math.min(health,maxHealth));
               this._lastHeal = GLOBAL.Timestamp();
            }
         }
         if(this._behaviourMode == "defend" && _frameNumber % 200 == 0)
         {
            this.FindDefenseTargets();
         }
         if(_behaviour == "pen" && _frameNumber > 240 && int(Math.random() * 150) == 1 && GLOBAL._fps > 25)
         {
            _targetPosition = CHAMPIONCAGE.PointInCage(_targetCenter);
            _hasPath = true;
         }
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && this._level.Get() < 6)
         {
            if(!this._warnStarve)
            {
               if(GLOBAL.Timestamp() > this._feedTime.Get() + CHAMPIONCAGE.STARVETIMER)
               {
                  CHAMPIONCAGE.Hide();
                  if(!GLOBAL._catchup)
                  {
                     GLOBAL.Message(KEYS.Get("msg_champion_starving"));
                  }
                  this._feeds.Add(-1);
                  if(this._feeds.Get() < 0)
                  {
                     this._feeds.Set(0);
                  }
                  this._feedTime = new SecNum(int(GLOBAL.Timestamp() + CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"feedTime")));
                  this._warnStarve = true;
                  LOGGER.Log("fed","Starved level " + this._level.Get());
               }
            }
            else if(!this._warned)
            {
               if(GLOBAL.Timestamp() > this._feedTime.Get())
               {
                  CHAMPIONCAGE.Hide();
                  if(!GLOBAL._catchup)
                  {
                     GLOBAL.Message(KEYS.Get("msg_champion_hungry",{"v1":GLOBAL.ToTime(this._feedTime.Get() - GLOBAL.Timestamp() + CHAMPIONCAGE.STARVETIMER)}));
                  }
                  this._warned = true;
               }
            }
            if(this._feeds.Get() >= CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"feeds"))
            {
               this.levelSet(this._level.Get() + 1);
            }
         }
         else if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && this._level.Get() == 6)
         {
            if(GLOBAL.Timestamp() > this._feedTime.Get() + CHAMPIONCAGE.STARVETIMER)
            {
               CHAMPIONCAGE.Hide();
               _loc2_ = health;
               _loc3_ = Math.max(1,this._foodBonus.Get() - 1);
               _loc4_ = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"health") + CHAMPIONCAGE.GetGuardianProperty(_creatureID,_loc3_,"bonusHealth");
               if(_loc2_ < 1)
               {
                  _loc2_ = 1;
               }
               else if(_loc2_ >= _loc4_)
               {
                  _loc2_ = _loc4_;
               }
               setHealth(_loc2_);
               this._foodBonus.Add(-param1);
               if(this._foodBonus.Get() < 0)
               {
                  this._foodBonus.Set(0);
               }
               this._feedTime = new SecNum(int(GLOBAL.Timestamp() + CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"feedTime")));
            }
         }
      }
      
      public function tickBCage(param1:int) : void
      {
         if(_atTarget)
         {
            _behaviour = k_sBHVR_PEN;
            if(_movement == "fly" && _altitude > 60)
            {
               if(BYMConfig.instance.RENDERER_ON)
               {
                  TweenLite.to(_rasterPt,1.2,{
                     "y":_rasterPt.y + _altitude,
                     "ease":Sine.easeOut,
                     "onComplete":this.flyerLanded
                  });
               }
               else
               {
                  TweenLite.to(_graphicMC,1.2,{
                     "y":_graphicMC.y + _altitude,
                     "ease":Sine.easeOut,
                     "onComplete":this.flyerLanded
                  });
               }
            }
            _waypoints[0] = CHAMPIONCAGE.PointInCage(_targetCenter);
         }
         else if(this._behaviourMode == k_sBHVR_DEFEND && _frameNumber % 200 == 0)
         {
            this.FindDefenseTargets();
         }
      }
      
      public function tickBRetreat() : Boolean
      {
         if(_atTarget)
         {
            return true;
         }
         return false;
      }
      
      public function tickDefault() : void
      {
      }
      
      public function export(param1:Boolean = true) : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         if(_behaviour == "juice" || _behaviour == "freeze")
         {
            return;
         }
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         _loc2_ = 0;
         while(_loc2_ < CREATURES._guardianList.length)
         {
            if(CREATURES._guardianList[_loc2_] == this)
            {
               _loc3_ = true;
               break;
            }
            _loc2_++;
         }
         if(param1 && _loc3_)
         {
            _loc6_ = int(BASE._guardianData.length);
            _loc7_ = false;
            _loc2_ = 0;
            while(_loc2_ < _loc6_)
            {
               if(BASE._guardianData[_loc2_].t == int(_creatureID.substr(1)))
               {
                  _loc7_ = true;
                  break;
               }
               _loc2_++;
            }
            if(!_loc7_)
            {
               _loc2_ = int(BASE._guardianData.push({}) - 1);
            }
            _loc4_ = int(BASE._guardianData[_loc2_].status);
            if((_loc5_ = String(BASE._guardianData[_loc2_].log)) == null)
            {
               _loc5_ = _loc4_.toString();
            }
            BASE._guardianData[_loc2_] = {};
            BASE._guardianData[_loc2_].hp = new SecNum(health);
            BASE._guardianData[_loc2_].l = new SecNum(this._level.Get());
            BASE._guardianData[_loc2_].fd = this._feeds.Get();
            BASE._guardianData[_loc2_].ft = this._feedTime.Get();
            BASE._guardianData[_loc2_].nm = this._name;
            BASE._guardianData[_loc2_].t = int(_creatureID.substr(1));
            BASE._guardianData[_loc2_].fb = new SecNum(this._foodBonus.Get());
            BASE._guardianData[_loc2_].pl = new SecNum(this._powerLevel.Get());
            BASE._guardianData[_loc2_].status = _loc4_;
            BASE._guardianData[_loc2_].log = _loc5_;
         }
         if(!param1 && GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD || param1 && _loc3_ && GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            _loc2_ = GLOBAL.getPlayerGuardianIndex(int(_creatureID.substr(1)));
            if(_loc2_ < 0)
            {
               _loc2_ = int(GLOBAL._playerGuardianData.push({}) - 1);
            }
            _loc4_ = int(GLOBAL._playerGuardianData[_loc2_].status);
            if((_loc5_ = String(GLOBAL._playerGuardianData[_loc2_].log)) == null)
            {
               _loc5_ = _loc4_.toString();
            }
            GLOBAL._playerGuardianData[_loc2_] = {};
            GLOBAL._playerGuardianData[_loc2_].hp = new SecNum(health);
            GLOBAL._playerGuardianData[_loc2_].l = new SecNum(this._level.Get());
            GLOBAL._playerGuardianData[_loc2_].fd = this._feeds.Get();
            GLOBAL._playerGuardianData[_loc2_].ft = this._feedTime.Get();
            GLOBAL._playerGuardianData[_loc2_].nm = this._name;
            GLOBAL._playerGuardianData[_loc2_].t = int(_creatureID.substr(1));
            GLOBAL._playerGuardianData[_loc2_].fb = new SecNum(this._foodBonus.Get());
            GLOBAL._playerGuardianData[_loc2_].pl = new SecNum(this._powerLevel.Get());
            GLOBAL._playerGuardianData[_loc2_].status = _loc4_;
            GLOBAL._playerGuardianData[_loc2_].log = _loc5_;
         }
      }
      
      public function heal() : void
      {
         var _loc1_:int = 0;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            _loc1_ = this.getHealCost();
            if(_loc1_ > 0)
            {
               GLOBAL.Message(KEYS.Get("msg_healchampion",{"v1":_loc1_}),KEYS.Get("str_heal"),this.healB);
            }
         }
      }
      
      public function healB() : void
      {
         var _loc1_:int = 0;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            _loc1_ = this.getHealCost();
            if(_loc1_ > BASE._credits.Get())
            {
               POPUPS.DisplayGetShiny();
               return;
            }
            setHealth(maxHealth);
            BASE.Purchase("IHE",_loc1_,"CHAMPION.Heal");
            this.export(_friendly);
            LOGGER.Stat([58,_creatureID,_loc1_,this._level.Get()]);
            BASE.Save();
         }
      }
      
      public function getHealCost() : int
      {
         var _loc1_:Number = (maxHealth - health) / maxHealth;
         var _loc2_:int = int(_loc1_ * CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"healtime"));
         return STORE.GetTimeCost(_loc2_,false);
      }
      
      override public function updateBuffs() : void
      {
         super.updateBuffs();
         if(this._foodBonus.Get() > 0)
         {
            moveSpeedProperty.value = (CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"speed") + CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._foodBonus.Get(),"bonusSpeed")) / 2;
         }
         else
         {
            moveSpeedProperty.value = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"speed") / 2;
         }
         if(_speed > moveSpeed)
         {
            _speed = moveSpeed;
         }
         if(this._foodBonus.Get() > 0)
         {
            maxHealthProperty.value = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"health") + CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._foodBonus.Get(),"bonusHealth");
         }
         else
         {
            maxHealthProperty.value = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"health");
         }
         if(health > maxHealth)
         {
            setHealth(maxHealth);
         }
         if(this._foodBonus.Get() > 0)
         {
            damageProperty.value = int(CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"damage")) + int(CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._foodBonus.Get(),"bonusDamage"));
         }
         else
         {
            damageProperty.value = int(CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"damage"));
         }
         if(this._foodBonus.Get() > 0)
         {
            m_range = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"range") + CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._foodBonus.Get(),"bonusRange");
         }
         else
         {
            m_range = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"range");
         }
         if(this._foodBonus.Get() > 0)
         {
            this._buff = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"buffs") + CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._foodBonus.Get(),"bonusBuffs");
         }
         else
         {
            this._buff = CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"buffs");
         }
      }
      
      public function get tickLimit() : int
      {
         if(_behaviour != "cage" && _behaviour != "pen" && _behaviour != "juice" && _behaviour != "freeze")
         {
            return 1;
         }
         return int.MAX_VALUE;
      }
      
      override protected function hackCheck() : Boolean
      {
         if(_frameNumber % 30 == 0)
         {
            if(maxHealth != CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"health"))
            {
               if(maxHealth != CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"health") + CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._foodBonus.Get(),"bonusHealth"))
               {
                  LOGGER.Log("hak","Champion monster health max incorrect");
                  GLOBAL.ErrorMessage("GUARDIANMONSTER hack 2");
                  return false;
               }
            }
            if(m_range != CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"range"))
            {
               if(m_range != CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._level.Get(),"range") + CHAMPIONCAGE.GetGuardianProperty(_creatureID,this._foodBonus.Get(),"bonusRange"))
               {
                  LOGGER.Log("hak","Champion monster range incorrect");
                  GLOBAL.ErrorMessage("GUARDIANMONSTER hack 4");
                  return false;
               }
            }
         }
         return true;
      }
      
      override protected function tickState(param1:int = 1) : Boolean
      {
         var _loc2_:Number = NaN;
         super.tickState(param1);
         this.updateBuffs();
         this.hackCheck();
         this.export(_friendly);
         if(_movement == "fly" && health > 0 && _behaviour != "pen")
         {
            if(_altitude >= 60)
            {
               _loc2_ = Math.sin(_frameNumber / 50) * 5;
               _altitude = 108 - _loc2_;
               _graphicMC.y = -_altitude - 36 + _loc2_;
            }
         }
         switch(_behaviour)
         {
            case k_sBHVR_ATTACK:
            case k_sBHVR_BOUNCE:
               this.tickBAttack();
               var activeEvent:* = SPECIALEVENT.getActiveSpecialEvent();
               if(activeEvent.active && this.health <= 0)
               {
                  return true;
               }
               break;
            case k_sBHVR_DEFEND:
               this.tickBDefend();
               break;
            case k_sBHVR_PEN:
               this.tickBPen(param1);
               break;
            case "cage":
               this.tickBCage(param1);
               break;
            case k_sBHVR_JUICE:
               if(this.tickBJuice(param1))
               {
                  return true;
               }
               break;
            case "freeze":
               if(this.tickBFreeze(param1))
               {
                  return true;
               }
               break;
            case k_sBHVR_RETREAT:
               if(this.tickBRetreat())
               {
                  return true;
               }
               break;
            case k_sBHVR_DECOY:
               if(this.tickBDecoy())
               {
                  return true;
               }
               break;
            default:
               this.tickDefault();
         }
         if((this.inBattleState || _behaviour == "retreat" && health > 0) && _frameNumber % 5 == 0)
         {
            newNode = Targeting.CreepCellMove(_tmpPoint,_id,this,node);
            if(newNode)
            {
               node = newNode;
            }
         }
         return false;
      }
      
      override protected function move() : void
      {
         _speed = moveSpeed * 0.5;
         if(_behaviour == "pen")
         {
            _speed *= 0.5;
         }
         if(_behaviour == "juice" || _behaviour == "cage" || _behaviour == "bunker" || _behaviour == "freeze")
         {
            _speed *= 1.5;
         }
         if(_behaviour == "defend")
         {
            _speed *= 1.5;
         }
         if(_behaviour == "juice" && _movement == "fly" && _altitude < 60)
         {
            _speed = 0;
         }
         if(_attacking)
         {
            _speed = 0;
         }
         if(_jumping)
         {
            if(_jumpingUp)
            {
               _speed *= 3;
            }
            else
            {
               _speed *= 2;
            }
         }
         if(!_atTarget && _behaviour != "cage" && _behaviour != "pen" && _behaviour != "juice" && (_targetCreep && this.canShootCreep() || this.canHitBuilding()))
         {
            _atTarget = true;
            if(_targetCreep)
            {
               _xd = _targetCreep._tmpPoint.x - _tmpPoint.x;
               _yd = _targetCreep._tmpPoint.y - _tmpPoint.y;
               _targetPosition = _targetCreep._tmpPoint;
            }
            else if(_targetBuilding)
            {
               _targetPosition = new Point(_targetBuilding._mc.x,_targetBuilding._mc.y + _targetBuilding._footprint[0].height / 2);
               _xd = _targetPosition.x - _tmpPoint.x;
               _yd = _targetPosition.y - _tmpPoint.y;
            }
            else if(_waypoints.length > 0)
            {
               _xd = _waypoints[_waypoints.length - 1].x - _tmpPoint.x;
               _yd = _waypoints[_waypoints.length - 1].y - _tmpPoint.y;
               _targetPosition = _waypoints[_waypoints.length - 1];
            }
         }
         else if(Boolean(_targetCreep) && _behaviour == GLOBAL.e_BASE_MODE.ATTACK)
         {
            _xd = _targetCreep._tmpPoint.x - _tmpPoint.x;
            _yd = _targetCreep._tmpPoint.y - _tmpPoint.y;
            _targetPosition = _targetCreep._tmpPoint;
            if(GLOBAL.QuickDistance(_targetPosition,_tmpPoint) > m_range)
            {
               _tmpPoint.x += Math.cos(Math.atan2(_yd,_xd)) * _speed;
               _tmpPoint.y += Math.sin(Math.atan2(_yd,_xd)) * _speed;
            }
            else
            {
               _atTarget = true;
            }
         }
         else if(_waypoints.length > 0)
         {
            _targetPosition = _waypoints[0];
            if(GLOBAL.QuickDistance(_targetPosition,_tmpPoint) <= 10)
            {
               while(_waypoints.length > 0 && GLOBAL.QuickDistance(_targetPosition,_tmpPoint) <= 10)
               {
                  _waypoints.splice(0,1);
                  if(_waypoints[0])
                  {
                     _targetPosition = _waypoints[0];
                  }
                  else
                  {
                     if(_behaviour != "defend")
                     {
                        _atTarget = true;
                        return;
                     }
                     if(GLOBAL.QuickDistance(_targetCreep._tmpPoint,_tmpPoint) < m_range)
                     {
                        _atTarget = true;
                        if(_targetCreep._behaviour != "heal")
                        {
                           _targetCreep._targetCreep = this;
                           if(_targetCreep._creatureID == "C14" || _targetCreep.canShootCreep() || GLOBAL.QuickDistance(_targetCreep._tmpPoint,_tmpPoint) < 50 && _movement != "fly")
                           {
                              _targetCreep._atTarget = true;
                           }
                           else
                           {
                              _targetCreep._atTarget = false;
                              _targetCreep._waypoints = [_tmpPoint];
                           }
                           _targetCreep._hasTarget = true;
                           _targetCreep._looking = false;
                        }
                        return;
                     }
                  }
               }
               if(_behaviour == k_sBHVR_DEFEND)
               {
                  if(_creatureID != "G3" && GLOBAL.QuickDistance(_targetCreep._tmpPoint,_tmpPoint) < m_range || this.canShootCreep())
                  {
                     _atTarget = true;
                     _targetPosition = _targetCreep._tmpPoint;
                     if(!_targetCreep._explode && _targetCreep._behaviour != "heal")
                     {
                        _targetCreep._targetCreep = this;
                        if(_targetCreep._creatureID == "C14" || _targetCreep.canShootCreep() || GLOBAL.QuickDistance(_targetCreep._tmpPoint,_tmpPoint) < 50 && _movement != "fly")
                        {
                           _targetCreep._atTarget = true;
                        }
                        else
                        {
                           _targetCreep._atTarget = false;
                           _targetCreep._waypoints = [_tmpPoint];
                        }
                        _targetCreep._hasTarget = true;
                        _targetCreep._looking = false;
                     }
                     return;
                  }
                  if(_targetCreep && _waypoints.length == 0 && _hasPath)
                  {
                     if(_noDefensePath)
                     {
                        _targetPosition = _targetCreep._tmpPoint;
                        _waypoints = [_targetCreep._tmpPoint];
                     }
                     else
                     {
                        WaypointTo(_targetCreep._tmpPoint,null);
                     }
                  }
               }
               else if(_waypoints.length == 0 && _hasPath && (_targetCreep || _behaviour == "cage" || _behaviour == "juice" || _behaviour == "retreat" || _behaviour == "pen"))
               {
                  _atTarget = true;
                  return;
               }
            }
            if(_waypoints.length > 0)
            {
               _targetPosition = _waypoints[0];
            }
            if(_behaviour == GLOBAL.e_BASE_MODE.ATTACK && Boolean(_targetCreep))
            {
               _xd = _targetCreep._tmpPoint.x - _tmpPoint.x;
               _yd = _targetCreep._tmpPoint.y - _tmpPoint.y;
            }
            else if(_behaviour == "defend")
            {
               if(_attacking)
               {
                  _xd = _targetCreep._tmpPoint.x - _tmpPoint.x;
                  _yd = _targetCreep._tmpPoint.y - _tmpPoint.y;
               }
               else if(_targetPosition)
               {
                  _xd = _targetPosition.x - _tmpPoint.x;
                  _yd = _targetPosition.y - _tmpPoint.y;
               }
            }
            else if(_targetPosition)
            {
               _xd = _targetPosition.x - _tmpPoint.x;
               _yd = _targetPosition.y - _tmpPoint.y;
            }
            _tmpPoint.x += Math.cos(Math.atan2(_yd,_xd)) * _speed;
            _tmpPoint.y += Math.sin(Math.atan2(_yd,_xd)) * _speed;
         }
         else if(_hasPath)
         {
            if(_targetCreep)
            {
               _xd = _targetCreep._tmpPoint.x - _tmpPoint.x;
               _yd = _targetCreep._tmpPoint.y - _tmpPoint.y;
            }
            else if(_targetBuilding)
            {
               _xd = _targetBuilding.x - _tmpPoint.x;
               _yd = _targetBuilding.y + _targetBuilding._middle - _tmpPoint.y;
            }
            else if(_targetPosition)
            {
               _xd = _targetPosition.x - _tmpPoint.x;
               _yd = _targetPosition.y - _tmpPoint.y;
               if(!_atTarget && GLOBAL.QuickDistance(_targetPosition,_tmpPoint) > 5)
               {
                  _tmpPoint.x += Math.cos(Math.atan2(_yd,_xd)) * _speed;
                  _tmpPoint.y += Math.sin(Math.atan2(_yd,_xd)) * _speed;
               }
            }
         }
      }
      
      override protected function getNextSprite() : void
      {
         if(_behaviour == "pen" && !_hasPath)
         {
            SPRITES.GetSprite(_graphic,this._spriteID,"idle",m_rotation - 45);
         }
         else if(_attacking)
         {
            SPRITES.GetSprite(_graphic,this._spriteID,GLOBAL.e_BASE_MODE.ATTACK,m_rotation - 45,_frameNumber);
         }
         else
         {
            SPRITES.GetSprite(_graphic,this._spriteID,"walking",m_rotation - 45,_frameNumber);
         }
         if(_movement == "fly" && Boolean(_shadow))
         {
            SPRITES.GetSprite(_shadow,"bigshadow","bigshadow",0);
         }
      }
   }
}
