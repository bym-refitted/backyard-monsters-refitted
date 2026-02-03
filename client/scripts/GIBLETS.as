package
{
   import com.monsters.utils.ObjectPool;
   import flash.geom.Point;
   import gs.*;
   import gs.easing.*;
   
   public class GIBLETS
   {
      
      public static var _giblets:Object = {};
      
      public static var _gibletCount:int = 0;
      
      public static var _tmpGibCount:int = 0;
      
      public static var _frame:int = 0;
      
      private static var _pool:Vector.<GIBLET> = new Vector.<GIBLET>();
       
      
      public function GIBLETS()
      {
         super();
      }
      
      public static function Clear() : void
      {
         var giblet:GIBLET = null;
         var g:String = null;
         try
         {
            for(g in _giblets)
            {
               giblet = _giblets[g];
               if(giblet.parent)
               {
                  giblet.parent.removeChild(giblet);
               }
               giblet.Clear();
               PoolSet(giblet);
               delete _giblets[g];
            }
            _giblets = {};
            _gibletCount = 0;
            _frame = 0;
         }
         catch(e:Error)
         {
            LOGGER.Log("err","Giblets Clear" + " " + e.getStackTrace());
         }
      }
      
      public static function PoolGet(param1:int, param2:Point, param3:Point, param4:int, param5:Number, param6:Number) : GIBLET
      {
         var _loc7_:GIBLET = null;
         if(_pool.length)
         {
            _loc7_ = _pool.pop();
         }
         else
         {
            _loc7_ = new GIBLET();
         }
         _loc7_.init(param1,param2,param3,param4,param5,param6);
         return _loc7_;
      }
      
      public static function PoolSet(param1:GIBLET) : void
      {
         _pool.push(param1);
      }
      
      public static function Create(param1:Point, param2:Number, param3:int, param4:int, param5:int = 0) : void
      {
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         if(!GLOBAL._catchup)
         {
            if(_tmpGibCount < 20)
            {
               _loc6_ = 0;
               while(_loc6_ < param4)
               {
                  ++_tmpGibCount;
                  _loc7_ = param3 * 0.2 + Math.random() * (param3 * 0.8);
                  if(Math.random() <= 0.3)
                  {
                     _loc7_ *= 1.5;
                  }
                  var offsetPt:Point = ObjectPool.getPoint(-3 + Math.random() * 6, -2 + Math.random() * 4);
                  var spawnPt:Point = param1.add(offsetPt);
                  ObjectPool.returnPoint(offsetPt);
                  Spawn(spawnPt, param2, _loc7_, _loc6_ / 100, param5);
                  _loc6_++;
               }
            }
         }
      }
      
      public static function Spawn(param1:Point, param2:Number, param3:int, param4:Number, param5:int) : void
      {
         var _loc6_:Number = Math.random() * 360;
         var _loc7_:Point;
         var _loc8_:Number = (_loc7_ = GRID.FromISO(param1.x,param1.y)).x + Math.cos(_loc6_) * param3;
         var _loc9_:Number = _loc7_.y + Math.sin(_loc6_) * param3;
         var offsetPt:Point = ObjectPool.getPoint(0, param5);
         var _loc10_:Point = GRID.ToISO(_loc8_,_loc9_,0).add(offsetPt);
         ObjectPool.returnPoint(offsetPt);
         _giblets[_gibletCount] = MAP._RESOURCES.addChild(PoolGet(_gibletCount,param1,_loc10_,param3,param4,param2));
         ++_gibletCount;
      }
      
      public static function Remove(param1:*) : void
      {
         var _loc2_:GIBLET = _giblets[param1];
         --_tmpGibCount;
         try
         {
            EFFECTS.SplatParticle(20,_loc2_.x,_loc2_.y,0,0);
            MAP._RESOURCES.removeChild(_loc2_);
            _loc2_.Clear();
            PoolSet(_loc2_);
            delete _giblets[param1];
         }
         catch(e:Error)
         {
         }
      }
   }
}
