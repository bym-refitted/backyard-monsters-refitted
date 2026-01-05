package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import de.polygonal.core.util.Instance;
   import flash.Boot;
   
   public class Array2 implements Collection
   {
       
      
      public var key:int;
      
      public var _w:int;
      
      public var _h:int;
      
      public var _a:Array;
      
      public function Array2(param1:int = 0, param2:int = 0)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         null;
         _w = param1;
         _h = param2;
         null;
         var _loc3_:Array = new Array(_w * _h);
         _a = _loc3_;
         var _loc4_:int;
         HashKey._counter = (_loc4_ = int(HashKey._counter)) + 1;
         key = _loc4_;
      }
      
      public function walk(param1:Function) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:int = _h;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            _loc5_ = 0;
            _loc6_ = _w;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = _loc5_++;
               _loc8_ = _loc4_ * _w + _loc7_;
               _a[_loc8_] = param1(_a[_loc8_],_loc7_,_loc4_);
            }
         }
      }
      
      public function transpose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc9_:* = null as Object;
         var _loc10_:* = null as Array;
         if(_w == _h)
         {
            _loc1_ = 0;
            _loc2_ = _h;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = _loc1_++;
               _loc4_ = _loc3_ + 1;
               _loc5_ = _w;
               while(_loc4_ < _loc5_)
               {
                  _loc6_ = _loc4_++;
                  null;
                  null;
                  null;
                  null;
                  null;
                  _loc7_ = _loc3_ * _w + _loc6_;
                  _loc8_ = _loc6_ * _w + _loc3_;
                  _loc9_ = _a[_loc7_];
                  _a[_loc7_] = _a[_loc8_];
                  _a[_loc8_] = _loc9_;
               }
            }
         }
         else
         {
            _loc10_ = [];
            _loc1_ = 0;
            _loc2_ = _h;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = _loc1_++;
               _loc4_ = 0;
               _loc5_ = _w;
               while(_loc4_ < _loc5_)
               {
                  _loc6_ = _loc4_++;
                  null;
                  null;
                  _loc10_[_loc6_ * _h + _loc3_] = _a[_loc3_ * _w + _loc6_];
               }
            }
            _a = _loc10_;
            _w ^= _h;
            _h ^= _w;
            _w ^= _h;
         }
      }
      
      public function toString() : String
      {
         return Sprintf.format("{Array2, %dx%d}",[_w,_h]);
      }
      
      public function toDA() : DA
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:DA = new DA(_w * _h);
         var _loc2_:int = 0;
         var _loc3_:* = _w * _h;
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
         var _loc2_:Array = new Array(_w * _h);
         var _loc1_:Array = _loc2_;
         var _loc3_:int = 0;
         var _loc4_:* = _w * _h;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc1_[_loc5_] = _a[_loc5_];
         }
         return _loc1_;
      }
      
      public function swap(param1:int, param2:int, param3:int, param4:int) : void
      {
         null;
         null;
         null;
         null;
         null;
         var _loc5_:* = param2 * _w + param1;
         var _loc6_:* = param4 * _w + param3;
         var _loc7_:Object = _a[_loc5_];
         _a[_loc5_] = _a[_loc6_];
         _a[_loc6_] = _loc7_;
      }
      
      public function size() : int
      {
         return _w * _h;
      }
      
      public function shuffle(param1:DA = undefined) : void
      {
         var _loc3_:* = null as Class;
         var _loc4_:int = 0;
         var _loc5_:* = null as Object;
         var _loc6_:int = 0;
         var _loc2_:* = _w * _h;
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
      
      public function shiftW() : void
      {
         var _loc1_:* = null as Object;
         var _loc2_:* = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = _h;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = (_loc5_ = _loc3_++) * _w;
            _loc1_ = _a[_loc2_];
            _loc6_ = 1;
            _loc7_ = _w;
            while(_loc6_ < _loc7_)
            {
               _loc8_ = _loc6_++;
               _a[_loc2_ + _loc8_ - 1] = _a[_loc2_ + _loc8_];
            }
            _a[_loc2_ + _w - 1] = _loc1_;
         }
      }
      
      public function shiftS() : void
      {
         var _loc1_:* = null as Object;
         var _loc3_:int = 0;
         var _loc8_:int = 0;
         var _loc4_:*;
         var _loc5_:* = (_loc4_ = _h - 1) * _w;
         var _loc6_:int = 0;
         var _loc7_:int = _w;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = _loc6_++;
            _loc1_ = _a[_loc5_ + _loc8_];
            _loc3_ = _loc4_;
            while(_loc3_-- > 0)
            {
               _a[(_loc3_ + 1) * _w + _loc8_] = _a[_loc3_ * _w + _loc8_];
            }
            _a[_loc8_] = _loc1_;
         }
      }
      
      public function shiftN() : void
      {
         var _loc1_:* = null as Object;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:* = _h - 1;
         var _loc3_:* = (_h - 1) * _w;
         var _loc4_:int = 0;
         var _loc5_:int = _w;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            _loc1_ = _a[_loc6_];
            _loc7_ = 0;
            while(_loc7_ < _loc2_)
            {
               _loc8_ = _loc7_++;
               _a[_loc8_ * _w + _loc6_] = _a[(_loc8_ + 1) * _w + _loc6_];
            }
            _a[_loc3_ + _loc6_] = _loc1_;
         }
      }
      
      public function shiftE() : void
      {
         var _loc1_:* = null as Object;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = _h;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = (_loc6_ = _loc4_++) * _w;
            _loc1_ = _a[_loc3_ + _w - 1];
            _loc2_ = _w - 1;
            while(_loc2_-- > 0)
            {
               _a[_loc3_ + _loc2_ + 1] = _a[_loc3_ + _loc2_];
            }
            _a[_loc3_] = _loc1_;
         }
      }
      
      public function setW(param1:int) : void
      {
         resize(param1,_h);
      }
      
      public function setRow(param1:int, param2:Array) : void
      {
         var _loc6_:int = 0;
         null;
         null;
         null;
         var _loc3_:* = param1 * _w;
         var _loc4_:int = 0;
         var _loc5_:int = _w;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            _a[_loc3_ + _loc6_] = param2[_loc6_];
         }
      }
      
      public function setH(param1:int) : void
      {
         resize(_w,param1);
      }
      
      public function setCol(param1:int, param2:Array) : void
      {
         var _loc5_:int = 0;
         null;
         null;
         null;
         var _loc3_:int = 0;
         var _loc4_:int = _h;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _a[_loc5_ * _w + param1] = param2[_loc5_];
         }
      }
      
      public function setAtIndex(param1:int, param2:Object) : void
      {
         // Comment:  Rewritten function - no return needed for void return type
         // null;
         _a[int(param1 / _w) * _w + int(param1 % _w)] = param2;
      }
      
      public function set(param1:int, param2:int, param3:Object) : void
      {
         null;
         null;
         _a[param2 * _w + param1] = param3;
      }
      
      public function resize(param1:int, param2:int) : void
      {
         var _loc8_:int = 0;
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         null;
         if(param1 == _w && param2 == _h)
         {
            return;
         }
         var _loc3_:Array = _a;
         null;
         var _loc4_:Array;
         _a = _loc4_ = new Array(param1 * param2);
         var _loc5_:int = param1 < _w ? param1 : _w;
         var _loc6_:int = param2 < _h ? param2 : _h;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc9_ = (_loc8_ = _loc7_++) * param1;
            _loc10_ = _loc8_ * _w;
            _loc11_ = 0;
            while(_loc11_ < _loc5_)
            {
               _loc12_ = _loc11_++;
               _a[_loc9_ + _loc12_] = _loc3_[_loc10_ + _loc12_];
            }
         }
         _w = param1;
         _h = param2;
      }
      
      public function remove(param1:Object) : Boolean
      {
         var _loc6_:int = 0;
         var _loc2_:Object = param1;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:* = _w * _h;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            if(_a[_loc6_] == _loc2_)
            {
               _a[_loc6_] = null;
               _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      public function prependRow(param1:Array) : void
      {
         null;
         null;
         ++_h;
         var _loc2_:* = _w * _h;
         while(_loc2_-- > _w)
         {
            _a[_loc2_] = _a[_loc2_ - _w];
         }
         _loc2_++;
         while(_loc2_-- > 0)
         {
            _a[_loc2_] = param1[_loc2_];
         }
      }
      
      public function prependCol(param1:Array) : void
      {
         null;
         null;
         var _loc2_:* = _w * _h + _h;
         var _loc3_:* = _h - 1;
         var _loc4_:int = _h;
         var _loc5_:int = 0;
         var _loc6_:int = _loc2_;
         while(_loc6_-- > 0)
         {
            _loc5_++;
            if(_loc5_ > _w)
            {
               _loc5_ = 0;
               _loc4_--;
               _a[_loc6_] = param1[_loc3_--];
            }
            else
            {
               _a[_loc6_] = _a[_loc6_ - _loc4_];
            }
         }
         ++_w;
      }
      
      public function iterator() : Itr
      {
         return new Array2Iterator(this);
      }
      
      public function isEmpty() : Boolean
      {
         return false;
      }
      
      public function indexToCell(param1:int, param2:Array2Cell) : Array2Cell
      {
         null;
         null;
         param2.y = int(param1 / _w);
         param2.x = int(param1 % _w);
         return param2;
      }
      
      public function indexOf(param1:Object) : int
      {
         var _loc2_:int = 0;
         var _loc3_:* = _w * _h;
         while(_loc2_ < _loc3_)
         {
            if(_a[_loc2_] == param1)
            {
               break;
            }
            _loc2_++;
         }
         return _loc2_ == _loc3_ ? -1 : _loc2_;
      }
      
      public function getW() : int
      {
         return _w;
      }
      
      public function getRow(param1:int, param2:Array) : Array
      {
         var _loc6_:int = 0;
         null;
         null;
         var _loc3_:* = param1 * _w;
         var _loc4_:int = 0;
         var _loc5_:int = _w;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            param2[_loc6_] = _a[_loc3_ + _loc6_];
         }
         return param2;
      }
      
      public function getIndex(param1:int, param2:int) : int
      {
         return param2 * _w + param1;
      }
      
      public function getH() : int
      {
         return _h;
      }
      
      public function getCol(param1:int, param2:Array) : Array
      {
         var _loc5_:int = 0;
         null;
         null;
         var _loc3_:int = 0;
         var _loc4_:int = _h;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            param2[_loc5_] = _a[_loc5_ * _w + param1];
         }
         return param2;
      }
      
      public function getAtIndex(param1:int) : Object
      {
         null;
         return _a[int(param1 / _w) * _w + int(param1 % _w)];
      }
      
      public function getArray() : Array
      {
         return _a;
      }
      
      public function get(param1:int, param2:int) : Object
      {
         null;
         null;
         return _a[param2 * _w + param1];
      }
      
      public function free() : void
      {
         var _loc4_:int = 0;
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:* = _w * _h;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            _a[_loc4_] = _loc1_;
         }
         _a = null;
      }
      
      public function fill(param1:Object) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:* = _w * _h;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            _a[_loc4_] = param1;
         }
      }
      
      public function contains(param1:Object) : Boolean
      {
         var _loc5_:int = 0;
         var _loc2_:Object = param1;
         var _loc3_:int = 0;
         var _loc4_:* = _w * _h;
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
         var _loc5_:int = 0;
         var _loc6_:* = 0;
         var _loc7_:int = 0;
         var _loc8_:* = null as Cloneable;
         var _loc3_:* = param2;
         var _loc4_:Array2 = new Array2(_w,_h);
         if(param1)
         {
            _loc5_ = 0;
            _loc6_ = _w * _h;
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
            _loc6_ = _w * _h;
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
            _loc6_ = _w * _h;
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
         var _loc5_:int = 0;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = int(_a.length);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _a[_loc5_] = _loc2_;
         }
      }
      
      public function cellToIndex(param1:Array2Cell) : int
      {
         null;
         null;
         null;
         return param1.y * _w + param1.x;
      }
      
      public function cellOf(param1:Object, param2:Array2Cell) : Array2Cell
      {
         null;
         var _loc4_:int = 0;
         var _loc5_:* = _w * _h;
         while(_loc4_ < _loc5_)
         {
            if(_a[_loc4_] == param1)
            {
               break;
            }
            _loc4_++;
         }
         var _loc3_:int = _loc4_ == _loc5_ ? -1 : _loc4_;
         if(_loc3_ == -1)
         {
            return null;
         }
         null;
         null;
         param2.y = int(_loc3_ / _w);
         param2.x = int(_loc3_ % _w);
         return param2;
      }
      
      public function assign(param1:Class, param2:Array = undefined) : void
      {
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = _w * _h;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _a[_loc5_] = Instance.create(param1,param2);
         }
      }
      
      public function appendRow(param1:Array) : void
      {
         var _loc5_:int = 0;
         null;
         null;
         var _loc3_:int;
         _h = (_loc3_ = _h) + 1;
         var _loc2_:* = _w * _loc3_;
         _loc3_ = 0;
         var _loc4_:int = _w;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _a[_loc5_ + _loc2_] = param1[_loc5_];
         }
      }
      
      public function appendCol(param1:Array) : void
      {
         null;
         null;
         var _loc2_:* = _w * _h + _h;
         var _loc3_:* = _h - 1;
         var _loc4_:int = _h;
         var _loc5_:int = _w;
         var _loc6_:int = _loc2_;
         while(_loc6_-- > 0)
         {
            _loc5_++;
            if(_loc5_ > _w)
            {
               _loc5_ = 0;
               _loc4_--;
               _a[_loc6_] = param1[_loc3_--];
            }
            else
            {
               _a[_loc6_] = _a[_loc6_ - _loc4_];
            }
         }
         ++_w;
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
