package com.monsters.mailbox.model
{
   public class Contact
   {
      
      public static var contacts:Array = [];
      
      public static var unlisted:Array = [];
       
      
      public var firstname:String;
      
      public var lastname:String;
      
      public var pic:String;
      
      public var userid:int;
      
      public var friend:Boolean;
      
      public var picClass:Class;
      
      public function Contact(param1:String, param2:Object, param3:Boolean = false)
      {
         super();
         this.userid = int(param1);
         this.firstname = param2.first_name;
         this.lastname = param2.last_name;
         this.pic = param2.pic_square;
         if(!param3 && !contactWithUserId(this.userid))
         {
            contacts.push(this);
         }
         else if(param3 && !contactWithUserId(this.userid))
         {
            unlisted.push(this);
         }
         this.friend = param2.friend == 1;
      }
      
      public static function contactWithUserId(param1:uint, param2:Boolean = false) : Contact
      {
         var _loc4_:Contact = null;
         var _loc5_:Contact = null;
         var _loc3_:Array = param2 ? contacts.concat(unlisted) : contacts;
         for each(_loc5_ in _loc3_)
         {
            if(_loc5_.userid == param1)
            {
               _loc4_ = _loc5_;
               break;
            }
         }
         return _loc4_;
      }
      
      public function toString() : String
      {
         return KEYS.Get("contact_tostring",{
            "v1":this.lastname,
            "v2":this.firstname,
            "v3":this.userid
         });
      }
   }
}
