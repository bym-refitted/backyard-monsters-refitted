package
{
   import com.monsters.debug.Console;
   import com.monsters.interfaces.IAttackable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.siege.weapons.VacuumHose;
   import flash.geom.Point;
   
   public class FIREBALLS
   {
      
      public static const TYPE_FIREBALL:String = "fireball";
      
      public static const TYPE_MISSILE:String = "missile";
      
      public static const TYPE_MAGMA:String = "magma";
      
      public static var _fireballs:Object;
      
      public static var _id:int;
      
      public static var _fireballCount:int;
      
      public static var _type:String = FIREBALL.TYPE_FIREBALL;
      
      public static var _pool:Array = [];
       
      
      public function FIREBALLS()
      {
         super();
         Clear();
      }
      
      public static function Spawn(param1:Point, param2:Point, param3:BFOUNDATION, param4:Number, param5:int, param6:int = 0, param7:int = 0, param8:String = "fireball", param9:IAttackable = null) : FIREBALL
      {
         var _loc10_:FIREBALL = null;
         if(!param8)
         {
            param8 = FIREBALL.TYPE_FIREBALL;
         }
         _type = param8;
         _loc10_ = PoolGet();
         if(param8 == TYPE_FIREBALL || param8 == TYPE_MAGMA)
         {
            if(param5 > 0)
            {
               _loc10_._graphic.gotoAndStop(1);
            }
            else
            {
               _loc10_._graphic.gotoAndStop(2);
            }
         }
         if(!GLOBAL._catchup)
         {
            MAP._FIREBALLS.addChild(_loc10_._graphic);
         }
         _loc10_._id = _id;
         if(!param9)
         {
            Console.warning("you created a fireball with no source",true);
         }
         _loc10_._source = param9;
         _loc10_._startPoint = param1;
         _loc10_._targetType = 2;
         _loc10_._targetBuilding = param3;
         _loc10_._maxSpeed = param4;
         _loc10_._damage = param5;
         _loc10_._splash = param6;
         _loc10_._tmpX = param1.x;
         _loc10_._tmpY = param1.y;
         _loc10_._glaves = param7;
         _loc10_._speed = param4;
         _loc10_._startDistance = 0;
         if(!_fireballs)
         {
            _fireballs = {};
         }
         _fireballs[_id] = _loc10_;
         ++_id;
         ++_fireballCount;
         return _loc10_;
      }
      
      public static function Spawn2(param1:Point, param2:Point, param3:IAttackable, param4:Number, param5:int, param6:int = 0, param7:String = "fireball", param8:int = 1, param9:IAttackable = null) : FIREBALL
      {
         var _loc10_:FIREBALL = null;
         if(!param7)
         {
            param7 = FIREBALL.TYPE_FIREBALL;
         }
         _type = param7;
         _loc10_ = PoolGet();
         if(!GLOBAL._catchup)
         {
            MAP._FIREBALLS.addChild(_loc10_._graphic);
         }
         if(param5 > 0)
         {
            _loc10_._graphic.gotoAndStop(1);
         }
         else
         {
            _loc10_._graphic.gotoAndStop(2);
         }
         _loc10_._type = param7;
         _loc10_._id = _id;
         if(!param9)
         {
            Console.warning("you created a fireball with no source",true);
         }
         _loc10_._source = param9;
         _loc10_._startPoint = param1;
         _loc10_._targetType = param3 is VacuumHose ? 4 : param8;
         _loc10_._targetPoint = param2;
         _loc10_._targetCreep = param3;
         _loc10_._maxSpeed = param4;
         _loc10_._damage = param5;
         _loc10_._glaves = 0;
         if(param3 && param3 is MonsterBase && MonsterBase(param3)._movement != "fly")
         {
            _loc10_._splash = param6;
         }
         else
         {
            _loc10_._splash = 0;
         }
         _loc10_._tmpX = param1.x;
         _loc10_._tmpY = param1.y;
         _loc10_._speed = param4;
         _loc10_._startDistance = 0;
         if(!_fireballs)
         {
            _fireballs = {};
         }
         _fireballs[_id] = _loc10_;
         ++_id;
         ++_fireballCount;
         return _loc10_;
      }
      
      public static function Remove(param1:int) : void
      {
         var _loc2_:FIREBALL = _fireballs[param1];
         try
         {
            _loc2_._graphic.filters = [];
            MAP._FIREBALLS.removeChild(_loc2_._graphic);
         }
         catch(e:Error)
         {
         }
         PoolSet(_loc2_);
         delete _fireballs[param1];
         --_fireballCount;
      }
      
      public static function Tick() : void
      {
         var _loc1_:String = null;
         var _loc2_:FIREBALL = null;
         for each(_loc2_ in _fireballs)
         {
            _loc2_.Tick();
         }
      }
      
      public static function Clear() : void
      {
         var _loc1_:String = null;
         var _loc2_:FIREBALL = null;
         for(_loc1_ in _fireballs)
         {
            _loc2_ = _fireballs[_loc1_];
            try
            {
               MAP._FIREBALLS.removeChild(_loc2_._graphic);
            }
            catch(e:Error)
            {
            }
         }
         _fireballs = {};
         _id = 0;
         _fireballCount = 0;
      }
      
      public static function PoolSet(param1:FIREBALL) : void
      {
         _pool.push(param1);
      }
      
      public static function PoolGet() : FIREBALL
      {
         var _loc1_:FIREBALL = null;
         if(_pool.length)
         {
            _loc1_ = _pool.pop();
         }
         else
         {
            _loc1_ = new FIREBALL();
         }
         _loc1_.Setup(_type);
         return _loc1_;
      }
   }
}
