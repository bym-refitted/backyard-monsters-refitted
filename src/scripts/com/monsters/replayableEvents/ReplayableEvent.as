package com.monsters.replayableEvents
{
   import com.monsters.frontPage.FrontPageGraphic;
   import com.monsters.frontPage.FrontPageLibrary;
   import com.monsters.frontPage.messages.Message;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class ReplayableEvent extends EventDispatcher
   {
       
      
      protected const _DEFAULT_EVENT_DURATION:uint = 345600;
      
      private const _PROMO3_DURATION:Number = 259200;
      
      private const _PROMO2_DURATION:Number = 86400;
      
      protected var _priority:int;
      
      protected var _name:String;
      
      protected var _dates:Vector.<Number>;
      
      protected var _originalStartDate:Number;
      
      protected var _progress:Number = -1;
      
      protected var _imageURL:String;
      
      protected var _titleImage:String;
      
      protected var _eventStoreTitleImage:String;
      
      protected var _messages:Vector.<Message>;
      
      protected var _rewardMessage:Message;
      
      protected var _id:uint;
      
      protected var _score:Number = -1;
      
      protected var _buttonCopy:String;
      
      protected var _duration:uint = 345600;
      
      protected var _quotas:Vector.<com.monsters.replayableEvents.ReplayableEventQuota>;
      
      protected var m_mustBeInsideBase:Boolean = false;
      
      protected var _maxScore:Number = 1.7976931348623157e+308;
      
      public function ReplayableEvent()
      {
         super();
         if(this._rewardMessage)
         {
            if(FrontPageLibrary.EVENTS === null)
            {
               FrontPageLibrary.addCategories();
            }
            FrontPageLibrary.EVENTS.addMessage(this._rewardMessage);
         }
         this._quotas = new Vector.<com.monsters.replayableEvents.ReplayableEventQuota>();
      }
      
      public function get preEventHUDImageURL() : String
      {
         return "";
      }
      
      public function get eventHUDImageURL() : String
      {
         return "";
      }
      
      public function createNewUI() : IReplayableEventUI
      {
         return new ReplayableEventUI();
      }
      
      public function doesQualify() : Boolean
      {
         return false;
      }
      
      protected function onEventComplete() : void
      {
      }
      
      public function pressedActionButton() : void
      {
      }
      
      protected function onInitialize() : void
      {
      }
      
      internal function initialize() : void
      {
         var _loc1_:Message = this.getCurrentMessage();
         if(_loc1_)
         {
            FrontPageLibrary.EVENTS.addMessage(_loc1_);
         }
         this.onInitialize();
      }
      
      public function getCurrentMessage() : Message
      {
         var _loc1_:Number = NaN;
         if(this.hasCompletedEvent && Boolean(this._rewardMessage))
         {
            return this._rewardMessage;
         }
         if(this.hasEventEnded)
         {
            return this._messages[this._messages.length - 1];
         }
         if(this.hasEventStarted)
         {
            return this._messages[this._messages.length - 2];
         }
         _loc1_ = this.startDate - ReplayableEventHandler.currentTime;
         if(_loc1_ > this._PROMO3_DURATION)
         {
            return this._messages[0];
         }
         if(_loc1_ > this._PROMO2_DURATION)
         {
            return this._messages[1];
         }
         return this._messages[2];
      }
      
      public function pressedHelpButton() : Message
      {
         return this.getCurrentMessage();
      }
      
      public function reset() : void
      {
         var _loc2_:Message = null;
         this.score = 0;
         this.setStartDate(0);
         var _loc1_:int = 0;
         while(_loc1_ < this._messages.length)
         {
            _loc2_ = this._messages[_loc1_];
            _loc2_.timeLastSeen = 0;
            FrontPageLibrary.EVENTS.addMessage(_loc2_);
            _loc1_++;
         }
         ReplayableEventHandler.callServerMethod("resetevent",[["eventid",this._id]],this.resetCallback);
         BASE.Save();
      }
      
      protected function resetCallback(param1:Object) : void
      {
         dispatchEvent(new Event("reset"));
      }
      
      public function exportData() : Object
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc1_:Object = {};
         _loc1_.startDate = this.startDate;
         if(this._rewardMessage)
         {
            _loc1_.reward = this._rewardMessage.export();
         }
         var _loc2_:int = !!this._quotas ? int(this._quotas.length) : 0;
         if(_loc2_ != 0)
         {
            _loc1_.quotas = new Array(_loc2_);
            _loc3_ = 0;
            while(_loc3_ < this._quotas.length)
            {
               if(_loc4_ = this._quotas[_loc3_].exportData())
               {
                  _loc1_.quotas[_loc3_] = _loc4_;
               }
               _loc3_++;
            }
         }
         return _loc1_;
      }
      
      public function importData(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.setStartDate(param1.startDate);
         if(Boolean(this._rewardMessage) && Boolean(param1.reward))
         {
            this._rewardMessage.setup(param1.reward);
         }
         if(param1.quotas)
         {
            _loc2_ = int(this._quotas.length);
            _loc3_ = int(param1.quotas.length);
            _loc4_ = 0;
            while(_loc4_ < _loc2_ && _loc4_ < _loc3_)
            {
               this._quotas[_loc4_].importData(param1.quotas[_loc4_]);
               _loc4_++;
            }
         }
         this.onImport();
      }
      
      protected function onImport() : void
      {
      }
      
      internal function get duration() : uint
      {
         return this._duration;
      }
      
      public function get buttonCopy() : String
      {
         return this._buttonCopy;
      }
      
      public function get hasCompletedEvent() : Boolean
      {
         return this._progress >= 1;
      }
      
      public function get hasEventStarted() : Boolean
      {
         return ReplayableEventHandler.currentTime >= this.startDate;
      }
      
      public function get hasEventEnded() : Boolean
      {
         return ReplayableEventHandler.currentTime >= this.endDate;
      }
      
      public function get endDate() : Number
      {
         if(!this._dates)
         {
            return 0;
         }
         return this._dates[this._dates.length - 1];
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get originalStartDate() : Number
      {
         return this._originalStartDate;
      }
      
      public function get progress() : Number
      {
         return this._progress;
      }
      
      public function set progress(param1:Number) : void
      {
         this._progress = param1;
         if(this.hasCompletedEvent)
         {
            this.completedEvent();
         }
      }
      
      public function set score(param1:Number) : void
      {
         if(this._score >= 0 && param1 - this._score > 0)
         {
            ReplayableEventHandler.callServerMethod("updatescore",[["eventid",this._id],["delta",param1 - this._score],["saveid",GLOBAL.Timestamp()]],this.verifyScoreFromServer);
         }
         this._score = param1;
         this.setMetQuotas();
      }
      
      protected function setMetQuotas() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:com.monsters.replayableEvents.ReplayableEventQuota = null;
         if(!this.m_mustBeInsideBase || this.m_mustBeInsideBase && GLOBAL.isAtHome() === true)
         {
            _loc1_ = int(this._quotas.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._quotas[_loc2_];
               if(this._score >= _loc3_.quota)
               {
                  _loc3_.metQuota();
               }
               _loc2_++;
            }
         }
      }
      
      protected function getLatestMetQuota(param1:Number) : com.monsters.replayableEvents.ReplayableEventQuota
      {
         var _loc3_:com.monsters.replayableEvents.ReplayableEventQuota = null;
         var _loc2_:int = int(this._quotas.length - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = this._quotas[_loc2_];
            if(param1 >= _loc3_.quota)
            {
               return _loc3_;
            }
            _loc2_--;
         }
         return null;
      }
      
      protected function verifyScoreFromServer(param1:Object) : void
      {
         var _loc2_:Number = param1.score as Number;
         if(this._score != _loc2_)
         {
            print("WARNING: the server score(" + _loc2_ + ") doesnt match the local score(" + this._score + "), ignoring server score");
         }
      }
      
      protected function getServerScore() : void
      {
         ReplayableEventHandler.callServerMethod("geteventscore",[["eventid",this._id]],this.setScoreFromServer);
      }
      
      protected function setScoreFromServer(param1:Object) : void
      {
         var _loc2_:Number = param1.score as Number;
         if(Boolean(_loc2_) && !isNaN(_loc2_))
         {
            this._score = _loc2_;
         }
      }
      
      private function completedEvent() : void
      {
         if(this.m_mustBeInsideBase && GLOBAL.isAtHome() != true)
         {
            return;
         }
         if(Boolean(this._rewardMessage) && !this._rewardMessage.hasBeenSeen)
         {
            POPUPS.Push(new FrontPageGraphic(this._rewardMessage));
            this._rewardMessage.viewed();
         }
         this.onEventComplete();
      }
      
      public function update() : void
      {
      }
      
      internal function get priority() : int
      {
         return this._priority;
      }
      
      public function get startDate() : Number
      {
         if(!this._dates)
         {
            return 0;
         }
         return this._dates[0];
      }
      
      internal function setStartDate(param1:Number) : void
      {
         this._dates = Vector.<Number>([param1,param1 + this._duration]);
      }
      
      public function get timeUntilNextDate() : Number
      {
         var _loc1_:Number = NaN;
         if(this.hasEventEnded)
         {
            _loc1_ = this.endDate + ReplayableEventHandler.k_DURATION_STORE_IS_OPEN_AFTER_EVENT;
         }
         else if(this.hasEventStarted)
         {
            _loc1_ = this.endDate;
         }
         else
         {
            _loc1_ = this.startDate;
         }
         return _loc1_ - ReplayableEventHandler.currentTime;
      }
      
      public function get titleImage() : String
      {
         return this._titleImage;
      }
      
      public function get eventStoreTitleImage() : String
      {
         return this._eventStoreTitleImage;
      }
      
      public function get imageURL() : String
      {
         return this._imageURL;
      }
      
      internal function get id() : uint
      {
         return this._id;
      }
      
      public function get score() : Number
      {
         return this._score;
      }
      
      public function get rewards() : Vector.<com.monsters.replayableEvents.ReplayableEventQuota>
      {
         return this._quotas;
      }
      
      public function get maxScore() : Number
      {
         return this._maxScore;
      }
      
      public function get isLive() : Boolean
      {
         return Boolean(this._originalStartDate) && (ReplayableEventHandler.currentTime >= this._originalStartDate - ReplayableEventHandler.DURATION_UNTIL_EVENT_STARTS && ReplayableEventHandler.currentTime <= this._originalStartDate + this._duration);
      }
   }
}
