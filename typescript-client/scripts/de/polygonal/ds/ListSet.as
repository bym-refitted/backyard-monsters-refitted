package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import de.polygonal.core.util.Instance;
   import flash.Boot;
   
   public class ListSet implements Set
   {
       
      
      public var key:int;
      
      public var _a:DA;
      
      public function ListSet()
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _a = new DA();
         var _loc1_:int;
         HashKey._counter = (_loc1_ = int(HashKey._counter)) + 1;
         key = _loc1_;
      }
      
      public function toString() : String
      {
         return Sprintf.format("{ListSet, size: %d}",[size()]);
      }
      
      public function toDA() : DA
      {
         return _a.toDA();
      }
      
      public function toArray() : Array
      {
         return _a.toArray();
      }
      
      public function size() : int
      {
         return _a._size;
      }
      
      public function set(param1:Object) : Boolean
      {
         var _loc3_:* = null as DA;
         var _loc5_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:Object = param1;
         _loc3_ = _a;
         var _loc4_:Boolean = false;
         _loc5_ = 0;
         var _loc6_:int = _loc3_._size;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            if(_loc3_._a[_loc7_] == _loc2_)
            {
               _loc4_ = true;
               break;
            }
         }
         if(_loc4_)
         {
            return false;
         }
         _loc3_ = _a;
         _loc5_ = _loc3_._size;
         null;
         _loc3_._a[_loc5_] = _loc2_;
         if(_loc5_ >= _loc3_._size)
         {
            ++_loc3_._size;
         }
         return true;
      }
      
      public function remove(param1:Object) : Boolean
      {
         var _loc2_:Object = param1;
         return _a.remove(_loc2_);
      }
      
      public function merge(param1:Set, param2:Boolean, param3:Object = undefined) : void
      {
         var _loc4_:* = null;
         var _loc5_:* = null as Object;
         if(param2)
         {
            _loc4_ = param1.iterator();
            while(_loc4_.hasNext())
            {
               _loc5_ = _loc4_.next();
               set(_loc5_);
            }
         }
         else if(param3 != null)
         {
            _loc4_ = param1.iterator();
            while(_loc4_.hasNext())
            {
               _loc5_ = _loc4_.next();
               set(param3(_loc5_));
            }
         }
         else
         {
            _loc4_ = param1.iterator();
            while(_loc4_.hasNext())
            {
               _loc5_ = _loc4_.next();
               null;
               set(_loc5_.clone());
            }
         }
      }
      
      public function iterator() : Itr
      {
         return _a.iterator();
      }
      
      public function isEmpty() : Boolean
      {
         return _a._size == 0;
      }
      
      public function has(param1:Object) : Boolean
      {
         var _loc7_:int = 0;
         var _loc2_:Object = param1;
         var _loc3_:DA = _a;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:int = _loc3_._size;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            if(_loc3_._a[_loc7_] == _loc2_)
            {
               _loc4_ = true;
               break;
            }
         }
         return _loc4_;
      }
      
      public function free() : void
      {
         _a.free();
         _a = null;
      }
      
      public function contains(param1:Object) : Boolean
      {
         var _loc7_:int = 0;
         var _loc2_:Object = param1;
         var _loc3_:DA = _a;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:int = _loc3_._size;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            if(_loc3_._a[_loc7_] == _loc2_)
            {
               _loc4_ = true;
               break;
            }
         }
         return _loc4_;
      }
      
      public function clone(param1:Boolean, param2:Object = undefined) : Collection
      {
         var _loc3_:* = param2;
         var _loc5_:int;
         HashKey._counter = (_loc5_ = int(HashKey._counter)) + 1;
         var _loc4_:ListSet;
         (_loc4_ = Instance.createEmpty(ListSet)).key = _loc5_;
         _loc4_._a = _a.clone(param1,_loc3_);
         return _loc4_;
      }
      
      public function clear(param1:Boolean = false) : void
      {
         var _loc3_:* = null as Object;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:DA = _a;
         if(param1)
         {
            _loc3_ = null;
            _loc4_ = 0;
            _loc5_ = int(_loc2_._a.length);
            while(_loc4_ < _loc5_)
            {
               _loc6_ = _loc4_++;
               _loc2_._a[_loc6_] = _loc3_;
            }
         }
         _loc2_._size = 0;
      }
   }
}
