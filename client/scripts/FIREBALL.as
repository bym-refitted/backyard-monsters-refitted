package
{
   import com.monsters.display.SpriteData;
   import com.monsters.events.ProjectileEvent;
   import com.monsters.managers.InstanceManager;
   import com.monsters.monsters.DummyTarget;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.siege.weapons.Vacuum;
   import com.monsters.siege.weapons.VacuumHose;
   import com.monsters.utils.ObjectPool;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   
   public class FIREBALL extends ProjectileBase
   {
      
      public static const TYPE_FIREBALL:String = "fireball";
      
      public static const TYPE_MISSILE:String = "missile";
      
      public static const TYPE_MAGMA:String = "magma";
      
      public static const TYPE_SPURTZ:String = "spurtz";
      
      public static const COLLIDED:String = "fireballCollided";
      
      public static const ROCKET_GRAPHIC_NAME:String = "rocket";
      
      public static const SPRUTZ_GRAPHIC_NAME:String = "IC1";
       
      
      private const DO_ROCKETS_ACCELERATE:Boolean = false;
      
      public var _targetMC:MovieClip;
      
      public var _targetBuilding:BFOUNDATION;
      
      public var _previousTarget:BFOUNDATION;
      
      public var _targetCreep:*;
      
      public var _type:String;
      
      public var _bitmapData:BitmapData;
      
      private var _acceleration:Number;
      
      private var _graphicName:String;
      
      public function FIREBALL()
      {
         super();
      }
      
      public function Setup(param1:String = "fireball") : void
      {
         var _loc2_:SpriteData = null;
         var _loc3_:Bitmap = null;
         if(_graphic)
         {
            if(_graphic.numChildren > 0)
            {
               _graphic.removeChildAt(0);
            }
            _graphic = null;
         }
         this._type = param1;
         this._acceleration = 0.5;
         if(this._type == TYPE_FIREBALL || this._type == TYPE_MAGMA)
         {
            _graphic = new FIREBALL_CLIP();
            if(this._type == TYPE_MAGMA)
            {
               _graphic.filters = [new GlowFilter(16748544,1,12,12,6,1,false,false)];
            }
         }
         else
         {
            switch(this._type)
            {
               case TYPE_MISSILE:
                  this._graphicName = ROCKET_GRAPHIC_NAME;
                  break;
               case TYPE_SPURTZ:
                  this._graphicName = SpurtzCannon.SPURTZ_PROJECTILE;
                  _targetType = 3;
            }
            _graphic = new MovieClip();
            if(this.DO_ROCKETS_ACCELERATE)
            {
               this._acceleration = 0.05;
            }
            _loc2_ = SPRITES.GetSpriteDescriptor(this._graphicName) as SpriteData;
            this._bitmapData = new BitmapData(_loc2_.width,_loc2_.height,true,16777215);
            _loc3_ = new Bitmap(this._bitmapData);
            _loc3_.x = -(_loc2_.width * 0.5);
            _loc3_.y = -(_loc2_.height * 0.5);
            _graphic.addChild(_loc3_);
         }
      }
      
      public function Tick() : Boolean
      {
         ++_frameNumber;
         if(_targetType == 1)
         {
            if(!this._targetCreep)
            {
               FIREBALLS.Remove(_id);
               return true;
            }
            if(Boolean(this._targetCreep._movement) && this._targetCreep._movement == "fly")
            {
               // Reuse _targetPoint instead of allocating new Point
               if(!_targetPoint) _targetPoint = new Point();
               _targetPoint.x = this._targetCreep._tmpPoint.x;
               _targetPoint.y = this._targetCreep._tmpPoint.y - this._targetCreep._altitude;
            }
            else
            {
               _targetPoint = this._targetCreep._tmpPoint;
            }
         }
         else if(_targetType == 2)
         {
            // Reuse _targetPoint instead of allocating new Point
            if(!_targetPoint) _targetPoint = new Point();
            _targetPoint.x = this._targetBuilding._mc.x;
            _targetPoint.y = this._targetBuilding._mc.y + this._targetBuilding._footprint[0].height / 2;
         }
         else if(_targetType != 3)
         {
            if(_targetType == 4)
            {
            }
         }
         // Use pooled Point for distance calculation
         var tempPt:Point = ObjectPool.getPoint(_tmpX, _tmpY);
         _distance = Point.distance(_targetPoint, tempPt);
         ObjectPool.returnPoint(tempPt);
         if(this.Move())
         {
            return true;
         }
         this.Render();
         return false;
      }
      
      public function Move() : Boolean
      {
         var _loc2_:Number = NaN;
         var _loc3_:VacuumHose = null;
         if(this._type == TYPE_MISSILE && this.DO_ROCKETS_ACCELERATE)
         {
            this._acceleration += 0.025;
         }
         var _loc1_:Number = _maxSpeed * this._acceleration;
         if(_frameNumber % 5 == 0)
         {
            _xd = _targetPoint.x - _tmpX;
            _yd = _targetPoint.y - _tmpY;
            _xChange = Math.cos(Math.atan2(_yd,_xd)) * _loc1_;
            _yChange = Math.sin(Math.atan2(_yd,_xd)) * _loc1_;
         }
         _tmpX += _xChange;
         _tmpY += _yChange;
         _distance -= _loc1_;
         if(_distance <= _maxSpeed)
         {
            dispatchEvent(new ProjectileEvent(COLLIDED,this._targetCreep,this._targetBuilding));
            if(_splash > 0)
            {
               this.Splash();
            }
            else if(_targetType == 1)
            {
               if(this._targetCreep.dead)
               {
                  FIREBALLS.Remove(_id);
                  return true;
               }
               if(_damage > 0)
               {
                  _loc2_ = this._targetCreep._damageMult * _damage;
                  this._targetCreep.modifyHealth(-(this._targetCreep._damageMult * _damage));
               }
               else
               {
                  if(this._targetCreep._creatureID.substr(0,1) == "G")
                  {
                     _damage *= 0.1;
                  }
                  _loc2_ = _damage;
                  if(this._targetCreep.health - _loc2_ >= this._targetCreep.maxHealth)
                  {
                     _loc2_ = -(this._targetCreep.maxHealth - this._targetCreep.health);
                  }
                  this._targetCreep.modifyHealth(-_loc2_);
               }
               ATTACK.Damage(_startPoint.x,_startPoint.y,_loc2_);
            }
            else if(_targetType == 2)
            {
               if(this._targetBuilding.health > 0)
               {
                  this._targetBuilding.modifyHealth(_damage,new DummyTarget(_startPoint.x,_startPoint.y));
               }
            }
            else if(_targetType != 3)
            {
               if(_targetType == 4)
               {
                  _loc3_ = Vacuum.getHose();
                  if(Boolean(_loc3_) && this._targetCreep == _loc3_)
                  {
                     _loc3_.modifyHealth(-_damage);
                  }
               }
            }
            if(_glaves > 0)
            {
               --_glaves;
               this.FindGlaiveTarget();
               _damage *= 0.5;
            }
            else
            {
               this._targetBuilding = null;
            }
            if(this._targetBuilding == null)
            {
               FIREBALLS.Remove(_id);
               return true;
            }
         }
         return false;
      }
      
      public function Render() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(GLOBAL._render)
         {
            _graphic.x = int(_tmpX);
            _graphic.y = int(_tmpY);
         }
         if(this._graphicName)
         {
            _loc1_ = Math.atan2(_targetPoint.y - _tmpY,_targetPoint.x - _tmpX);
            _loc2_ = _loc1_ * (180 / Math.PI);
            SPRITES.GetSprite(this._bitmapData,this._graphicName,"",_loc2_,_frameNumber);
         }
      }
      
      public function Splash() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MonsterBase = null;
         var _loc3_:Number = NaN;
         var _loc4_:Point = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         // Use pooled Point for position
         var splashPt:Point = ObjectPool.getPoint(_tmpX, _tmpY);
         if(this._targetCreep._movement == "fly")
         {
            _loc6_ = Targeting.getCreepsInRange(_splash, splashPt, Targeting.getOldStyleTargets(2));
         }
         else
         {
            _loc6_ = Targeting.getCreepsInRange(_splash, splashPt, Targeting.getOldStyleTargets(0));
         }
         ObjectPool.returnPoint(splashPt);
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         while(_loc8_ < _loc6_.length)
         {
            _loc1_ = _loc6_[_loc8_];
            _loc2_ = _loc1_.creep;
            if(!(_loc2_._friendly && _damage < 0))
            {
               if(_loc2_ == this._targetCreep)
               {
                  if(_damage > 0)
                  {
                     _loc2_.modifyHealth(-_damage);
                     _loc7_ += _damage;
                  }
                  else if(_loc2_._creatureID.substr(0,1) == "G")
                  {
                     _loc2_.modifyHealth(-_damage / 10);
                     _loc7_ += _damage / 10;
                  }
                  else
                  {
                     _loc2_.modifyHealth(-_damage);
                     _loc7_ += _damage;
                  }
                  if(_loc2_.health > _loc2_.maxHealth)
                  {
                     _loc7_ -= _loc2_.maxHealth - _loc2_.health;
                     _loc2_.modifyHealth(_loc7_);
                  }
               }
               else
               {
                  _loc3_ = Number(_loc1_.dist);
                  _loc4_ = _loc1_.pos;
                  if((_loc5_ = _damage * 0.75 / _splash * (_splash - _loc3_)) > 0)
                  {
                     _loc2_.modifyHealth(-_loc5_);
                     _loc7_ += _loc5_;
                  }
                  else if(_loc2_._creatureID.substr(0,1) == "G")
                  {
                     _loc2_.modifyHealth(-_loc5_ / 10);
                     _loc7_ += _loc5_ / 10;
                  }
                  else
                  {
                     _loc2_.modifyHealth(-_loc5_);
                     _loc7_ += _loc5_;
                  }
                  if(_loc2_.health > _loc2_.maxHealth)
                  {
                     _loc7_ -= _loc2_.maxHealth - _loc2_.health;
                     _loc2_.modifyHealth(_loc7_);
                  }
               }
            }
            _loc8_++;
         }
         ATTACK.Damage(_startPoint.x,_startPoint.y,_loc7_);
      }
      
      private function FindGlaiveTarget() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Point = null;
         var _loc3_:int = 0;
         var _loc5_:BFOUNDATION = null;
         if(this._targetBuilding == null)
         {
            return;
         }
         var _loc4_:Array = [];
         _loc1_ = new Point(_graphic.x,_graphic.y);
         var _loc6_:int = 100;
         var _loc7_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         for each(_loc5_ in _loc7_)
         {
            if(Boolean(_loc5_.isTargetable) && _loc5_._class != "wall" && _loc5_._class != "mushroom" && _loc5_._class != "decoration" && _loc5_._class != "immovable" && _loc5_.health > 0 && _loc5_._class != "enemy" && _loc5_._class != "trap" && !(_loc5_ is BTOWER && (_loc5_ as BTOWER).isJard))
            {
               _loc2_ = new Point(_loc5_._mc.x,_loc5_._mc.y + _loc5_._footprint[0].height / 2);
               _loc3_ = Point.distance(_loc1_,_loc2_);
               if(_loc5_ != this._targetBuilding && _loc3_ <= _loc6_)
               {
                  _loc4_.push({
                     "building":_loc5_,
                     "distance":_loc3_,
                     "expand":true
                  });
               }
            }
         }
         if(_loc4_.length == 0)
         {
            _loc7_ = InstanceManager.getInstancesByClass(BWALL);
            for each(_loc5_ in _loc7_)
            {
               _loc2_ = new Point(_loc5_._mc.x,_loc5_._mc.y + _loc5_._footprint[0].height / 2);
               _loc3_ = Point.distance(_loc1_,_loc2_);
               if(_loc5_ != this._targetBuilding && _loc3_ <= _loc6_ && _loc5_.health > 0)
               {
                  _loc4_.push({
                     "building":_loc5_,
                     "distance":_loc3_,
                     "expand":true
                  });
               }
            }
         }
         _loc4_.sortOn("distance",Array.NUMERIC);
         if(_loc4_.length == 0)
         {
            this._targetBuilding = null;
            return;
         }
         if(_loc4_[0].building == this._previousTarget)
         {
            _loc4_.shift();
         }
         if(_loc4_.length > 0)
         {
            this._previousTarget = this._targetBuilding;
            this._targetBuilding = _loc4_[0].building;
            _targetPoint = new Point(this._targetBuilding._mc.x,this._targetBuilding._mc.y + (!!_loc4_[0].expand ? this._targetBuilding._footprint[0].height / 2 : 0));
            _loc3_ = Point.distance(_loc1_,_targetPoint) - (!!_loc4_[0].expand ? Math.abs(this._targetBuilding._footprint[0].height - this._previousTarget._footprint[0].height) / 2 : 0);
            if(_loc3_ > _loc6_)
            {
               this._targetBuilding = null;
            }
         }
         else
         {
            this._targetBuilding = null;
         }
      }
   }
}
