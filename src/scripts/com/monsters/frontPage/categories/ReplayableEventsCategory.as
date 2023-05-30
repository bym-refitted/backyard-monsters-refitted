package com.monsters.frontPage.categories
{
   import com.monsters.frontPage.messages.Message;
   
   public class ReplayableEventsCategory extends Category
   {
       
      
      private var m_importedData:Object;
      
      public function ReplayableEventsCategory()
      {
         this.m_importedData = {};
         super();
         priority = 6;
         name = "Replayable Events";
         _doesViewRepeatedly = false;
      }
      
      override public function export() : Object
      {
         var _loc4_:Message = null;
         var _loc5_:Object = null;
         var _loc1_:Boolean = true;
         var _loc2_:Object = this.m_importedData;
         _loc2_.name = name;
         if(lastMessageSeen)
         {
            _loc2_.lastMessage = lastMessageSeen.name;
            _loc1_ = true;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _messages.length)
         {
            if(_loc5_ = (_loc4_ = _messages[_loc3_]).export())
            {
               _loc2_[_loc4_.name] = _loc5_;
               _loc1_ = true;
            }
            _loc3_++;
         }
         if(!_loc1_)
         {
            return null;
         }
         return _loc2_;
      }
      
      override public function setup(param1:Object) : void
      {
         this.m_importedData = param1;
         super.setup(param1);
      }
   }
}
