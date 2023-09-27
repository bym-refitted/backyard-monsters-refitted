package com.monsters.frontPage.categories
{
   import com.monsters.frontPage.messages.Message;
   
   public class Category
   {
       
      
      public var priority:uint;
      
      public var name:String;
      
      public var lastMessageSeen:Message;
      
      protected var _messages:Vector.<Message>;
      
      protected var _doesViewRepeatedly:Boolean = true;
      
      public function Category()
      {
         this._messages = new Vector.<Message>();
         super();
      }
      
      public function getNextQualifiedMessage() : Message
      {
         var _loc1_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Message = null;
         if(this.lastMessageSeen)
         {
            if((_loc4_ = this._messages.indexOf(this.lastMessageSeen)) >= 0)
            {
               _loc1_ = _loc4_ + 1;
               if(_loc1_ >= this._messages.length)
               {
                  _loc1_ = 0;
               }
            }
         }
         var _loc2_:Boolean = false;
         var _loc3_:int = _loc1_;
         _loc3_ = _loc1_;
         while(_loc3_ < this._messages.length)
         {
            if((!(_loc5_ = this._messages[_loc3_]).hasBeenSeen || this._doesViewRepeatedly) && _loc5_.areRequirementsMet)
            {
               return _loc5_;
            }
            if(_loc3_ == this._messages.length - 1)
            {
               _loc3_ = -1;
               _loc2_ = true;
            }
            if(_loc2_ && _loc3_ == _loc1_ - 1)
            {
               break;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function addMessage(param1:Message) : void
      {
         this._messages.push(param1);
         param1.category = this;
      }
      
      public function setup(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Message = null;
         this.lastMessageSeen = this.getMessageByName(param1.lastMessage);
         for(_loc2_ in param1)
         {
            _loc3_ = this.getMessageByName(_loc2_);
            if(_loc3_)
            {
               _loc3_.setup(param1[_loc2_]);
            }
         }
      }
      
      public function export() : Object
      {
         var _loc4_:Message = null;
         var _loc5_:Object = null;
         var _loc1_:Boolean = false;
         var _loc2_:Object = {};
         _loc2_.name = this.name;
         if(this.lastMessageSeen)
         {
            _loc2_.lastMessage = this.lastMessageSeen.name;
            _loc1_ = true;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this._messages.length)
         {
            if(_loc5_ = (_loc4_ = this._messages[_loc3_]).export())
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
      
      public function getMessageByName(param1:String) : Message
      {
         var _loc3_:Message = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._messages.length)
         {
            _loc3_ = this._messages[_loc2_];
            if(_loc3_.name == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
   }
}
