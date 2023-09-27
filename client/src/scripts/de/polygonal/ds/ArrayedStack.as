package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import de.polygonal.core.util.Instance;
   import flash.Boot;
   
   public class ArrayedStack implements Stack
   {
       
      
      public var maxSize:int;
      
      public var key:int;
      
      public var _top:int;
      
      public var _a:Array;
      
      public function ArrayedStack(param1:int = 0, param2:int = -1)
      {
         var _loc3_:* = null as Array;
         if(Boot.skip_constructor)
         {
            return;
         }
         if(param1 > 0)
         {
            if(param2 != -1)
            {
               null;
            }
            null;
            _loc3_ = new Array(param1);
            _a = _loc3_;
         }
         else
         {
            _a = [];
         }
         _top = 0;
         maxSize = -1;
         var _loc4_:int;
         HashKey._counter = (_loc4_ = int(HashKey._counter)) + 1;
         key = _loc4_;
      }
      
      public function walk(param1:Function) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = _top;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            _a[_loc4_] = param1(_a[_loc4_],_loc4_);
         }
      }
      
      public function top() : Object
      {
         null;
         return _a[_top - 1];
      }
      
      public function toString() : String
      {
         return Sprintf.format("{ArrayedStack, size: %d}",[_top]);
      }
      
      public function toDA() : DA
      {
         var _loc3_:int = 0;
         var _loc1_:DA = new DA(_top);
         var _loc2_:int = _top;
         while(_loc2_ > 0)
         {
            _loc3_ = _loc1_._size;
            null;
            _loc2_--;
            _loc1_._a[_loc3_] = _a[_loc2_];
            if(_loc3_ >= _loc1_._size)
            {
               ++_loc1_._size;
            }
         }
         return _loc1_;
      }
      
      public function toArray() : Array
      {
         null;
         var _loc2_:Array = new Array(_top);
         var _loc1_:Array = _loc2_;
         var _loc3_:int = _top;
         var _loc4_:int = 0;
         while(_loc3_ > 0)
         {
            _loc3_--;
            _loc1_[_loc4_++] = _a[_loc3_];
         }
         return _loc1_;
      }
      
      public function swp(param1:int, param2:int) : void
      {
         null;
         null;
         null;
         null;
         var _loc3_:Object = _a[param1];
         null;
         null;
         null;
         null;
         _a[param1] = _a[param2];
         _a[param2] = _loc3_;
      }
      
      public function size() : int
      {
         return _top;
      }
      
      public function shuffle(param1:DA = undefined) : void
      {
         var _loc3_:* = null as Class;
         var _loc4_:int = 0;
         var _loc5_:* = null as Object;
         var _loc6_:int = 0;
         var _loc2_:int = _top;
         if(param1 == null)
         {
            _loc3_ = Math;
            while(_loc2_ > 1)
            {
               _loc2_--;
               _loc4_ = Number(_loc3_.random()) * _loc2_;
               _loc5_ = _a[_loc2_];
               _a[_loc2_] = _a[_loc4_];
               _a[_loc4_] = _loc5_;
            }
         }
         else
         {
            null;
            _loc4_ = 0;
            while(_loc2_ > 1)
            {
               null;
               _loc2_--;
               _loc6_ = Number(param1._a[_loc4_++]) * _loc2_;
               _loc5_ = _a[_loc2_];
               _a[_loc2_] = _a[_loc6_];
               _a[_loc6_] = _loc5_;
            }
         }
      }
      
      public function set(param1:int, param2:Object) : void
      {
         null;
         null;
         _a[param1] = param2;
      }
      
      public function rotRight(param1:int) : void
      {
         null;
         var _loc2_:* = _top - param1;
         var _loc3_:* = _top - 1;
         var _loc4_:Object = _a[_loc2_];
         while(_loc2_ < _loc3_)
         {
            _a[_loc2_] = _a[_loc2_ + 1];
            _loc2_++;
         }
         _a[_top - 1] = _loc4_;
      }
      
      public function rotLeft(param1:int) : void
      {
         null;
         var _loc2_:* = _top - 1;
         var _loc3_:* = _top - param1;
         var _loc4_:Object = _a[_loc2_];
         while(_loc2_ > _loc3_)
         {
            _a[_loc2_] = _a[_loc2_ - 1];
            _loc2_--;
         }
         _a[_top - param1] = _loc4_;
      }
      
      public function reserve(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(_top == param1)
         {
            return;
         }
         var _loc2_:Array = _a;
         null;
         var _loc3_:Array = new Array(param1);
         _a = _loc3_;
         if(_top < param1)
         {
            _loc4_ = 0;
            _loc5_ = _top;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = _loc4_++;
               _a[_loc6_] = _loc2_[_loc6_];
            }
         }
      }
      
      public function remove(param1:Object) : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc2_:Object = param1;
         if(_top == 0)
         {
            return false;
         }
         var _loc3_:Object = null;
         var _loc4_:Boolean = false;
         while(_top > 0)
         {
            _loc4_ = false;
            _loc5_ = 0;
            _loc6_ = _top;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = _loc5_++;
               if(_a[_loc7_] == _loc2_)
               {
                  _loc8_ = _top - 1;
                  _loc9_ = _loc7_;
                  while(_loc9_ < _loc8_)
                  {
                     _a[_loc9_++] = _a[_loc9_];
                  }
                  _a[_top = _top - 1] = _loc3_;
                  _loc4_ = true;
                  break;
               }
            }
            if(!_loc4_)
            {
               break;
            }
         }
         return _loc4_;
      }
      
      public function push(param1:Object) : void
      {
         var _loc2_:Object = param1;
         var _loc3_:int;
         _top = (_loc3_ = _top) + 1;
         _a[_loc3_] = _loc2_;
      }
      
      public function pop() : Object
      {
         null;
         return _a[_top = _top - 1];
      }
      
      public function pack() : void
      {
         var _loc5_:int = 0;
         if(int(_a.length) == _top)
         {
            return;
         }
         var _loc1_:Array = _a;
         null;
         var _loc2_:Array = new Array(_top);
         _a = _loc2_;
         var _loc3_:int = 0;
         var _loc4_:int = _top;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _a[_loc5_] = _loc1_[_loc5_];
         }
         _loc3_ = _top;
         _loc4_ = int(_loc1_.length);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc1_[_loc5_] = null;
         }
      }
      
      public function iterator() : Itr
      {
         return new ArrayedStackIterator(this);
      }
      
      public function isEmpty() : Boolean
      {
         return _top == 0;
      }
      
      public function get(param1:int) : Object
      {
         null;
         null;
         return _a[param1];
      }
      
      public function free() : void
      {
         var _loc4_:int = 0;
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:int = int(_a.length);
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            _a[_loc4_] = _loc1_;
         }
         _a = null;
      }
      
      public function fill(param1:Object, param2:int = 0) : void
      {
         var _loc4_:int = 0;
         null;
         if(param2 > 0)
         {
            if(maxSize != -1)
            {
               null;
            }
         }
         else
         {
            param2 = _top;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2)
         {
            _loc4_ = _loc3_++;
            _a[_loc4_] = param1;
         }
         _top = param2;
      }
      
      public function exchange() : void
      {
         null;
         var _loc1_:* = _top - 1;
         var _loc2_:* = _loc1_ - 1;
         var _loc3_:Object = _a[_loc1_];
         _a[_loc1_] = _a[_loc2_];
         _a[_loc2_] = _loc3_;
      }
      
      public function dup() : void
      {
         null;
         _a[_top] = _a[_top - 1];
         ++_top;
      }
      
      public function dispose() : void
      {
         null;
         var _loc1_:Object = null;
         _a[_top] = _loc1_;
      }
      
      public function cpy(param1:int, param2:int) : void
      {
         null;
         null;
         null;
         null;
         _a[param1] = _a[param2];
      }
      
      public function contains(param1:Object) : Boolean
      {
         var _loc5_:int = 0;
         var _loc2_:Object = param1;
         var _loc3_:int = 0;
         var _loc4_:int = _top;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            if(_a[_loc5_] == _loc2_)
            {
               return true;
            }
         }
         return false;
      }
      
      public function clone(param1:Boolean, param2:Object = undefined) : Collection
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:* = null as Cloneable;
         var _loc3_:* = param2;
         var _loc4_:ArrayedStack = new ArrayedStack(_top,maxSize);
         if(_top == 0)
         {
            return _loc4_;
         }
         var _loc5_:Array = _loc4_._a;
         if(param1)
         {
            _loc6_ = 0;
            _loc7_ = _top;
            while(_loc6_ < _loc7_)
            {
               _loc8_ = _loc6_++;
               _loc5_[_loc8_] = _a[_loc8_];
            }
         }
         else if(_loc3_ == null)
         {
            _loc9_ = null;
            _loc6_ = 0;
            _loc7_ = _top;
            while(_loc6_ < _loc7_)
            {
               _loc8_ = _loc6_++;
               null;
               _loc9_ = _a[_loc8_];
               _loc5_[_loc8_] = _loc9_.clone();
            }
         }
         else
         {
            _loc6_ = 0;
            _loc7_ = _top;
            while(_loc6_ < _loc7_)
            {
               _loc8_ = _loc6_++;
               _loc5_[_loc8_] = _loc3_(_a[_loc8_]);
            }
         }
         _loc4_._top = _top;
         return _loc4_;
      }
      
      public function clear(param1:Boolean = false) : void
      {
         var _loc2_:* = null as Object;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1)
         {
            _loc2_ = null;
            _loc3_ = 0;
            _loc4_ = int(_a.length);
            while(_loc3_ < _loc4_)
            {
               _loc5_ = _loc3_++;
               _a[_loc5_] = null;
            }
         }
         _top = 0;
      }
      
      public function assign(param1:Class, param2:Array = undefined, param3:int = 0) : void
      {
         var _loc5_:int = 0;
         null;
         if(param3 <= 0)
         {
            param3 = _top;
         }
         var _loc4_:int = 0;
         while(_loc4_ < param3)
         {
            _loc5_ = _loc4_++;
            _a[_loc5_] = Instance.create(param1,param2);
         }
         _top = param3;
      }
      
      public function __set(param1:int, param2:Object) : void
      {
         _a[param1] = param2;
      }
      
      public function __get(param1:int) : Object
      {
         return _a[param1];
      }
      
      public function __cpy(param1:int, param2:int) : void
      {
         _a[param1] = _a[param2];
      }
   }
}
