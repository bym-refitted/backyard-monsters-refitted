package
{
   import com.monsters.interfaces.IAttackable;
   import flash.geom.Point;
   
   public class PROJECTILES
   {
      
      public static var _projectiles:Object;
      
      public static var _id:int;
      
      public static var _projectileCount:int;
      
      public static var _pool:Array = [];
       
      
      public function PROJECTILES()
      {
         super();
         Clear();
      }
      
      public static function Spawn(param1:Point, param2:Point, param3:IAttackable, param4:Number, param5:int, param6:Boolean = false, param7:int = 0, param8:int = 0) : void
      {
         var _loc9_:PROJECTILE = PoolGet();
         if(!GLOBAL._catchup)
         {
            _loc9_._graphic = new PROJECTILE_CLIP();
            MAP._PROJECTILES.addChild(_loc9_._graphic);
         }
         _loc9_._id = _id;
         _loc9_._startPoint = param1;
         if(param3)
         {
         }
         _loc9_._targetPoint = param2;
         _loc9_._target = param3;
         _loc9_._maxSpeed = param4;
         _loc9_._damage = param5;
         _loc9_._rocket = param6;
         _loc9_._splash = param7;
         _loc9_._splashTargetFlags = param8;
         _loc9_._tmpX = param1.x;
         _loc9_._tmpY = param1.y;
         if(param6)
         {
            _loc9_._speed = param4 / 2;
            _loc9_._rotationEasing = 25;
            _loc9_._graphic.rotation = Math.random() * 360;
         }
         else
         {
            _loc9_._speed = param4;
         }
         _loc9_._startDistance = 0;
         if(!_projectiles)
         {
            _projectiles = {};
         }
         _projectiles[_id] = _loc9_;
         ++_id;
         ++_projectileCount;
      }
      
      public static function Remove(param1:int) : void
      {
         var _loc2_:PROJECTILE = _projectiles[param1];
         try
         {
            MAP._PROJECTILES.removeChild(_loc2_._graphic);
         }
         catch(e:Error)
         {
         }
         PoolSet(_loc2_);
         delete _projectiles[param1];
         --_projectileCount;
      }
      
      public static function Tick() : void
      {
         var _loc1_:String = null;
         var _loc2_:PROJECTILE = null;
         for each(_loc2_ in _projectiles)
         {
            _loc2_.Tick();
         }
      }
      
      public static function Clear() : void
      {
         var _loc1_:String = null;
         var _loc2_:PROJECTILE = null;
         for(_loc1_ in _projectiles)
         {
            _loc2_ = _projectiles[_loc1_];
            try
            {
               MAP._PROJECTILES.removeChild(_loc2_._graphic);
            }
            catch(e:Error)
            {
            }
         }
         _projectiles = {};
         _id = 0;
         _projectileCount = 0;
      }
      
      public static function PoolSet(param1:PROJECTILE) : void
      {
         _pool.push(param1);
      }
      
      public static function PoolGet() : PROJECTILE
      {
         var _loc1_:PROJECTILE = null;
         if(_pool.length)
         {
            _loc1_ = _pool.pop();
         }
         else
         {
            _loc1_ = new PROJECTILE();
         }
         return _loc1_;
      }
   }
}
