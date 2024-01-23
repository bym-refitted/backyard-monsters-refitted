package com.smartfoxserver.v2.entities.variables
{
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   
   public class SFSRoomVariable extends SFSUserVariable implements RoomVariable
   {
       
      
      private var _isPersistent:Boolean;
      
      private var _isPrivate:Boolean;
      
      public function SFSRoomVariable(param1:String, param2:*, param3:int = -1)
      {
         super(param1,param2,param3);
      }
      
      public static function fromSFSArray(param1:ISFSArray) : RoomVariable
      {
         var _loc2_:RoomVariable = new SFSRoomVariable(param1.getUtfString(0),param1.getElementAt(2),param1.getByte(1));
         _loc2_.isPrivate = param1.getBool(3);
         return _loc2_;
      }
      
      public function get isPrivate() : Boolean
      {
         return this._isPrivate;
      }
      
      public function get isPersistent() : Boolean
      {
         return this._isPersistent;
      }
      
      public function set isPrivate(param1:Boolean) : void
      {
         this._isPrivate = param1;
      }
      
      public function set isPersistent(param1:Boolean) : void
      {
         this._isPersistent = param1;
      }
      
      override public function toString() : String
      {
         return "[RVar: " + _name + ", type: " + _type + ", value: " + _value + ", isPriv: " + this.isPrivate + "]";
      }
      
      override public function toSFSArray() : ISFSArray
      {
         var _loc1_:ISFSArray = super.toSFSArray();
         _loc1_.addBool(this._isPrivate);
         _loc1_.addBool(this._isPersistent);
         return _loc1_;
      }
   }
}
