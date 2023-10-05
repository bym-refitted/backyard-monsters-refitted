package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import de.polygonal.core.util.Instance;
   import flash.Boot;
   
   public class ArrayedQueue implements Queue
   {
       
      
      public var maxSize:int;
      
      public var key:int;
      
      public var capacity:int;
      
      public var _sizeLevel:int;
      
      public var _size:int;
      
      public var _isResizable:Boolean;
      
      public var _front:int;
      
      public var _capacity:int;
      
      public var _a:Array;
      
      public function ArrayedQueue(param1:int = 0, param2:Boolean = true, param3:int = -1)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         maxSize = -1;
         _capacity = param1;
         _isResizable = param2;
         _sizeLevel = 0;
         _size = _front = 0;
         null;
         var _loc5_:Array;
         _a = _loc5_ = new Array(_capacity);
         var _loc4_:int;
         HashKey._counter = (_loc4_ = int(HashKey._counter)) + 1;
         key = _loc4_;
      }
      
      public function walk(param1:Function) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = _capacity;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = ((_loc4_ = _loc2_++) + _front) % _capacity;
            _a[_loc5_] = param1(_a[_loc5_],_loc4_);
         }
      }
      
      public function toString() : String
      {
         return Sprintf.format("{ArrayedQueue, size/capacity: %d/%d}",[_size,_capacity]);
      }
      
      public function toDA() : DA
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:DA = new DA(_size);
         var _loc2_:int = 0;
         var _loc3_:int = _size;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            _loc5_ = _loc1_._size;
            null;
            _loc1_._a[_loc5_] = _a[int((_loc4_ + _front) % _capacity)];
            if(_loc5_ >= _loc1_._size)
            {
               ++_loc1_._size;
            }
         }
         return _loc1_;
      }
      
      public function toArray() : Array
      {
         var _loc5_:int = 0;
         null;
         var _loc2_:Array = new Array(_size);
         var _loc1_:Array = _loc2_;
         var _loc3_:int = 0;
         var _loc4_:int = _size;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc1_[_loc5_] = _a[int((_loc5_ + _front) % _capacity)];
         }
         return _loc1_;
      }
      
      public function swp(param1:int, param2:int) : void
      {
         null;
         null;
         null;
         null;
         null;
         null;
         var _loc3_:Object = _a[int((param1 + _front) % _capacity)];
         null;
         null;
         null;
         null;
         null;
         null;
         null;
         null;
         _a[int((param1 + _front) % _capacity)] = _a[int((param2 + _front) % _capacity)];
         null;
         null;
         _a[int((param2 + _front) % _capacity)] = _loc3_;
      }
      
      public function size() : int
      {
         return _size;
      }
      
      public function shuffle(param1:DA = undefined) : void
      {
         var _loc3_:* = null as Class;
         var _loc4_:int = 0;
         var _loc5_:* = null as Object;
         var _loc6_:int = 0;
         var _loc2_:int = _size;
         if(param1 == null)
         {
            _loc3_ = Math;
            while(_loc2_ > 1)
            {
               _loc2_--;
               _loc4_ = (int(Number(_loc3_.random()) * _loc2_) + _front) % _capacity;
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
               _loc2_--;
               null;
               _loc6_ = (int(Number(param1._a[_loc4_++]) * _loc2_) + _front) % _capacity;
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
         _a[int((param1 + _front) % _capacity)] = param2;
      }
      
      public function remove(param1:Object) : Boolean
      {
         var _loc6_:* = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:* = null as Array;
         var _loc14_:* = null as Array;
         var _loc2_:Object = param1;
         if(_size == 0)
         {
            return false;
         }
         var _loc3_:Object = null;
         var _loc4_:int = _size;
         var _loc5_:Boolean = false;
         while(_size > 0)
         {
            _loc5_ = false;
            _loc6_ = 0;
            _loc7_ = _size;
            while(_loc6_ < _loc7_)
            {
               _loc8_ = _loc6_++;
               if(_a[int((_loc8_ + _front) % _capacity)] == _loc2_)
               {
                  _loc5_ = true;
                  _a[int((_loc8_ + _front) % _capacity)] = _loc3_;
                  if(_loc8_ == 0)
                  {
                     if((_front = _front + 1) == _capacity)
                     {
                        _front = 0;
                     }
                     --_size;
                  }
                  else if(_loc8_ == _size - 1)
                  {
                     --_size;
                  }
                  else
                  {
                     _loc9_ = _front + _loc8_;
                     _loc10_ = _front + _size - 1;
                     _loc11_ = _loc9_;
                     while(_loc11_ < _loc10_)
                     {
                        _loc12_ = _loc11_++;
                        _a[int(_loc12_ % _capacity)] = _a[int((_loc12_ + 1) % _capacity)];
                     }
                     _a[int(_loc10_ % _capacity)] = _loc3_;
                     --_size;
                  }
                  break;
               }
            }
            if(!_loc5_)
            {
               break;
            }
         }
         if(_isResizable && _size < _loc4_)
         {
            if(_sizeLevel > 0 && _capacity > 2)
            {
               _loc6_ = _capacity;
               while(_size <= _loc6_ >> 2)
               {
                  _loc6_ >>= 2;
                  --_sizeLevel;
               }
               null;
               _loc13_ = _loc14_ = new Array(_loc6_);
               _loc7_ = 0;
               _loc8_ = _size;
               while(_loc7_ < _loc8_)
               {
                  _loc9_ = _loc7_++;
                  _front = (_loc10_ = _front) + 1;
                  _loc13_[_loc9_] = _a[_loc10_];
                  if(_front == _capacity)
                  {
                     _front = 0;
                  }
               }
               _a = _loc13_;
               _front = 0;
               _capacity = _loc6_;
            }
         }
         return _size < _loc4_;
      }
      
      public function peek() : Object
      {
         null;
         return _a[_front];
      }
      
      public function pack() : void
      {
         var _loc4_:int = 0;
         var _loc1_:* = _front + _size;
         var _loc2_:int = 0;
         var _loc3_:* = _capacity - _size;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            _a[int((_loc4_ + _loc1_) % _capacity)] = null;
         }
      }
      
      public function iterator() : Itr
      {
         return new ArrayedQueueIterator(this);
      }
      
      public function isFull() : Boolean
      {
         return _size == _capacity;
      }
      
      public function isEmpty() : Boolean
      {
         return _size == 0;
      }
      
      public function get(param1:int) : Object
      {
         null;
         null;
         return _a[int((param1 + _front) % _capacity)];
      }
      
      public function free() : void
      {
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:int = _capacity;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc1_++;
            _a[_loc3_] = null;
         }
         _a = null;
      }
      
      public function fill(param1:Object, param2:int = 0) : void
      {
         var _loc4_:int = 0;
         null;
         if(param2 > 0)
         {
            null;
         }
         else
         {
            param2 = _capacity;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2)
         {
            _loc4_ = _loc3_++;
            _a[int((_loc4_ + _front) % _capacity)] = param1;
         }
         _size = param2;
      }
      
      public function enqueue(param1:Object) : void
      {
         var _loc3_:* = null as Array;
         var _loc4_:* = null as Array;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:Object = param1;
         if(_capacity == _size)
         {
            if(_isResizable)
            {
               ++_sizeLevel;
               null;
               _loc3_ = _loc4_ = new Array(_capacity << 1);
               _loc5_ = 0;
               _loc6_ = _size;
               while(_loc5_ < _loc6_)
               {
                  _loc7_ = _loc5_++;
                  _front = (_loc8_ = _front) + 1;
                  _loc3_[_loc7_] = _a[_loc8_];
                  if(_front == _capacity)
                  {
                     _front = 0;
                  }
               }
               _a = _loc3_;
               _front = 0;
               _capacity <<= 1;
            }
         }
         _size = (_loc5_ = _size) + 1;
         _a[int((_loc5_ + _front) % _capacity)] = _loc2_;
      }
      
      public function dispose() : void
      {
         var _loc1_:Object = null;
         _a[(_front == 0 ? _capacity : _front) - 1] = _loc1_;
      }
      
      public function dequeue() : Object
      {
         var _loc2_:int = 0;
         var _loc3_:* = null as Array;
         var _loc4_:* = null as Array;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         null;
         _front = (_loc2_ = _front) + 1;
         var _loc1_:Object = _a[_loc2_];
         if(_front == _capacity)
         {
            _front = 0;
         }
         --_size;
         if(_isResizable && _sizeLevel > 0)
         {
            if(_size == _capacity >> 2)
            {
               --_sizeLevel;
               null;
               _loc3_ = _loc4_ = new Array(_capacity >> 2);
               _loc2_ = 0;
               _loc5_ = _size;
               while(_loc2_ < _loc5_)
               {
                  _loc6_ = _loc2_++;
                  _front = (_loc7_ = _front) + 1;
                  _loc3_[_loc6_] = _a[_loc7_];
                  if(_front == _capacity)
                  {
                     _front = 0;
                  }
               }
               _a = _loc3_;
               _front = 0;
               _capacity >>= 2;
            }
         }
         return _loc1_;
      }
      
      public function cpy(param1:int, param2:int) : void
      {
         null;
         null;
         null;
         null;
         null;
         null;
         null;
         null;
         _a[int((param1 + _front) % _capacity)] = _a[int((param2 + _front) % _capacity)];
      }
      
      public function contains(param1:Object) : Boolean
      {
         var _loc5_:int = 0;
         var _loc2_:Object = param1;
         var _loc3_:int = 0;
         var _loc4_:int = _size;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            if(_a[int((_loc5_ + _front) % _capacity)] == _loc2_)
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
         var _loc4_:ArrayedQueue;
         (_loc4_ = new ArrayedQueue(_capacity,_isResizable,maxSize))._sizeLevel = _sizeLevel;
         if(_capacity == 0)
         {
            return _loc4_;
         }
         var _loc5_:Array = _loc4_._a;
         if(param1)
         {
            _loc6_ = 0;
            _loc7_ = _size;
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
            _loc7_ = _size;
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
            _loc7_ = _size;
            while(_loc6_ < _loc7_)
            {
               _loc8_ = _loc6_++;
               _loc5_[_loc8_] = _loc3_(_a[_loc8_]);
            }
         }
         _loc4_._front = _front;
         _loc4_._size = _size;
         return _loc4_;
      }
      
      public function clear(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null as Object;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = null as Array;
         if(param1)
         {
            _loc2_ = _front;
            _loc3_ = null;
            _loc4_ = 0;
            _loc5_ = _size;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = _loc4_++;
               _a[int(_loc2_++ % _capacity)] = _loc3_;
            }
            if(_isResizable && _sizeLevel > 0)
            {
               _capacity >>= _sizeLevel;
               _sizeLevel = 0;
               null;
               _a = _loc7_ = new Array(_capacity);
            }
         }
         _front = _size = 0;
      }
      
      public function back() : Object
      {
         null;
         return _a[int((_size - 1 + _front) % _capacity)];
      }
      
      public function assign(param1:Class, param2:Array = undefined, param3:int = 0) : void
      {
         var _loc5_:int = 0;
         null;
         if(param3 > 0)
         {
            null;
         }
         else
         {
            param3 = _capacity;
         }
         var _loc4_:int = 0;
         while(_loc4_ < param3)
         {
            _loc5_ = _loc4_++;
            _a[int((_loc5_ + _front) % _capacity)] = Instance.create(param1,param2);
         }
         _size = param3;
      }
      
      public function _pack(param1:int) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         null;
         var _loc3_:Array = new Array(param1);
         var _loc2_:Array = _loc3_;
         var _loc4_:int = 0;
         var _loc5_:int = _size;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            _front = (_loc7_ = _front) + 1;
            _loc2_[_loc6_] = _a[_loc7_];
            if(_front == _capacity)
            {
               _front = 0;
            }
         }
         _a = _loc2_;
      }
      
      public function _capacityGetter() : int
      {
         return _capacity;
      }
      
      public function __set(param1:int, param2:Object) : void
      {
         _a[param1] = param2;
      }
      
      public function __get(param1:int) : Object
      {
         return _a[param1];
      }
   }
}
