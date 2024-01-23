package com.monsters.monsters.components
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class CProperty extends Component
   {
      
      public static const MODIFIED:String = "valueModified";
      
      public static const DECREASED:String = "valueDecreased";
      
      public static const INCREASED:String = "valueIncreased";
      
      public static const MINIMIZED:String = "valueMinimized";
      
      public static const MAXIMIZED:String = "valueMaximized";
       
      
      public var doesDispatchEvents:Boolean = false;
      
      protected var _maximum:Number = 1.7976931348623157e+308;
      
      protected var _value:Number;
      
      protected var _minimum:Number = -Infinity;
      
      private var _previousValue:Number;
      
      private var _eventDispatcher:EventDispatcher;
      
      public function CProperty(param1:Number = 1.7976931348623157e+308, param2:Number = 0, param3:Number = -1)
      {
         this._value = this._maximum;
         super();
         this._eventDispatcher = new EventDispatcher();
         this._maximum = param1;
         this._minimum = param2;
         if(param3 == -1)
         {
            param3 = this._maximum;
         }
         this._value = param3;
      }
      
      public function get previousValue() : Number
      {
         return this._previousValue;
      }
      
      public function get eventDispatcher() : EventDispatcher
      {
         return this._eventDispatcher;
      }
      
      public function set value(param1:Number) : void
      {
         param1 = Math.max(this._minimum,param1);
         param1 = Math.min(this._maximum,param1);
         if(param1 == this._value)
         {
            return;
         }
         this._previousValue = this._value;
         this._value = param1;
         this.dispatchEvent(MODIFIED);
         if(this._value - this._previousValue >= 0)
         {
            this.dispatchEvent(INCREASED);
            if(this._value == this._maximum)
            {
               this.dispatchEvent(MAXIMIZED);
            }
         }
         else
         {
            this.dispatchEvent(DECREASED);
            if(this._value == this._minimum)
            {
               this.dispatchEvent(MINIMIZED);
            }
         }
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function get maxmimum() : Number
      {
         return this._maximum;
      }
      
      public function get minimum() : Number
      {
         return this._minimum;
      }
      
      public function modify(param1:Number, param2:* = null) : Number
      {
         this.value += param1;
         return this.value;
      }
      
      public function set(param1:Number, param2:* = null) : Number
      {
         this.value = param1;
         return this.value;
      }
      
      public function minimize(param1:* = null) : Number
      {
         return this.set(this._minimum,param1);
      }
      
      public function maximize(param1:* = null) : Number
      {
         return this.set(this._maximum,param1);
      }
      
      public function getValuePercentage() : Number
      {
         return 1 - (this._maximum - this._value) / (this._maximum - this._minimum);
      }
      
      public function setValuePercentage(param1:Number) : void
      {
         this.value = param1 * (this._maximum - this._minimum) + this._minimum;
      }
      
      private function dispatchEvent(param1:String) : void
      {
         if(!this.doesDispatchEvents)
         {
            return;
         }
         this._eventDispatcher.dispatchEvent(new Event(param1));
      }
   }
}
