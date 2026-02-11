package com.monsters.chat
{
   /**
    * Authentication system for chat login.
    * Uses ChatData for platform-neutral parameter passing.
    */
   public class AS_Login implements IAuthenticationSystem
   {
      private var user:UserRecord;
      
      private var password:String = null;
      
      private var params:ChatData = null;
      
      private const SALT_SEED:String = "073c187f8a02f626210bbcb7f55a4cee";
      
      public function AS_Login(param1:UserRecord)
      {
         super();
         this.user = param1;
      }
      
      public function authenticate() : Boolean
      {
         var _loc1_:int = int(Math.random() * 9999999);
         this.password = md5(this.SALT_SEED + this.user.Name + _loc1_ * (_loc1_ % 11));
         this.params = new ChatData();
         this.params.putLong("hnumber",_loc1_);
         this.params.putUtfString("pass",this.password);
         return true;
      }
      
      public function get User() : UserRecord
      {
         return this.user;
      }
      
      public function get Password() : String
      {
         return this.password;
      }
      
      public function get Params() : ChatData
      {
         return this.params;
      }
   }
}
