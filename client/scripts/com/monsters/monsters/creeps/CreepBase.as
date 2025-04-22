package com.monsters.monsters.creeps
{
   import com.monsters.configs.BYMConfig;
   import com.monsters.display.CreepSkinManager;
   import com.monsters.interfaces.IAttackable;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.*;
   import com.monsters.monsters.components.abilities.*;
   import com.monsters.monsters.components.modifiers.AdditionPropertyModifier;
   import com.monsters.pathing.PATHING;
   import com.monsters.rendering.RasterData;
   import com.monsters.siege.SiegeWeapons;
   import com.monsters.siege.weapons.Decoy;
   import com.monsters.siege.weapons.SiegeWeapon;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import gs.TweenLite;
   import gs.easing.Bounce;
   import gs.easing.Sine;
   
   public class CreepBase extends MonsterBase
   {
       
      
      protected var _lastFrame:int = -1;
      
      protected var _defenderRemoved:Boolean = false;
      
      protected const DEFENSE_RANGE:int = 30;
      
      protected const DEFENSE_RANGE_SQUARED:int = 900;
      
      protected const DEFENSE_MODIFIER:Number = 1;
      
      protected var _healerGiveUpTimer:int = 800;
      
      protected var m_bInfernoCreep:Boolean;
      
      protected var m_altitudeMax:int;
      
      protected var m_altitudeMin:int;
      
      public function CreepBase(param1:String, param2:String, param3:Point, param4:Number, param5:int = 0, param6:int = 2147483647, param7:Point = null, param8:Boolean = false, param9:BFOUNDATION = null, param10:Number = 1, param11:Boolean = false, param12:MonsterBase = null)
      {
         var _loc13_:Point = null;
         super();
         _friendly = param8;
         setInitialFriendlyFlags(_friendly);
         _creatureID = param1;
         _middle = 5;
         _house = param9;
         _hits = 0;
         _spawnPoint = new Point(int(param3.x / 100) * 100,int(param3.y / 100) * 100);
         _goeasy = param11;
         _movement = CREATURELOCKER._creatures[param1].movement;
         this.m_bInfernoCreep = BASE.isInfernoCreep(_creatureID);
         _pathing = CREATURELOCKER._creatures[param1].pathing;
         if(_house)
         {
            _house._creatures.push(this);
         }
         _behaviour = param2;
         _targetGroup = CREATURES.GetProperty(param1,"targetGroup");
         _explode = CREATURES.GetProperty(param1,"explode");
         _spawnTime = GLOBAL.Timestamp();
         _waypoints = [];
         _targetCreeps = [];
         _targetCreep = null;
         _homeBunker = null;
         graphic.mouseEnabled = false;
         graphic.mouseChildren = false;
         _speed = 0;
         moveSpeedProperty.value = CREATURES.GetProperty(_creatureID,"speed",param5,_friendly) / 2;
         if(TUTORIAL._stage < 200)
         {
            moveSpeedProperty.value *= 2;
         }
         setHealth(int(CREATURES.GetProperty(_creatureID,"health",param5,_friendly) * param10));
         maxHealthProperty.value = health;
         if(health > param6)
         {
            setHealth(param6);
         }
         damageProperty.set(int(CREATURES.GetProperty(_creatureID,"damage",param5,_friendly) * param10));
         _goo = CREATURES.GetProperty(_creatureID,"cResource",param5,_friendly);
         _targetPosition = param3;
         _targetCenter = param7;
         graphic.x = _targetPosition.x;
         graphic.y = _targetPosition.y;
         _tmpPoint.x = x;
         _tmpPoint.y = y;
         if(param4)
         {
            _targetRotation = param4;
         }
         else
         {
            _targetRotation = 0;
         }
         m_rotation = _targetRotation;
         attackDelayProperty.value = CREATURES.GetProperty(_creatureID,"attackDelay",param5,_friendly);
         if(!attackDelay)
         {
            attackDelayProperty.value = 60;
         }
         m_range = CREATURES.GetProperty(_creatureID,"range",param5,_friendly);
         if(!m_range)
         {
            m_range = 1;
         }
         _attacking = false;
         _frameNumber = 0;
         CreepSkinManager.instance.SetupSkins(_creatureID);
         if(_movement == "fly")
         {
            _shadow = new BitmapData(52,50,true,0);
            _shadowMC = BYMConfig.instance.RENDERER_ON ? new Bitmap(_shadow) : graphic.addChild(new Bitmap(_shadow));
            _shadowMC.x = -21;
            _shadowMC.y = -16;
            _frameNumber = int(Math.random() * 1000);
            defenseFlags |= Targeting.k_TARGETS_FLYING;
         }
         else
         {
            defenseFlags |= Targeting.k_TARGETS_GROUND;
         }
         if(!_graphic)
         {
            _graphic = new BitmapData(52,50,true,0);
         }
         _graphicMC = BYMConfig.instance.RENDERER_ON ? new Bitmap(_graphic) : graphic.addChild(new Bitmap(_graphic)) as Bitmap;
         _graphicMC.x = -26;
         _graphicMC.y = -36;
         if(BYMConfig.instance.RENDERER_ON)
         {
            _rasterData = new RasterData(_graphic,_rasterPt,int.MAX_VALUE);
            if(_movement === "fly")
            {
               _shadowData = new RasterData(_shadow,_shadowPt,MAP.DEPTH_SHADOW);
            }
         }
         this.applyInfernoVenom();
         if(_creatureID == "IC5")
         {
            this.m_altitudeMax = 40;
            this.m_altitudeMin = 35;
         }
         else
         {
            this.m_altitudeMax = !!CREATURES.GetProperty(_creatureID,"altitude",param5,_friendly) ? int(CREATURES.GetProperty(_creatureID,"altitude",param5,_friendly)) : 108;
            this.m_altitudeMin = 60;
         }
         if(param2 == k_sBHVR_HOUSING)
         {
            _loc13_ = GRID.ToISO(_targetCenter.x + 100,_targetCenter.y + 100,0);
            if(_movement == "fly")
            {
               _graphicMC.y -= _altitude;
            }
            else
            {
               _altitude = 0;
            }
            PATHING.GetPath(_tmpPoint,new Rectangle(_loc13_.x,_loc13_.y,10,10),setWaypoints,true);
         }
         else if(_behaviour == k_sBHVR_BOUNCE)
         {
            if(GLOBAL._render && _movement != "fly")
            {
               if(!this.m_bInfernoCreep)
               {
                  _graphicMC.y -= 90;
                  TweenLite.to(_graphicMC,0.6,{
                     "y":_graphicMC.y + 90,
                     "ease":Bounce.easeOut,
                     "onComplete":changeModeAttack
                  });
               }
               else
               {
                  EFFECTS.Dig(int(_tmpPoint.x),int(_tmpPoint.y));
                  TweenLite.to(_graphicMC,0.4,{
                     "y":_graphicMC.y - 20,
                     "ease":Sine.easeOut,
                     "overwrite":false
                  });
                  TweenLite.to(_graphicMC,0.4,{
                     "y":_graphicMC.y,
                     "ease":Bounce.easeOut,
                     "overwrite":false,
                     "delay":0.4,
                     "onComplete":changeModeAttack
                  });
               }
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
               if(_targetGroup == 5)
               {
                  this.changeModeHeal();
               }
               else if(_targetGroup == 6)
               {
                  this.changeModeHunt();
               }
               else
               {
                  changeModeAttack();
               }
            }
         }
         else if(_behaviour === k_sBHVR_DEFEND)
         {
            this.changeModeDefend();
         }
         else if(_behaviour === k_sBHVR_DECOY)
         {
            this.changeModeDecoy();
         }
         if(param10 > 1)
         {
            LOGGER.Log("log","MONSTER Strength");
            GLOBAL.ErrorMessage("CREEP");
         }
         if(_behaviour === k_sBHVR_JUICE)
         {
            this.changeModeJuice();
         }
         if(_behaviour === k_sBHVR_FEED)
         {
            changeModeFeed();
         }
         updateBuffs();
         render();
         if(_targetGroup == 3)
         {
            CModifiableProperty(getComponentByName(k_LOOT_PROPERTY)).addModifier(new AdditionPropertyModifier(1.5));
         }
      }
      
      override protected function tickState(param1:int = 1) : Boolean
      {
         var _loc2_:Number = NaN;
         super.tickState(param1);
         if(_damagePerSecond.Get() > 0)
         {
            if(_frameNumber % 60 == 0)
            {
               modifyHealth(-_damagePerSecond.Get());
            }
         }
         if(!this.hackCheck())
         {
            return false;
         }
         if(_movement === "fly" && health > 0 && _behaviour !== k_sBHVR_PEN)
         {
            if(_behaviour !== k_sBHVR_JUICE && _behaviour !== k_sBHVR_FEED || _altitude >= this.m_altitudeMin)
            {
               _loc2_ = Math.sin(_frameNumber / 50) * 5;
               _altitude = this.m_altitudeMax - _loc2_;
               _graphicMC.y = -_altitude - 36 + _loc2_;
            }
         }
         if(_homeBunker && (_behaviour !== k_sBHVR_DEFEND && _behaviour !== k_sBHVR_BUNKER && _behaviour !== k_sBHVR_JUICE && _behaviour !== k_sBHVR_PEN && _behaviour !== k_sBHVR_DECOY && _behaviour !== k_sBHVR_HOUSING))
         {
            _behaviour = k_sBHVR_DEFEND;
         }
         switch(_behaviour)
         {
            case k_sBHVR_ATTACK:
            case k_sBHVR_BOUNCE:
            case k_sBHVR_HUNT:
               if(this.tickBAttack())
               {
                  return true;
               }
               break;
            case k_sBHVR_HOUSING:
               if(this.m_bInfernoCreep)
               {
                  if(health <= 0)
                  {
                     return true;
                  }
                  if(_atTarget)
                  {
                     _behaviour = k_sBHVR_PEN;
                     if(_movement == "fly")
                     {
                        TweenLite.to(_graphicMC,1.2,{
                           "y":_graphicMC.y + _altitude,
                           "ease":Sine.easeOut,
                           "onComplete":this.flyerLanded
                        });
                     }
                     _waypoints[0] = HOUSING.PointInHouse(_targetCenter);
                  }
               }
               else if(this.tickBHousing())
               {
                  return true;
               }
               break;
            case k_sBHVR_PEN:
               if(this.m_bInfernoCreep)
               {
                  if(health <= 0)
                  {
                     return true;
                  }
                  if(_frameNumber > 240 && int(Math.random() * 200) == 1 && GLOBAL._fps > 25)
                  {
                     _targetPosition = HOUSING.PointInHouse(_targetCenter);
                     _hasPath = true;
                  }
                  break;
               }
               if(this.tickBPen())
               {
                  return true;
               }
               break;
            case k_sBHVR_RETREAT:
            case k_sBHVR_JUICE:
            case k_sBHVR_FEED:
               if(this.tickBDeathRun())
               {
                  return true;
               }
               break;
            case k_sBHVR_HEAL:
               if(this.tickBHeal())
               {
                  return true;
               }
               break;
            case k_sBHVR_WANDER:
               if(_frameNumber > 480 && !_targetCenter)
               {
                  _targetPosition = new Point(Math.random() * 200,Math.random() * 150);
               }
               break;
            case k_sBHVR_DEFEND:
               if(this.tickBDefend())
               {
                  return true;
               }
               break;
            case k_sBHVR_BUNKER:
               if(this.tickBBunker())
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
         }
         if(_enraged == 0 && graphic.filters.length > 0)
         {
            updateBuffs();
         }
         newNode = Targeting.CreepCellMove(_tmpPoint,_id,this,node);
         if(newNode)
         {
            node = newNode;
         }
         return false;
      }
      
      override public function changeModeJuice() : void
      {
         _behaviour = k_sBHVR_JUICE;
         changeMode();
         _targetBuilding = GLOBAL._bJuicer;
         if(_movement == "fly" && _altitude < 60)
         {
            TweenLite.to(_graphicMC,2,{
               "y":_graphicMC.y - (this.m_altitudeMax - _altitude),
               "ease":Sine.easeIn,
               "onComplete":this.flyerTakeOff
            });
         }
         PATHING.GetPath(_tmpPoint,new Rectangle(_targetBuilding._mc.x,_targetBuilding._mc.y,80,80),setWaypoints,true);
         GLOBAL._bJuicer.Prep(_creatureID);
      }
      
      public function changeModeHeal() : void
      {
         _behaviour = k_sBHVR_HEAL;
         changeMode();
         this.findHealingTargets();
      }
      
      public function changeModeDefend() : void
      {
         _behaviour = k_sBHVR_DEFEND;
         changeMode();
         if(isDisposable)
         {
            this.findDefenseTargets();
         }
      }
      
      public function changeModeHunt() : void
      {
         _behaviour = k_sBHVR_HUNT;
         changeMode();
         findTarget(_targetGroup);
      }
      
      public function changeModeBunker() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Number = NaN;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:BFOUNDATION = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         _behaviour = k_sBHVR_BUNKER;
         changeMode();
         _doDefenseBurrow = false;
         if(isDisposable)
         {
            setHealth(0);
            return;
         }
         if(!_homeBunker)
         {
            _loc2_ = 9999999 * 9999999;
            _loc3_ = BASE._buildingsAll;
            for(_loc4_ in _loc3_)
            {
               _loc5_ = _loc3_[_loc4_];
               if(MONSTERBUNKER.isBunkerBuilding(_loc5_._type) && _loc5_._countdownBuild.Get() <= 0 && _loc5_.health > 0)
               {
                  _loc7_ = (_loc6_ = _loc5_ as BFOUNDATION)._mc.x - _tmpPoint.x;
                  _loc8_ = _loc6_._mc.y - _tmpPoint.y;
                  if(_loc2_ > _loc7_ * _loc7_ + _loc8_ * _loc8_)
                  {
                     _homeBunker = _loc6_;
                  }
               }
            }
         }
         if(_homeBunker)
         {
            if(BASE.isInfernoMainYardOrOutpost)
            {
               _targetCenter = GRID.FromISO(_homeBunker._mc.x,_homeBunker._mc.y);
               _targetPosition = GRID.FromISO(_homeBunker._mc.x,_homeBunker._mc.y);
               _loc9_ = 100;
               _loc10_ = 60;
            }
            else
            {
               _loc9_ = _tmpPoint.x - _homeBunker._position.x;
               _loc10_ = _tmpPoint.y - _homeBunker._position.y;
               _loc11_ = int(_homeBunker._footprint[0].width);
               _loc12_ = int(_homeBunker._footprint[0].height);
               if(_loc10_ <= 0)
               {
                  _loc10_ = _loc12_ / 4;
                  if(_loc9_ <= 0)
                  {
                     _loc9_ = _loc11_ / -3;
                  }
                  else
                  {
                     _loc9_ = _loc11_ / 2;
                  }
               }
               else
               {
                  _loc10_ = _loc12_ / 2;
                  if(_loc9_ <= 0)
                  {
                     _loc9_ = _loc11_ / -4;
                  }
                  else
                  {
                     _loc9_ = _loc11_ / 2;
                  }
               }
               _targetCenter = GRID.FromISO(_homeBunker._position.x + _loc9_,_homeBunker._position.y + _loc10_);
               _targetPosition = new Point(_homeBunker._mc.x,_homeBunker._mc.y);
            }
            _jumpingUp = false;
            if(BASE.isInfernoMainYardOrOutpost)
            {
               _loc1_ = GRID.ToISO(_targetCenter.x + _loc9_,_targetCenter.y + _loc10_,0);
            }
            else
            {
               _loc1_ = GRID.ToISO(_targetCenter.x,_targetCenter.y,0);
            }
            PATHING.GetPath(_tmpPoint,new Rectangle(_loc1_.x,_loc1_.y,10,10),setWaypoints,true);
            return;
         }
      }
      
      public function changeModeDecoy() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Number = NaN;
         var _loc4_:Decoy = null;
         var _loc5_:Rectangle = null;
         var _loc6_:Point = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Point = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Point = null;
         var _loc3_:SiegeWeapon = SiegeWeapons.activeWeapon;
         if(Boolean(_loc3_) && _loc3_ is Decoy)
         {
            _behaviour = "decoy";
            changeMode();
            _attacking = false;
            _targetCreep = null;
            _loc4_ = _loc3_ as Decoy;
            _loc5_ = new Rectangle(_loc4_.x,_loc4_.y + _loc4_.decoyGraphic.height / 2,40,40);
            _targetCenter = new Point(_loc5_.x,_loc5_.y);
            if(_movement == "burrow")
            {
               _hasTarget = true;
               _hasPath = true;
               _loc9_ = GRID.FromISO(_loc5_.x,_loc5_.y);
               _loc10_ = int(Math.random() * 4);
               _loc11_ = _loc5_.height;
               _loc12_ = _loc5_.width;
               if(_loc10_ == 0)
               {
                  _loc9_.x += Math.random() * _loc11_;
                  _loc9_.y += _loc12_;
               }
               else if(_loc10_ == 1)
               {
                  _loc9_.x += _loc11_;
                  _loc9_.y += _loc12_;
               }
               else if(_loc10_ == 2)
               {
                  _loc9_.x += _loc11_ - Math.random() * _loc11_ / 2;
                  _loc9_.y -= _loc12_ / 4;
               }
               else if(_loc10_ == 3)
               {
                  _loc9_.x -= _loc11_ / 4;
                  _loc9_.y += _loc12_ - Math.random() * _loc12_ / 2;
               }
               _waypoints = [GRID.ToISO(_loc9_.x,_loc9_.y,0)];
               _targetPosition = _waypoints[0];
            }
            else if(_movement == "fly")
            {
               _hasTarget = true;
               _hasPath = true;
               _loc1_ = _tmpPoint.subtract(_targetCenter);
               _loc2_ = _loc1_.x * _loc1_.x + _loc1_.y * _loc1_.y;
               if(_loc2_ < 2500)
               {
                  _atTarget = true;
                  _hasPath = true;
                  _targetPosition = _targetCenter;
               }
               else
               {
                  _loc8_ = (_loc8_ = (_loc8_ = Math.atan2(_tmpPoint.y - _targetCenter.y,_tmpPoint.x - _targetCenter.x) * 57.2957795) + (Math.random() * 90 - 45)) / (180 / Math.PI);
                  _loc7_ = 30 + Math.random() * 10;
                  _loc13_ = new Point(_targetCenter.x + Math.cos(_loc8_) * _loc7_ * 1.7,_targetCenter.y + Math.sin(_loc8_) * _loc7_);
                  _waypoints = [_loc13_];
                  _targetPosition = _waypoints[0];
               }
            }
            else
            {
               _loc8_ = (_loc8_ = (_loc8_ = Math.atan2(_tmpPoint.y - _targetCenter.y,_tmpPoint.x - _targetCenter.x) * 57.2957795) + (Math.random() * 90 - 45)) / (180 / Math.PI);
               _loc7_ = 30 + Math.random() * 10;
               _loc6_ = new Point(_targetCenter.x + Math.cos(_loc8_) * _loc7_ * 1.7,_targetCenter.y + Math.sin(_loc8_) * _loc7_);
               _loc6_.x += Math.random() * -10 + 5;
               _loc6_.y += Math.random() * -10 + 5;
               _targetPosition = _targetCenter;
               WaypointTo(_loc6_);
            }
         }
         else
         {
            _hasTarget = false;
            this.findDefenseTargets();
         }
      }
      
      public function interceptTarget() : void
      {
         var _loc1_:Point = _targetCreep._tmpPoint.subtract(_tmpPoint);
         var _loc2_:Number = _loc1_.x * _loc1_.x + _loc1_.y * _loc1_.y;
         _intercepting = false;
         _looking = true;
         if(_loc2_ < this.DEFENSE_RANGE_SQUARED || this.canShootCreep())
         {
            _waypoints = [];
            _atTarget = true;
            _looking = false;
         }
         else if(_noDefensePath || _loc2_ < this.DEFENSE_RANGE_SQUARED * 3 || _pathing == "direct")
         {
            _waypoints = [_targetCreep._tmpPoint];
            _targetPosition = _targetCreep._tmpPoint;
            if(_pathing == "direct" && !_hasTarget && _loc2_ < 14400)
            {
               _doDefenseBurrow = false;
            }
            else
            {
               _doDefenseBurrow = true;
            }
         }
         else if(_targetCreep._atTarget || _targetCreep._waypoints.length < 8 || _loc2_ < 62500)
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
      
      public function findHealingTargets() : void
      {
         var _loc2_:BFOUNDATION = null;
         var _loc3_:Array = null;
         var _loc1_:Boolean = false;
         for each(_loc2_ in BASE._buildingsMain)
         {
            if(_loc2_._class != "decoration" && _loc2_._class != "immovable" && _loc2_.health > 0 && _loc2_._class != "enemy")
            {
               _loc1_ = true;
               break;
            }
         }
         if(!_loc1_)
         {
            changeModeRetreat();
            return;
         }
         var _loc4_:Boolean = false;
         _targetCreeps = Targeting.getCreepsInRange(600,_tmpPoint,attackFlags,this);
         if(_targetCreeps.length > 0)
         {
            _targetCreeps.sortOn(["dist"],Array.NUMERIC);
            if(!(Boolean(_targetCreep) && _targetCreep.health > 0 && _targetCreep.health < _targetCreep.maxHealth))
            {
               _loc4_ = true;
               while(_targetCreeps.length > 0 && (_targetCreeps[0].creep._creatureID.substring(0,1) == "C" && CREATURELOCKER._creatures[_targetCreeps[0].creep._creatureID].antiHeal))
               {
                  _targetCreeps.shift();
               }
               if(_targetCreeps.length > 0)
               {
                  _targetCreep = _targetCreeps[0].creep;
                  _waypoints = [_targetCreep._tmpPoint];
               }
            }
            while(_targetCreeps.length > 0 && (_targetCreeps[0].creep._behaviour == k_sBHVR_RETREAT || _targetCreeps[0].creep._creatureID.substring(0,1) == "C" && CREATURELOCKER._creatures[_targetCreeps[0].creep._creatureID].antiHeal || _targetCreeps[0].creep.health == _targetCreeps[0].creep.maxHealth))
            {
               _targetCreeps.shift();
            }
         }
         if(_targetCreeps.length > 0)
         {
            _loc4_ = false;
            _targetCreep = _targetCreeps[0].creep;
            _waypoints = [_targetCreep._tmpPoint];
            _targetPosition = _targetCreep._tmpPoint;
            _behaviour = "heal";
         }
         else if(_targetCreep && _targetCreep.health > 0 && _targetCreep.health < _targetCreep.maxHealth)
         {
            _loc4_ = false;
            _waypoints = [_targetCreep._tmpPoint];
            _targetPosition = _targetCreep._tmpPoint;
            _behaviour = "heal";
         }
         else if(this._healerGiveUpTimer > 0)
         {
            --this._healerGiveUpTimer;
         }
         else if(_behaviour != "retreat")
         {
            changeModeRetreat();
         }
         if(_waypoints.length)
         {
            _hasTarget = true;
            _hasPath = true;
            WaypointTo(_waypoints[0],null);
         }
      }
      
      public function findDefenseTargets() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Boolean = true;
         _targetCreeps = Targeting.getCreepsInRange(200,_tmpPoint,Targeting.getOldStyleTargets(targetMode));
         if(_targetCreeps.length)
         {
            _targetCreeps.sortOn(["dist"],Array.NUMERIC);
            while(_targetCreeps.length > 0 && _targetCreeps[0].creep._behaviour == k_sBHVR_RETREAT)
            {
               _targetCreeps.splice(0,1);
            }
            if(_creatureID == "IC5")
            {
               while(_targetCreeps.length > 0 && _targetCreeps[0].creep._creatureID == "C5")
               {
                  _targetCreeps.splice(0,1);
               }
            }
         }
         if(_targetCreeps.length)
         {
            _targetCreep = _targetCreeps[0].creep;
            this.interceptTarget();
            _behaviour = k_sBHVR_DEFEND;
         }
         else if(Boolean(_targetCreep) && _targetCreep.health > 0)
         {
            if(_noDefensePath || _pathing == "direct")
            {
               this.interceptTarget();
            }
            _behaviour = k_sBHVR_DEFEND;
         }
         else if(_homeBunker && _homeBunker.health > 0)
         {
            _targetCreep = _homeBunker.GetTarget(targetMode);
            if(_targetCreep)
            {
               _atTarget = false;
               _attacking = false;
               _behaviour = k_sBHVR_DEFEND;
               this.interceptTarget();
            }
            else if(_behaviour != k_sBHVR_BUNKER)
            {
               this.changeModeBunker();
            }
         }
      }
      
      public function click(param1:MouseEvent) : void
      {
         if(_waypoints.length > 0)
         {
            PATHING.RenderPath(_waypoints,true);
         }
         if(!_clicked)
         {
            _clicked = true;
         }
         else
         {
            _clicked = false;
         }
      }
      
      public function flyerLanded() : void
      {
         _altitude = 0;
      }
      
      public function flyerTakeOff() : void
      {
         _altitude = this.m_altitudeMax;
      }
      
      override public function canShootCreep() : Boolean
      {
         if(_targetCreep == null || !isRanged)
         {
            return false;
         }
         var _loc1_:Point = _targetCreep._tmpPoint.subtract(_tmpPoint);
         var _loc2_:Number = _loc1_.x * _loc1_.x + _loc1_.y * _loc1_.y;
         if(_loc2_ > range * range)
         {
            return false;
         }
         if(PATHING.LineOfSight(_tmpPoint.x,_tmpPoint.y,_targetCreep._tmpPoint.x,_targetCreep._tmpPoint.y))
         {
            return true;
         }
         return false;
      }
      
      protected function canShootBuilding() : Boolean
      {
         if(_targetBuilding == null || !isRanged)
         {
            return false;
         }
         var _loc1_:Point = _targetBuilding._position.subtract(_tmpPoint);
         var _loc2_:Number = _loc1_.x * _loc1_.x + _loc1_.y * _loc1_.y;
         if(_loc2_ > range * range)
         {
            return false;
         }
         if(PATHING.LineOfSight(_tmpPoint.x,_tmpPoint.y,_targetBuilding._position.x,_targetBuilding._position.y,_targetBuilding))
         {
            return true;
         }
         return false;
      }
      
      protected function attacked(param1:IAttackable, param2:Number, param3:ITargetable = null) : void
      {
         var _loc6_:Component = null;
         var _loc4_:int = int(_attackComponents.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if((_loc6_ = _attackComponents[_loc5_]) is IAttackingComponent)
            {
               IAttackingComponent(_loc6_).onAttack(param1,param2,param3);
            }
            _loc5_++;
         }
      }
      
      protected function explode() : Number
      {
         var tmpPointA:Point;
         var tmpPointB:Point;
         var tmpPointC:Point;
         var damageDealt:int = 0;
         var distancePoint:Point = null;
         var distanceSquared:Number = NaN;
         var dist:int = 0;
         var building:BFOUNDATION = null;
         var creepid:String = null;
         var creep:MonsterBase = null;
         if(_creatureID == "C5" && poweredUp())
         {
            _jumpingUp = true;
            TweenLite.to(_graphicMC,0.4,{
               "y":_graphicMC.y - (40 + 20 * (powerUpLevel() - 1)),
               "ease":Sine.easeOut,
               "overwrite":false,
               "onComplete":function():void
               {
                  airburst();
               }
            });
         }
         if(_jumpingUp)
         {
            return 0;
         }
         tmpPointA = PATHING.FromISO(_tmpPoint).add(new Point(-5,-5));
         tmpPointB = new Point(0,0);
         tmpPointC = new Point(0,0);
         for each(building in BASE._buildingsAll)
         {
            if(building._class != "decoration" && building._class != "enemy" && building.health > 0)
            {
               tmpPointC.x = building.x;
               tmpPointC.y = building.y;
               tmpPointB = PATHING.FromISO(tmpPointC);
               tmpPointC.x = building._middle;
               tmpPointC.y = building._middle;
               tmpPointB.add(tmpPointC);
               distancePoint = tmpPointA.subtract(tmpPointB);
               distanceSquared = distancePoint.x * distancePoint.x + distancePoint.y * distancePoint.y;
               if(distanceSquared < 3600)
               {
                  damageDealt += building.modifyHealth(Math.round(damage * ((3600 - distanceSquared) / 3600)),this);
               }
            }
         }
         if(_targetCreep)
         {
            distancePoint = _tmpPoint.subtract(_targetCreep._tmpPoint);
            distanceSquared = distancePoint.x * distancePoint.x + distancePoint.y * distancePoint.y;
            if(distanceSquared < this.DEFENSE_RANGE_SQUARED)
            {
               damageDealt += _targetCreep.modifyHealth(-damage);
            }
         }
         for(creepid in CREATURES._creatures)
         {
            creep = CREATURES._creatures[creepid];
            if((creep._behaviour == k_sBHVR_DEFEND || creep._behaviour == k_sBHVR_BUNKER) && creep != _targetCreep && creep._movement != "fly")
            {
               distancePoint = creep._tmpPoint.subtract(_tmpPoint);
               distanceSquared = distancePoint.x * distancePoint.x + distancePoint.y * distancePoint.y;
               if(distanceSquared < 8100)
               {
                  damageDealt += creep.modifyHealth(-int(damage * creep._damageMult * ((8100 - distanceSquared) / 8100)));
               }
            }
         }
         if(CREATURES._guardian)
         {
            distancePoint = CREATURES._guardian._tmpPoint.subtract(_tmpPoint);
            distanceSquared = distancePoint.x * distancePoint.x + distancePoint.y * distancePoint.y;
            if(distanceSquared < 3600)
            {
               damageDealt += CREATURES._guardian.modifyHealth(-int(damage * ((3600 - distanceSquared) / 3600)));
            }
         }
         if(Boolean(damageDealt) && Boolean(_explode))
         {
            ATTACK.Log("creep" + _id,"<font color=\"#0000FF\">" + KEYS.Get("attack_log_eyera") + "</font>");
            EFFECTS.Scorch(_tmpPoint);
         }
         setHealth(0);
         return damage;
      }
      
      public function tickBAttack() : Boolean
      {
         var _loc1_:Point = null;
         var _loc2_:Number = NaN;
         var _loc3_:ITargetable = null;
         var _loc4_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:MonsterBase = null;
         var _loc5_:Number = 1;
         if(health <= 0)
         {
            return true;
         }
         if(_hasTarget)
         {
            if(!_targetCreep)
            {
               if(_behaviour === k_sBHVR_HUNT && (CREATURES._creatureCount > 0 || CREATURES._guardian && CREATURES._guardian.health > 0) && _frameNumber % 150 == 0)
               {
                  findTarget(_targetGroup);
               }
               else if(_targetBuilding == null || _targetBuilding.health <= 0 || _targetGroup == 3 && _targetBuilding._looted || _targetBuilding._class == "tower" && !MONSTERBUNKER.isBunkerBuilding(_targetBuilding._type) && (_targetBuilding as BTOWER).isJard)
               {
                  loseTarget();
                  findTarget(_targetGroup);
               }
            }
            else
            {
               if(_targetCreep.health <= 0)
               {
                  loseTarget();
                  findTarget(_targetGroup);
               }
               if(!_atTarget && Boolean(_targetCreep))
               {
                  if(GLOBAL.QuickDistanceSquared(_targetCreep._tmpPoint,_tmpPoint) < range * range)
                  {
                     _atTarget = true;
                  }
                  else
                  {
                     _waypoints = [_targetCreep._tmpPoint];
                  }
               }
            }
         }
         if(!_looking && !_attacking && _frameNumber % (GLOBAL._catchup ? 300 : 150) == 0)
         {
            findTarget(_targetGroup);
         }
         if(_atTarget)
         {
            _attacking = true;
            if(_creatureID == "IC5" && _movement == "fly" && (!_targetCreep || _targetCreep._movement != "fly"))
            {
               _movement = "fly_low";
            }
            if(attackCooldown <= 0)
            {
               attackCooldown += int(attackDelay);
               if(_behaviour == k_sBHVR_HUNT && Boolean(_targetCreep))
               {
                  _loc5_ *= 3;
               }
               else if(_targetBuilding)
               {
                  if(_targetGroup == 2 && _targetBuilding._class == "wall")
                  {
                     _loc5_ *= 2;
                  }
                  if(_targetGroup == 4 && _targetBuilding._class == "tower")
                  {
                     _loc5_ *= 2;
                  }
               }
               if(_behaviour == k_sBHVR_ATTACK || _behaviour == k_sBHVR_HUNT)
               {
                  if(_explode)
                  {
                     return Boolean(this.explode());
                  }
                  if(_targetCreep)
                  {
                     _loc1_ = _tmpPoint.subtract(_targetCreep._tmpPoint);
                     _loc2_ = _loc1_.x * _loc1_.x + _loc1_.y * _loc1_.y;
                     if(isRanged)
                     {
                        _loc3_ = rangedAttack(_targetCreep);
                     }
                     else
                     {
                        _loc4_ = _targetCreep.modifyHealth(-(damage * _loc5_));
                        ATTACK.Damage(_tmpPoint.x,_tmpPoint.y - 5,-_loc4_,_mc.visible);
                        if(!_targetCreep._targetCreep || !_targetCreep._atTarget)
                        {
                           _targetCreep._targetCreep = this;
                           _targetCreep._hasTarget = true;
                           _targetCreep._atTarget = true;
                           if(_targetCreep._behaviour !== k_sBHVR_DEFEND)
                           {
                              _targetCreep._behaviour = k_sBHVR_DEFEND;
                           }
                        }
                     }
                  }
                  else if(_targetBuilding)
                  {
                     if(isRanged)
                     {
                        _loc3_ = rangedAttack(_targetBuilding);
                     }
                     else
                     {
                        _loc4_ = _targetBuilding.modifyHealth(damage * _loc5_,this);
                        ATTACK.Damage(_tmpPoint.x,_tmpPoint.y - 5,_loc4_,_mc.visible);
                     }
                  }
                  this.attacked(!!_targetCreep ? _targetCreep : _targetBuilding,_loc4_,_loc3_);
                  if(!_targetCreep)
                  {
                     ++_hits;
                  }
                  if(_goeasy)
                  {
                     if(_hits > 20)
                     {
                        changeModeRetreat();
                        return false;
                     }
                  }
                  else if(!GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && _hits > _hitLimit)
                  {
                     return true;
                  }
                  if(this.m_bInfernoCreep)
                  {
                     _loc6_ = "ihit" + int(1 + Math.random() * 7);
                     SOUNDS.Play(_loc6_,0.1 + Math.random() * 0.1);
                  }
                  else if(int(_creatureID.substr(1)) < 5)
                  {
                     SOUNDS.Play("hit" + int(1 + Math.random() * 3),0.1 + Math.random() * 0.1);
                  }
                  else if(int(_creatureID.substr(1)) < 10)
                  {
                     SOUNDS.Play("hit" + int(3 + Math.random() * 2),0.1 + Math.random() * 0.1);
                  }
                  else
                  {
                     SOUNDS.Play("hit" + int(4 + Math.random() * 1),0.1 + Math.random() * 0.1);
                  }
               }
            }
            else
            {
               --attackCooldown;
            }
         }
         else
         {
            _attacking = false;
            if(_movement == "fly_low")
            {
               _movement = "fly";
            }
            if(_creatureID == "C12" && poweredUp() && !_targetCreep && _frameNumber % 30 == 0)
            {
               _loc7_ = 160000;
               for each(_loc8_ in CREATURES._creatures)
               {
                  if((_loc8_._creatureID == "C5" || _loc8_._creatureID == "IC5") && _loc8_._behaviour == k_sBHVR_DEFEND)
                  {
                     _loc1_ = _loc8_._tmpPoint.subtract(_tmpPoint);
                     _loc2_ = _loc1_.x * _loc1_.x + _loc1_.y * _loc1_.y;
                     if(_loc2_ < _loc7_)
                     {
                        _targetCreep = _loc8_;
                        _loc7_ = _loc2_;
                        _hasTarget = true;
                     }
                  }
               }
            }
         }
         return false;
      }
      
      protected function tickBDefend() : Boolean
      {
         var damageDelt:int = 0;
         var i:int = 0;
         var creep:MonsterBase = null;
         var distancePoint:Point = null;
         var distanceSquared:Number = NaN;
         var targetFlags:int = 0;
         var projectile:ITargetable = null;
         var aggros:Array = null;
         var l:int = 0;
         if(health <= 0)
         {
            if(_creatureID == "C12")
            {
               SOUNDS.Play("monsterlanddave");
            }
            else
            {
               SOUNDS.Play("monsterland" + (1 + int(Math.random() * 3)));
            }
            if(_homeBunker)
            {
               if(Boolean(_homeBunker._monsters) && !this._defenderRemoved)
               {
                  if(BASE.isInfernoMainYardOrOutpost)
                  {
                     _homeBunker.RemoveCreature(_creatureID);
                     if(MapRoomManager.instance.isInMapRoom3)
                     {
                        GLOBAL.player.monsterListByID(_creatureID).unlinkCreepFromData(this);
                     }
                     this._defenderRemoved = true;
                     _behaviour = k_sBHVR_PEN;
                     return false;
                  }
                  if(!MapRoomManager.instance.isInMapRoom3 || !BASE.isMainYardOrInfernoMainYard)
                  {
                     --_homeBunker._monsters[_creatureID];
                     if(_homeBunker._monsters[_creatureID] < 0)
                     {
                        _homeBunker._monsters[_creatureID] = 0;
                     }
                  }
                  else
                  {
                     GLOBAL.player.monsterListByID(_creatureID).unlinkCreepFromData(this);
                  }
                  --_homeBunker._monstersDispatched[_creatureID];
                  if(_homeBunker._monstersDispatched[_creatureID] < 0)
                  {
                     _homeBunker._monstersDispatched[_creatureID] = 0;
                  }
                  --_homeBunker._monstersDispatchedTotal;
                  if(_homeBunker._monstersDispatchedTotal < 0)
                  {
                     _homeBunker._monstersDispatchedTotal = 0;
                  }
                  this._defenderRemoved = true;
               }
            }
            if(_explode)
            {
               if(Boolean(_explode) && _jumpingUp)
               {
                  this.airburst();
                  return true;
               }
               _targetCreeps = Targeting.getCreepsInRange(90,_tmpPoint,Targeting.getOldStyleTargets(-1));
               Targeting.DealLinearAEDamage(_tmpPoint,90,damage,_targetCreeps);
               if(_explode)
               {
                  EFFECTS.Scorch(_tmpPoint);
               }
            }
            return true;
         }
         if(_hasTarget)
         {
            if(_targetCreep)
            {
               distancePoint = _tmpPoint.subtract(_targetCreep._tmpPoint);
               distanceSquared = distancePoint.x * distancePoint.x + distancePoint.y * distancePoint.y;
            }
            if(_targetCreep.health <= 0)
            {
               _hasTarget = false;
               _atTarget = false;
               _attacking = false;
               _hasPath = false;
               this.findDefenseTargets();
            }
            else if(_targetBuilding && distanceSquared < this.DEFENSE_RANGE_SQUARED || this.canShootCreep())
            {
               _waypoints = [];
               _atTarget = true;
               if(this.m_bInfernoCreep)
               {
                  SOUNDS.Play("imonster" + int(1 + Math.random() * 4));
               }
            }
            else if(!_attacking && _frameNumber % 150 == 0)
            {
               this.findDefenseTargets();
            }
            else if(_attacking && _targetBuilding && distanceSquared > 3600 && !this.canShootCreep())
            {
               _attacking = false;
               _atTarget = false;
               _hasPath = false;
               this.findDefenseTargets();
            }
            else if(_creatureID == "C5" && _targetBuilding && poweredUp() && distanceSquared < 3600 && !_jumpingUp)
            {
               _jumpingUp = true;
               TweenLite.to(_graphicMC,0.4,{
                  "y":_graphicMC.y - (40 + 20 * (powerUpLevel() - 1)),
                  "ease":Sine.easeOut,
                  "overwrite":false,
                  "onComplete":function():void
                  {
                     airburst();
                  }
               });
            }
            else if(_creatureID == "C5" && _targetCreep && poweredUp() && !_jumpingUp)
            {
               distancePoint = _tmpPoint.subtract(_targetCreep._tmpPoint);
               distanceSquared = distancePoint.x * distancePoint.x + distancePoint.y * distancePoint.y;
               if(distanceSquared < 3600)
               {
                  _jumpingUp = true;
                  TweenLite.to(_graphicMC,0.4,{
                     "y":_graphicMC.y - (40 + 20 * (powerUpLevel() - 1)),
                     "ease":Sine.easeOut,
                     "overwrite":false,
                     "onComplete":function():void
                     {
                        airburst();
                     }
                  });
               }
            }
         }
         if(_atTarget)
         {
            _targetPosition = _targetCreep._tmpPoint;
            _attacking = true;
            _intercepting = false;
            if(_targetCreep._behaviour != "heal" && !_targetCreep._explode && !_explode && !_targetCreep._targetCreep)
            {
               distancePoint = _targetCreep._tmpPoint.subtract(_tmpPoint);
               distanceSquared = distancePoint.x * distancePoint.x + distancePoint.y * distancePoint.y;
               _waypoints = [];
               _targetCreep._targetCreep = this;
               if(_targetCreep.canShootCreep() || distanceSquared < 2500 || _targetCreep._creatureID == "C14")
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
               _targetCreep._hasPath = true;
            }
            if(attackCooldown <= 0)
            {
               attackCooldown += int(attackDelay);
               if(_explode)
               {
                  if(Boolean(_explode) && _jumpingUp)
                  {
                     this.airburst();
                     return true;
                  }
                  targetFlags = _friendly ? Targeting.k_TARGETS_ATTACKERS : Targeting.k_TARGETS_DEFENDERS;
                  targetFlags |= Targeting.k_TARGETS_GROUND;
                  if(_explode)
                  {
                     targetFlags |= Targeting.k_TARGETS_INVISIBLE;
                  }
                  _targetCreeps = Targeting.getCreepsInRange(90,_tmpPoint,targetFlags);
                  Targeting.DealLinearAEDamage(_tmpPoint,90,damage,_targetCreeps);
                  ATTACK.Damage(_tmpPoint.x,_tmpPoint.y - 5,damage,_mc.visible);
                  if(_explode)
                  {
                     EFFECTS.Scorch(_tmpPoint);
                     setHealth(0);
                     if(_homeBunker)
                     {
                        if(Boolean(_homeBunker._monsters) && !this._defenderRemoved)
                        {
                           if(!MapRoomManager.instance.isInMapRoom3 || !BASE.isMainYardOrInfernoMainYard)
                           {
                              --_homeBunker._monsters[_creatureID];
                              if(_homeBunker._monsters[_creatureID] < 0)
                              {
                                 _homeBunker._monsters[_creatureID] = 0;
                              }
                           }
                           else
                           {
                              GLOBAL.player.monsterListByID(_creatureID).unlinkCreepFromData(this);
                           }
                           --_homeBunker._monstersDispatched[_creatureID];
                           if(_homeBunker._monstersDispatched[_creatureID] < 0)
                           {
                              _homeBunker._monstersDispatched[_creatureID] = 0;
                           }
                           --_homeBunker._monstersDispatchedTotal;
                           if(_homeBunker._monstersDispatchedTotal < 0)
                           {
                              _homeBunker._monstersDispatchedTotal = 0;
                           }
                           this._defenderRemoved = true;
                        }
                     }
                     return true;
                  }
               }
               else if(isRanged)
               {
                  projectile = rangedAttack(_targetCreep);
               }
               else
               {
                  ATTACK.Damage(_tmpPoint.x,_tmpPoint.y - 5,damageDelt,_mc.visible);
                  damageDelt = _targetCreep.modifyHealth(-damage);
               }
               if(!_explode)
               {
                  if(!_targetCreep._explode && !_targetCreep._targetCreep && _targetCreep._behaviour != "heal")
                  {
                     distancePoint = _targetCreep._tmpPoint.subtract(_tmpPoint);
                     distanceSquared = distancePoint.x * distancePoint.x + distancePoint.y * distancePoint.y;
                     _waypoints = [];
                     _targetCreep._targetCreep = this;
                     if(_targetCreep.canShootCreep() || distanceSquared < 2500 || _targetCreep._creatureID == "C14")
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
                     _targetCreep._hasPath = true;
                     _targetCreep._hasTarget = true;
                  }
                  this.attacked(!!_targetCreep ? _targetCreep : _targetBuilding,damageDelt,projectile);
                  aggros = Targeting.getCreepsInRange(50,_tmpPoint,Targeting.k_TARGETS_ATTACKERS | Targeting.k_TARGETS_GROUND);
                  l = int(aggros.length);
                  i = 0;
                  while(i < 5 && i < l)
                  {
                     if(!aggros[i].creep._explode)
                     {
                        distancePoint = aggros[i].creep._tmpPoint.subtract(_tmpPoint);
                        distanceSquared = distancePoint.x * distancePoint.x + distancePoint.y * distancePoint.y;
                        aggros[i].creep._targetCreep = this;
                        if(!this.m_bInfernoCreep)
                        {
                           if(aggros[i].creep.canShootCreep() || distanceSquared < 2500 || aggros[i].creep._creatureID == "C14")
                           {
                              aggros[i].creep._atTarget = true;
                           }
                           else
                           {
                              aggros[i].creep._atTarget = false;
                              aggros[i].creep._waypoints = [_tmpPoint];
                           }
                        }
                        aggros[i].creep._looking = false;
                        aggros[i].creep._hasPath = true;
                        aggros[i].creep._hasTarget = true;
                     }
                     i++;
                  }
               }
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
         return false;
      }
      
      public function tickBDecoy() : Boolean
      {
         if(health <= 0)
         {
            if(_homeBunker)
            {
               if(Boolean(_homeBunker._monsters) && !this._defenderRemoved)
               {
                  if(!MapRoomManager.instance.isInMapRoom3 || !BASE.isMainYardOrInfernoMainYard)
                  {
                     --_homeBunker._monsters[_creatureID];
                     if(_homeBunker._monsters[_creatureID] < 0)
                     {
                        _homeBunker._monsters[_creatureID] = 0;
                     }
                  }
                  else
                  {
                     GLOBAL.player.monsterListByID(_creatureID).unlinkCreepFromData(this);
                  }
                  --_homeBunker._monstersDispatched[_creatureID];
                  if(_homeBunker._monstersDispatched[_creatureID] < 0)
                  {
                     _homeBunker._monstersDispatched[_creatureID] = 0;
                  }
                  --_homeBunker._monstersDispatchedTotal;
                  if(_homeBunker._monstersDispatchedTotal < 0)
                  {
                     _homeBunker._monstersDispatchedTotal = 0;
                  }
                  this._defenderRemoved = true;
               }
            }
         }
         if(_atTarget)
         {
         }
         if(!(SiegeWeapons.activeWeapon && SiegeWeapons.activeWeapon is Decoy))
         {
            _hasTarget = false;
            _atTarget = false;
            _attacking = false;
            _hasPath = false;
            this.findDefenseTargets();
         }
         return false;
      }
      
      protected function tickBDeathRun() : Boolean
      {
         if(health <= 0)
         {
            return true;
         }
         if(_atTarget)
         {
            if(_behaviour == k_sBHVR_JUICE)
            {
               if(_movement == "fly")
               {
                  if(!dying)
                  {
                     _dying = true;
                     TweenLite.to(_graphicMC,0.4,{
                        "y":_graphicMC.y + _altitude,
                        "ease":Sine.easeOut,
                        "onComplete":flyerJuice
                     });
                  }
                  if(!m_juiceReady)
                  {
                     return false;
                  }
               }
               GLOBAL._bJuicer.Blend(Math.ceil(_goo / 400),_creatureID,health / maxHealth);
            }
            if(_behaviour == k_sBHVR_FEED)
            {
               GIBLETS.Create(_tmpPoint,0.8,100,_goo / 400,36);
            }
            if(_behaviour == k_sBHVR_RETREAT && MapRoomManager.instance.isInMapRoom3)
            {
               if(GLOBAL.attackingPlayer.monsterListByID(_creatureID))
               {
                  GLOBAL.attackingPlayer.monsterListByID(_creatureID).unlinkCreepFromData(this);
               }
            }
            return true;
         }
         return false;
      }
      
      protected function tickBHeal() : Boolean
      {
         var _loc2_:ITargetable = null;
         var _loc3_:Point = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc1_:Number = 1;
         if(health <= 0)
         {
            if(_creatureID == "C12")
            {
               SOUNDS.Play("monsterlanddave");
            }
            else
            {
               SOUNDS.Play("monsterland" + (1 + int(Math.random() * 3)));
            }
            return true;
         }
         if(_hasTarget)
         {
            _loc5_ = range * range;
            if(_targetCreep)
            {
               _loc3_ = _targetCreep._tmpPoint.subtract(_tmpPoint);
               _loc4_ = _loc3_.x * _loc3_.x + _loc3_.y * _loc3_.y;
            }
            if(!_targetCreep || _targetCreep.health <= 0 || _targetCreep.health == _targetCreep.maxHealth && _frameNumber % 100 == 0)
            {
               _hasTarget = false;
               _attacking = false;
               _atTarget = false;
               _hasPath = false;
               if(Boolean(_targetCreep) && _targetCreep.health <= 0)
               {
                  _targetCreep = null;
               }
               this.findHealingTargets();
            }
            else if(!_attacking && _frameNumber % 120 == 0)
            {
               this.findHealingTargets();
            }
            else if(_loc4_ < _loc5_)
            {
               _atTarget = true;
            }
            else if(_attacking && _loc4_ > _loc5_ * 1.25)
            {
               _attacking = false;
               _atTarget = false;
               _waypoints = [_targetCreep._tmpPoint];
            }
         }
         else
         {
            _attacking = false;
            _atTarget = false;
            _hasPath = false;
            this.findHealingTargets();
         }
         if(_atTarget)
         {
            if(attackCooldown <= 0)
            {
               attackCooldown += int(attackDelay);
               if(_targetCreep.health > 0 && _targetCreep.health < _targetCreep.maxHealth)
               {
                  _attacking = true;
                  _loc2_ = rangedAttack(_targetCreep);
                  this.attacked(!!_targetCreep ? _targetCreep : _targetBuilding,damage * _loc1_,_loc2_);
               }
               else
               {
                  _attacking = false;
               }
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
         return false;
      }
      
      public function tickBPen() : Boolean
      {
         if(health <= 0)
         {
            return true;
         }
         if(_frameNumber > 240 && int(Math.random() * 200) == 1 && GLOBAL._fps > 25)
         {
            _targetPosition = HOUSING.PointInHouse(_targetCenter);
            _hasPath = true;
         }
         return false;
      }
      
      public function tickBHousing() : Boolean
      {
         if(_atTarget)
         {
            _behaviour = k_sBHVR_PEN;
            if(_movement == "fly")
            {
               TweenLite.to(_graphicMC,1.2,{
                  "y":_graphicMC.y + _altitude,
                  "ease":Sine.easeOut,
                  "onComplete":this.flyerLanded
               });
            }
            _waypoints[0] = HOUSING.PointInHouse(_targetCenter);
         }
         return false;
      }
      
      protected function tickBBunker() : Boolean
      {
         if(health <= 0)
         {
            if(_homeBunker)
            {
               if(Boolean(_homeBunker._monsters) && !this._defenderRemoved)
               {
                  if(!MapRoomManager.instance.isInMapRoom3 || !BASE.isMainYardOrInfernoMainYard)
                  {
                     --_homeBunker._monsters[_creatureID];
                     if(_homeBunker._monsters[_creatureID] < 0)
                     {
                        _homeBunker._monsters[_creatureID] = 0;
                     }
                  }
                  else
                  {
                     GLOBAL.player.monsterListByID(_creatureID).unlinkCreepFromData(this);
                  }
                  --_homeBunker._monstersDispatched[_creatureID];
                  if(_homeBunker._monstersDispatched[_creatureID] < 0)
                  {
                     _homeBunker._monstersDispatched[_creatureID] = 0;
                  }
                  --_homeBunker._monstersDispatchedTotal;
                  if(_homeBunker._monstersDispatchedTotal < 0)
                  {
                     _homeBunker._monstersDispatchedTotal = 0;
                  }
                  this._defenderRemoved = true;
               }
            }
            return true;
         }
         if(_frameNumber % 200)
         {
            this.findDefenseTargets();
         }
         if(_atTarget && _behaviour == k_sBHVR_BUNKER)
         {
            if(_homeBunker)
            {
               if(MapRoomManager.instance.isInMapRoom3 && BASE.isMainYardOrInfernoMainYard)
               {
                  GLOBAL.player.monsterListByID(_creatureID).unlinkCreepFromData(this);
               }
               --_homeBunker._monstersDispatched[_creatureID];
               if(_homeBunker._monstersDispatched[_creatureID] < 0)
               {
                  _homeBunker._monstersDispatched[_creatureID] = 0;
               }
               --_homeBunker._monstersDispatchedTotal;
               if(_homeBunker._monstersDispatchedTotal < 0)
               {
                  _homeBunker._monstersDispatchedTotal = 0;
               }
            }
            if(!this.m_bInfernoCreep || !BASE.isInfernoMainYardOrOutpost)
            {
               return true;
            }
         }
         return false;
      }
      
      override protected function move() : void
      {
         var distancePoint:Point = null;
         var distanceSquared:Number = NaN;
         var targetDistance:Number = NaN;
         var targetDistanceSquared:Number = NaN;
         var building:BFOUNDATION = null;
         var growled:Boolean = false;
         _speed = moveSpeed * 0.5;
         if(_behaviour == k_sBHVR_PEN)
         {
            _speed *= 0.5;
         }
         if(_behaviour == k_sBHVR_JUICE || _behaviour == k_sBHVR_HOUSING || _behaviour == k_sBHVR_BUNKER)
         {
            _speed *= 1.5;
         }
         if(_behaviour == k_sBHVR_DEFEND)
         {
            _speed *= 1.5;
         }
         if(_behaviour == k_sBHVR_JUICE && _movement == "fly" && _altitude < 25)
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
         if(_behaviour != k_sBHVR_JUICE && _behaviour != k_sBHVR_RETREAT && _behaviour != k_sBHVR_HOUSING && _behaviour != k_sBHVR_BUNKER && _behaviour != k_sBHVR_PEN && !_atTarget && (_targetCreep && this.canShootCreep() || this.canShootBuilding()))
         {
            _atTarget = true;
            SOUNDS.Play("imonster" + int(1 + Math.random() * 4));
            if(_targetCreep)
            {
               _xd = _targetCreep._tmpPoint.x - _tmpPoint.x;
               _yd = _targetCreep._tmpPoint.y - _tmpPoint.y;
               _targetPosition = _targetCreep._tmpPoint;
            }
            else
            {
               _xd = _targetBuilding._position.x - _tmpPoint.x;
               _yd = _targetBuilding._position.y - _tmpPoint.y;
               _targetPosition = _targetBuilding._position;
            }
         }
         else if(_waypoints.length > 0)
         {
            distancePoint = _targetPosition.subtract(_tmpPoint);
            distanceSquared = distancePoint.x * distancePoint.x + distancePoint.y * distancePoint.y;
            if(distanceSquared <= 100)
            {
               while(_waypoints.length > 0 && distanceSquared <= 100)
               {
                  _waypoints.splice(0,1);
                  if(_waypoints[0])
                  {
                     _targetPosition = _waypoints[0];
                     distancePoint = _targetPosition.subtract(_tmpPoint);
                     distanceSquared = distancePoint.x * distancePoint.x + distancePoint.y * distancePoint.y;
                     if(_movement == "jump" && !_jumping)
                     {
                        building = PATHING.GetBuildingFromISO(_targetPosition);
                        if(building)
                        {
                           if(building.health > 0)
                           {
                              TweenLite.to(_graphicMC,0.4,{
                                 "y":_graphicMC.y - 60,
                                 "ease":Sine.easeOut,
                                 "overwrite":false,
                                 "onComplete":function():void
                                 {
                                    _jumpingUp = false;
                                 }
                              });
                              TweenLite.to(_graphicMC,0.4,{
                                 "y":_graphicMC.y,
                                 "ease":Bounce.easeOut,
                                 "overwrite":false,
                                 "delay":0.4,
                                 "onComplete":function():void
                                 {
                                    _jumping = false;
                                 }
                              });
                              _jumping = true;
                              _jumpingUp = true;
                           }
                        }
                     }
                  }
                  else if(_behaviour == k_sBHVR_DEFEND)
                  {
                     if(_targetCreep)
                     {
                        distancePoint = _targetCreep._tmpPoint.subtract(_tmpPoint);
                        targetDistanceSquared = distancePoint.x * distancePoint.x + distancePoint.y * distancePoint.y;
                        if(targetDistanceSquared < this.DEFENSE_RANGE_SQUARED || this.canShootCreep())
                        {
                           _waypoints = [];
                           _atTarget = true;
                           _targetCreep._targetCreep = this;
                           if(this.m_bInfernoCreep && !growled)
                           {
                              growled = true;
                              SOUNDS.Play("imonster" + int(1 + Math.random() * 4));
                           }
                           if(_targetCreep.canShootCreep() || targetDistanceSquared < 2500 || _targetCreep._creatureID == "C14")
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
                           _targetCreep._hasTarget = true;
                           return;
                        }
                     }
                  }
                  else
                  {
                     if(_behaviour != k_sBHVR_HEAL)
                     {
                        if(_behaviour == k_sBHVR_RETREAT)
                        {
                           _atTarget = true;
                           return;
                        }
                        if(_targetCreep)
                        {
                           distancePoint = _targetCreep._tmpPoint.subtract(_tmpPoint);
                           targetDistanceSquared = distancePoint.x * distancePoint.x + distancePoint.y * distancePoint.y;
                           if(this.canShootCreep() || targetDistanceSquared < 2500 || _creatureID == "C14")
                           {
                              _atTarget = true;
                           }
                           else
                           {
                              _atTarget = false;
                              _waypoints = [_targetCreep._tmpPoint];
                           }
                           if(this.m_bInfernoCreep && _atTarget && !growled)
                           {
                              growled = true;
                              SOUNDS.Play("imonster" + int(1 + Math.random() * 4));
                           }
                        }
                        else
                        {
                           _atTarget = true;
                        }
                        return;
                     }
                     if(_targetCreep)
                     {
                        distancePoint = _targetCreep._tmpPoint.subtract(_tmpPoint);
                        targetDistanceSquared = distancePoint.x * distancePoint.x + distancePoint.y * distancePoint.y;
                        if(targetDistanceSquared < range * range)
                        {
                           _atTarget = true;
                           return;
                        }
                     }
                  }
               }
               if(_targetCreep)
               {
                  distancePoint = _targetCreep._tmpPoint.subtract(_tmpPoint);
                  targetDistanceSquared = distancePoint.x * distancePoint.x + distancePoint.y * distancePoint.y;
               }
               if(_behaviour == k_sBHVR_DEFEND && Boolean(_targetCreep))
               {
                  if(targetDistanceSquared < this.DEFENSE_RANGE_SQUARED || this.canShootCreep())
                  {
                     _atTarget = true;
                     if(this.m_bInfernoCreep && !growled)
                     {
                        growled = true;
                        SOUNDS.Play("imonster" + int(1 + Math.random() * 4));
                     }
                     _waypoints = [];
                     if(!_targetCreep._explode)
                     {
                        _targetCreep._targetCreep = this;
                        if(_targetCreep.canShootCreep() || targetDistanceSquared < 2500 || _targetCreep._creatureID == "C14")
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
                        _targetCreep._hasTarget = true;
                     }
                     _targetPosition = _targetCreep._tmpPoint;
                     return;
                  }
                  if(_waypoints.length == 0 && _hasPath)
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
               else if(_behaviour == k_sBHVR_HEAL)
               {
                  if(targetDistanceSquared < range * range)
                  {
                     _atTarget = true;
                     return;
                  }
                  if(_targetCreep && _waypoints.length == 0 && _hasPath)
                  {
                     _waypoints = [_targetCreep._tmpPoint];
                     WaypointTo(_targetCreep._tmpPoint,null);
                  }
               }
               else if(_waypoints.length == 0 && _hasPath)
               {
                  if(this.canShootCreep() || targetDistanceSquared < 2500 || _creatureID == "C14")
                  {
                     _atTarget = true;
                  }
                  else
                  {
                     _atTarget = false;
                     if(_targetCreep)
                     {
                        _waypoints = [_targetCreep._tmpPoint];
                     }
                  }
                  if(this.m_bInfernoCreep && _atTarget && !growled)
                  {
                     growled = true;
                     SOUNDS.Play("imonster" + int(1 + Math.random() * 4));
                  }
                  return;
               }
            }
            if(_waypoints.length > 0 && !_atTarget)
            {
               _targetPosition = _waypoints[0];
            }
            if(_behaviour == k_sBHVR_ATTACK && Boolean(_targetCreep))
            {
               _xd = _targetCreep._tmpPoint.x - _tmpPoint.x;
               _yd = _targetCreep._tmpPoint.y - _tmpPoint.y;
            }
            else if(_behaviour == k_sBHVR_DEFEND || _behaviour == k_sBHVR_HEAL)
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
            }
            distancePoint = _targetPosition.subtract(_tmpPoint);
            distanceSquared = distancePoint.x * distancePoint.x + distancePoint.y * distancePoint.y;
            if(!_atTarget)
            {
               if(distanceSquared > 25)
               {
                  _tmpPoint.x += Math.cos(Math.atan2(_yd,_xd)) * _speed;
                  _tmpPoint.y += Math.sin(Math.atan2(_yd,_xd)) * _speed;
               }
               else
               {
                  _atTarget = true;
               }
            }
         }
      }
      
      override protected function getNextSprite() : void
      {
         if(_creatureID == "IC5" && _movement == "fly" || _movement == "fly_low")
         {
            SPRITES.GetSprite(_shadow,"shadow","shadow",0);
         }
         if(_creatureID == "C14" || _creatureID == "C16")
         {
            SPRITES.GetSprite(_shadow,"shadow","shadow",0);
            if(health <= 0)
            {
               this._lastFrame = CreepSkinManager.instance.GetSprite(_graphic,_creatureID,"landed",m_rotation,0,this._lastFrame,_currentSkinOverride);
            }
            else
            {
               this._lastFrame = CreepSkinManager.instance.GetSprite(_graphic,_creatureID,"flying",m_rotation,_frameNumber,this._lastFrame,_currentSkinOverride);
            }
         }
         else if(_creatureID == "C15")
         {
            SPRITES.GetSprite(_shadow,"bigshadow","bigshadow",0);
            this._lastFrame = CreepSkinManager.instance.GetSprite(_graphic,_creatureID,"flying",m_rotation,0,this._lastFrame,_currentSkinOverride);
         }
         else
         {
            this._lastFrame = CreepSkinManager.instance.GetSprite(_graphic,_creatureID,spriteAction,m_rotation,_frameNumber,this._lastFrame,_currentSkinOverride);
         }
      }
      
      override protected function hackCheck() : Boolean
      {
         return true;
      }
      
      private function airburst() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc6_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:BFOUNDATION = null;
         var _loc10_:MonsterBase = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:* = undefined;
         var _loc15_:Number = NaN;
         var _loc7_:Number = 1.1 + powerUpLevel() * 0.1;
         if(_behaviour == k_sBHVR_ATTACK)
         {
            _loc1_ = int(60 * (1.1 + powerUpLevel() * 0.1));
            _loc1_ *= _loc1_;
            ATTACK.Damage(_tmpPoint.x,_tmpPoint.y - (45 + 20 * (powerUpLevel() - 1)),damage * _loc7_,_mc.visible);
            if(_targetBuilding)
            {
               _targetBuilding.modifyHealth(damage * _loc7_,this);
            }
            _loc2_ = PATHING.FromISO(_tmpPoint).add(new Point(-5,-5));
            _loc3_ = new Point(0,0);
            _loc4_ = new Point(0,0);
            for each(_loc9_ in BASE._buildingsAll)
            {
               if(_loc9_._class != "decoration" && _loc9_._class != "enemy" && _loc9_._class != "trap")
               {
                  _loc4_.x = _loc9_.x;
                  _loc4_.y = _loc9_.y;
                  _loc3_ = PATHING.FromISO(_loc4_);
                  _loc4_.x = _loc9_._middle;
                  _loc4_.y = _loc9_._middle;
                  _loc3_.add(_loc4_);
                  if((_loc6_ = (_loc5_ = _loc2_.subtract(_loc3_)).x * _loc5_.x + _loc5_.y * _loc5_.y) < _loc1_)
                  {
                     if(_loc9_ != _targetBuilding)
                     {
                        _loc9_.modifyHealth(int(damage * _loc7_ * ((_loc1_ - _loc6_) / _loc1_)),this);
                     }
                  }
               }
            }
            _loc1_ = int(90 * (1.1 + powerUpLevel() * 0.1));
            _loc1_ *= _loc1_;
            if(_targetCreep)
            {
               if((_loc6_ = (_loc5_ = _tmpPoint.subtract(_targetCreep._tmpPoint)).x * _loc5_.x + _loc5_.y * _loc5_.y) < _loc1_)
               {
                  _targetCreep.modifyHealth(-(damage * _loc7_));
               }
            }
            for each(_loc10_ in CREATURES._creatures)
            {
               if((_loc10_._behaviour == k_sBHVR_DEFEND || _loc10_._behaviour == k_sBHVR_BUNKER) && _loc10_ != _targetCreep)
               {
                  if((_loc8_ = _loc6_ = (_loc5_ = _loc2_.subtract(_loc3_)).x * _loc5_.x + _loc5_.y * _loc5_.y) < _loc1_)
                  {
                     _loc10_.modifyHealth(-int(damage * _loc7_ * _loc10_._damageMult * ((_loc1_ - _loc8_) / _loc1_)));
                  }
               }
            }
            if(CREATURES._guardian && CREATURES._guardian._behaviour == k_sBHVR_DEFEND && CREATURES._guardian != _targetCreep)
            {
               if((_loc6_ = (_loc5_ = CREATURES._guardian._tmpPoint.subtract(_tmpPoint)).x * _loc5_.x + _loc5_.y * _loc5_.y) < _loc1_)
               {
                  _loc11_ = _loc7_;
                  if(CREATURES._guardian._movement == "fly")
                  {
                     _loc11_ = 0.1 * (0.1 * _loc7_);
                  }
                  CREATURES._guardian.modifyHealth(-int(damage * _loc11_ * ((_loc1_ - _loc6_) / _loc1_)));
               }
            }
            ATTACK.Log("creep" + _id,"<font color=\"#0000FF\">" + KEYS.Get("attack_log_eyera") + "</font>");
            EFFECTS.Scorch(_tmpPoint);
         }
         else
         {
            _loc12_ = 1;
            _loc1_ = int(90 * (1.1 + powerUpLevel() * 0.1));
            if(Boolean(GLOBAL._monsterOverdrive) && GLOBAL._monsterOverdrive.Get() >= GLOBAL.Timestamp())
            {
               _loc12_ *= 1.25;
            }
            ATTACK.Damage(_tmpPoint.x,_tmpPoint.y - (45 + 20 * (powerUpLevel() - 1)),damage * _loc12_,_mc.visible);
            _targetCreeps = Targeting.getCreepsInRange(_loc1_,_tmpPoint,Targeting.getOldStyleTargets(-1));
            _loc13_ = 0;
            while(_loc13_ < _targetCreeps.length)
            {
               _loc14_ = _targetCreeps[_loc13_].creep;
               if(_loc13_ == 0)
               {
                  _loc15_ = _loc12_;
               }
               else
               {
                  _loc15_ = _loc12_ * ((_loc1_ - _targetCreeps[_loc13_].dist) / _loc1_);
               }
               _loc14_.modifyHealth(-(damage * _loc15_ * _loc7_ * _loc14_._damageMult));
               _loc13_++;
            }
            _loc1_ = 90;
            _loc12_ = 0.1 * powerUpLevel() + 0.1;
            if(Boolean(GLOBAL._monsterOverdrive) && GLOBAL._monsterOverdrive.Get() >= GLOBAL.Timestamp())
            {
               _loc12_ *= 1.25;
            }
            _targetCreeps = Targeting.getCreepsInRange(_loc1_,_tmpPoint,Targeting.getOldStyleTargets(2));
            _loc13_ = 0;
            while(_loc13_ < _targetCreeps.length)
            {
               _loc14_ = _targetCreeps[_loc13_].creep;
               if(_loc13_ == 0)
               {
                  _loc15_ = _loc12_;
               }
               else
               {
                  _loc15_ = _loc12_ * ((_loc1_ - _targetCreeps[_loc13_].dist) / _loc1_);
               }
               _loc14_.modifyHealth(-(damage * _loc15_ * _loc7_ * _loc14_._damageMult));
               _loc13_++;
            }
            if(_homeBunker)
            {
               if(Boolean(_homeBunker._monsters) && !this._defenderRemoved)
               {
                  if(!MapRoomManager.instance.isInMapRoom3 || !BASE.isMainYardOrInfernoMainYard)
                  {
                     --_homeBunker._monsters[_creatureID];
                     if(_homeBunker._monsters[_creatureID] < 0)
                     {
                        _homeBunker._monsters[_creatureID] = 0;
                     }
                  }
                  else
                  {
                     setHealth(0);
                     GLOBAL.player.monsterListByID(_creatureID).unlinkCreepFromData(this);
                  }
                  --_homeBunker._monstersDispatched[_creatureID];
                  if(_homeBunker._monstersDispatched[_creatureID] < 0)
                  {
                     _homeBunker._monstersDispatched[_creatureID] = 0;
                  }
                  --_homeBunker._monstersDispatchedTotal;
                  if(_homeBunker._monstersDispatchedTotal < 0)
                  {
                     _homeBunker._monstersDispatchedTotal = 0;
                  }
                  this._defenderRemoved = true;
               }
            }
         }
         setHealth(0);
      }
      
      private function applyInfernoVenom() : void
      {
         if(!this.m_bInfernoCreep && BASE.isInfernoMainYardOrOutpost && (GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == "wmattack"))
         {
            _damagePerSecond.Add(10);
         }
      }
   }
}
