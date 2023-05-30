package com.monsters.effects.particles
{
   import flash.geom.Point;
   
   public class ParticleText
   {
      
      public static const TYPE_DAMAGE:uint = 10;
      
      public static const TYPE_THORN:uint = 11;
      
      public static const TYPE_HEAL:uint = 11;
      
      private static var _pool:Array = [];
      
      private static var _currentCount:int = 0;
      
      private static var _currentMax:int = 20;
       
      
      public function ParticleText()
      {
         super();
      }
      
      public static function Create(param1:Point, param2:int, param3:uint) : ParticleDamageItem
      {
         var _loc4_:ParticleDamageItem = null;
         if(!GLOBAL._catchup && _currentCount < _currentMax)
         {
            if(_loc4_ = PoolGet(param3))
            {
               _loc4_.Init(param1,param2,param3);
            }
         }
         return _loc4_;
      }
      
      private static function PoolGet(param1:uint) : ParticleDamageItem
      {
         var _loc2_:ParticleDamageItem = null;
         ++_currentCount;
         if(_pool.length)
         {
            _loc2_ = _pool.pop();
         }
         else
         {
            _loc2_ = new ParticleDamageItem();
         }
         return _loc2_;
      }
      
      public static function Remove(param1:ParticleDamageItem) : void
      {
         --_currentCount;
         if(_currentCount < 0)
         {
            _currentCount = 0;
         }
         PoolSet(param1);
      }
      
      private static function PoolSet(param1:ParticleDamageItem) : void
      {
         _pool.push(param1);
      }
      
      public static function Clear() : void
      {
         _pool = [];
         _currentCount = 0;
      }
   }
}
