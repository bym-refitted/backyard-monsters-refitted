package de.polygonal.ds
{
   import flash.Boot;
   import flash.utils.Dictionary;
   
   public class HashMapKeyIterator implements Itr
   {
       
      
      public var _s:int;
      
      public var _keys:Array;
      
      public var _i:int;
      
      public var _f:Object;
      
      public function HashMapKeyIterator(param1:Object = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _f = param1;
         var _loc3_:* = 0;
         var _loc2_:Array = [];
         var _loc4_:* = _f._map;
         §§push(§§findproperty(_keys));
         for(_loc3_ in _loc4_)
         {
            _loc2_.push(_loc3_);
         }
         §§pop()._keys = _loc2_;
         _i = 0;
         _s = int(_keys.length);
      }
      
      public function reset() : void
      {
         var _loc2_:* = 0;
         var _loc1_:Array = [];
         var _loc3_:* = _f._map;
         §§push(§§findproperty(_keys));
         for(_loc2_ in _loc3_)
         {
            _loc1_.push(_loc2_);
         }
         §§pop()._keys = _loc1_;
         _i = 0;
         _s = int(_keys.length);
      }
      
      public function next() : Object
      {
         var _loc1_:int;
         _i = (_loc1_ = _i) + 1;
         return _keys[_loc1_];
      }
      
      public function hasNext() : Boolean
      {
         return _i < _s;
      }
      
      public function __map(param1:Object) : Dictionary
      {
         return param1._map;
      }
   }
}
