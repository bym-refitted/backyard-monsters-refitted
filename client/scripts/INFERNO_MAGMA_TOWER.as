package
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.statusEffects.FlameEffect;
   import com.monsters.utils.ObjectPool;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class INFERNO_MAGMA_TOWER extends BTOWER
   {
      
      public static const ID:int = 132;
       
      
      public var _animMC:MovieClip;
      
      public var _animBitmap:BitmapData;
      
      public var _lostCreep:Boolean = false;
      
      public var _fireStage:int = 1;
      
      public var _targetArray:Array;
      
      protected var _projectile:FIREBALL;
      
      protected var _projectileType:String;
      
      public function INFERNO_MAGMA_TOWER()
      {
         this._targetArray = [4,4,6,8,10,12];
         super();
         _frameNumber = 0;
         _type = 132;
         _top = -30;
         _footprint = [new Rectangle(0,0,70,70)];
         _gridCost = [[new Rectangle(0,0,70,70),10],[new Rectangle(10,10,50,50),200]];
         this._projectileType = FIREBALLS.TYPE_MAGMA;
         this._fireStage = 1;
         SetProps();
      }
      
      override public function TickAttack() : void
      {
         super.TickAttack();
         Rotate();
      }
      
      override public function AnimFrame(param1:Boolean = true) : void
      {
         if(_animLoaded && GLOBAL._render)
         {
            _animRect.x = _animRect.width * _animTick;
            _animContainerBMD.copyPixels(_animBMD,_animRect,_nullPoint);
         }
         super.AnimFrame(false);
      }
      
      override public function Fire(param1:IAttackable) : void
      {
         super.Fire(param1);
         if(Math.random() * 2 <= 1)
         {
            SOUNDS.Play("magma1");
         }
         else
         {
            SOUNDS.Play("magma2");
         }
         var _loc2_:Number = 0.5 + 0.5 / maxHealth * health;
         var _loc3_:Number = 1;
         if(Boolean(GLOBAL._towerOverdrive) && GLOBAL._towerOverdrive.Get() >= GLOBAL.Timestamp())
         {
            _loc3_ = 1.25;
         }
         this._projectile = FIREBALLS.Spawn2(ObjectPool.getPoint(_mc.x, _mc.y + _top), ObjectPool.getPoint(param1.x, param1.y), param1, _speed, int(damage * _loc2_ * _loc3_), _splash, this._projectileType, 1, this);
      }
      
      protected function onProjectileCollision(param1:Event) : void
      {
         var _loc2_:FIREBALL = param1.target as FIREBALL;
         _loc2_.removeEventListener(FIREBALL.COLLIDED,this.onProjectileCollision);
         var rangePt:Point = ObjectPool.getPoint(_loc2_._targetCreep.x, _loc2_._targetCreep.y);
         var _loc3_:Array = Targeting.getCreepsInRange(_splash, rangePt, Targeting.getOldStyleTargets(0));
         ObjectPool.returnPoint(rangePt);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            MonsterBase(_loc3_[_loc4_].creep).addStatusEffect(new FlameEffect(MonsterBase(_loc3_[_loc4_].creep),damage * 0.5));
            _loc4_++;
         }
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
            if(_loc1_.damage < _loc2_.damage)
            {
               _upgradeDescription += KEYS.Get("building_dpsincrease",{
                  "v1":_loc1_.damage,
                  "v2":_loc2_.damage
               }) + "<br>";
            }
            if(_lvl.Get() > 1)
            {
               _upgradeDescription += KEYS.Get("building_sfpsincrease",{
                  "v1":this._targetArray[_lvl.Get() - 1],
                  "v2":this._targetArray[_lvl.Get()]
               }) + "<br>";
            }
         }
      }
      
      override public function Setup(param1:Object) : void
      {
         param1.t = _type;
         super.Setup(param1);
         Props();
      }
   }
}
