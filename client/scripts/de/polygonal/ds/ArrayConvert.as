package de.polygonal.ds
{
   public class ArrayConvert
   {
       
      
      public function ArrayConvert()
      {
      }
      
      public static function toArray2(param1:Array, param2:int, param3:int) : Array2
      {
         var _loc8_:int = 0;
         null;
         null;
         var _loc4_:Array2;
         var _loc5_:Array = (_loc4_ = new Array2(param2,param3))._a;
         var _loc6_:int = 0;
         var _loc7_:int = int(param1.length);
         while(_loc6_ < _loc7_)
         {
            _loc8_ = _loc6_++;
            _loc5_[_loc8_] = param1[_loc8_];
         }
         return _loc4_;
      }
      
      public static function toArray3(param1:Array, param2:int, param3:int, param4:int) : Array3
      {
         var _loc9_:int = 0;
         null;
         null;
         var _loc5_:Array3;
         var _loc6_:Array = (_loc5_ = new Array3(param2,param3,param4))._a;
         var _loc7_:int = 0;
         var _loc8_:int = int(param1.length);
         while(_loc7_ < _loc8_)
         {
            _loc9_ = _loc7_++;
            _loc6_[_loc9_] = param1[_loc9_];
         }
         return _loc5_;
      }
      
      public static function toArrayedQueue(param1:Array) : ArrayedQueue
      {
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         var _loc6_:* = null as Array;
         var _loc7_:* = null as Array;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         null;
         null;
         var _loc2_:int = int(param1.length);
         var _loc3_:ArrayedQueue = new ArrayedQueue(_loc2_ > 0 && (_loc2_ & _loc2_ - 1) == 0 ? _loc2_ : (_loc4_ = _loc2_, _loc4_ |= _loc4_ >> 1, _loc4_ |= _loc4_ >> 2, _loc4_ |= _loc4_ >> 3, _loc4_ |= _loc4_ >> 4, (_loc4_ |= _loc4_ >> 5) + 1));
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = _loc4_++;
            if(_loc3_._capacity == _loc3_._size)
            {
               if(_loc3_._isResizable)
               {
                  ++_loc3_._sizeLevel;
                  null;
                  _loc6_ = _loc7_ = new Array(_loc3_._capacity << 1);
                  _loc8_ = 0;
                  _loc9_ = _loc3_._size;
                  while(_loc8_ < _loc9_)
                  {
                     _loc10_ = _loc8_++;
                     _loc3_._front = (_loc11_ = _loc3_._front) + 1;
                     _loc6_[_loc10_] = _loc3_._a[_loc11_];
                     if(_loc3_._front == _loc3_._capacity)
                     {
                        _loc3_._front = 0;
                     }
                  }
                  _loc3_._a = _loc6_;
                  _loc3_._front = 0;
                  _loc3_._capacity <<= 1;
               }
            }
            _loc3_._size = (_loc8_ = _loc3_._size) + 1;
            _loc3_._a[int((_loc8_ + _loc3_._front) % _loc3_._capacity)] = param1[_loc5_];
         }
         return _loc3_;
      }
      
      public static function toArrayedStack(param1:Array) : ArrayedStack
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         null;
         null;
         var _loc2_:ArrayedStack = new ArrayedStack(int(param1.length));
         var _loc3_:int = 0;
         var _loc4_:int = int(param1.length);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc2_._top = (_loc6_ = _loc2_._top) + 1;
            _loc2_._a[_loc6_] = param1[_loc5_];
         }
         return _loc2_;
      }
      
      public static function toSLL(param1:Array) : SLL
      {
         var _loc5_:int = 0;
         var _loc6_:* = null as Object;
         var _loc7_:* = null as SLLNode;
         var _loc8_:* = null as SLLNode;
         null;
         null;
         var _loc2_:SLL = new SLL();
         var _loc3_:int = 0;
         var _loc4_:int = int(param1.length);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc6_ = param1[_loc5_];
            _loc7_ = _loc2_._reservedSize == 0 || _loc2_._poolSize == 0 ? new SLLNode(_loc6_,_loc2_) : (null, _loc8_ = _loc2_._headPool, _loc2_._headPool = _loc2_._headPool.next, --_loc2_._poolSize, _loc8_.val = _loc6_, _loc8_.next = null, _loc8_);
            if(_loc2_.tail != null)
            {
               _loc2_.tail.next = _loc7_;
            }
            else
            {
               _loc2_.head = _loc7_;
            }
            _loc2_.tail = _loc7_;
            ++_loc2_._size;
            _loc7_;
         }
         return _loc2_;
      }
      
      public static function toDLL(param1:Array) : DLL
      {
         var _loc5_:int = 0;
         var _loc6_:* = null as Object;
         var _loc7_:* = null as DLLNode;
         var _loc8_:* = null as DLLNode;
         null;
         null;
         var _loc2_:DLL = new DLL();
         var _loc3_:int = 0;
         var _loc4_:int = int(param1.length);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc6_ = param1[_loc5_];
            _loc7_ = _loc2_._reservedSize == 0 || _loc2_._poolSize == 0 ? new DLLNode(_loc6_,_loc2_) : (_loc8_ = _loc2_._headPool, null, null, _loc2_._headPool = _loc2_._headPool.next, --_loc2_._poolSize, _loc8_.next = null, _loc8_.val = _loc6_, _loc8_);
            if(_loc2_.tail != null)
            {
               _loc2_.tail.next = _loc7_;
               _loc7_.prev = _loc2_.tail;
            }
            else
            {
               _loc2_.head = _loc7_;
            }
            _loc2_.tail = _loc7_;
            if(_loc2_._circular)
            {
               _loc2_.tail.next = _loc2_.head;
               _loc2_.head.prev = _loc2_.tail;
            }
            ++_loc2_._size;
            _loc7_;
         }
         return _loc2_;
      }
      
      public static function toLinkedQueue(param1:Array) : LinkedQueue
      {
         var _loc5_:int = 0;
         var _loc6_:* = null as Object;
         var _loc7_:* = null as LinkedQueueNode;
         var _loc8_:* = null as LinkedQueueNode;
         null;
         null;
         var _loc2_:LinkedQueue = new LinkedQueue();
         var _loc3_:int = 0;
         var _loc4_:int = int(param1.length);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc6_ = param1[_loc5_];
            ++_loc2_._size;
            _loc7_ = _loc2_._reservedSize == 0 || _loc2_._poolSize == 0 ? new LinkedQueueNode(_loc6_) : (_loc8_ = _loc2_._headPool, _loc2_._headPool = _loc2_._headPool.next, --_loc2_._poolSize, _loc8_.val = _loc6_, _loc8_);
            if(_loc2_._head == null)
            {
               _loc2_._head = _loc2_._tail = _loc7_;
               _loc2_._head.next = _loc2_._tail;
            }
            else
            {
               _loc2_._tail.next = _loc7_;
               _loc2_._tail = _loc7_;
            }
         }
         return _loc2_;
      }
      
      public static function toLinkedStack(param1:Array) : LinkedStack
      {
         var _loc5_:int = 0;
         var _loc6_:* = null as Object;
         var _loc7_:* = null as LinkedStackNode;
         var _loc8_:* = null as LinkedStackNode;
         null;
         null;
         var _loc2_:LinkedStack = new LinkedStack();
         var _loc3_:int = 0;
         var _loc4_:int = int(param1.length);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc6_ = param1[_loc5_];
            (_loc7_ = _loc2_._reservedSize == 0 || _loc2_._poolSize == 0 ? new LinkedStackNode(_loc6_) : (_loc8_ = _loc2_._headPool, _loc2_._headPool = _loc2_._headPool.next, --_loc2_._poolSize, _loc8_.val = _loc6_, _loc8_)).next = _loc2_._head;
            _loc2_._head = _loc7_;
            ++_loc2_._top;
         }
         return _loc2_;
      }
      
      public static function toDA(param1:Array) : DA
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         null;
         null;
         var _loc2_:DA = new DA(int(param1.length));
         var _loc3_:int = 0;
         var _loc4_:int = int(param1.length);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc3_++;
            _loc6_ = _loc2_._size;
            null;
            _loc2_._a[_loc6_] = param1[_loc5_];
            if(_loc6_ >= _loc2_._size)
            {
               ++_loc2_._size;
            }
         }
         return _loc2_;
      }
   }
}
