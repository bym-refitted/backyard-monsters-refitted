package com.monsters.monsters.components
{
   import com.monsters.interfaces.IPropertyModifier;
   
   public class CModifiableProperty extends CProperty
   {
       
      
      protected var _modifiers:Vector.<IPropertyModifier>;
      
      public function CModifiableProperty(param1:Number = 1.7976931348623157e+308, param2:Number = -Infinity, param3:Number = -1)
      {
         super(param1,param2,param3);
         this._modifiers = new Vector.<IPropertyModifier>();
      }
      
      override public function get value() : Number
      {
         var _loc1_:Number = _value;
         var _loc2_:int = 0;
         while(_loc2_ < this._modifiers.length)
         {
            _loc1_ = this._modifiers[_loc2_].modify(_loc1_);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get modifiers() : Vector.<IPropertyModifier>
      {
         return this._modifiers;
      }
      
      public function addModifier(param1:IPropertyModifier, param2:Number = 0) : void
      {
         this._modifiers.push(param1);
      }
      
      public function removeModifier(param1:IPropertyModifier) : void
      {
         var _loc2_:int = this._modifiers.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this._modifiers.splice(_loc2_,1);
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
