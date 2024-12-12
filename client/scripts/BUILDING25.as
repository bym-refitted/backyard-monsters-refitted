package
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.siege.weapons.Vacuum;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class BUILDING25 extends BTOWER
   {
      
      public static const TYPE:uint = 25;
       
      
      public var _field:BitmapData;
      
      public var _fieldBMP:Bitmap;
      
      public var _animBitmap:BitmapData;
      
      public var _fireStage:int;
      
      public var _shotsFired:int;
      
      public var _laserTarget:IAttackable;
      
      public function BUILDING25()
      {
         super();
         _type = 25;
         _frameNumber = 0;
         _animTick = 0;
         _top = -30;
         this._fireStage = 0;
         this._shotsFired = 0;
         _footprint = [new Rectangle(0,0,70,70)];
         _gridCost = [[new Rectangle(0,0,70,70),10],[new Rectangle(10,10,50,50),200]];
         SetProps();
         this.Props();
      }
      
      override public function Description() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         super.Description();
         _upgradeDescription = "";
         if(_lvl.Get() > 0 && _lvl.Get() < _buildingProps.costs.length)
         {
            _loc1_ = _buildingProps.stats[_lvl.Get() - 1];
            _loc2_ = _buildingProps.stats[_lvl.Get()];
            _loc3_ = int(_loc1_.range);
            _loc4_ = int(_loc2_.range);
            if(BASE.isOutpost)
            {
               _loc3_ = BTOWER.AdjustTowerRange(GLOBAL._currentCell,_loc3_);
               _loc4_ = BTOWER.AdjustTowerRange(GLOBAL._currentCell,_loc4_);
            }
            if(_loc1_.range < _loc2_.range)
            {
               _upgradeDescription += KEYS.Get("building_rangeincrease",{
                  "v1":_loc3_,
                  "v2":_loc4_
               }) + "<br>";
            }
            if(_loc1_.damage.Get() < _loc2_.damage.Get())
            {
               _upgradeDescription += KEYS.Get("building_dpsincrease",{
                  "v1":_loc1_.damage.Get(),
                  "v2":_loc2_.damage.Get()
               }) + "<br>";
            }
            if(_loc1_.rate < _loc2_.rate)
            {
               _upgradeDescription += KEYS.Get("building_sfpcincrease",{
                  "v1":_loc1_.rate,
                  "v2":_loc2_.rate
               }) + "<br>";
            }
         }
      }
      
      override public function AnimFrame(param1:Boolean = true) : void
      {
         if(_animLoaded && !GLOBAL._catchup)
         {
            _animRect.x = _animRect.width * _animTick;
            _animContainerBMD.copyPixels(_animBMD,_animRect,_nullPoint);
         }
      }
      
      override public function Fire(param1:IAttackable) : void
      {
         super.Fire(param1);
         if(param1 is MonsterBase)
         {
            this._laserTarget = param1;
         }
         else
         {
            this._laserTarget = null;
         }
         if(this._fireStage == 0)
         {
            this._fireStage = 1;
            SOUNDS.Play("lightningstart",!isJard ? 0.8 : 0.4);
         }
      }
      
      override public function TickFast(param1:Event = null) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         super.TickFast(param1);
         ++_frameNumber;
         if(_frameNumber == 40)
         {
            _frameNumber = 4;
         }
         if(!GLOBAL._catchup)
         {
            if(this._fireStage == 1)
            {
               ++_animTick;
               if(_animTick == 32)
               {
                  this._fireStage = 2;
                  this._shotsFired = 0;
               }
            }
            else if(this._fireStage == 2)
            {
               if(health <= 0)
               {
                  this._fireStage = 3;
               }
               else
               {
                  ++_animTick;
                  if(_animTick == 41)
                  {
                     _animTick = 32;
                  }
                  if(_frameNumber % 4 == 0)
                  {
                     if(_hasTargets || _targetVacuum)
                     {
                        _loc2_ = 0.5 + 0.5 / maxHealth * health;
                        _loc3_ = 1;
                        if(Boolean(GLOBAL._towerOverdrive) && GLOBAL._towerOverdrive.Get() >= GLOBAL.Timestamp())
                        {
                           _loc3_ = 1.25;
                        }
                        if(isJard)
                        {
                           _jarHealth.Add(-int(damage * _loc2_ * _loc3_));
                           ATTACK.Damage(_mc.x,_mc.y + _top,damage * _loc2_ * _loc3_);
                           if(_jarHealth.Get() <= 0)
                           {
                              KillJar();
                           }
                        }
                        else if(Boolean(this._laserTarget) || _targetVacuum)
                        {
                           if(this._laserTarget)
                           {
                              if(this._laserTarget is MonsterBase && MonsterBase(this._laserTarget)._movement == "fly")
                              {
                                 EFFECTS.Lightning(_mc.x,_mc.y - 50,this._laserTarget.x,this._laserTarget.y - MonsterBase(this._laserTarget)._altitude);
                              }
                              else
                              {
                                 EFFECTS.Lightning(_mc.x,_mc.y - 50,this._laserTarget.x,this._laserTarget.y);
                              }
                              this._laserTarget.modifyHealth(-int(damage * _loc2_ * _loc3_));
                              ATTACK.Damage(_mc.x,_mc.y - 50,int(damage * _loc2_ * _loc3_));
                           }
                           else if(_targetVacuum && canShootVacuumHose())
                           {
                              EFFECTS.Lightning(_mc.x,_mc.y - 50,GLOBAL.townHall._mc.x,GLOBAL.townHall._mc.y - GLOBAL.townHall._mc.height);
                              Vacuum.getHose().modifyHealth(-int(damage * _loc2_ * _loc3_));
                              ATTACK.Damage(_mc.x,_mc.y - 50,int(damage * _loc2_ * _loc3_));
                           }
                        }
                     }
                     SOUNDS.Play("lightningfire",!isJard ? 0.8 : 0.4);
                     ++this._shotsFired;
                     if(this._shotsFired >= _rate)
                     {
                        this._fireStage = 3;
                        SOUNDS.Play("lightningend",!isJard ? 0.8 : 0.4);
                     }
                     else if(_targetVacuum)
                     {
                        if(canShootVacuumHose())
                        {
                           _targetVacuum = true;
                        }
                        else
                        {
                           _hasTargets = false;
                           FindTargets(1,_priority);
                           if(!_hasTargets)
                           {
                              this._fireStage = 3;
                           }
                           SOUNDS.Play("lightningend",!isJard ? 0.8 : 0.4);
                        }
                     }
                     else if(Boolean(this._laserTarget) && (this._laserTarget.health <= 0 || this._laserTarget is MonsterBase && !MonsterBase(this._laserTarget).isTargetable))
                     {
                        if(canShootVacuumHose())
                        {
                           _targetVacuum = true;
                        }
                        else
                        {
                           _hasTargets = false;
                           FindTargets(1,_priority);
                           if(!_hasTargets)
                           {
                              this._fireStage = 3;
                           }
                           SOUNDS.Play("lightningend",!isJard ? 0.8 : 0.4);
                        }
                     }
                  }
               }
            }
            else if(this._fireStage == 3)
            {
               if(_frameNumber % 2 == 0)
               {
                  ++_animTick;
                  if(_animTick == 55)
                  {
                     _animTick = 0;
                     this._fireStage = 0;
                  }
               }
            }
            if(GLOBAL._render && _animTick > 0)
            {
               this.AnimFrame();
            }
         }
      }
      
      override public function Props() : void
      {
         super.Props();
      }
      
      override public function Upgraded() : void
      {
         super.Upgraded();
      }
      
      override public function Constructed() : void
      {
         super.Constructed();
      }
   }
}
