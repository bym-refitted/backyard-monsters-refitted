package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import de.polygonal.core.util.Instance;
   import flash.Boot;
   
   public class Array3 implements Collection
   {
       
      
      public var key:int;
      
      public var _w:int;
      
      public var _h:int;
      
      public var _d:int;
      
      public var _a:Array;
      
      public function Array3(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         null;
         _w = param1;
         _h = param2;
         _d = param3;
         null;
         var _loc4_:Array;
         _a = _loc4_ = new Array(_w * _h * _d);
         var _loc5_:int;
         HashKey._counter = (_loc5_ = int(HashKey._counter)) + 1;
         key = _loc5_;
      }
      
      public function walk(param1:Function) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:int = _d;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            _loc5_ = 0;
            _loc6_ = _h;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = _loc5_++;
               _loc8_ = 0;
               _loc9_ = _w;
               while(_loc8_ < _loc9_)
               {
                  _loc10_ = _loc8_++;
                  _loc11_ = _loc4_ * _w * _h + _loc7_ * _w + _loc10_;
                  _a[_loc11_] = param1(_a[_loc11_],_loc10_,_loc7_,_loc4_);
               }
            }
         }
      }
      
      public function toString() : String
      {
         return Sprintf.format("{Array3, %dx%dx%d}",[_w,_h,_d]);
      }
      
      public function toDA() : DA
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:DA = new DA(_w * _h * _d);
         var _loc2_:int = 0;
         var _loc3_:* = _w * _h * _d;
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
         var _loc2_:Array = new Array(_w * _h * _d);
         var _loc1_:Array = _loc2_;
         var _loc3_:int = 0;
         var _loc4_:* = _w * _h * _d;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc1_[_loc5_] = _a[_loc5_];
         }
         return _loc1_;
      }
      
      public function swap(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : void
      {
         null;
         null;
         null;
         null;
         null;
         null;
         null;
         var _loc7_:* = param3 * _w * _h + param2 * _w + param1;
         var _loc8_:* = param6 * _w * _h + param5 * _w + param4;
         var _loc9_:Object = _a[_loc7_];
         _a[_loc7_] = _a[_loc8_];
         _a[_loc8_] = _loc9_;
      }
      
      public function size() : int
      {
         return _w * _h * _d;
      }
      
      public function shuffle(param1:DA = undefined) : void
      {
         var _loc3_:* = null as Class;
         var _loc4_:int = 0;
         var _loc5_:* = null as Object;
         var _loc6_:int = 0;
         var _loc2_:* = _w * _h * _d;
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
      
      public function setW(param1:int) : void
      {
         resize(param1,_h,_d);
      }
      
      public function setRow(param1:int, param2:int, param3:Array) : void
      {
         var _loc7_:int = 0;
         null;
         null;
         null;
         null;
         var _loc4_:* = param1 * _w * _h + param2 * _w;
         var _loc5_:int = 0;
         var _loc6_:int = _w;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            _a[_loc4_ + _loc7_] = param3[_loc7_];
         }
      }
      
      public function setPile(param1:int, param2:int, param3:Array) : void
      {
         var _loc8_:int = 0;
         null;
         null;
         null;
         null;
         var _loc4_:* = _w * _h;
         var _loc5_:* = param2 * _w + param1;
         var _loc6_:int = 0;
         var _loc7_:int = _d;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = _loc6_++;
            _a[_loc8_ * _loc4_ + _loc5_] = param3[_loc8_];
         }
      }
      
      public function setH(param1:int) : void
      {
         resize(_w,param1,_d);
      }
      
      public function setD(param1:int) : void
      {
         resize(_w,_h,param1);
      }
      
      public function setCol(param1:int, param2:int, param3:Array) : void
      {
         var _loc7_:int = 0;
         null;
         null;
         null;
         null;
         var _loc4_:* = param1 * _w * _h;
         var _loc5_:int = 0;
         var _loc6_:int = _h;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            _a[_loc4_ + (_loc7_ * _w + param2)] = param3[_loc7_];
         }
      }
      
      public function set(param1:int, param2:int, param3:int, param4:Object) : void
      {
         null;
         null;
         null;
         _a[param3 * _w * _h + param2 * _w + param1] = param4;
      }
      
      public function resize(param1:int, param2:int, param3:int) : void
      {
         var _loc10_:int = 0;
         var _loc11_:* = 0;
         var _loc12_:* = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:* = 0;
         var _loc16_:* = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         null;
         if(param1 == _w && param2 == _h && param3 == _d)
         {
            return;
         }
         var _loc4_:Array = _a;
         null;
         var _loc5_:Array;
         _a = _loc5_ = new Array(param1 * param2 * param3);
         var _loc6_:int = param1 < _w ? param1 : _w;
         var _loc7_:int = param2 < _h ? param2 : _h;
         var _loc8_:int = param3 < _d ? param3 : _d;
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            _loc11_ = (_loc10_ = _loc9_++) * param1 * param2;
            _loc12_ = _loc10_ * _w * _h;
            _loc13_ = 0;
            while(_loc13_ < _loc7_)
            {
               _loc15_ = (_loc14_ = _loc13_++) * param1;
               _loc16_ = _loc14_ * _w;
               _loc17_ = 0;
               while(_loc17_ < _loc6_)
               {
                  _loc18_ = _loc17_++;
                  _a[_loc11_ + _loc15_ + _loc18_] = _loc4_[_loc12_ + _loc16_ + _loc18_];
               }
            }
         }
         _w = param1;
         _h = param2;
         _d = param3;
      }
      
      public function remove(param1:Object) : Boolean
      {
         var _loc6_:int = 0;
         var _loc2_:Object = param1;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:* = _w * _h * _d;
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
      
      public function iterator() : Itr
      {
         return new Array3Iterator(this);
      }
      
      public function isEmpty() : Boolean
      {
         return false;
      }
      
      public function indexToCell(param1:int, param2:Array3Cell) : Array3Cell
      {
         null;
         null;
         var _loc3_:* = _w * _h;
         var _loc4_:int = param1 % _loc3_;
         param2.z = int(param1 / _loc3_);
         param2.y = int(_loc4_ / _w);
         param2.x = int(_loc4_ % _w);
         return param2;
      }
      
      public function indexOf(param1:Object) : int
      {
         var _loc2_:int = 0;
         var _loc3_:* = _w * _h * _d;
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
      
      public function getRow(param1:int, param2:int, param3:Array) : Array
      {
         var _loc7_:int = 0;
         null;
         null;
         null;
         var _loc4_:* = param1 * _w * _h + param2 * _w;
         var _loc5_:int = 0;
         var _loc6_:int = _w;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            param3.push(_a[_loc4_ + _loc7_]);
         }
         return param3;
      }
      
      public function getPile(param1:int, param2:int, param3:Array) : Array
      {
         var _loc8_:int = 0;
         null;
         null;
         null;
         var _loc4_:* = _w * _h;
         var _loc5_:* = param2 * _w + param1;
         var _loc6_:int = 0;
         var _loc7_:int = _d;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = _loc6_++;
            param3.push(_a[_loc8_ * _loc4_ + _loc5_]);
         }
         return param3;
      }
      
      public function getLayer(param1:int, param2:Array2) : Array2
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         null;
         null;
         null;
         var _loc3_:* = param1 * _w * _h;
         var _loc4_:int = 0;
         var _loc5_:int = _w;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc4_++;
            _loc7_ = 0;
            _loc8_ = _h;
            while(_loc7_ < _loc8_)
            {
               _loc9_ = _loc7_++;
               null;
               null;
               param2._a[_loc9_ * param2._w + _loc6_] = _a[_loc3_ + _loc9_ * _w + _loc6_];
            }
         }
         return param2;
      }
      
      public function getIndex(param1:int, param2:int, param3:int) : int
      {
         return param3 * _w * _h + param2 * _w + param1;
      }
      
      public function getH() : int
      {
         return _h;
      }
      
      public function getD() : int
      {
         return _d;
      }
      
      public function getCol(param1:int, param2:int, param3:Array) : Array
      {
         var _loc7_:int = 0;
         null;
         null;
         null;
         var _loc4_:* = param1 * _w * _h;
         var _loc5_:int = 0;
         var _loc6_:int = _h;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            param3.push(_a[_loc4_ + (_loc7_ * _w + param2)]);
         }
         return param3;
      }
      
      public function getArray() : Array
      {
         return _a;
      }
      
      public function get(param1:int, param2:int, param3:int) : Object
      {
         null;
         null;
         null;
         return _a[param3 * _w * _h + param2 * _w + param1];
      }
      
      public function free() : void
      {
         var _loc4_:int = 0;
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:* = _w * _h * _d;
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
         var _loc3_:* = _w * _h * _d;
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
         var _loc4_:* = _w * _h * _d;
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
         var _loc4_:Array3 = new Array3(_w,_h,_d);
         if(param1)
         {
            _loc5_ = 0;
            _loc6_ = _w * _h * _d;
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
            _loc6_ = _w * _h * _d;
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
            _loc6_ = _w * _h * _d;
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
            _a[_loc5_] = null;
         }
      }
      
      public function cellToIndex(param1:Array3Cell) : int
      {
         null;
         null;
         null;
         null;
         return param1.z * _w * _h + param1.y * _w + param1.x;
      }
      
      public function cellOf(param1:Object, param2:Array3Cell) : Array3Cell
      {
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         null;
         _loc4_ = 0;
         _loc5_ = _w * _h * _d;
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
         _loc4_ = _w * _h;
         _loc5_ = _loc3_ % _loc4_;
         param2.z = int(_loc3_ / _loc4_);
         param2.y = int(_loc5_ / _w);
         param2.x = int(_loc5_ % _w);
         return param2;
      }
      
      public function assign(param1:Class, param2:Array = undefined) : void
      {
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = _w * _h * _d;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _a[_loc5_] = Instance.create(param1,param2);
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
   }
}
