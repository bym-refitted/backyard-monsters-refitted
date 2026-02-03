package
{
   import com.cc.utils.SecNum;
   import com.monsters.display.BuildingAssetContainer;
   import com.monsters.interfaces.IAttackable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.creeps.inferno.Spurtz;
   import com.monsters.utils.MathUtils;
   import com.monsters.utils.ObjectPool;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class SpurtzCannon extends BTOWER
   {
      
      public static const TYPE:uint = 136;
      
      public static var SPURTZ_PROJECTILE:String = "spurtz_projectile";
       
      
      protected var _shotsFired:uint;
      
      protected var _shotsPerFire:uint;
      
      protected var _projectile:FIREBALL;
      
      protected var _projectileType:String;
      
      protected var _barrelRotation:Number = 0;
      
      protected var _angleToTarget:Number;
      
      protected var _chanceToSpawnSpurtz:Number = 0.5;
      
      private const _barrelRotationSpeed:Number = 1;
      
      private const _ANGLE_THRESHOLD_TO_SWITCH_TARGETS:Number = 2;
      
      private const _ANGLE_THRESHOLD_TO_START_SHOOTING:Number = 20;
      
      private var _spurts:Vector.<Spurtz>;
      
      private var _targetCreepIndex:int;
      
      public function SpurtzCannon(param1:int = 0)
      {
         super();
         _animRandomStart = false;
         _top = -32;
         _footprint = [new Rectangle(0,0,70,70)];
         _gridCost = [[new Rectangle(0,0,70,70),10],[new Rectangle(10,10,50,50),200]];
         _maxTargets = 10;
         if(!param1)
         {
            param1 = int(TYPE);
         }
         _type = param1;
         SetProps();
         this._projectileType = FIREBALL.TYPE_SPURTZ;
         SPRITES.SetupSprite(SPURTZ_PROJECTILE);
         this._spurts = new Vector.<Spurtz>();
         _buildInstant = true;
         _buildInstantCost = new SecNum(0);
      }
      
      override public function InstantBuildCost() : int
      {
         return 0;
      }
      
      public function get isFiring() : Boolean
      {
         return this._shotsFired > 0;
      }
      
      override protected function setupImage(param1:uint, param2:String, param3:BuildingAssetContainer, param4:Object, param5:BitmapData, param6:Number) : void
      {
         super.setupImage(param1,param2,param3,param4,param5,param6);
         this.renderRotation();
      }
      
      override public function Fire(param1:IAttackable) : void
      {
         super.Fire(param1);
         FindTargets(_maxTargets,_priority);
         this._shotsFired = 0;
         this._targetCreepIndex = 0;
         if(_target)
         {
            this.setAngleToTarget();
         }
      }
      
      override public function TickFast(param1:Event = null) : void
      {
         super.TickFast(param1);
         this.killSpurts();
      }
      
      private function killSpurts() : void
      {
         var _loc2_:Spurtz = null;
         var _loc1_:int = int(this._spurts.length - 1);
         while(_loc1_ >= 0)
         {
            _loc2_ = this._spurts[_loc1_];
            if(_loc2_._frameNumber > 100 && (Math.random() > 0.9 || !_loc2_._hasTarget))
            {
               _loc2_.setHealth(0);
            }
            if(_loc2_.health <= 0)
            {
               this._spurts.splice(_loc1_,1);
            }
            _loc1_--;
         }
      }
      
      override public function TickAttack() : void
      {
         super.TickAttack();
         this._shotsPerFire = _buildingProps.stats[_lvl.Get() - 1].shots;
         this.updateTarget();
         if(_target)
         {
            this.rotateBarrelTowardsTarget();
            if(this.shouldFire())
            {
               this.shoot();
            }
         }
      }
      
      private function updateTarget() : void
      {
         if(!this.hasValidTarget())
         {
            _target = null;
            return;
         }
         if(Math.abs(this._angleToTarget - this._barrelRotation) <= this._ANGLE_THRESHOLD_TO_SWITCH_TARGETS)
         {
            if(_targetCreeps.length > 1)
            {
               _target = this.getNextTarget();
               this.setAngleToTarget();
            }
         }
      }
      
      private function getNextTarget() : *
      {
         ++this._targetCreepIndex;
         if(this._targetCreepIndex >= _targetCreeps.length)
         {
            this._targetCreepIndex = 0;
         }
         return _targetCreeps[this._targetCreepIndex].creep;
      }
      
      private function setAngleToTarget() : void
      {
         var _loc1_:Number = Math.atan2(y + Math.abs(_top) - _target.y,x - _target.x);
         this._angleToTarget = _loc1_ * (180 / Math.PI);
      }
      
      private function shouldFire() : Boolean
      {
         return _fireTick % 5 == 0 && this._shotsFired < this._shotsPerFire && (Math.abs(this._angleToTarget - this._barrelRotation) <= this._ANGLE_THRESHOLD_TO_START_SHOOTING || this.isFiring);
      }
      
      private function hasValidTarget() : Boolean
      {
         return Boolean(_targetCreeps) && _targetCreeps.length > 0 && MonsterBase(_targetCreeps[0].creep).health > 0;
      }
      
      private function rotateBarrelTowardsTarget() : void
      {
         var _loc1_:int = this._angleToTarget - this._barrelRotation > 0 ? 1 : -1;
         this._barrelRotation += _loc1_ * this._barrelRotationSpeed;
         if(this._barrelRotation > 180)
         {
            this._barrelRotation = -(180 - this._barrelRotation);
         }
         else if(this._barrelRotation < -180)
         {
            this._barrelRotation = 180 - (180 - this._barrelRotation);
         }
         this.renderRotation();
      }
      
      private function renderRotation() : void
      {
         _animTick = int((this._barrelRotation + 180) / 11.25);
         AnimFrame();
         ++_frameNumber;
      }
      
      private function shoot() : void
      {
         SOUNDS.Play(Math.random() > 0.5 ? "magma2" : "magma1");
         if(isJard)
         {
            this.shootJar();
            return;
         }
         var _loc1_:Number = 0.5 + 0.5 / maxHealth * health;
         var _loc2_:Number = 1;
         var targetPt:Point = ObjectPool.getPoint(_target.x, _target.y);
         var _loc3_:Number = MathUtils.getDistanceBetweenTwoPoints(_position, targetPt);
         ObjectPool.returnPoint(targetPt);
         var _loc4_:Number = (this._barrelRotation + 180) * (Math.PI / 180);
         var _loc5_:Point = ObjectPool.getPoint(x + Math.cos(_loc4_) * _loc3_, y + Math.sin(_loc4_) * _loc3_);
         var spreadPt:Point = ObjectPool.getPoint(this.getSpreadFromDistance(_loc3_ * 0.2), this.getSpreadFromDistance(_loc3_ * 0.2));
         _loc5_ = _loc5_.add(spreadPt);
         ObjectPool.returnPoint(spreadPt);
         if(Boolean(GLOBAL._towerOverdrive) && GLOBAL._towerOverdrive.Get() >= GLOBAL.Timestamp())
         {
            _loc2_ = 1.25;
         }
         var spawnPt:Point = ObjectPool.getPoint(_mc.x, _mc.y + _top);
         this._projectile = FIREBALLS.Spawn2(spawnPt, _loc5_, null, _speed, int(damage * _loc1_ * _loc2_), _splash, this._projectileType, 3, this);
         this._projectile.addEventListener(FIREBALL.COLLIDED,this.collidedWithTarget,false,0,true);
         ++this._shotsFired;
         this.scaleDisplayObjectRandomly(this._projectile._graphic);
      }
      
      private function shootJar() : void
      {
         var _loc1_:Number = 0.5 + 0.5 / maxHealth * health;
         var _loc2_:Number = 1;
         if(Boolean(GLOBAL._towerOverdrive) && GLOBAL._towerOverdrive.Get() >= GLOBAL.Timestamp())
         {
            _loc2_ = 1.25;
         }
         var _loc3_:int = damage * 0.25 * _loc1_ * _loc2_;
         _jarHealth.Add(-int(_loc3_));
         ATTACK.Damage(_mc.x,_mc.y + _top,_loc3_);
      }
      
      private function scaleDisplayObjectRandomly(param1:DisplayObject) : void
      {
         var _loc2_:Number = Math.random() * 0.6 + 0.4;
         param1.scaleX = _loc2_;
         param1.scaleY = _loc2_;
      }
      
      private function makeItSperm(param1:Sprite) : void
      {
         var _loc2_:Array = new Array();
         _loc2_ = _loc2_.concat([1,1,1,1,1]);
         _loc2_ = _loc2_.concat([1,1,1,1,1]);
         _loc2_ = _loc2_.concat([1,1,1,1,1]);
         _loc2_ = _loc2_.concat([0,0,0,1,0]);
         param1.filters = [new ColorMatrixFilter(_loc2_)];
      }
      
      private function getSpreadFromDistance(param1:Number) : Number
      {
         return Math.random() * (param1 * 2) - param1;
      }
      
      protected function collidedWithTarget(param1:Event) : void
      {
         var _loc2_:FIREBALL = param1.target as FIREBALL;
         _loc2_.removeEventListener(FIREBALL.COLLIDED,this.collidedWithTarget);
         var _loc3_:Number = Math.atan2(_loc2_._startPoint.x - _loc2_._targetPoint.x,_loc2_._startPoint.y - _loc2_._targetPoint.y);
         var _loc4_:Number = _loc3_ * (180 / Math.PI);
         this.dealAoEDamage(_loc2_);
         if(Math.random() > this._chanceToSpawnSpurtz)
         {
            this.spawnSpurtzAt(_loc2_._tmpX,_loc2_._tmpY,_loc4_,_loc2_._graphic.scaleX);
         }
      }
      
      private function dealAoEDamage(param1:FIREBALL) : void
      {
         var _loc2_:uint = this._projectile._graphic.width + this._projectile._graphic.height;
         var _loc3_:Point = new Point(param1._tmpX,this._projectile._tmpY);
         var _loc4_:Array;
         if((_loc4_ = Targeting.getCreepsInRange(_loc2_,_loc3_,Targeting.getOldStyleTargets(0))).length > 0)
         {
            Targeting.DealLinearAEDamage(_loc3_,_loc2_,this._projectile._damage,_loc4_);
         }
      }
      
      private function spawnSpurtzAt(param1:int, param2:int, param3:Number, param4:Number) : void
      {
         var _loc5_:Spurtz;
         (_loc5_ = CREATURES.Spawn("IC1",MAP._BUILDINGTOPS,"defend",new Point(param1,param2),param3) as Spurtz).isDisposable = true;
         _loc5_.findDefenseTargets();
         _loc5_.graphic.scaleX = param4;
         _loc5_.graphic.scaleY = param4;
         this._spurts.push(_loc5_);
      }
      
      private function makeSuperSpurtz(param1:Spurtz) : void
      {
         param1.graphic.scaleX = 2;
         param1.graphic.scaleY = 2;
         param1.graphic.filters = [new GlowFilter(16759349,1,10,10,6,3)];
      }
   }
}
