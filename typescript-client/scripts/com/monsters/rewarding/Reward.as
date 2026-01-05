package com.monsters.rewarding
{
   import com.monsters.interfaces.IExportable;
   
   public class Reward implements IExportable
   {
       
      
      internal var id:String;
      
      protected var _hasBeenApplied:Boolean;
      
      protected var _name:String;
      
      protected var _description:String;
      
      protected var _value:Number = 0;
      
      public function Reward()
      {
         super();
      }
      
      internal function applyReward() : Boolean
      {
         if(!this.canBeApplied())
         {
            return false;
         }
         this._hasBeenApplied = true;
         this.onApplication();
         return true;
      }
      
      public function canBeApplied() : Boolean
      {
         return true;
      }
      
      protected function onApplication() : void
      {
      }
      
      public function set value(param1:Number) : void
      {
         this._value = param1;
      }
      
      public function get value() : *
      {
         return this._value;
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function exportData() : Object
      {
         var _loc1_:Object = {};
         _loc1_["id"] = this.id;
         if(this.value)
         {
            _loc1_["value"] = this.value;
         }
         return _loc1_;
      }
      
      public function importData(param1:Object) : void
      {
         this.id = param1["id"];
         if(param1["value"])
         {
            this._value = param1["value"];
         }
      }
      
      public function removed() : void
      {
      }
      
      public function reset() : void
      {
      }
      
      public function get hasBeenApplied() : Boolean
      {
         return this._hasBeenApplied;
      }
   }
}
