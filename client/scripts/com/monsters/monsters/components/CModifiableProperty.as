package com.monsters.monsters.components
{
   import com.monsters.interfaces.IPropertyModifier;
   
   public class CModifiableProperty extends CProperty
   {
       
      
      protected var _modifiers:Vector.<IPropertyModifier>;
      
      // Performance optimization: Cache calculated values to avoid recalculating modifiers every access
      private var _cachedValue:Number = NaN;
      private var _isDirty:Boolean = true;
      
      // Comment: Rewritten function - floating-point numbers are not compile-time constants.
      public function CModifiableProperty(param1:Number = Number.MAX_VALUE, param2:Number = Number.NEGATIVE_INFINITY, param3:Number = -1)
      {
         super(param1,param2,param3);
         this._modifiers = new Vector.<IPropertyModifier>();
      }
      
      override public function get value() : Number
      {
         // Performance optimization: Use cached value if available and not dirty
         if (!_isDirty && !isNaN(_cachedValue)) {
            return _cachedValue;
         }
         
         var _loc1_:Number = _value;
         var _loc2_:int = 0;
         while(_loc2_ < this._modifiers.length)
         {
            _loc1_ = this._modifiers[_loc2_].modify(_loc1_);
            _loc2_++;
         }
         
         // Cache the calculated value
         _cachedValue = _loc1_;
         _isDirty = false;
         
         return _loc1_;
      }
      
      override public function set value(param1:Number) : void
      {
         super.value = param1;
         _isDirty = true; // Mark cache as dirty when base value changes
      }
      
      public function get modifiers() : Vector.<IPropertyModifier>
      {
         return this._modifiers;
      }
      
      public function addModifier(param1:IPropertyModifier, param2:Number = 0) : void
      {
         this._modifiers.push(param1);
         _isDirty = true; // Mark cache as dirty when modifiers change
      }
      
      public function removeModifier(param1:IPropertyModifier) : void
      {
         var _loc2_:int = this._modifiers.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this._modifiers.splice(_loc2_,1);
            _isDirty = true; // Mark cache as dirty when modifiers change
         }
      }
      
      public function getModifierByType(param1:Class) : IPropertyModifier
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._modifiers.length)
         {
            if(this._modifiers[_loc2_] is param1)
            {
               return this._modifiers[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getModifier(param1:IPropertyModifier) : IPropertyModifier
      {
         var _loc2_:int = this._modifiers.indexOf(param1);
         if(_loc2_ != -1)
         {
            return this._modifiers[_loc2_];
         }
         return null;
      }
   }
}
