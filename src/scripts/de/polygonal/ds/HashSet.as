package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import de.polygonal.core.util.Instance;
   import flash.Boot;
   
   public class HashSet implements Set
   {
       
      
      public var slotCount:int;
      
      public var maxSize:int;
      
      public var loadFactor:Number;
      
      public var key:int;
      
      public var capacity:int;
      
      public var _vals:Array;
      
      public var _sizeLevel:int;
      
      public var _next:Array;
      
      public var _isResizable:Boolean;
      
      public var _h:de.polygonal.ds.IntIntHashTable;
      
      public var _free:int;
      
      public function HashSet(param1:int = 0, param2:int = -1, param3:Boolean = true, param4:int = -1)
      {
         var _loc8_:int = 0;
         if(Boot.skip_constructor)
         {
            return;
         }
         if(param2 == -1)
         {
            param2 = param1;
         }
         _isResizable = param3;
         _h = new de.polygonal.ds.IntIntHashTable(param1,param2,_isResizable,param4);
         null;
         var _loc5_:Array;
         _vals = _loc5_ = new Array(param2);
         maxSize = -1;
         null;
         _next = _loc5_ = new Array(param2);
         var _loc6_:int = 0;
         var _loc7_:* = param2 - 1;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = _loc6_++;
            _next[_loc8_] = _loc8_ + 1;
         }
         _next[param2 - 1] = -1;
         _free = 0;
         _sizeLevel = 0;
         HashKey._counter = (_loc6_ = int(HashKey._counter)) + 1;
         key = _loc6_;
      }
      
      public function toString() : String
      {
         var _loc1_:de.polygonal.ds.IntIntHashTable = _h;
         return Sprintf.format("{HashSet, size/capacity: %d/%d, load factor: %.2f}",[size(),_h._capacity,_loc1_._size / (_loc1_._mask + 1)]);
      }
      
      public function toDA() : DA
      {
         var _loc4_:int = 0;
         var _loc5_:* = null as Hashable;
         var _loc6_:int = 0;
         var _loc1_:DA = new DA(size());
         var _loc2_:int = 0;
         var _loc3_:int = _h._capacity;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            if((_loc5_ = _vals[_loc4_]) != null)
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
         var _loc7_:* = null as Hashable;
         null;
         var _loc2_:Array = new Array(size());
         var _loc1_:Array = _loc2_;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = _h._capacity;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            if((_loc7_ = _vals[_loc6_]) != null)
            {
               _loc1_[_loc3_++] = _loc7_;
            }
         }
         return _loc1_;
      }
      
      public function size() : int
      {
         return _h._size;
      }
      
      public function set(param1:Object) : Boolean
      {
         var _loc3_:* = null as de.polygonal.ds.IntIntHashTable;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc10_:* = null as Array;
         var _loc11_:* = null as Array;
         var _loc12_:* = null as Array;
         var _loc2_:Hashable = param1;
         null;
         if(size() == _h._capacity)
         {
            _loc3_ = _h;
            null;
            _loc4_ = int(_loc2_.key);
            _loc5_ = size();
            _loc6_ = _loc4_ * 73856093 & _loc3_._mask;
            if((_loc7_ = int(_loc3_._hash[_loc6_])) == -1)
            {
               if(_loc3_._size == _loc3_._capacity)
               {
                  if(_loc3_._isResizable)
                  {
                     _loc3_._expand();
                  }
               }
               _loc8_ = _loc3_._free * 3;
               _loc3_._free = int(_loc3_._next[_loc3_._free]);
               _loc3_._hash[_loc6_] = _loc8_;
               _loc3_._data[_loc8_] = _loc4_;
               _loc3_._data[_loc8_ + 1] = _loc5_;
               ++_loc3_._size;
               §§push(true);
            }
            else if(int(_loc3_._data[_loc7_]) == _loc4_)
            {
               §§push(false);
            }
            else
            {
               _loc8_ = int(_loc3_._data[_loc7_ + 2]);
               while(_loc8_ != -1)
               {
                  if(int(_loc3_._data[_loc8_]) == _loc4_)
                  {
                     _loc7_ = -1;
                     break;
                  }
                  _loc8_ = int(_loc3_._data[(_loc7_ = _loc8_) + 2]);
               }
               if(_loc7_ == -1)
               {
                  §§push(false);
               }
               else
               {
                  if(_loc3_._size == _loc3_._capacity)
                  {
                     if(_loc3_._isResizable)
                     {
                        _loc3_._expand();
                     }
                  }
                  _loc9_ = _loc3_._free * 3;
                  _loc3_._free = int(_loc3_._next[_loc3_._free]);
                  _loc3_._data[_loc7_ + 2] = _loc9_;
                  _loc3_._data[_loc9_] = _loc4_;
                  _loc3_._data[_loc9_ + 1] = _loc5_;
                  ++_loc3_._size;
                  §§push(true);
               }
            }
            if(§§pop())
            {
               _loc5_ = (_loc4_ = _h._capacity >> 1) << 1;
               null;
               _loc10_ = _loc11_ = new Array(_loc5_);
               _loc11_ = _next;
               if((_loc6_ = _loc4_) == -1)
               {
                  _loc6_ = int(_loc11_.length);
               }
               null;
               null;
               null;
               null;
               null;
               _loc7_ = 0;
               _loc8_ = 0;
               while(_loc8_ < _loc6_)
               {
                  _loc9_ = _loc8_++;
                  _loc10_[_loc7_++] = int(_loc11_[_loc9_]);
               }
               _next = _loc10_;
               _loc6_ = _loc4_ - 1;
               _loc7_ = _loc5_ - 1;
               while(_loc6_ < _loc7_)
               {
                  _loc8_ = _loc6_++;
                  _next[_loc8_] = _loc8_ + 1;
               }
               _next[_loc5_ - 1] = -1;
               _free = _loc4_;
               null;
               _loc11_ = _loc12_ = new Array(_loc5_);
               _loc12_ = _vals;
               if((_loc6_ = _loc4_) == -1)
               {
                  _loc6_ = int(_loc12_.length);
               }
               null;
               null;
               null;
               null;
               null;
               _loc7_ = 0;
               _loc8_ = 0;
               while(_loc8_ < _loc6_)
               {
                  _loc9_ = _loc8_++;
                  _loc11_[_loc7_++] = _loc12_[_loc9_];
               }
               _vals = _loc11_;
               ++_sizeLevel;
               _vals[_free] = _loc2_;
               _free = int(_next[_free]);
               return true;
            }
            return false;
         }
         _loc3_ = _h;
         null;
         _loc4_ = int(_loc2_.key);
         _loc5_ = _free;
         _loc6_ = _loc4_ * 73856093 & _loc3_._mask;
         if((_loc7_ = int(_loc3_._hash[_loc6_])) == -1)
         {
            if(_loc3_._size == _loc3_._capacity)
            {
               if(_loc3_._isResizable)
               {
                  _loc3_._expand();
               }
            }
            _loc8_ = _loc3_._free * 3;
            _loc3_._free = int(_loc3_._next[_loc3_._free]);
            _loc3_._hash[_loc6_] = _loc8_;
            _loc3_._data[_loc8_] = _loc4_;
            _loc3_._data[_loc8_ + 1] = _loc5_;
            ++_loc3_._size;
            §§push(true);
         }
         else if(int(_loc3_._data[_loc7_]) == _loc4_)
         {
            §§push(false);
         }
         else
         {
            _loc8_ = int(_loc3_._data[_loc7_ + 2]);
            while(_loc8_ != -1)
            {
               if(int(_loc3_._data[_loc8_]) == _loc4_)
               {
                  _loc7_ = -1;
                  break;
               }
               _loc8_ = int(_loc3_._data[(_loc7_ = _loc8_) + 2]);
            }
            if(_loc7_ == -1)
            {
               §§push(false);
            }
            else
            {
               if(_loc3_._size == _loc3_._capacity)
               {
                  if(_loc3_._isResizable)
                  {
                     _loc3_._expand();
                  }
               }
               _loc9_ = _loc3_._free * 3;
               _loc3_._free = int(_loc3_._next[_loc3_._free]);
               _loc3_._data[_loc7_ + 2] = _loc9_;
               _loc3_._data[_loc9_] = _loc4_;
               _loc3_._data[_loc9_ + 1] = _loc5_;
               ++_loc3_._size;
               §§push(true);
            }
         }
         if(§§pop())
         {
            _vals[_free] = _loc2_;
            _free = int(_next[_free]);
            return true;
         }
         return false;
      }
      
      public function remove(param1:Object) : Boolean
      {
         var _loc4_:* = null as de.polygonal.ds.IntIntHashTable;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:* = 0;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:* = null as Array;
         var _loc13_:* = null as Array;
         var _loc14_:* = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc2_:Hashable = param1;
         _loc4_ = _h;
         null;
         _loc5_ = int(_loc2_.key);
         if((_loc6_ = int(_loc4_._hash[_loc5_ * 73856093 & _loc4_._mask])) == -1)
         {
            §§push(-2147483648);
         }
         else if(int(_loc4_._data[_loc6_]) == _loc5_)
         {
            §§push(int(_loc4_._data[_loc6_ + 1]));
         }
         else
         {
            _loc7_ = -2147483648;
            _loc6_ = int(_loc4_._data[_loc6_ + 2]);
            while(_loc6_ != -1)
            {
               if(int(_loc4_._data[_loc6_]) == _loc5_)
               {
                  _loc7_ = int(_loc4_._data[_loc6_ + 1]);
                  break;
               }
               _loc6_ = int(_loc4_._data[_loc6_ + 2]);
            }
            §§push(_loc7_);
         }
         var _loc3_:int = §§pop();
         if(_loc3_ == -2147483648)
         {
            return false;
         }
         _vals[_loc3_] = null;
         _next[_loc3_] = _free;
         _free = _loc3_;
         _loc8_ = false;
         if(_sizeLevel > 0)
         {
            if(size() - 1 == _h._capacity >> 2)
            {
               if(_isResizable)
               {
                  _loc8_ = true;
               }
            }
         }
         _loc4_ = _h;
         null;
         _loc6_ = (_loc5_ = int(_loc2_.key)) * 73856093 & _loc4_._mask;
         if((_loc7_ = int(_loc4_._hash[_loc6_])) == -1)
         {
            false;
         }
         else if(_loc5_ == int(_loc4_._data[_loc7_]))
         {
            if(int(_loc4_._data[_loc7_ + 2]) == -1)
            {
               _loc4_._hash[_loc6_] = -1;
            }
            else
            {
               _loc4_._hash[_loc6_] = int(_loc4_._data[_loc7_ + 2]);
            }
            _loc9_ = _loc7_ / 3;
            _loc4_._next[_loc9_] = _loc4_._free;
            _loc4_._free = _loc9_;
            _loc4_._data[_loc7_ + 1] = -2147483648;
            _loc4_._data[_loc7_ + 2] = -1;
            --_loc4_._size;
            if(_loc4_._sizeLevel > 0)
            {
               if(_loc4_._size == _loc4_._capacity >> 2)
               {
                  if(_loc4_._isResizable)
                  {
                     _loc4_._shrink();
                  }
               }
            }
            true;
         }
         else
         {
            _loc10_ = false;
            _loc9_ = _loc7_;
            _loc7_ = int(_loc4_._data[_loc7_ + 2]);
            while(_loc7_ != -1)
            {
               if(int(_loc4_._data[_loc7_]) == _loc5_)
               {
                  _loc10_ = true;
                  break;
               }
               _loc7_ = int(_loc4_._data[(_loc9_ = _loc7_) + 2]);
            }
            if(_loc10_)
            {
               _loc4_._data[_loc9_ + 2] = int(_loc4_._data[_loc7_ + 2]);
               _loc11_ = _loc7_ / 3;
               _loc4_._next[_loc11_] = _loc4_._free;
               _loc4_._free = _loc11_;
               _loc4_._data[_loc7_ + 1] = -2147483648;
               _loc4_._data[_loc7_ + 2] = -1;
               --_loc4_._size;
               if(_loc4_._sizeLevel > 0)
               {
                  if(_loc4_._size == _loc4_._capacity >> 2)
                  {
                     if(_loc4_._isResizable)
                     {
                        _loc4_._shrink();
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
         if(_loc8_)
         {
            --_sizeLevel;
            _loc5_ = _h._capacity << 1;
            _loc6_ = _h._capacity;
            null;
            _next = _loc12_ = new Array(_loc6_);
            _loc7_ = 0;
            _loc9_ = _loc6_ - 1;
            while(_loc7_ < _loc9_)
            {
               _loc11_ = _loc7_++;
               _next[_loc11_] = _loc11_ + 1;
            }
            _next[_loc6_ - 1] = -1;
            _free = 0;
            null;
            _loc12_ = _loc13_ = new Array(_loc6_);
            _loc14_ = _h.iterator();
            while(_loc14_.hasNext())
            {
               _loc7_ = int(_loc14_.next());
               _loc12_[_free] = _vals[_loc7_];
               _free = int(_next[_free]);
            }
            _vals = _loc12_;
            _loc7_ = 0;
            _loc9_ = _free;
            while(_loc7_ < _loc9_)
            {
               _loc11_ = _loc7_++;
               _loc4_ = _h;
               null;
               _loc15_ = int(_vals[_loc11_].key);
               if((_loc16_ = int(_loc4_._hash[_loc15_ * 73856093 & _loc4_._mask])) == -1)
               {
                  false;
               }
               else if(int(_loc4_._data[_loc16_]) == _loc15_)
               {
                  _loc4_._data[_loc16_ + 1] = _loc11_;
                  true;
               }
               else
               {
                  _loc16_ = int(_loc4_._data[_loc16_ + 2]);
                  while(_loc16_ != -1)
                  {
                     if(int(_loc4_._data[_loc16_]) == _loc15_)
                     {
                        _loc4_._data[_loc16_ + 1] = _loc11_;
                        break;
                     }
                     _loc16_ = int(_loc4_._data[_loc16_ + 2]);
                  }
                  _loc16_ != -1;
               }
            }
         }
         return true;
      }
      
      public function rehash(param1:int) : void
      {
         _h.rehash(param1);
      }
      
      public function iterator() : Itr
      {
         return new HashSetIterator(this);
      }
      
      public function isEmpty() : Boolean
      {
         return _h._size == 0;
      }
      
      public function hasFront(param1:Hashable) : Boolean
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc3_:de.polygonal.ds.IntIntHashTable = _h;
         null;
         var _loc4_:int;
         var _loc5_:* = (_loc4_ = int(param1.key)) * 73856093 & _loc3_._mask;
         var _loc6_:int;
         if((_loc6_ = int(_loc3_._hash[_loc5_])) == -1)
         {
            §§push(-2147483648);
         }
         else if(int(_loc3_._data[_loc6_]) == _loc4_)
         {
            §§push(int(_loc3_._data[_loc6_ + 1]));
         }
         else
         {
            _loc7_ = -2147483648;
            _loc9_ = _loc8_ = _loc6_;
            _loc6_ = int(_loc3_._data[_loc6_ + 2]);
            while(_loc6_ != -1)
            {
               if(int(_loc3_._data[_loc6_]) == _loc4_)
               {
                  _loc7_ = int(_loc3_._data[_loc6_ + 1]);
                  _loc3_._data[_loc9_ + 2] = int(_loc3_._data[_loc6_ + 2]);
                  _loc3_._data[_loc6_ + 2] = _loc8_;
                  _loc3_._hash[_loc5_] = _loc6_;
                  break;
               }
               _loc6_ = int(_loc3_._data[(_loc9_ = _loc6_) + 2]);
            }
            §§push(_loc7_);
         }
         var _loc2_:int = §§pop();
         return _loc2_ != -2147483648;
      }
      
      public function has(param1:Object) : Boolean
      {
         var _loc6_:int = 0;
         var _loc2_:Hashable = param1;
         var _loc3_:de.polygonal.ds.IntIntHashTable = _h;
         null;
         var _loc4_:int = int(_loc2_.key);
         var _loc5_:int;
         if((_loc5_ = int(_loc3_._hash[_loc4_ * 73856093 & _loc3_._mask])) == -1)
         {
            §§push(-2147483648);
         }
         else if(int(_loc3_._data[_loc5_]) == _loc4_)
         {
            §§push(int(_loc3_._data[_loc5_ + 1]));
         }
         else
         {
            _loc6_ = -2147483648;
            _loc5_ = int(_loc3_._data[_loc5_ + 2]);
            while(_loc5_ != -1)
            {
               if(int(_loc3_._data[_loc5_]) == _loc4_)
               {
                  _loc6_ = int(_loc3_._data[_loc5_ + 1]);
                  break;
               }
               _loc5_ = int(_loc3_._data[_loc5_ + 2]);
            }
            §§push(_loc6_);
         }
         return §§pop() != -2147483648;
      }
      
      public function getCollisionCount() : int
      {
         return _h.getCollisionCount();
      }
      
      public function free() : void
      {
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:int = size();
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc1_++;
            _vals[_loc3_] = null;
         }
         _vals = null;
         _next = null;
         _h.free();
         _h = null;
      }
      
      public function contains(param1:Object) : Boolean
      {
         var _loc6_:int = 0;
         var _loc2_:Hashable = param1;
         var _loc3_:de.polygonal.ds.IntIntHashTable = _h;
         null;
         var _loc4_:int = int(_loc2_.key);
         var _loc5_:int;
         if((_loc5_ = int(_loc3_._hash[_loc4_ * 73856093 & _loc3_._mask])) == -1)
         {
            §§push(-2147483648);
         }
         else if(int(_loc3_._data[_loc5_]) == _loc4_)
         {
            §§push(int(_loc3_._data[_loc5_ + 1]));
         }
         else
         {
            _loc6_ = -2147483648;
            _loc5_ = int(_loc3_._data[_loc5_ + 2]);
            while(_loc5_ != -1)
            {
               if(int(_loc3_._data[_loc5_]) == _loc4_)
               {
                  _loc6_ = int(_loc3_._data[_loc5_ + 1]);
                  break;
               }
               _loc5_ = int(_loc3_._data[_loc5_ + 2]);
            }
            §§push(_loc6_);
         }
         return §§pop() != -2147483648;
      }
      
      public function clone(param1:Boolean, param2:Object = undefined) : Collection
      {
         var _loc5_:int = 0;
         var _loc6_:* = null as Array;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:* = null as Array;
         var _loc11_:* = null as Hashable;
         var _loc12_:* = null as Cloneable;
         var _loc3_:* = param2;
         var _loc4_:HashSet;
         (_loc4_ = Instance.createEmpty(HashSet))._isResizable = _isResizable;
         _loc4_.maxSize = maxSize;
         HashKey._counter = (_loc5_ = int(HashKey._counter)) + 1;
         _loc4_.key = _loc5_;
         _loc4_._h = _h.clone(false);
         if(param1)
         {
            _loc4_._vals = [];
            _loc6_ = _vals;
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
               _loc4_._vals[_loc7_++] = _loc6_[_loc9_];
            }
         }
         else
         {
            null;
            _loc6_ = _loc10_ = new Array(_h._capacity);
            if(_loc3_ != null)
            {
               _loc5_ = 0;
               _loc7_ = _h._capacity;
               while(_loc5_ < _loc7_)
               {
                  _loc8_ = _loc5_++;
                  if((_loc11_ = _vals[_loc8_]) != null)
                  {
                     _loc6_[_loc8_] = _loc3_(_loc11_);
                  }
               }
            }
            else
            {
               _loc12_ = null;
               _loc5_ = 0;
               _loc7_ = _h._capacity;
               while(_loc5_ < _loc7_)
               {
                  _loc8_ = _loc5_++;
                  if((_loc11_ = _vals[_loc8_]) != null)
                  {
                     null;
                     _loc12_ = _loc11_;
                     _loc6_[_loc8_] = _loc12_.clone();
                  }
               }
            }
            _loc4_._vals = _loc6_;
         }
         _loc4_._sizeLevel = _sizeLevel;
         _loc4_._free = _free;
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
         return _loc4_;
      }
      
      public function clear(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         var _loc4_:int = 0;
         _h.clear();
         if(param1)
         {
            _loc2_ = 0;
            _loc3_ = _h._capacity;
            while(_loc2_ < _loc3_)
            {
               _loc4_ = _loc2_++;
               _vals[_loc4_] = null;
            }
         }
         _loc2_ = 0;
         _loc3_ = _h._capacity - 1;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            _next[_loc4_] = _loc4_ + 1;
         }
         _next[_h._capacity - 1] = -1;
         _free = 0;
      }
      
      public function _slotCountGetter() : int
      {
         return _h._mask + 1;
      }
      
      public function _shrink() : void
      {
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc9_:* = null as de.polygonal.ds.IntIntHashTable;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         --_sizeLevel;
         var _loc1_:* = _h._capacity << 1;
         var _loc2_:int = _h._capacity;
         null;
         var _loc3_:Array = new Array(_loc2_);
         _next = _loc3_;
         _loc4_ = 0;
         var _loc5_:* = _loc2_ - 1;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            _next[_loc6_] = _loc6_ + 1;
         }
         _next[_loc2_ - 1] = -1;
         _free = 0;
         null;
         var _loc7_:Array;
         _loc3_ = _loc7_ = new Array(_loc2_);
         var _loc8_:* = _h.iterator();
         while(_loc8_.hasNext())
         {
            _loc4_ = int(_loc8_.next());
            _loc3_[_free] = _vals[_loc4_];
            _free = int(_next[_free]);
         }
         _vals = _loc3_;
         _loc4_ = 0;
         _loc5_ = _free;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            _loc9_ = _h;
            null;
            _loc10_ = int(_vals[_loc6_].key);
            if((_loc11_ = int(_loc9_._hash[_loc10_ * 73856093 & _loc9_._mask])) == -1)
            {
               false;
            }
            else if(int(_loc9_._data[_loc11_]) == _loc10_)
            {
               _loc9_._data[_loc11_ + 1] = _loc6_;
               true;
            }
            else
            {
               _loc11_ = int(_loc9_._data[_loc11_ + 2]);
               while(_loc11_ != -1)
               {
                  if(int(_loc9_._data[_loc11_]) == _loc10_)
                  {
                     _loc9_._data[_loc11_ + 1] = _loc6_;
                     break;
                  }
                  _loc11_ = int(_loc9_._data[_loc11_ + 2]);
               }
               _loc11_ != -1;
            }
         }
      }
      
      public function _loadFactorGetter() : Number
      {
         var _loc1_:de.polygonal.ds.IntIntHashTable = _h;
         return _loc1_._size / (_loc1_._mask + 1);
      }
      
      public function _expand(param1:int) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:* = param1 << 1;
         null;
         var _loc4_:Array;
         var _loc3_:Array = _loc4_ = new Array(_loc2_);
         _loc4_ = _next;
         var _loc5_:*;
         if((_loc5_ = param1) == -1)
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
         _loc5_ = param1 - 1;
         _loc6_ = _loc2_ - 1;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            _next[_loc7_] = _loc7_ + 1;
         }
         _next[_loc2_ - 1] = -1;
         _free = param1;
         null;
         var _loc9_:Array;
         _loc4_ = _loc9_ = new Array(_loc2_);
         _loc9_ = _vals;
         if((_loc5_ = param1) == -1)
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
            _loc4_[_loc6_++] = _loc9_[_loc8_];
         }
         _vals = _loc4_;
         ++_sizeLevel;
      }
      
      public function _capacityGetter() : int
      {
         return _h._capacity;
      }
      
      public function __setNext(param1:int, param2:int) : void
      {
         _next[param1] = param2;
      }
      
      public function __key(param1:Hashable) : int
      {
         null;
         return param1.key;
      }
      
      public function __getNext(param1:int) : int
      {
         return int(_next[param1]);
      }
   }
}
