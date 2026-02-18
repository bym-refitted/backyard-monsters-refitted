package
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.utils.ObjectPool;
   import flash.geom.Point;
   
   public class PROJECTILE extends ProjectileBase
   {
       
      
      public var _target:IAttackable;
      
      public var _splashTargetFlags:int;
      
      public var _rocket:Boolean;
      
      public function PROJECTILE()
      {
         super();
      }
      
      public function Tick() : Boolean
      {
         ++_frameNumber;
         if(!this._target || this._target.health <= 0)
         {
            PROJECTILES.Remove(_id);
            return false;
         }
         // Reuse _targetPoint instead of allocating new Point
         if(!_targetPoint) _targetPoint = new Point();
         _targetPoint.x = this._target.x;
         _targetPoint.y = this._target.y - (this._target is MonsterBase && MonsterBase(this._target)._movement == "fly" ? MonsterBase(this._target)._altitude : 0);
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
         var _loc1_:Number = _maxSpeed * 0.5;
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
            if(_splash > 0)
            {
               this.Splash();
            }
            else
            {
               this._target.modifyHealth(-_damage,this);
            }
            PROJECTILES.Remove(_id);
            return true;
         }
         return false;
      }
      
      public function Render() : void
      {
         if(GLOBAL._render && Boolean(_graphic))
         {
            _graphic.x = int(_tmpX);
            _graphic.y = int(_tmpY);
         }
      }
      
      public function Splash() : void
      {
         var _loc1_:Point = ObjectPool.getPoint(_tmpX, _tmpY);
         var _loc2_:Array = Targeting.getTargetsInRange(_splash, _loc1_, this._splashTargetFlags);
         Targeting.DealLinearAEDamage(_loc1_, _splash, _damage, _loc2_);
         ObjectPool.returnPoint(_loc1_);
         this._target.modifyHealth(0,this);
      }
   }
}
