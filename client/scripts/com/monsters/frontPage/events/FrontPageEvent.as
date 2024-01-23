package com.monsters.frontPage.events
{
   import com.monsters.frontPage.categories.Category;
   import flash.events.Event;
   
   public class FrontPageEvent extends Event
   {
      
      public static const NEXT:String = "next";
      
      public static const PREVIOUS:String = "previous";
      
      public static const CHANGE_CATEGORY:String = "changeCategory";
       
      
      private var _category:Category;
      
      public function FrontPageEvent(param1:String, param2:Category = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._category = param2;
      }
      
      public function get category() : Category
      {
         return this._category;
      }
   }
}
