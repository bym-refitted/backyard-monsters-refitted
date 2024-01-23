package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import de.polygonal.core.util.Instance;
   import flash.Boot;
   
   public class DA implements Collection
   {
       
      
      public var maxSize:int;
      
      public var key:int;
      
      public var _size:int;
      
      public var _a:Array;
      
      public function DA(param1:int = 0, param2:int = -1)
      {
         var _loc3_:* = null as Array;
         if(Boot.skip_constructor)
         {
            return;
         }
         _size = 0;
         maxSize = -1;
         if(param1 > 0)
         {
            null;
            _loc3_ = new Array(param1);
            _a = _loc3_;
         }
         else
         {
            _a = [];
         }
         var _loc4_:int;
         HashKey._counter = (_loc4_ = int(HashKey._counter)) + 1;
         key = _loc4_;
      }
      
      public function trim(param1:int) : void
      {
         null;
         _size = param1;
      }
      
      public function toString() : String
      {
         return Sprintf.format("{DA, size: %d}",[_size]);
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
            _loc1_._a[_loc5_] = _a[_loc4_];
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
            _loc1_[_loc5_] = _a[_loc5_];
         }
         return _loc1_;
      }
      
      public function swp(param1:int, param2:int) : void
      {
         null;
         null;
         var _loc3_:Object = _a[param1];
         null;
         null;
         null;
         _a[param1] = _a[param2];
         if(param1 >= _size)
         {
            ++_size;
         }
         null;
         _a[param2] = _loc3_;
         if(param2 >= _size)
         {
            ++_size;
         }
      }
      
      public function swapWithBack(param1:int) : void
      {
         var _loc3_:* = null as Object;
         null;
         var _loc2_:* = _size - 1;
         if(param1 < _loc2_)
         {
            null;
            _loc3_ = _a[_size - 1];
            _a[_loc2_] = _a[param1];
            _a[param1] = _loc3_;
         }
      }
      
      public function sort(param1:Function, param2:Boolean = false) : void
      {
         if(_size > 1)
         {
            if(param1 == null)
            {
               if(param2)
               {
                  _insertionSortComparable();
               }
               else
               {
                  _quickSortComparable(0,_size);
               }
            }
            else if(param2)
            {
               _insertionSort(param1);
            }
            else
            {
               _a.sort(param1);
            }
         }
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
            while(true)
            {
               _loc2_--;
               if(_loc2_ <= 1)
               {
                  break;
               }
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
            while(true)
            {
               _loc2_--;
               if(_loc2_ <= 1)
               {
                  break;
               }
               null;
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
         _a[param1] = param2;
         if(param1 >= _size)
         {
            ++_size;
         }
      }
      
      public function reverse() : void
      {
         var _loc1_:* = null as Array;
         var _loc2_:int = 0;
         if(int(_a.length) > _size)
         {
            _loc1_ = _a;
            _loc2_ = _size;
            if(int(_loc1_.length) > _loc2_)
            {
               _loc1_.length = _loc2_;
            }
            _loc1_;
         }
         _a.reverse();
      }
      
      public function reserve(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(_size == param1)
         {
            return;
         }
         var _loc2_:Array = _a;
         null;
         var _loc3_:Array = new Array(param1);
         _a = _loc3_;
         if(_size < param1)
         {
            _loc4_ = 0;
            _loc5_ = _size;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = _loc4_++;
               _a[_loc6_] = _loc2_[_loc6_];
            }
         }
      }
      
      public function removeRange(param1:int, param2:int, param3:DA = undefined) : DA
      {
         var _loc4_:int = 0;
         var _loc5_:* = 0;
         var _loc6_:* = null as Object;
         var _loc7_:* = 0;
         var _loc8_:int = 0;
         null;
         null;
         if(param3 == null)
         {
            _loc4_ = _size;
            _loc5_ = param1 + param2;
            while(_loc5_ < _loc4_)
            {
               _a[_loc5_ - param2] = _a[_loc5_++];
            }
         }
         else
         {
            _loc4_ = _size;
            _loc5_ = param1 + param2;
            while(_loc5_ < _loc4_)
            {
               _loc7_ = _loc5_ - param2;
               _loc6_ = _a[_loc7_];
               _loc8_ = param3._size;
               null;
               param3._a[_loc8_] = _loc6_;
               if(_loc8_ >= param3._size)
               {
                  ++param3._size;
               }
               _a[_loc7_] = _a[_loc5_++];
            }
         }
         _size -= param2;
         return param3;
      }
      
      public function removeAt(param1:int) : Object
      {
         null;
         var _loc2_:Object = _a[param1];
         var _loc3_:* = _size - 1;
         var _loc4_:int = param1;
         while(_loc4_ < _loc3_)
         {
            _a[_loc4_++] = _a[_loc4_];
         }
         --_size;
         return _loc2_;
      }
      
      public function remove(param1:Object) : Boolean
      {
         var _loc5_:int = 0;
         var _loc2_:Object = param1;
         if(_size == 0)
         {
            return false;
         }
         var _loc3_:int = 0;
         var _loc4_:int = _size;
         while(_loc3_ < _loc4_)
         {
            if(_a[_loc3_] == _loc2_)
            {
               _loc4_--;
               _loc5_ = _loc3_;
               while(_loc5_ < _loc4_)
               {
                  _a[_loc5_] = _a[_loc5_ + 1];
                  _loc5_++;
               }
            }
            else
            {
               _loc3_++;
            }
         }
         var _loc6_:* = _size - _loc4_ != 0;
         _size = _loc4_;
         return _loc6_;
      }
      
      public function pushFront(param1:Object) : void
      {
         if(maxSize != -1)
         {
            null;
         }
         null;
         null;
         var _loc2_:int = _size;
         while(_loc2_ > 0)
         {
            _a[_loc2_--] = _a[_loc2_];
         }
         _a[0] = param1;
         ++_size;
      }
      
      public function pushBack(param1:Object) : void
      {
         var _loc2_:int = _size;
         null;
         _a[_loc2_] = param1;
         if(_loc2_ >= _size)
         {
            ++_size;
         }
      }
      
      public function popFront() : Object
      {
         null;
         var _loc1_:Object = _a[0];
         var _loc2_:* = _size - 1;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _a[_loc3_++] = _a[_loc3_];
         }
         --_size;
         return _loc1_;
      }
      
      public function popBack() : Object
      {
         null;
         var _loc1_:Object = _a[_size - 1];
         --_size;
         return _loc1_;
      }
      
      public function pack() : void
      {
         var _loc6_:int = 0;
         var _loc1_:int = int(_a.length);
         if(_loc1_ == _size)
         {
            return;
         }
         var _loc2_:Array = _a;
         null;
         var _loc3_:Array = new Array(_size);
         _a = _loc3_;
         var _loc4_:int = 0;
         var _loc5_:int = _size;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            _a[_loc6_] = _loc2_[_loc6_];
         }
         _loc4_ = _size;
         _loc5_ = int(_loc2_.length);
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            _loc2_[_loc6_] = null;
         }
      }
      
      public function memmove(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         null;
         null;
         null;
         null;
         if(param2 == param1)
         {
            return;
         }
         if(param2 <= param1)
         {
            _loc4_ = param2 + param3;
            _loc5_ = param1 + param3;
            _loc6_ = 0;
            while(_loc6_ < param3)
            {
               _loc7_ = _loc6_++;
               _loc4_--;
               _loc5_--;
               _a[_loc5_] = _a[_loc4_];
            }
         }
         else
         {
            _loc4_ = param2;
            _loc5_ = param1;
            _loc6_ = 0;
            while(_loc6_ < param3)
            {
               _loc7_ = _loc6_++;
               _a[_loc5_] = _a[_loc4_];
               _loc4_++;
               _loc5_++;
            }
         }
      }
      
      public function lastIndexOf(param1:Object, param2:int = -1) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(_size == 0)
         {
            return -1;
         }
         if(param2 < 0)
         {
            param2 = _size + param2;
         }
         null;
         _loc3_ = -1;
         _loc4_ = param2;
         do
         {
            if(_a[_loc4_] == param1)
            {
               _loc3_ = _loc4_;
               break;
            }
         }
         while(_loc4_-- > 0);
         
         return _loc3_;
      }
      
      public function join(param1:String) : String
      {
         var _loc5_:int = 0;
         if(_size == 0)
         {
            return "";
         }
         if(_size == 1)
         {
            null;
            return Std.string(_a[0]);
         }
         null;
         var _loc2_:String = Std.string(_a[0]) + param1;
         var _loc3_:int = 1;
         var _loc4_:* = _size - 1;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            null;
            _loc2_ += Std.string(_a[_loc5_]);
            _loc2_ += param1;
         }
         null;
         return _loc2_ + Std.string(_a[_size - 1]);
      }
      
      public function iterator() : Itr
      {
         return new DAIterator(this);
      }
      
      public function isEmpty() : Boolean
      {
         return _size == 0;
      }
      
      public function insertAt(param1:int, param2:Object) : void
      {
         null;
         null;
         var _loc3_:int = _size;
         while(_loc3_ > param1)
         {
            _a[_loc3_--] = _a[_loc3_];
         }
         _a[param1] = param2;
         ++_size;
      }
      
      public function indexOf(param1:Object, param2:int = 0, param3:Boolean = false, param4:Object = undefined) : int
      {
         var _loc5_:* = null as Array;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         if(_size == 0)
         {
            return -1;
         }
         null;
         if(param3)
         {
            if(param4 != null)
            {
               _loc5_ = _a;
               _loc6_ = _size - 1;
               null;
               null;
               null;
               null;
               _loc7_ = param2;
               _loc9_ = _loc6_ + 1;
               while(_loc7_ < _loc9_)
               {
                  _loc8_ = _loc7_ + (_loc9_ - _loc7_ >> 1);
                  if(param4(_loc5_[_loc8_],param1) < 0)
                  {
                     _loc7_ = _loc8_ + 1;
                  }
                  else
                  {
                     _loc9_ = _loc8_;
                  }
               }
               return _loc7_ <= _loc6_ && param4(_loc5_[_loc7_],param1) == 0 ? _loc7_ : ~_loc7_;
            }
            null;
            _loc6_ = _size;
            _loc7_ = param2;
            _loc9_ = _loc6_;
            while(_loc7_ < _loc9_)
            {
               _loc8_ = _loc7_ + (_loc9_ - _loc7_ >> 1);
               null;
               if(int(_a[_loc8_].compare(param1)) < 0)
               {
                  _loc7_ = _loc8_ + 1;
               }
               else
               {
                  _loc9_ = _loc8_;
               }
            }
            null;
            return _loc7_ <= _loc6_ && int(_a[_loc7_].compare(param1)) == 0 ? _loc7_ : -_loc7_;
         }
         _loc6_ = param2;
         _loc7_ = -1;
         _loc8_ = _size - 1;
         do
         {
            if(_a[_loc6_] == param1)
            {
               _loc7_ = _loc6_;
               break;
            }
         }
         while(_loc6_++ < _loc8_);
         
         return _loc7_;
      }
      
      public function getPrev(param1:int) : Object
      {
         null;
         return _a[param1 - 1 == -1 ? _size - 1 : param1 - 1];
      }
      
      public function getNext(param1:int) : Object
      {
         null;
         return _a[param1 + 1 == _size ? 0 : param1 + 1];
      }
      
      public function getArray() : Array
      {
         return _a;
      }
      
      public function get(param1:int) : Object
      {
         null;
         return _a[param1];
      }
      
      public function front() : Object
      {
         null;
         return _a[0];
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
            null;
            _size = param2;
         }
         else
         {
            param2 = _size;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2)
         {
            _loc4_ = _loc3_++;
            _a[_loc4_] = param1;
         }
      }
      
      public function cpy(param1:int, param2:int) : void
      {
         null;
         null;
         null;
         _a[param1] = _a[param2];
         if(param1 >= _size)
         {
            ++_size;
         }
      }
      
      public function contains(param1:Object) : Boolean
      {
         var _loc6_:int = 0;
         var _loc2_:Object = param1;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = _size;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            if(_a[_loc6_] == _loc2_)
            {
               _loc3_ = true;
               break;
            }
         }
         return _loc3_;
      }
      
      public function concat(param1:DA, param2:Boolean = false) : DA
      {
         var _loc3_:* = null as DA;
         var _loc4_:int = 0;
         var _loc5_:* = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         null;
         if(param2)
         {
            _loc3_ = new DA();
            _loc3_._size = _size + param1._size;
            _loc4_ = 0;
            _loc5_ = _size;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = _loc4_++;
               null;
               _loc3_._a[_loc6_] = _a[_loc6_];
               if(_loc6_ >= _loc3_._size)
               {
                  ++_loc3_._size;
               }
            }
            _loc4_ = _size;
            _loc5_ = _size + param1._size;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = _loc4_++;
               null;
               null;
               _loc3_._a[_loc6_] = param1._a[_loc6_ - _size];
               if(_loc6_ >= _loc3_._size)
               {
                  ++_loc3_._size;
               }
            }
            return _loc3_;
         }
         null;
         _loc4_ = _size;
         _size += param1._size;
         _loc5_ = 0;
         _loc6_ = param1._size;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            null;
            _a[_loc4_++] = param1._a[_loc7_];
         }
         return this;
      }
      
      public function clone(param1:Boolean, param2:Object = undefined) : Collection
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = null as Cloneable;
         var _loc3_:* = param2;
         var _loc4_:DA;
         (_loc4_ = new DA(_size,maxSize))._size = _size;
         if(param1)
         {
            _loc5_ = 0;
            _loc6_ = _size;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = _loc5_++;
               _loc4_._a[_loc7_] = _a[_loc7_];
            }
         }
         else if(_loc3_ == null)
         {
            _loc8_ = null;
            _loc5_ = 0;
            _loc6_ = _size;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = _loc5_++;
               null;
               _loc8_ = _a[_loc7_];
               _loc4_._a[_loc7_] = _loc8_.clone();
            }
         }
         else
         {
            _loc5_ = 0;
            _loc6_ = _size;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = _loc5_++;
               _loc4_._a[_loc7_] = _loc3_(_a[_loc7_]);
            }
         }
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
               _a[_loc5_] = _loc2_;
            }
         }
         _size = 0;
      }
      
      public function back() : Object
      {
         null;
         return _a[_size - 1];
      }
      
      public function assign(param1:Class, param2:Array = undefined, param3:int = 0) : void
      {
         var _loc5_:int = 0;
         null;
         if(param3 > 0)
         {
            null;
            _size = param3;
         }
         else
         {
            param3 = _size;
         }
         var _loc4_:int = 0;
         while(_loc4_ < param3)
         {
            _loc5_ = _loc4_++;
            _a[_loc5_] = Instance.create(param1,param2);
         }
      }
      
      public function _quickSortComparable(param1:int, param2:int) : void
      {
         var _loc6_:int = 0;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc9_:* = null as Object;
         var _loc10_:* = null as Object;
         var _loc11_:* = null as Object;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:* = null as Object;
         var _loc3_:* = param1 + param2 - 1;
         var _loc4_:int = param1;
         var _loc5_:int = _loc3_;
         if(param2 > 1)
         {
            _loc7_ = (_loc6_ = param1) + (param2 >> 1);
            _loc8_ = _loc6_ + param2 - 1;
            _loc9_ = _a[_loc6_];
            _loc10_ = _a[_loc7_];
            _loc11_ = _a[_loc8_];
            null;
            null;
            null;
            _loc13_ = int(_loc9_.compare(_loc11_));
            if(_loc13_ < 0 && int(_loc9_.compare(_loc10_)) < 0)
            {
               _loc12_ = int(_loc10_.compare(_loc11_)) < 0 ? _loc7_ : _loc8_;
            }
            else if(int(_loc9_.compare(_loc10_)) < 0 && int(_loc10_.compare(_loc11_)) < 0)
            {
               _loc12_ = _loc13_ < 0 ? _loc6_ : _loc8_;
            }
            else
            {
               _loc12_ = int(_loc11_.compare(_loc9_)) < 0 ? _loc7_ : _loc6_;
            }
            _loc14_ = _a[_loc12_];
            _a[_loc12_] = _a[param1];
            while(_loc4_ < _loc5_)
            {
               null;
               null;
               null;
               while(int(_loc14_.compare(_a[_loc5_])) < 0 && _loc4_ < _loc5_)
               {
                  _loc5_--;
               }
               if(_loc5_ != _loc4_)
               {
                  _a[_loc4_] = _a[_loc5_];
                  _loc4_++;
               }
               while(int(_loc14_.compare(_a[_loc4_])) > 0 && _loc4_ < _loc5_)
               {
                  _loc4_++;
               }
               if(_loc5_ != _loc4_)
               {
                  _a[_loc5_] = _a[_loc4_];
                  _loc5_--;
               }
            }
            _a[_loc4_] = _loc14_;
            _quickSortComparable(param1,_loc4_ - param1);
            _quickSortComparable(_loc4_ + 1,_loc3_ - _loc4_);
         }
      }
      
      public function _quickSort(param1:int, param2:int, param3:Function) : void
      {
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc10_:* = null as Object;
         var _loc11_:* = null as Object;
         var _loc12_:* = null as Object;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:* = null as Object;
         var _loc4_:* = param1 + param2 - 1;
         var _loc5_:int = param1;
         var _loc6_:int = _loc4_;
         if(param2 > 1)
         {
            _loc8_ = (_loc7_ = param1) + (param2 >> 1);
            _loc9_ = _loc7_ + param2 - 1;
            _loc10_ = _a[_loc7_];
            _loc11_ = _a[_loc8_];
            _loc12_ = _a[_loc9_];
            _loc14_ = param3(_loc10_,_loc12_);
            if(_loc14_ < 0 && param3(_loc10_,_loc11_) < 0)
            {
               _loc13_ = param3(_loc11_,_loc12_) < 0 ? _loc8_ : _loc9_;
            }
            else if(param3(_loc11_,_loc10_) < 0 && param3(_loc11_,_loc12_) < 0)
            {
               _loc13_ = _loc14_ < 0 ? _loc7_ : _loc9_;
            }
            else
            {
               _loc13_ = param3(_loc12_,_loc10_) < 0 ? _loc8_ : _loc7_;
            }
            _loc15_ = _a[_loc13_];
            _a[_loc13_] = _a[param1];
            while(_loc5_ < _loc6_)
            {
               while(param3(_loc15_,_a[_loc6_]) < 0 && _loc5_ < _loc6_)
               {
                  _loc6_--;
               }
               if(_loc6_ != _loc5_)
               {
                  _a[_loc5_] = _a[_loc6_];
                  _loc5_++;
               }
               while(param3(_loc15_,_a[_loc5_]) > 0 && _loc5_ < _loc6_)
               {
                  _loc5_++;
               }
               if(_loc6_ != _loc5_)
               {
                  _a[_loc6_] = _a[_loc5_];
                  _loc6_--;
               }
            }
            _a[_loc5_] = _loc15_;
            _quickSort(param1,_loc5_ - param1,param3);
            _quickSort(_loc5_ + 1,_loc4_ - _loc5_,param3);
         }
      }
      
      public function _insertionSortComparable() : void
      {
         var _loc3_:int = 0;
         var _loc4_:* = null as Object;
         var _loc5_:int = 0;
         var _loc6_:* = null as Object;
         var _loc1_:int = 1;
         var _loc2_:int = _size;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc1_++;
            _loc4_ = _a[_loc3_];
            null;
            _loc5_ = _loc3_;
            while(_loc5_ > 0)
            {
               _loc6_ = _a[_loc5_ - 1];
               null;
               if(int(_loc6_.compare(_loc4_)) <= 0)
               {
                  break;
               }
               _a[_loc5_] = _loc6_;
               _loc5_--;
            }
            _a[_loc5_] = _loc4_;
         }
      }
      
      public function _insertionSort(param1:Function) : void
      {
         var _loc4_:int = 0;
         var _loc5_:* = null as Object;
         var _loc6_:int = 0;
         var _loc7_:* = null as Object;
         var _loc2_:int = 1;
         var _loc3_:int = _size;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            _loc5_ = _a[_loc4_];
            _loc6_ = _loc4_;
            while(_loc6_ > 0)
            {
               _loc7_ = _a[_loc6_ - 1];
               if(param1(_loc7_,_loc5_) <= 0)
               {
                  break;
               }
               _a[_loc6_] = _loc7_;
               _loc6_--;
            }
            _a[_loc6_] = _loc5_;
         }
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
