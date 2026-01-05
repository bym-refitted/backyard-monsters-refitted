package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import de.polygonal.core.util.Instance;
   import flash.Boot;
   
   public class IntIntHashTable implements Map
   {
      
      public static var KEY_ABSENT:int;
      
      public static var VAL_ABSENT:int;
      
      public static var EMPTY_SLOT:int;
      
      public static var NULL_POINTER:int;
       
      
      public var slotCount:int;
      
      public var maxSize:int;
      
      public var loadFactor:Number;
      
      public var key:int;
      
      public var capacity:int;
      
      public var _sizeLevel:int;
      
      public var _size:int;
      
      public var _next:Array;
      
      public var _mask:int;
      
      public var _isResizable:Boolean;
      
      public var _hash:Array;
      
      public var _free:int;
      
      public var _data:Array;
      
      public var _capacity:int;
      
      public function IntIntHashTable(param1:int = 0, param2:int = -1, param3:Boolean = true, param4:int = -1)
      {
         var _loc8_:* = 0;
         var _loc9_:int = 0;
         if(Boot.skip_constructor)
         {
            return;
         }
         if(param2 == -1)
         {
            param2 = param1;
         }
         _isResizable = param3;
         _free = 0;
         _capacity = param2;
         _size = 0;
         _mask = param1 - 1;
         _sizeLevel = 0;
         maxSize = -1;
         null;
         var _loc5_:Array;
         _hash = _loc5_ = new Array(param1);
         _loc5_ = _hash;
         var _loc6_:*;
         if((_loc6_ = param1) == -1)
         {
            _loc6_ = int(_loc5_.length);
         }
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = _loc7_++;
            _loc5_[_loc8_] = -1;
         }
         null;
         _data = _loc5_ = new Array(_capacity * 3);
         null;
         _next = _loc5_ = new Array(_capacity);
         _loc6_ = 2;
         _loc7_ = 0;
         while(_loc7_ < param2)
         {
            _loc8_ = _loc7_++;
            _data[_loc6_ - 1] = -2147483648;
            _data[_loc6_] = -1;
            _loc6_ += 3;
         }
         _loc7_ = 0;
         _loc8_ = _capacity - 1;
         while(_loc7_ < _loc8_)
         {
            _loc9_ = _loc7_++;
            _next[_loc9_] = _loc9_ + 1;
         }
         _next[_capacity - 1] = -1;
         HashKey._counter = (_loc7_ = int(HashKey._counter)) + 1;
         key = _loc7_;
      }
      
      public function toValSet() : Set
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = 0;
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc1_:IntHashSet = new IntHashSet(_capacity);
         var _loc2_:int = 0;
         var _loc3_:int = _capacity;
         while(true)
         {
            if(_loc2_ >= _loc3_)
            {
               return _loc1_;
            }
            _loc4_ = _loc2_++;
            if((_loc5_ = int(_data[_loc4_ * 3 + 1])) != -2147483648)
            {
               _loc6_ = _loc5_ * 73856093 & _loc1_._mask;
               if((_loc7_ = int(_loc1_._hash[_loc6_])) == -1)
               {
                  if(_loc1_._size == _loc1_._capacity)
                  {
                     _loc1_._expand();
                  }
                  _loc8_ = _loc1_._free << 1;
                  _loc1_._free = int(_loc1_._next[_loc1_._free]);
                  _loc1_._hash[_loc6_] = _loc8_;
                  _loc1_._data[_loc8_] = _loc5_;
                  ++_loc1_._size;
                  true;
               }
               else if(int(_loc1_._data[_loc7_]) == _loc5_)
               {
                  false;
               }
               else
               {
                  _loc8_ = int(_loc1_._data[_loc7_ + 1]);
                  while(_loc8_ != -1)
                  {
                     if(int(_loc1_._data[_loc8_]) == _loc5_)
                     {
                        _loc7_ = -1;
                        break;
                     }
                     _loc7_ = _loc8_;
                     _loc8_ = int(_loc1_._data[_loc8_ + 1]);
                  }
                  if(_loc7_ == -1)
                  {
                     false;
                  }
                  else
                  {
                     if(_loc1_._size == _loc1_._capacity)
                     {
                        if(!_loc1_._isResizable)
                        {
                           break;
                        }
                        _loc1_._expand();
                     }
                     _loc9_ = _loc1_._free << 1;
                     _loc1_._free = int(_loc1_._next[_loc1_._free]);
                     _loc1_._data[_loc9_] = _loc5_;
                     _loc1_._data[_loc7_ + 1] = _loc9_;
                     ++_loc1_._size;
                     true;
                  }
               }
            }
         }
         Boot.lastError = new Error();
         throw Sprintf.format("hash set is full (%d)",[_loc1_._capacity]);
      }
      
      public function toString() : String
      {
         return Sprintf.format("{IntIntHashTable, size/capacity: %d/%d, load factor: %.2f}",[_size,_capacity,_size / (_mask + 1)]);
      }
      
      public function toKeySet() : Set
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = 0;
         var _loc8_:int = 0;
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         var _loc1_:IntHashSet = new IntHashSet(_capacity);
         var _loc2_:int = 0;
         var _loc3_:int = _capacity;
         while(true)
         {
            if(_loc2_ >= _loc3_)
            {
               return _loc1_;
            }
            _loc4_ = _loc2_++;
            if((_loc5_ = int(_data[_loc4_ * 3 + 1])) != -2147483648)
            {
               _loc7_ = (_loc6_ = int(_data[_loc4_ * 3])) * 73856093 & _loc1_._mask;
               if((_loc8_ = int(_loc1_._hash[_loc7_])) == -1)
               {
                  if(_loc1_._size == _loc1_._capacity)
                  {
                     _loc1_._expand();
                  }
                  _loc9_ = _loc1_._free << 1;
                  _loc1_._free = int(_loc1_._next[_loc1_._free]);
                  _loc1_._hash[_loc7_] = _loc9_;
                  _loc1_._data[_loc9_] = _loc6_;
                  ++_loc1_._size;
                  true;
               }
               else if(int(_loc1_._data[_loc8_]) == _loc6_)
               {
                  false;
               }
               else
               {
                  _loc9_ = int(_loc1_._data[_loc8_ + 1]);
                  while(_loc9_ != -1)
                  {
                     if(int(_loc1_._data[_loc9_]) == _loc6_)
                     {
                        _loc8_ = -1;
                        break;
                     }
                     _loc8_ = _loc9_;
                     _loc9_ = int(_loc1_._data[_loc9_ + 1]);
                  }
                  if(_loc8_ == -1)
                  {
                     false;
                  }
                  else
                  {
                     if(_loc1_._size == _loc1_._capacity)
                     {
                        if(!_loc1_._isResizable)
                        {
                           break;
                        }
                        _loc1_._expand();
                     }
                     _loc10_ = _loc1_._free << 1;
                     _loc1_._free = int(_loc1_._next[_loc1_._free]);
                     _loc1_._data[_loc10_] = _loc6_;
                     _loc1_._data[_loc8_ + 1] = _loc10_;
                     ++_loc1_._size;
                     true;
                  }
               }
            }
         }
         Boot.lastError = new Error();
         throw Sprintf.format("hash set is full (%d)",[_loc1_._capacity]);
      }
      
      public function toKeyDA() : DA
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:DA = new DA(_size);
         var _loc2_:int = 0;
         var _loc3_:int = _capacity;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            if(int(_data[_loc4_ * 3 + 1]) != -2147483648)
            {
               _loc5_ = _loc1_._size;
               null;
               _loc1_._a[_loc5_] = int(_data[_loc4_ * 3]);
               if(_loc5_ >= _loc1_._size)
               {
                  ++_loc1_._size;
               }
            }
         }
         return _loc1_;
      }
      
      public function toKeyArray() : Array
      {
         var _loc6_:int = 0;
         if(_size == 0)
         {
            return [];
         }
         null;
         var _loc2_:Array = new Array(_size);
         var _loc1_:Array = _loc2_;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = _capacity;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            if(int(_data[_loc6_ * 3 + 1]) != -2147483648)
            {
               _loc1_[_loc3_++] = int(_data[_loc6_ * 3]);
            }
         }
         return _loc1_;
      }
      
      public function toDA() : DA
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:DA = new DA(_size);
         var _loc2_:int = 0;
         var _loc3_:int = _capacity;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            if((_loc5_ = int(_data[_loc4_ * 3 + 1])) != -2147483648)
            {
               _loc6_ = _loc1_._size;
               null;
               _loc1_._a[_loc6_] = _loc5_;
               if(_loc6_ >= _loc1_._size)
               {
                  ++_loc1_._size;
               }
            }
         }
         return _loc1_;
      }
      
      public function toArray() : Array
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         null;
         var _loc2_:Array = new Array(_size);
         var _loc1_:Array = _loc2_;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = _capacity;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            if((_loc7_ = int(_data[_loc6_ * 3 + 1])) != -2147483648)
            {
               _loc1_[_loc3_++] = _loc7_;
            }
         }
         return _loc1_;
      }
      
      public function size() : int
      {
         return _size;
      }
      
      public function setIfAbsent(param1:int, param2:int) : Boolean
      {
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc3_:* = param1 * 73856093 & _mask;
         var _loc4_:int;
         if((_loc4_ = int(_hash[_loc3_])) == -1)
         {
            if(_size == _capacity)
            {
               if(_isResizable)
               {
                  _expand();
               }
            }
            _loc5_ = _free * 3;
            _free = int(_next[_free]);
            _hash[_loc3_] = _loc5_;
            _data[_loc5_] = param1;
            _data[_loc5_ + 1] = param2;
            ++_size;
            return true;
         }
         if(int(_data[_loc4_]) == param1)
         {
            return false;
         }
         _loc5_ = int(_data[_loc4_ + 2]);
         while(_loc5_ != -1)
         {
            if(int(_data[_loc5_]) == param1)
            {
               _loc4_ = -1;
               break;
            }
            _loc5_ = int(_data[(_loc4_ = _loc5_) + 2]);
         }
         if(_loc4_ == -1)
         {
            return false;
         }
         if(_size == _capacity)
         {
            if(_isResizable)
            {
               _expand();
            }
         }
         _loc6_ = _free * 3;
         _free = int(_next[_free]);
         _data[_loc4_ + 2] = _loc6_;
         _data[_loc6_] = param1;
         _data[_loc6_ + 1] = param2;
         ++_size;
         return true;
      }
      
      public function set(param1:Object, param2:Object) : Boolean
      {
         var _loc8_:* = false;
         var _loc9_:int = 0;
         var _loc3_:int = int(param1);
         var _loc4_:int = int(param2);
         if(_size == _capacity)
         {
            if(_isResizable)
            {
               _expand();
            }
         }
         var _loc5_:* = _free * 3;
         _free = int(_next[_free]);
         _data[_loc5_] = _loc3_;
         _data[_loc5_ + 1] = _loc4_;
         var _loc6_:* = _loc3_ * 73856093 & _mask;
         var _loc7_:int;
         if((_loc7_ = int(_hash[_loc6_])) == -1)
         {
            _hash[_loc6_] = _loc5_;
            ++_size;
            return true;
         }
         _loc8_ = int(_data[_loc7_]) != _loc3_;
         _loc9_ = int(_data[_loc7_ + 2]);
         while(_loc9_ != -1)
         {
            if(int(_data[_loc9_]) == _loc3_)
            {
               _loc8_ = false;
            }
            _loc7_ = _loc9_;
            _loc9_ = int(_data[_loc9_ + 2]);
         }
         _data[_loc7_ + 2] = _loc5_;
         ++_size;
         return _loc8_;
      }
      
      public function remove(param1:Object) : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc2_:int = int(param1);
         var _loc3_:int = 0;
         var _loc4_:Array = [];
         _loc5_ = 0;
         _loc6_ = _capacity;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            if((_loc8_ = int(_data[_loc7_ * 3])) == _loc2_)
            {
               _loc4_[_loc3_++] = int(_data[_loc7_ * 3]);
            }
         }
         if(_loc3_ > 0)
         {
            _loc5_ = 0;
            while(_loc5_ < int(_loc4_.length))
            {
               _loc6_ = int(_loc4_[_loc5_]);
               _loc5_++;
               _loc7_ = _loc6_ * 73856093 & _mask;
               if((_loc8_ = int(_hash[_loc7_])) == -1)
               {
                  false;
               }
               else if(_loc6_ == int(_data[_loc8_]))
               {
                  if(int(_data[_loc8_ + 2]) == -1)
                  {
                     _hash[_loc7_] = -1;
                  }
                  else
                  {
                     _hash[_loc7_] = int(_data[_loc8_ + 2]);
                  }
                  _loc9_ = _loc8_ / 3;
                  _next[_loc9_] = _free;
                  _free = _loc9_;
                  _data[_loc8_ + 1] = -2147483648;
                  _data[_loc8_ + 2] = -1;
                  --_size;
                  if(_sizeLevel > 0)
                  {
                     if(_size == _capacity >> 2)
                     {
                        if(_isResizable)
                        {
                           _shrink();
                        }
                     }
                  }
                  true;
               }
               else
               {
                  _loc10_ = false;
                  _loc9_ = _loc8_;
                  _loc8_ = int(_data[_loc8_ + 2]);
                  while(_loc8_ != -1)
                  {
                     if(int(_data[_loc8_]) == _loc6_)
                     {
                        _loc10_ = true;
                        break;
                     }
                     _loc8_ = int(_data[(_loc9_ = _loc8_) + 2]);
                  }
                  if(_loc10_)
                  {
                     _data[_loc9_ + 2] = int(_data[_loc8_ + 2]);
                     _loc11_ = _loc8_ / 3;
                     _next[_loc11_] = _free;
                     _free = _loc11_;
                     _data[_loc8_ + 1] = -2147483648;
                     _data[_loc8_ + 2] = -1;
                     --_size;
                     if(_sizeLevel > 0)
                     {
                        if(_size == _capacity >> 2)
                        {
                           if(_isResizable)
                           {
                              _shrink();
                           }
                        }
                     }
                     true;
                  }
                  else
                  {
                     false;
                  }
               }
            }
            return true;
         }
         return false;
      }
      
      public function remap(param1:Object, param2:Object) : Boolean
      {
         var _loc3_:int = int(param1);
         var _loc4_:int = int(param2);
         var _loc5_:int;
         if((_loc5_ = int(_hash[_loc3_ * 73856093 & _mask])) == -1)
         {
            return false;
         }
         if(int(_data[_loc5_]) == _loc3_)
         {
            _data[_loc5_ + 1] = _loc4_;
            return true;
         }
         _loc5_ = int(_data[_loc5_ + 2]);
         while(_loc5_ != -1)
         {
            if(int(_data[_loc5_]) == _loc3_)
            {
               _data[_loc5_ + 1] = _loc4_;
               break;
            }
            _loc5_ = int(_data[_loc5_ + 2]);
         }
         return _loc5_ != -1;
      }
      
      public function rehash(param1:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc10_:int = 0;
         var _loc11_:* = false;
         var _loc12_:int = 0;
         if(param1 == _mask + 1)
         {
            return;
         }
         var _loc2_:IntIntHashTable = new IntIntHashTable(param1,_capacity);
         var _loc3_:int = 0;
         var _loc4_:int = _capacity;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            if((_loc6_ = int(_data[_loc5_ * 3 + 1])) != -2147483648)
            {
               _loc7_ = int(_data[_loc5_ * 3]);
               if(_loc2_._size == _loc2_._capacity)
               {
                  if(_loc2_._isResizable)
                  {
                     _loc2_._expand();
                  }
               }
               _loc8_ = _loc2_._free * 3;
               _loc2_._free = int(_loc2_._next[_loc2_._free]);
               _loc2_._data[_loc8_] = _loc7_;
               _loc2_._data[_loc8_ + 1] = _loc6_;
               _loc9_ = _loc7_ * 73856093 & _loc2_._mask;
               if((_loc10_ = int(_loc2_._hash[_loc9_])) == -1)
               {
                  _loc2_._hash[_loc9_] = _loc8_;
                  ++_loc2_._size;
                  true;
               }
               else
               {
                  _loc11_ = int(_loc2_._data[_loc10_]) != _loc7_;
                  _loc12_ = int(_loc2_._data[_loc10_ + 2]);
                  while(_loc12_ != -1)
                  {
                     if(int(_loc2_._data[_loc12_]) == _loc7_)
                     {
                        _loc11_ = false;
                     }
                     _loc10_ = _loc12_;
                     _loc12_ = int(_loc2_._data[_loc12_ + 2]);
                  }
                  _loc2_._data[_loc10_ + 2] = _loc8_;
                  ++_loc2_._size;
                  _loc11_;
               }
            }
         }
         _hash = _loc2_._hash;
         _data = _loc2_._data;
         _next = _loc2_._next;
         _mask = _loc2_._mask;
         _free = _loc2_._free;
         _sizeLevel = _loc2_._sizeLevel;
      }
      
      public function keys() : Itr
      {
         return new IntIntHashTableKeyIterator(this);
      }
      
      public function iterator() : Itr
      {
         return new IntIntHashTableValIterator(this);
      }
      
      public function isEmpty() : Boolean
      {
         return _size == 0;
      }
      
      public function hasKey(param1:Object) : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc2_:int = int(param1);
         var _loc3_:int = int(_hash[_loc2_ * 73856093 & _mask]);
         if(_loc3_ == -1)
         {
            return false;
         }
         if(int(_data[_loc3_]) == _loc2_)
         {
            return true;
         }
         _loc4_ = false;
         _loc3_ = int(_data[_loc3_ + 2]);
         while(_loc3_ != -1)
         {
            if(int(_data[_loc3_]) == _loc2_)
            {
               _loc4_ = true;
               break;
            }
            _loc3_ = int(_data[_loc3_ + 2]);
         }
         return _loc4_;
      }
      
      public function has(param1:Object) : Boolean
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:int = int(param1);
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = _capacity;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            if((_loc7_ = int(_data[_loc6_ * 3 + 1])) == _loc2_)
            {
               _loc3_ = true;
               break;
            }
         }
         return _loc3_;
      }
      
      public function getFront(param1:int) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:* = param1 * 73856093 & _mask;
         var _loc3_:int = int(_hash[_loc2_]);
         if(_loc3_ == -1)
         {
            return -2147483648;
         }
         if(int(_data[_loc3_]) == param1)
         {
            return int(_data[_loc3_ + 1]);
         }
         _loc4_ = -2147483648;
         _loc6_ = _loc5_ = _loc3_;
         _loc3_ = int(_data[_loc3_ + 2]);
         while(_loc3_ != -1)
         {
            if(int(_data[_loc3_]) == param1)
            {
               _loc4_ = int(_data[_loc3_ + 1]);
               _data[_loc6_ + 2] = int(_data[_loc3_ + 2]);
               _data[_loc3_ + 2] = _loc5_;
               _hash[_loc2_] = _loc3_;
               break;
            }
            _loc3_ = int(_data[(_loc6_ = _loc3_) + 2]);
         }
         return _loc4_;
      }
      
      public function getCollisionCount() : int
      {
         var _loc2_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = _mask + 1;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc2_ = int(_hash[_loc5_]);
            if(_loc2_ != -1)
            {
               _loc2_ = int(_data[_loc2_ + 2]);
               while(_loc2_ != -1)
               {
                  _loc2_ = int(_data[_loc2_ + 2]);
                  _loc1_++;
               }
            }
         }
         return _loc1_;
      }
      
      public function get(param1:Object) : Object
      {
         var _loc4_:int = 0;
         var _loc2_:int = int(param1);
         var _loc3_:int = int(_hash[_loc2_ * 73856093 & _mask]);
         if(_loc3_ == -1)
         {
            return -2147483648;
         }
         if(int(_data[_loc3_]) == _loc2_)
         {
            return int(_data[_loc3_ + 1]);
         }
         _loc4_ = -2147483648;
         _loc3_ = int(_data[_loc3_ + 2]);
         while(_loc3_ != -1)
         {
            if(int(_data[_loc3_]) == _loc2_)
            {
               _loc4_ = int(_data[_loc3_ + 1]);
               break;
            }
            _loc3_ = int(_data[_loc3_ + 2]);
         }
         return _loc4_;
      }
      
      public function free() : void
      {
         _hash = null;
         _data = null;
         _next = null;
      }
      
      public function extract(param1:int) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:* = param1 * 73856093 & _mask;
         var _loc3_:int = int(_hash[_loc2_]);
         if(_loc3_ == -1)
         {
            return -2147483648;
         }
         if(param1 == int(_data[_loc3_]))
         {
            _loc4_ = int(_data[_loc3_ + 1]);
            if(int(_data[_loc3_ + 2]) == -1)
            {
               _hash[_loc2_] = -1;
            }
            else
            {
               _hash[_loc2_] = int(_data[_loc3_ + 2]);
            }
            _loc5_ = _loc3_ / 3;
            _next[_loc5_] = _free;
            _free = _loc5_;
            _data[_loc3_ + 1] = -2147483648;
            _data[_loc3_ + 2] = -1;
            --_size;
            if(_sizeLevel > 0)
            {
               if(_size == _capacity >> 2)
               {
                  if(_isResizable)
                  {
                     _shrink();
                  }
               }
            }
            return _loc4_;
         }
         _loc4_ = _loc3_;
         _loc3_ = int(_data[_loc3_ + 2]);
         _loc5_ = -2147483648;
         while(_loc3_ != -1)
         {
            if(int(_data[_loc3_]) == param1)
            {
               _loc5_ = int(_data[_loc3_ + 1]);
               break;
            }
            _loc3_ = int(_data[(_loc4_ = _loc3_) + 2]);
         }
         if(_loc5_ != -2147483648)
         {
            _data[_loc4_ + 2] = int(_data[_loc3_ + 2]);
            _loc6_ = _loc3_ / 3;
            _next[_loc6_] = _free;
            _free = _loc6_;
            _data[_loc3_ + 1] = -2147483648;
            _data[_loc3_ + 2] = -1;
            --_size;
            if(_sizeLevel > 0)
            {
               if(_size == _capacity >> 2)
               {
                  if(_isResizable)
                  {
                     _shrink();
                  }
               }
            }
            return _loc5_;
         }
         return -2147483648;
      }
      
      public function count(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(_hash[param1 * 73856093 & _mask]);
         if(_loc3_ == -1)
         {
            return _loc2_;
         }
         while(_loc3_ != -1)
         {
            if(int(_data[_loc3_]) == param1)
            {
               _loc2_++;
            }
            _loc3_ = int(_data[_loc3_ + 2]);
         }
         return _loc2_;
      }
      
      public function contains(param1:Object) : Boolean
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:int = int(param1);
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = _capacity;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            if((_loc7_ = int(_data[_loc6_ * 3 + 1])) == _loc2_)
            {
               _loc3_ = true;
               break;
            }
         }
         return _loc3_;
      }
      
      public function clr(param1:Object) : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc2_:int = int(param1);
         var _loc3_:* = _loc2_ * 73856093 & _mask;
         var _loc4_:int;
         if((_loc4_ = int(_hash[_loc3_])) == -1)
         {
            return false;
         }
         if(_loc2_ == int(_data[_loc4_]))
         {
            if(int(_data[_loc4_ + 2]) == -1)
            {
               _hash[_loc3_] = -1;
            }
            else
            {
               _hash[_loc3_] = int(_data[_loc4_ + 2]);
            }
            _loc5_ = _loc4_ / 3;
            _next[_loc5_] = _free;
            _free = _loc5_;
            _data[_loc4_ + 1] = -2147483648;
            _data[_loc4_ + 2] = -1;
            --_size;
            if(_sizeLevel > 0)
            {
               if(_size == _capacity >> 2)
               {
                  if(_isResizable)
                  {
                     _shrink();
                  }
               }
            }
            return true;
         }
         _loc6_ = false;
         _loc5_ = _loc4_;
         _loc4_ = int(_data[_loc4_ + 2]);
         while(_loc4_ != -1)
         {
            if(int(_data[_loc4_]) == _loc2_)
            {
               _loc6_ = true;
               break;
            }
            _loc4_ = int(_data[(_loc5_ = _loc4_) + 2]);
         }
         if(_loc6_)
         {
            _data[_loc5_ + 2] = int(_data[_loc4_ + 2]);
            _loc7_ = _loc4_ / 3;
            _next[_loc7_] = _free;
            _free = _loc7_;
            _data[_loc4_ + 1] = -2147483648;
            _data[_loc4_ + 2] = -1;
            --_size;
            if(_sizeLevel > 0)
            {
               if(_size == _capacity >> 2)
               {
                  if(_isResizable)
                  {
                     _shrink();
                  }
               }
            }
            return true;
         }
         return false;
      }
      
      public function clone(param1:Boolean, param2:Object = undefined) : Collection
      {
         var _loc9_:int = 0;
         var _loc3_:* = param2;
         var _loc5_:int;
         HashKey._counter = (_loc5_ = int(HashKey._counter)) + 1;
         var _loc4_:IntIntHashTable;
         (_loc4_ = Instance.createEmpty(IntIntHashTable)).key = _loc5_;
         _loc4_.maxSize = maxSize;
         _loc4_._hash = [];
         var _loc6_:Array = _hash;
         if((_loc5_ = -1) == -1)
         {
            _loc5_ = int(_loc6_.length);
         }
         null;
         null;
         null;
         null;
         null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         while(_loc8_ < _loc5_)
         {
            _loc9_ = _loc8_++;
            _loc4_._hash[_loc7_++] = int(_loc6_[_loc9_]);
         }
         _loc4_._data = [];
         _loc6_ = _data;
         if((_loc5_ = -1) == -1)
         {
            _loc5_ = int(_loc6_.length);
         }
         null;
         null;
         null;
         null;
         null;
         _loc7_ = 0;
         _loc8_ = 0;
         while(_loc8_ < _loc5_)
         {
            _loc9_ = _loc8_++;
            _loc4_._data[_loc7_++] = int(_loc6_[_loc9_]);
         }
         _loc4_._next = [];
         _loc6_ = _next;
         if((_loc5_ = -1) == -1)
         {
            _loc5_ = int(_loc6_.length);
         }
         null;
         null;
         null;
         null;
         null;
         _loc7_ = 0;
         _loc8_ = 0;
         while(_loc8_ < _loc5_)
         {
            _loc9_ = _loc8_++;
            _loc4_._next[_loc7_++] = int(_loc6_[_loc9_]);
         }
         _loc4_._mask = _mask;
         _loc4_._capacity = _capacity;
         _loc4_._free = _free;
         _loc4_._size = _size;
         _loc4_._sizeLevel = _sizeLevel;
         return _loc4_;
      }
      
      public function clear(param1:Boolean = false) : void
      {
         var _loc2_:* = null as Array;
         var _loc5_:* = 0;
         var _loc6_:int = 0;
         if(_sizeLevel > 0)
         {
            _capacity >>= _sizeLevel;
            _sizeLevel = 0;
            null;
            _loc2_ = new Array(_capacity * 3);
            _data = _loc2_;
            null;
            _loc2_ = new Array(_capacity);
            _next = _loc2_;
         }
         _loc2_ = _hash;
         var _loc3_:* = _mask + 1;
         if(_loc3_ == -1)
         {
            _loc3_ = int(_loc2_.length);
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc4_++;
            _loc2_[_loc5_] = -1;
         }
         _loc3_ = 2;
         _loc4_ = 0;
         _loc5_ = _capacity;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            _data[_loc3_ - 1] = -2147483648;
            _data[_loc3_] = -1;
            _loc3_ += 3;
         }
         _loc4_ = 0;
         _loc5_ = _capacity - 1;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            _next[_loc6_] = _loc6_ + 1;
         }
         _next[_capacity - 1] = -1;
         _free = 0;
         _size = 0;
      }
      
      public function _slotCountGetter() : int
      {
         return _mask + 1;
      }
      
      public function _shrink() : void
      {
         var _loc9_:* = 0;
         var _loc10_:int = 0;
         --_sizeLevel;
         var _loc1_:int = _capacity;
         var _loc2_:* = _loc1_ >> 1;
         _capacity = _loc2_;
         var _loc3_:* = _loc2_ * 3;
         null;
         var _loc5_:Array;
         var _loc4_:Array = _loc5_ = new Array(_loc3_);
         null;
         _next = _loc5_ = new Array(_loc2_);
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = _mask + 1;
         while(_loc7_ < _loc8_)
         {
            _loc9_ = _loc7_++;
            if((_loc10_ = int(_hash[_loc9_])) != -1)
            {
               _hash[_loc9_] = _loc6_;
               _loc4_[_loc6_] = int(_data[_loc10_]);
               _loc4_[_loc6_ + 1] = int(_data[_loc10_ + 1]);
               _loc4_[_loc6_ + 2] = -1;
               _loc6_ += 3;
               _loc10_ = int(_data[_loc10_ + 2]);
               while(_loc10_ != -1)
               {
                  _loc4_[_loc6_ - 1] = _loc6_;
                  _loc4_[_loc6_] = int(_data[_loc10_]);
                  _loc4_[_loc6_ + 1] = int(_data[_loc10_ + 1]);
                  _loc4_[_loc6_ + 2] = -1;
                  _loc6_ += 3;
                  _loc10_ = int(_data[_loc10_ + 2]);
               }
            }
         }
         _loc7_ = _loc3_ >> 1;
         while(_loc7_ < _loc3_)
         {
            _loc4_[_loc7_ + 1] = -2147483648;
            _loc4_[_loc7_ + 2] = -1;
            _loc7_ += 3;
         }
         _data = _loc4_;
         _loc8_ = 0;
         _loc9_ = _loc2_ - 1;
         while(_loc8_ < _loc9_)
         {
            _loc10_ = _loc8_++;
            _next[_loc10_] = _loc10_ + 1;
         }
         _next[_loc2_ - 1] = -1;
         _free = _loc2_ >> 1;
      }
      
      public function _loadFactorGetter() : Number
      {
         return _size / (_mask + 1);
      }
      
      public function _hashCode(param1:int) : int
      {
         return param1 * 73856093 & _mask;
      }
      
      public function _expand() : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         ++_sizeLevel;
         var _loc1_:int = _capacity;
         var _loc2_:* = _loc1_ << 1;
         _capacity = _loc2_;
         null;
         var _loc4_:Array;
         var _loc3_:Array = _loc4_ = new Array(_loc2_);
         _loc4_ = _next;
         var _loc5_:*;
         if((_loc5_ = _loc1_) == -1)
         {
            _loc5_ = int(_loc4_.length);
         }
         null;
         null;
         null;
         null;
         null;
         var _loc6_:* = 0;
         _loc7_ = 0;
         while(_loc7_ < _loc5_)
         {
            _loc8_ = _loc7_++;
            _loc3_[_loc6_++] = int(_loc4_[_loc8_]);
         }
         _next = _loc3_;
         null;
         var _loc9_:Array;
         _loc4_ = _loc9_ = new Array(_loc2_ * 3);
         _loc9_ = _data;
         if((_loc5_ = _loc1_ * 3) == -1)
         {
            _loc5_ = int(_loc9_.length);
         }
         null;
         null;
         null;
         null;
         null;
         _loc6_ = 0;
         _loc7_ = 0;
         while(_loc7_ < _loc5_)
         {
            _loc8_ = _loc7_++;
            _loc4_[_loc6_++] = int(_loc9_[_loc8_]);
         }
         _data = _loc4_;
         _loc5_ = _loc1_ - 1;
         _loc6_ = _loc2_ - 1;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            _next[_loc7_] = _loc7_ + 1;
         }
         _next[_loc2_ - 1] = -1;
         _free = _loc1_;
         _loc5_ = _loc1_ * 3 + 2;
         _loc6_ = 0;
         while(_loc6_ < _loc1_)
         {
            _loc7_ = _loc6_++;
            _data[_loc5_ - 1] = -2147483648;
            _data[_loc5_] = -1;
            _loc5_ += 3;
         }
      }
      
      public function _capacityGetter() : int
      {
         return _capacity;
      }
      
      public function __setNext(param1:int, param2:int) : void
      {
         _next[param1] = param2;
      }
      
      public function __setHash(param1:int, param2:int) : void
      {
         _hash[param1] = param2;
      }
      
      public function __setData(param1:int, param2:int) : void
      {
         _data[param1] = param2;
      }
      
      public function __getNext(param1:int) : int
      {
         return int(_next[param1]);
      }
      
      public function __getHash(param1:int) : int
      {
         return int(_hash[param1]);
      }
      
      public function __getData(param1:int) : int
      {
         return int(_data[param1]);
      }
   }
}
