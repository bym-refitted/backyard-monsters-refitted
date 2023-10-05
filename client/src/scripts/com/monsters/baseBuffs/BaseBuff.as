package com.monsters.baseBuffs
{
   public class BaseBuff
   {
       
      
      internal var value:Number;
      
      protected var m_id:uint;
      
      protected var m_name:String;
      
      protected var m_imageURL:String;
      
      public function BaseBuff(param1:String = "", param2:String = "")
      {
         super();
         this.m_name = param1;
         this.m_imageURL = param2;
      }
      
      public function get description() : String
      {
         return "";
      }
      
      internal function get id() : uint
      {
         return this.m_id;
      }
      
      public function get name() : String
      {
         return this.m_name;
      }
      
      public function get imageURL() : String
      {
         return this.m_imageURL;
      }
      
      internal function set id(param1:uint) : void
      {
         this.m_id = param1;
      }
      
      public function apply() : void
      {
      }
      
      public function clear() : void
      {
      }
      
      protected function getValue() : Number
      {
         return this.value;
      }
   }
}
