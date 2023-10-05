package com.monsters.replayableEvents
{
   import com.cc.tests.ABTest;
   import com.monsters.debug.Console;
   import com.monsters.frontPage.FrontPageGraphic;
   import com.monsters.frontPage.messages.DebugMessage;
   import com.monsters.frontPage.messages.Message;
   import com.monsters.ui.UI_BOTTOM;
   import flash.events.Event;
   
   public class ReplayableEventHandler
   {
      
      public static var debugDate:Date = new Date();
      
      public static var doesDebugClear:Boolean;
      
      public static var activeEvent:com.monsters.replayableEvents.ReplayableEvent;
      
      private static var _graphic:com.monsters.replayableEvents.IReplayableEventUI;
      
      public static const k_DURATION_STORE_IS_OPEN_AFTER_EVENT:Number = 172800;
      
      public static const DURATION_UNTIL_EVENT_STARTS:Number = 604800;
      
      private static const _DURATION_UNTIL_EVENT_RESET:Number = Number.MAX_VALUE;
      
      private static const _DURATION_BETWEEN_EVENTS:Number = 1209600;
      
      internal static const DURATION_REQUIRED_TO_CONFIRM_EVENT:Number = 259200;
      
      public static var eventXP:uint;
       
      
      public function ReplayableEventHandler()
      {
         super();
      }
      
      public static function get currentTime() : Number
      {
         if(Boolean(debugDate) && GLOBAL._aiDesignMode)
         {
            return debugDate.time / 1000;
         }
         return GLOBAL.Timestamp();
      }
      
      public static function initialize(param1:Object = null) : void
      {
         var _loc2_:com.monsters.replayableEvents.ReplayableEvent = null;
         var _loc3_:Number = NaN;
         if(GLOBAL.isAtHome() && TUTORIAL.hasFinished)
         {
            if(param1)
            {
               importData(param1);
            }
            if(activeEvent)
            {
               activeEvent.initialize();
               checkIfActiveEventIsFinished();
            }
            else if(canScheduleNewEvent())
            {
               _loc2_ = getQualifiedEvent();
               if(_loc2_)
               {
                  _loc3_ = getPotentialStartDateForEvent(_loc2_);
                  if(_loc3_)
                  {
                     scheduleNewEvent(_loc2_,_loc3_);
                     activeEvent.initialize();
                  }
               }
            }
         }
         addUI();
      }
      
      public static function updateDebugDate(param1:Number = 0) : void
      {
         var _loc2_:Message = null;
         if(param1)
         {
            debugDate.setTime(param1);
         }
         BASE.Save();
         UI2.DebugWarningEdit(ReplayableEventHandler.debugDate.toDateString());
         if(activeEvent)
         {
            _loc2_ = activeEvent.getCurrentMessage();
            if(_loc2_ && !_loc2_.hasBeenSeen && !(_loc2_ is DebugMessage))
            {
               POPUPS.Push(new FrontPageGraphic(_loc2_));
               _loc2_.viewed();
            }
            checkIfActiveEventIsFinished();
         }
      }
      
      private static function checkIfActiveEventIsFinished() : void
      {
         var _loc1_:Message = null;
         if(Boolean(activeEvent) && (activeEvent.hasEventEnded || activeEvent.hasCompletedEvent))
         {
            LOGGER.StatB({
               "st1":"ERS",
               "st2":activeEvent.name
            },"event_end");
            _loc1_ = activeEvent.getCurrentMessage();
            if(_loc1_ && !_loc1_.hasBeenSeen && !(_loc1_ is DebugMessage))
            {
               POPUPS.Push(new FrontPageGraphic(_loc1_));
               _loc1_.viewed();
            }
            if(activeEvent.endDate - currentTime >= k_DURATION_STORE_IS_OPEN_AFTER_EVENT)
            {
               if(_graphic)
               {
                  removeUI();
               }
               activeEvent = null;
            }
         }
      }
      
      public static function scheduleNewEvent(param1:com.monsters.replayableEvents.ReplayableEvent, param2:Number) : void
      {
         if(param1.startDate)
         {
            param1.reset();
         }
         param1.setStartDate(param2);
         callServerMethod("startevent",[["eventid",param1.id],["starttime",param1.startDate],["endtime",param1.endDate]],startEventCallback);
         LOGGER.StatB({
            "st1":"ERS",
            "st2":param1.name
         },"event_start");
         activeEvent = param1;
      }
      
      public static function callServerMethod(param1:String, param2:Array, param3:Function = null) : void
      {
         var _loc4_:URLLoaderApi;
         (_loc4_ = new URLLoaderApi()).load(GLOBAL._apiURL + "bm/event/" + param1,param2,param3);
      }
      
      protected static function startEventCallback(param1:Object) : void
      {
         var _loc2_:Object = param1;
      }
      
      private static function addUI() : void
      {
         if(!activeEvent || !activeEvent.doesQualify())
         {
            return;
         }
         _graphic = activeEvent.createNewUI();
         _graphic.setup(activeEvent);
         _graphic.addEventListener(Event.ENTER_FRAME,update,false,0,true);
         _graphic.addEventListener(ReplayableEventUI.CLICKED_ACTION,pressedActionButton,false,0,true);
         _graphic.addEventListener(ReplayableEventUI.CLICKED_INFO,pressedInfoButton,false,0,true);
         UI_BOTTOM.addChild(_graphic.eventUI);
      }
      
      private static function removeUI() : void
      {
         if(!_graphic)
         {
            return;
         }
         _graphic.removeEventListener(Event.ENTER_FRAME,update);
         _graphic.removeEventListener(ReplayableEventUI.CLICKED_ACTION,pressedActionButton);
         _graphic.removeEventListener(ReplayableEventUI.CLICKED_INFO,pressedInfoButton);
         UI_BOTTOM.removeChild(_graphic.eventUI);
      }
      
      private static function update(param1:Event) : void
      {
         _graphic.update();
         if(activeEvent)
         {
            activeEvent.update();
         }
         checkIfActiveEventIsFinished();
      }
      
      private static function pressedActionButton(param1:Event) : void
      {
         activeEvent.pressedActionButton();
      }
      
      private static function pressedInfoButton(param1:Event) : void
      {
         var _loc3_:FrontPageGraphic = null;
         var _loc2_:Message = activeEvent.pressedHelpButton();
         if(_loc2_)
         {
            _loc2_.refresh();
            _loc3_ = new FrontPageGraphic(_loc2_);
            POPUPS.Push(_loc3_);
         }
      }
      
      public static function getPotentialStartDateForEvent(param1:com.monsters.replayableEvents.ReplayableEvent) : Number
      {
         var _loc5_:Date = null;
         var _loc6_:Number = NaN;
         if(Boolean(param1.originalStartDate) && param1.originalStartDate - currentTime <= DURATION_UNTIL_EVENT_STARTS)
         {
            return param1.originalStartDate;
         }
         var _loc2_:uint = 86400;
         var _loc3_:Number = currentTime;
         var _loc4_:int = 0;
         while(_loc4_ < 7)
         {
            _loc3_ += _loc2_;
            if((_loc5_ = new Date(_loc3_ * 1000)).day == 4)
            {
               _loc3_ = _loc5_.setHours(12,0,0,0) / 1000;
               _loc6_ = _loc3_ - currentTime;
               if(!hasQualifiedLiveEventSoonAfter(_loc3_) && _loc6_ < DURATION_UNTIL_EVENT_STARTS && _loc6_ > DURATION_REQUIRED_TO_CONFIRM_EVENT)
               {
                  return _loc3_;
               }
            }
            _loc4_++;
         }
         return 0;
      }
      
      private static function canScheduleNewEvent() : Boolean
      {
         if(!GLOBAL._flags["ers"])
         {
            return false;
         }
         return Boolean(getQualifiedLiveEvent()) || !hasRecentlyParticipatedInAnEvent() && ABTest.isInTestGroup("ers",205);
      }
      
      private static function getQualifiedLiveEvent() : com.monsters.replayableEvents.ReplayableEvent
      {
         var _loc2_:com.monsters.replayableEvents.ReplayableEvent = null;
         var _loc1_:int = 0;
         while(_loc1_ < ReplayableEventLibrary.EVENTS.length)
         {
            _loc2_ = ReplayableEventLibrary.EVENTS[_loc1_];
            if(_loc2_.originalStartDate && currentTime < _loc2_.originalStartDate && _loc2_.originalStartDate - currentTime <= DURATION_UNTIL_EVENT_STARTS)
            {
               return _loc2_;
            }
            _loc1_++;
         }
         return null;
      }
      
      private static function hasQualifiedLiveEventSoonAfter(param1:Number) : Boolean
      {
         var _loc3_:com.monsters.replayableEvents.ReplayableEvent = null;
         var _loc2_:int = 0;
         while(_loc2_ < ReplayableEventLibrary.EVENTS.length)
         {
            _loc3_ = ReplayableEventLibrary.EVENTS[_loc2_];
            if(_loc3_.originalStartDate && _loc3_.originalStartDate >= param1 && _loc3_.originalStartDate - param1 <= _DURATION_BETWEEN_EVENTS)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private static function hasRecentlyParticipatedInAnEvent() : Boolean
      {
         var _loc2_:com.monsters.replayableEvents.ReplayableEvent = null;
         var _loc1_:int = 0;
         while(_loc1_ < ReplayableEventLibrary.EVENTS.length)
         {
            _loc2_ = ReplayableEventLibrary.EVENTS[_loc1_];
            if(Boolean(_loc2_.endDate) && currentTime - _loc2_.endDate <= _DURATION_BETWEEN_EVENTS)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public static function getQualifiedEvent() : com.monsters.replayableEvents.ReplayableEvent
      {
         var _loc3_:com.monsters.replayableEvents.ReplayableEvent = null;
         var _loc4_:com.monsters.replayableEvents.ReplayableEvent = null;
         var _loc1_:Vector.<com.monsters.replayableEvents.ReplayableEvent> = new Vector.<com.monsters.replayableEvents.ReplayableEvent>();
         var _loc2_:int = 0;
         while(_loc2_ < ReplayableEventLibrary.EVENTS.length)
         {
            if((_loc4_ = ReplayableEventLibrary.EVENTS[_loc2_]).doesQualify() && !_loc4_.startDate)
            {
               _loc1_.push(_loc4_);
            }
            _loc2_++;
         }
         _loc1_.sort(comparePriority);
         if(_loc1_.length >= 1)
         {
            _loc3_ = _loc1_[0];
         }
         return _loc3_;
      }
      
      private static function comparePriority(param1:com.monsters.replayableEvents.ReplayableEvent, param2:com.monsters.replayableEvents.ReplayableEvent) : Number
      {
         return param2.priority - param1.priority;
      }
      
      public static function exportData() : Object
      {
         var _loc2_:Boolean = false;
         var _loc4_:com.monsters.replayableEvents.ReplayableEvent = null;
         var _loc5_:Object = null;
         if(doesDebugClear)
         {
            doesDebugClear = false;
            return {};
         }
         if(GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD || BASE.isInfernoMainYardOrOutpost)
         {
            return null;
         }
         var _loc1_:Object = {};
         var _loc3_:int = 0;
         while(_loc3_ < ReplayableEventLibrary.EVENTS.length)
         {
            if(_loc5_ = (_loc4_ = ReplayableEventLibrary.EVENTS[_loc3_]).exportData())
            {
               _loc1_[_loc4_.name] = _loc5_;
               _loc2_ = true;
            }
            _loc3_++;
         }
         if(debugDate)
         {
            _loc1_.debugDate = debugDate.time;
            _loc2_ = true;
         }
         if(activeEvent)
         {
            _loc1_.activeEvent = activeEvent.id;
            _loc2_ = true;
         }
         return _loc2_ ? _loc1_ : null;
      }
      
      public static function importData(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:com.monsters.replayableEvents.ReplayableEvent = null;
         for(_loc2_ in param1)
         {
            _loc3_ = ReplayableEventLibrary.getEventByName(_loc2_);
            if(_loc3_)
            {
               _loc3_.importData(param1[_loc2_]);
            }
         }
         if(param1.debugDate)
         {
            debugDate = new Date(param1.debugDate);
         }
         if(param1.activeEvent)
         {
            activeEvent = ReplayableEventLibrary.getEventByID(param1.activeEvent);
         }
      }
      
      public static function optInForEventEmails() : void
      {
         if(!activeEvent)
         {
            Console.warning("You\'re trying to opt-in for an event that isnt currently running, something is fucked");
            return;
         }
         callServerMethod("emailoptin",[["eventid",activeEvent.id]]);
      }
   }
}
