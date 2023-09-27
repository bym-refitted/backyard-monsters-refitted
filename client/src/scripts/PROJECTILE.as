package
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.monsters.MonsterBase;
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
         _targetPoint = new Point(this._target.x,this._target.y - (this._target is MonsterBase && MonsterBase(this._target)._movement == "fly" ? MonsterBase(this._target)._altitude : 0));
         _distance = Point.distance(_targetPoint,new Point(_tmpX,_tmpY));
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
         var _loc1_:Point = new Point(_tmpX,_tmpY);
         var _loc2_:Array = Targeting.getTargetsInRange(_splash,_loc1_,this._splashTargetFlags);
         Targeting.DealLinearAEDamage(_loc1_,_splash,_damage,_loc2_);
         this._target.modifyHealth(0,this);
      }
   }
}
