package org.kissmyas.utils.loanshark
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class LoanShark
   {
      
      public static const EVENT_CLEANED:String = "cleaned";
      
      public static const EVENT_FLUSHED:String = "flushed";
      
      public static const EVENT_DISPOSED:String = "disposed";
      
      public static const ERROR_RECYCLE_UNUSED:int = 1;
      
      public static const ERROR_NULL_CHECK_IN:int = 2;
      
      public static const ERROR_CHECK_IN_TYPE:int = 3;
      
      public static const ERROR_MULTI_CHECK_IN:int = 4;
       
      
      private var _ObjectClass:Class;
      
      private var _size:int;
      
      private var _bufferSize:int;
      
      private var _pool:Array;
      
      private var _objectsInUse:Array;
      
      private var _maxBuffer:uint;
      
      private var _initObject:Object;
      
      private var _resetMethod:String;
      
      private var _disposeMethod:String;
      
      private var _dispatcher:EventDispatcher;
      
      private var _idealArrayInitialSize:uint = 500;
      
      private var _strictMode:Boolean;
      
      public function LoanShark(param1:Class, param2:Boolean = false, param3:uint = 0, param4:uint = 0, param5:Object = null, param6:String = "", param7:String = "")
      {
         super();
         this._dispatcher = new EventDispatcher();
         this._ObjectClass = param1;
         this._strictMode = param2;
         if(param3 > this._idealArrayInitialSize)
         {
            this._idealArrayInitialSize = param3;
         }
         this.flush();
         this._maxBuffer = param4;
         this._initObject = param5;
         this._resetMethod = param6;
         this._disposeMethod = param7;
         var _loc8_:uint = param3;
         while(_loc8_--)
         {
            this.createAndAddObject();
         }
      }
      
      public function borrowObject() : *
      {
         var _loc1_:* = undefined;
         if(this._bufferSize == 0)
         {
            _loc1_ = this.createObject();
         }
         else
         {
            _loc1_ = this._pool[--this._bufferSize];
         }
         if(this._strictMode)
         {
            this._objectsInUse.push(_loc1_);
         }
         return _loc1_;
      }
      
      public function returnObject(param1:*) : void
      {
         var _loc4_:int = 0;
         var _loc2_:* = param1 is this._ObjectClass;
         var _loc3_:Boolean = false;
         if(this._strictMode)
         {
            if((_loc4_ = this._objectsInUse.indexOf(param1)) == -1)
            {
               _loc3_ = true;
            }
            else
            {
               this._objectsInUse.splice(_loc4_,1);
            }
         }
         if(param1 && _loc2_ && this.used > 0 && !_loc3_)
         {
            this.addToPool(param1,true);
         }
         else if(this._strictMode)
         {
            if(!this.used)
            {
               throw new Error("You cannot return an object to a pool with no checked-out items. The specified object did not appear to come from this pool.",ERROR_RECYCLE_UNUSED);
            }
            if(param1 == null)
            {
               throw new Error("You cannot return a null object reference to the pool.",ERROR_NULL_CHECK_IN);
            }
            if(!_loc2_)
            {
               throw new Error("You cannot return an object of the wrong type " + param1 + " a pool of type " + this._ObjectClass + ".",ERROR_CHECK_IN_TYPE);
            }
            if(_loc3_)
            {
               throw new Error("You cannot return an object to the pool when it\'s already checked-in.",ERROR_MULTI_CHECK_IN);
            }
         }
         if(Boolean(this._maxBuffer) && this._bufferSize > this._maxBuffer)
         {
            this.clean();
         }
      }
      
      public function get size() : int
      {
         return this._size;
      }
      
      public function get unused() : int
      {
         return this._bufferSize;
      }
      
      public function get used() : int
      {
         return this._size - this._bufferSize;
      }
      
      public function get ObjectClass() : Class
      {
         return this._ObjectClass;
      }
      
      public function clean() : void
      {
         var _loc2_:uint = 0;
         var _loc1_:uint = uint(this._bufferSize);
         if(_loc1_ > 0)
         {
            _loc2_ = Math.min(this._size,_loc1_);
            this.disposeObjects();
            this.createList();
            this._bufferSize = 0;
            this._size -= _loc2_;
         }
         this.dispatch(EVENT_CLEANED);
      }
      
      public function flush(param1:Boolean = false, param2:Boolean = false) : void
      {
         if(this.used > 0 && !param1)
         {
            return;
         }
         if(param2)
         {
            this.disposeObjects();
         }
         this._size = this._bufferSize = 0;
         this.createList();
         this.dispatch(EVENT_FLUSHED);
      }
      
      public function dispose() : void
      {
         this.flush(true,true);
         this._ObjectClass = null;
         this._initObject = null;
         this._pool = null;
         this._objectsInUse = null;
         this._resetMethod = null;
         this._disposeMethod = null;
         this.dispatch(EVENT_DISPOSED);
         this._dispatcher = null;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._dispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._dispatcher.removeEventListener(param1,param2,param3);
      }
      
      private function createList() : void
      {
         this._pool = new Array(this._idealArrayInitialSize);
         this._objectsInUse = new Array();
      }
      
      private function disposeObjects() : void
      {
         var _loc1_:Object = null;
         if(this._disposeMethod == "")
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._bufferSize)
         {
            _loc1_ = this._pool[_loc2_];
            if(_loc1_)
            {
               _loc1_[this._disposeMethod]();
            }
            _loc2_++;
         }
      }
      
      private function createAndAddObject() : void
      {
         this.addToPool(this.createObject());
      }
      
      private function addToPool(param1:*, param2:Boolean = false) : void
      {
         if(param2 && this._resetMethod != "")
         {
            param1[this._resetMethod]();
         }
         var _loc3_:* = this._bufferSize++;
         this._pool[_loc3_] = param1;
      }
      
      private function createObject() : *
      {
         ++this._size;
         return this._initObject == null ? new this._ObjectClass() : new this._ObjectClass(this._initObject);
      }
      
      private function dispatch(param1:String) : void
      {
         this._dispatcher.dispatchEvent(new Event(param1));
      }
   }
}
