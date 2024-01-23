package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import flash.Boot;
   import flash.utils.Dictionary;
   
   public class HashMap implements Map
   {
       
      
      public var maxSize:int;
      
      public var key:int;
      
      public var _weak:Boolean;
      
      public var _size:int;
      
      public var _map:Dictionary;
      
      public function HashMap(param1:Boolean = false, param2:int = -1)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _map = new Dictionary(_weak = param1);
         _size = 0;
         var _loc4_:int;
         HashKey._counter = (_loc4_ = int(HashKey._counter)) + 1;
         key = _loc4_;
         maxSize = -1;
      }
      
      public function toValSet() : Set
      {
         var _loc6_:* = null as Object;
         var _loc1_:ListSet = new ListSet();
         var _loc4_:* = 0;
         var _loc3_:Array = [];
         var _loc5_:* = _map;
         for(_loc4_ in _loc5_)
         {
            _loc3_.push(_loc4_);
         }
         var _loc2_:Array = _loc3_;
         _loc4_ = 0;
         while(_loc4_ < int(_loc2_.length))
         {
            _loc6_ = _loc2_[_loc4_];
            _loc4_++;
            _loc1_.set(_map[_loc6_]);
         }
         return _loc1_;
      }
      
      public function toString() : String
      {
         return Sprintf.format("{HashMap, size: %d}",[_size]);
      }
      
      public function toKeySet() : Set
      {
         var _loc6_:* = null as Object;
         var _loc1_:ListSet = new ListSet();
         var _loc4_:* = 0;
         var _loc3_:Array = [];
         var _loc5_:* = _map;
         for(_loc4_ in _loc5_)
         {
            _loc3_.push(_loc4_);
         }
         var _loc2_:Array = _loc3_;
         _loc4_ = 0;
         while(_loc4_ < int(_loc2_.length))
         {
            _loc6_ = _loc2_[_loc4_];
            _loc4_++;
            _loc1_.set(_loc6_);
         }
         return _loc1_;
      }
      
      public function toKeyDA() : DA
      {
         return ArrayConvert.toDA(toKeyArray());
      }
      
      public function toKeyArray() : Array
      {
         var _loc2_:* = 0;
         var _loc1_:Array = [];
         var _loc3_:* = _map;
         for(_loc2_ in _loc3_)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function toDA() : DA
      {
         var _loc3_:* = null as Object;
         var _loc4_:int = 0;
         var _loc1_:DA = new DA(_size);
         var _loc2_:* = iterator();
         while(_loc2_.hasNext())
         {
            _loc3_ = _loc2_.next();
            _loc4_ = _loc1_._size;
            null;
            _loc1_._a[_loc4_] = _loc3_;
            if(_loc4_ >= _loc1_._size)
            {
               ++_loc1_._size;
            }
         }
         return _loc1_;
      }
      
      public function toArray() : Array
      {
         var _loc4_:* = null as Object;
         null;
         var _loc2_:Array = new Array(_size);
         var _loc1_:Array = _loc2_;
         var _loc3_:* = iterator();
         while(_loc3_.hasNext())
         {
            _loc4_ = _loc3_.next();
            _loc1_.push(_loc4_);
         }
         return _loc1_;
      }
      
      public function size() : int
      {
         return _size;
      }
      
      public function set(param1:Object, param2:Object) : Boolean
      {
         var _loc3_:Object = param1;
         var _loc4_:Object = param2;
         var _loc5_:Object;
         if((_loc5_ = _map[_loc3_]) != null)
         {
            return false;
         }
         _map[_loc3_] = _loc4_;
         ++_size;
         return true;
      }
      
      public function remove(param1:Object) : Boolean
      {
         var _loc5_:* = null as Array;
         var _loc6_:* = null as Array;
         var _loc7_:* = 0;
         var _loc8_:* = null;
         var _loc9_:* = null as Object;
         var _loc2_:Object = param1;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         _loc7_ = 0;
         _loc6_ = [];
         _loc8_ = _map;
         for(_loc7_ in _loc8_)
         {
            _loc6_.push(_loc7_);
         }
         _loc5_ = _loc6_;
         _loc7_ = 0;
         while(_loc7_ < int(_loc5_.length))
         {
            _loc9_ = _loc5_[_loc7_];
            _loc7_++;
            if(_map[_loc9_] == _loc2_)
            {
               _loc4_ = true;
               break;
            }
         }
         if(_loc4_)
         {
            _loc7_ = 0;
            _loc6_ = [];
            _loc8_ = _map;
            for(_loc7_ in _loc8_)
            {
               _loc6_.push(_loc7_);
            }
            _loc5_ = _loc6_;
            _loc7_ = 0;
            while(_loc7_ < int(_loc5_.length))
            {
               _loc9_ = _loc5_[_loc7_];
               _loc7_++;
               if(_map[_loc9_] == _loc2_)
               {
                  delete _map[_loc9_];
                  --_size;
                  _loc3_ = true;
               }
            }
         }
         return _loc3_;
      }
      
      public function remap(param1:Object, param2:Object) : Boolean
      {
         var _loc5_:* = null as Object;
         var _loc3_:Object = param1;
         var _loc4_:Object = param2;
         if((_loc5_ = _map[_loc3_]) != null)
         {
            if((_loc5_ = _map[_loc3_]) != null)
            {
               false;
            }
            else
            {
               _map[_loc3_] = _loc4_;
               ++_size;
               true;
            }
            return true;
         }
         return false;
      }
      
      public function keys() : Itr
      {
         return new HashMapKeyIterator(this);
      }
      
      public function iterator() : Itr
      {
         return new HashMapValIterator(this);
      }
      
      public function isEmpty() : Boolean
      {
         return _size == 0;
      }
      
      public function hasKey(param1:Object) : Boolean
      {
         var _loc2_:Object = param1;
         var _loc3_:Object = _map[_loc2_];
         return _loc3_ != null;
      }
      
      public function has(param1:Object) : Boolean
      {
         var _loc8_:* = null as Object;
         var _loc2_:Object = param1;
         var _loc3_:Boolean = false;
         var _loc6_:* = 0;
         var _loc5_:Array = [];
         var _loc7_:* = _map;
         for(_loc6_ in _loc7_)
         {
            _loc5_.push(_loc6_);
         }
         var _loc4_:Array = _loc5_;
         _loc6_ = 0;
         while(_loc6_ < int(_loc4_.length))
         {
            _loc8_ = _loc4_[_loc6_];
            _loc6_++;
            if(_map[_loc8_] == _loc2_)
            {
               _loc3_ = true;
               break;
            }
         }
         return _loc3_;
      }
      
      public function get(param1:Object) : Object
      {
         var _loc2_:Object = param1;
         return _map[_loc2_];
      }
      
      public function free() : void
      {
         var _loc1_:* = null as Array;
         var _loc2_:* = null as Array;
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc5_:* = null as Object;
         if(!_weak)
         {
            _loc3_ = 0;
            _loc2_ = [];
            _loc4_ = _map;
            for(_loc3_ in _loc4_)
            {
               _loc2_.push(_loc3_);
            }
            _loc1_ = _loc2_;
            _loc3_ = 0;
            while(_loc3_ < int(_loc1_.length))
            {
               _loc5_ = _loc1_[_loc3_];
               _loc3_++;
               delete _map[_loc5_];
            }
         }
         _map = null;
      }
      
      public function contains(param1:Object) : Boolean
      {
         var _loc8_:* = null as Object;
         var _loc2_:Object = param1;
         var _loc3_:Boolean = false;
         var _loc6_:* = 0;
         var _loc5_:Array = [];
         var _loc7_:* = _map;
         for(_loc6_ in _loc7_)
         {
            _loc5_.push(_loc6_);
         }
         var _loc4_:Array = _loc5_;
         _loc6_ = 0;
         while(_loc6_ < int(_loc4_.length))
         {
            _loc8_ = _loc4_[_loc6_];
            _loc6_++;
            if(_map[_loc8_] == _loc2_)
            {
               _loc3_ = true;
               break;
            }
         }
         return _loc3_;
      }
      
      public function clr(param1:Object) : Boolean
      {
         var _loc2_:Object = param1;
         if(_map[_loc2_] != null)
         {
            delete _map[_loc2_];
            --_size;
            return true;
         }
         return false;
      }
      
      public function clone(param1:Boolean, param2:Object = undefined) : Collection
      {
         var _loc7_:* = 0;
         var _loc9_:* = null as Object;
         var _loc10_:* = null as Object;
         var _loc11_:* = null as Cloneable;
         var _loc3_:* = param2;
         var _loc4_:HashMap = new HashMap(_weak,maxSize);
         _loc7_ = 0;
         var _loc6_:Array = [];
         var _loc8_:* = _map;
         for(_loc7_ in _loc8_)
         {
            _loc6_.push(_loc7_);
         }
         var _loc5_:Array = _loc6_;
         if(param1)
         {
            _loc7_ = 0;
            while(_loc7_ < int(_loc5_.length))
            {
               _loc9_ = _loc5_[_loc7_];
               _loc7_++;
               if((_loc10_ = _loc4_._map[_loc9_]) != null)
               {
                  false;
               }
               else
               {
                  _loc4_._map[_loc9_] = _map[_loc9_];
                  ++_loc4_._size;
                  true;
               }
            }
         }
         else if(_loc3_ == null)
         {
            _loc7_ = 0;
            while(_loc7_ < int(_loc5_.length))
            {
               _loc9_ = _loc5_[_loc7_];
               _loc7_++;
               null;
               _loc11_ = _map[_loc9_];
               if((_loc10_ = _loc4_._map[_loc9_]) != null)
               {
                  false;
               }
               else
               {
                  _loc4_._map[_loc9_] = _map[_loc9_];
                  ++_loc4_._size;
                  true;
               }
            }
         }
         else
         {
            _loc7_ = 0;
            while(_loc7_ < int(_loc5_.length))
            {
               _loc9_ = _loc5_[_loc7_];
               _loc7_++;
               if((_loc10_ = _loc4_._map[_loc9_]) != null)
               {
                  false;
               }
               else
               {
                  _loc4_._map[_loc9_] = _loc3_(_map[_loc9_]);
                  ++_loc4_._size;
                  true;
               }
            }
         }
         return _loc4_;
      }
      
      public function clear(param1:Boolean = false) : void
      {
         var _loc6_:* = null as Object;
         var _loc4_:* = 0;
         var _loc3_:Array = [];
         var _loc5_:* = _map;
         for(_loc4_ in _loc5_)
         {
            _loc3_.push(_loc4_);
         }
         var _loc2_:Array = _loc3_;
         _loc4_ = 0;
         while(_loc4_ < int(_loc2_.length))
         {
            _loc6_ = _loc2_[_loc4_];
            _loc4_++;
            delete _map[_loc6_];
         }
         _size = 0;
      }
   }
}
