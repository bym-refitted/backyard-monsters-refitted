package com.monsters.frontPage.categories
{
   public class WhatsAvailable extends Category
   {
      
      private static const _TIME_UNTIL_RESET:uint = 86400;
       
      
      public function WhatsAvailable()
      {
         super();
         priority = 3;
         name = "What\'s Available";
         _doesViewRepeatedly = false;
      }
      
      override public function setup(param1:Object) : void
      {
         super.setup(param1);
         this.markOldMessagesAsUnseen();
      }
      
      private function markOldMessagesAsUnseen() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < _messages.length)
         {
            _messages[_loc1_].markAsUnseenIfOlderThan(_TIME_UNTIL_RESET);
            _loc1_++;
         }
      }
   }
}
