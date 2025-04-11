package com.monsters.monsters.champions
{
   import com.monsters.interfaces.ITargetable;
   import com.monsters.managers.InstanceManager;
   import com.monsters.monsters.components.abilities.AOEEnrage;
   import com.monsters.pathing.PATHING;
   import flash.geom.Point;
   
   public class Fomor extends ChampionBase
   {
       
      /*
      param1 -> behaviour
      param2 -> targetPosition
      param3 -> targetRotation
      param4 -> targetCenter
      param5 -> friendly
      param6 -> house
      param7 -> level
      param8 -> feeds
      param9 -> feedTime
      param10 -> creatureID
      param11 -> health
      param12 -> foodBonus
      param13 -> powerLevel
      */
      public function Fomor(behaviour:String, targetPosition:Point, targetRotation:Number, targetCenter:Point = null, friendly:Boolean = false, house:BFOUNDATION = null, level:int = 1, feeds:int = 0, feedTime:int = 0, creatureID:int = 1, health:int = 20000, foodBonus:int = 0, powerLevel:int = 1)
      {
         super(behaviour,targetPosition,targetRotation,targetCenter,friendly,house,level,feeds,feedTime,creatureID,health,foodBonus,powerLevel);
         attackDelayProperty.value = 8;
         if(_behaviour == "bounce")
         {
            _graphicMC.y -= _altitude;
            this.changeModeBuff();
         }
         SPRITES.SetupSprite("bigshadow");
         addComponent(new AOEEnrage(250,1 + _buff * 2,_buff));
         attackFlags = Targeting.getOldStyleTargets(1);
      }
      /*
      _loc2_ -> tickResult
      param1 -> time delta?
      */
      override public function tick(param1:int = 1) : Boolean
      {
         var tickResult:Boolean = super.tick(param1);
         switch(_behaviour)
         {
            case k_sBHVR_BUFF:
               this.tickBBuff();
               break;
            case k_sBHVR_PEN:
               _hasTarget = false;
         }
         return tickResult;
      }
      //_loc1_ -> distance
      override public function canShootCreep() : Boolean
      {
         if(_targetCreep == null)
         {
            return false;
         }
         var distance:Number = GLOBAL.QuickDistance(_targetCreep._tmpPoint,_tmpPoint);
         if(distance > m_range)
         {
            return false;
         }
         if(PATHING.LineOfSight(_tmpPoint.x,_tmpPoint.y,_targetCreep._tmpPoint.x,_targetCreep._tmpPoint.y))
         {
            return true;
         }
         return false;
      }
      
      /*
         _loc2_ -> currentBuilding
         _loc3_ -> buildingFound
         _loc4_ -> removed since its never used
         _loc1_ -> buildings
         _loc5_ -> creepFound (removed since its never used)
      */
      public function findBuffTargets() : void
      {
         var currentBuilding:BFOUNDATION = null;
         var buildingFound:Boolean = false;
         var buildings:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         //if no building found theres no point in buffing anyone
         for each(currentBuilding in buildings)
         {
            if(currentBuilding._class !== "decoration" && currentBuilding._class !== "immovable" && currentBuilding.health > 0 && currentBuilding._class !== "enemy")
            {
               buildingFound = true;
            }
         }
         if(!buildingFound)
         {
            changeModeRetreat();
            return;
         }
         _looking = true;
         _targetCreeps = Targeting.getCreepsInRange(1500,_tmpPoint,Targeting.getOldStyleTargets(1),this);
         if(_targetCreeps.length > 0)
         {
            _targetCreeps.sortOn(["dist"],Array.NUMERIC);
            if(!(Boolean(_targetCreep) && _targetCreep.health > 0 && _targetCreep.health < _targetCreep.maxHealth))
            {
               while(_targetCreeps.length > 0 && (_targetCreeps[0].creep._behaviour == "heal" || _targetCreeps[0].creep.health == _targetCreeps[0].creep.maxHealth))
               {
                  _targetCreeps.shift();
               }
               if(_targetCreeps.length > 0)
               {
                  _helpCreep = _targetCreeps[0].creep;
                  if(_movement == "fly")
                  {
                     _waypoints = [_helpCreep._tmpPoint];
                     _targetPosition = _helpCreep._tmpPoint;
                  }
                  else
                  {
                     WaypointTo(_helpCreep._tmpPoint,null);
                  }
               }
            }
         }
         if(_targetCreeps.length > 0)
         {
            _helpCreep = _targetCreeps[0].creep;
            if(_movement == "fly")
            {
               _waypoints = [_helpCreep._tmpPoint];
               _targetPosition = _helpCreep._tmpPoint;
            }
            else
            {
               WaypointTo(_helpCreep._tmpPoint,null);
            }
            _behaviour = k_sBHVR_BUFF;
         }
         else if(_helpCreep && _helpCreep.health > 0 && _helpCreep.health < _helpCreep.maxHealth)
         {
            if(_movement == "fly")
            {
               _waypoints = [_helpCreep._tmpPoint];
               _targetPosition = _helpCreep._tmpPoint;
            }
            else
            {
               WaypointTo(_helpCreep._tmpPoint,null);
            }
            _behaviour = k_sBHVR_BUFF;
         }
         else if(_targetCreeps.length == 0)
         {
            changeModeAttack();
            return;
         }
         if(_waypoints.length)
         {
            _hasTarget = true;
            _hasPath = true;
         }
      }
      
      override protected function tickBAttack() : void
      {
         super.tickBAttack();
         if(_frameNumber % 100 == 0)
         {
            this.findBuffTargets();
            if(_behaviour == k_sBHVR_BUFF)
            {
               this.tickBBuff();
               return;
            }
         }
      }
      
      // _loc1_ -> removed since its never used
      override protected function doAttackDamage() : void
      {
         if(_creatureID == "G3")
         {
            if(Boolean(_targetCreep) && _targetCreep.health > 0)
            {
               this.rangedAttack(_targetCreep);
            }
            else if(_targetBuilding)
            {
               _targetCenter = _targetBuilding._position;
               _targetPosition = _targetBuilding._position;
               this.rangedAttack(_targetBuilding);
            }
            else
            {
               this.findBuffTargets();
            }
         }
      }
      
      /*
      _loc3_ -> fireball
      _loc2_ -> startingPoint
      param1 -> target
      */
      override protected function rangedAttack(target:ITargetable) : ITargetable
      {
         var fireball:FIREBALL = null;
         var startingPoint:Point = Point.interpolate(_tmpPoint.add(new Point(0,-_altitude)),_targetPosition,0.8);
         if(target is BFOUNDATION)
         {
            fireball = FIREBALLS.Spawn(startingPoint,_targetPosition,_targetBuilding,8,damage,0,0,FIREBALLS.TYPE_FIREBALL,this);
         }
         else
         {
            fireball = FIREBALLS.Spawn2(startingPoint,_targetCreep._tmpPoint,_targetCreep,8,damage,0,FIREBALLS.TYPE_FIREBALL,1,this);
         }
         SOUNDS.Play("hit" + int(1 + Math.random() * 3),0.1 + Math.random() * 0.1);
         FIREBALLS._fireballs[FIREBALLS._id - 1]._graphic.gotoAndStop(3);
         return fireball;
      }
      
      // _loc1_ removed since its never used
      public function tickBBuff() : void
      {
         if(health <= 0)
         {
            Targeting.CreepCellDelete(_id,node);
            changeModeRetreat();
            ATTACK.Log(_creatureID,KEYS.Get("attacklog_champ_retreated",{
               "v1":LOGIN._playerName,
               "v2":_level.Get(),
               "v3":CHAMPIONCAGE._guardians[_creatureID].name
            }));
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK)
            {
               LOGGER.Stat([54,_creatureID,1,_level.Get()]);
            }
            SOUNDS.Play("monsterland" + (1 + int(Math.random() * 3)));
            return;
         }
         if(_frameNumber % 100 == 0)
         {
            if(!_attacking)
            {
               this.findBuffTargets();
            }
         }
         if(_hasTarget)
         {
            if(_targetCreep)
            {
               if(_targetCreep.health <= 0 || _targetCreep.health == _targetCreep.maxHealth && _frameNumber % 20 == 0)
               {
                  _hasTarget = false;
                  _attacking = false;
                  _atTarget = false;
                  _hasPath = false;
                  _helpCreep = null;
                  if(Boolean(_targetCreep) && _targetCreep.health <= 0)
                  {
                     _targetCreep = null;
                  }
                  this.findBuffTargets();
               }
               else if(GLOBAL.QuickDistance(_targetCreep._tmpPoint,_tmpPoint) < m_range)
               {
                  _atTarget = true;
               }
               else
               {
                  _atTarget = false;
               }
            }
            else if(_helpCreep)
            {
               if(_helpCreep._targetBuilding)
               {
                  _targetBuilding = _helpCreep._targetBuilding;
               }
               if(_helpCreep.health <= 0 || _helpCreep.health == _helpCreep.maxHealth && _frameNumber % 20 == 0)
               {
                  _hasTarget = false;
                  _attacking = false;
                  _atTarget = false;
                  _hasPath = false;
                  if(_helpCreep && _helpCreep.health <= 0)
                  {
                     _helpCreep = null;
                  }
                  this.findBuffTargets();
               }
               else if(_helpCreep && GLOBAL.QuickDistance(_helpCreep._tmpPoint,_tmpPoint) < m_range && Boolean(_helpCreep._targetBuilding) && GLOBAL.QuickDistance(_helpCreep._targetBuilding._position,_tmpPoint) < m_range)
               {
                  _atTarget = true;
               }
               else if(!_attacking && !_looking && _frameNumber % 120 == 0)
               {
                  this.findBuffTargets();
               }
               else if(_attacking && _helpCreep && GLOBAL.QuickDistance(_helpCreep._tmpPoint,_tmpPoint) > m_range * 1.25)
               {
                  _attacking = false;
                  _atTarget = false;
               }
               else if(_waypoints.length == 0 && !_atTarget)
               {
                  if(canHitBuilding())
                  {
                     _atTarget = true;
                  }
                  else if(!_looking)
                  {
                     if(_movement == "fly")
                     {
                        _hasPath = true;
                        _waypoints = [_targetBuilding._position];
                        _targetPosition = _targetBuilding._position;
                     }
                     else if(!_looking)
                     {
                        _hasPath = false;
                        _hasTarget = false;
                        WaypointTo(_targetBuilding._position,_targetBuilding);
                     }
                  }
               }
            }
            else if(Boolean(_targetBuilding) && _targetBuilding.health > 0)
            {
               if(canHitBuilding())
               {
                  _atTarget = true;
               }
               else
               {
                  _atTarget = false;
                  _attacking = false;
                  if(_waypoints.length == 0 && !_looking)
                  {
                     _hasPath = false;
                     if(_movement == "fly")
                     {
                        _waypoints = [_helpCreep._tmpPoint];
                        _targetPosition = _helpCreep._tmpPoint;
                     }
                     else
                     {
                        WaypointTo(_helpCreep._tmpPoint,_targetBuilding);
                     }
                  }
               }
            }
            else
            {
               _attacking = false;
               _atTarget = false;
               _hasPath = false;
               _targetCreep = null;
               _helpCreep = null;
               _targetBuilding = null;
               this.findBuffTargets();
            }
         }
         else
         {
            _attacking = false;
            _atTarget = false;
            _hasPath = false;
            _targetCreep = null;
            _helpCreep = null;
            _targetBuilding = null;
            this.findBuffTargets();
         }
         if(_atTarget)
         {
            if(attackCooldown <= 0)
            {
               attackCooldown += int(attackDelay);
               if(Boolean(_targetCreep) && _targetCreep.health > 0)
               {
                  _attacking = true;
                  this.rangedAttack(_targetCreep);
                  _targetCenter = _targetCreep._tmpPoint;
                  _targetPosition = _targetCreep._tmpPoint;
               }
               else if(_helpCreep && _helpCreep._targetBuilding && _helpCreep._targetBuilding.health > 0 || _targetBuilding && _targetBuilding.health > 0)
               {
                  if(_helpCreep)
                  {
                     _targetBuilding = _helpCreep._targetBuilding;
                  }
                  if(Boolean(_targetBuilding) && GLOBAL.QuickDistance(_targetBuilding._position,_tmpPoint) < m_range)
                  {
                     _attacking = true;
                     _targetCenter = _targetBuilding._position;
                     _targetPosition = _targetBuilding._position;
                     this.rangedAttack(_targetBuilding);
                  }
                  else if(_targetBuilding)
                  {
                     _attacking = false;
                     _atTarget = false;
                     if(_movement == "fly")
                     {
                        _hasPath = true;
                        _waypoints = [_targetBuilding._position];
                        _targetPosition = _targetBuilding._position;
                     }
                     else if(!_looking)
                     {
                        _hasPath = false;
                        _hasTarget = false;
                        WaypointTo(_targetBuilding._position,_targetBuilding);
                     }
                  }
                  else
                  {
                     _attacking = false;
                     _atTarget = false;
                     _hasPath = false;
                     _targetCreep = null;
                     _helpCreep = null;
                     _targetBuilding = null;
                     this.findBuffTargets();
                  }
               }
               else
               {
                  _attacking = false;
                  _atTarget = false;
                  _hasTarget = false;
                  _hasPath = false;
                  _targetBuilding = null;
                  _targetCreep = null;
                  _helpCreep = null;
                  this.findBuffTargets();
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
      }
      
      public function changeModeBuff() : void
      {
         changeMode();
         _behaviour = k_sBHVR_BUFF;
         this.findBuffTargets();
      }
   }
}
