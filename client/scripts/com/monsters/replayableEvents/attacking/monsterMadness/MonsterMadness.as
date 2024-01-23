package com.monsters.replayableEvents.attacking.monsterMadness
{
   import com.cc.utils.SecNum;
   import com.monsters.debug.Console;
   import com.monsters.replayableEvents.looting.wotc.rewards.KorathReward;
   import com.monsters.replayableEvents.monsterMadness.popups.MonsterMadnessPopup;
   import com.monsters.rewarding.Reward;
   import com.monsters.rewarding.RewardHandler;
   import com.monsters.rewarding.RewardLibrary;
   import flash.events.Event;
   
   public class MonsterMadness
   {
      
      public static const POINTS_GOAL1:int = 42000000;
      
      public static const POINTS_GOAL2:int = 94500000;
      
      public static const POINTS_GOAL3:int = 160125000;
      
      public static const LAST_POPUP_INDEX:String = "lastPopupIndex";
      
      public static const LAST_SCORE:String = "mmscore";
      
      public static const EVENT_DATES:Vector.<Date> = Vector.<Date>([new Date(2012,2,15,12),new Date(2012,2,19,12),new Date(2012,2,21,12),new Date(2012,2,22,12),new Date(2012,2,26,12)]);
      
      public static var today:Date = new Date(2012,2,23);
      
      public static var infoBar:MonsterMadnessInfoBar;
      
      public static var stage:uint;
      
      private static var _points:SecNum = new SecNum(0);
      
      public static const SAVE_ID:String = "event_score";
       
      
      public function MonsterMadness()
      {
         super();
      }
      
      public static function get points() : uint
      {
         return _points.Get();
      }
      
      public static function set points(param1:uint) : void
      {
         _points = new SecNum(param1);
         stage = getStage();
         GLOBAL.StatSet(LAST_SCORE,param1);
      }
      
      public static function updateKorathStats() : void
      {
         var _loc1_:uint = 0;
         if(points >= POINTS_GOAL3)
         {
            _loc1_ = 3;
         }
         else if(points >= POINTS_GOAL2)
         {
            _loc1_ = 2;
         }
         else if(points >= POINTS_GOAL1)
         {
            _loc1_ = 1;
         }
         if(_loc1_ > 0)
         {
            setKorathPowerLevel(_loc1_);
         }
      }
      
      public static function setKorathPowerLevel(param1:int) : void
      {
         var _loc2_:Reward = RewardHandler.instance.getRewardByID(KorathReward.k_REWARD_ID);
         if(!_loc2_)
         {
            _loc2_ = RewardLibrary.getRewardByID(KorathReward.k_REWARD_ID);
            if(!_loc2_)
            {
               Console.warning("reward handler isnt working, you cant apply rewards here");
               return;
            }
            _loc2_.value = param1;
            RewardHandler.instance.addAndApplyReward(_loc2_);
         }
         else if(param1 > _loc2_.value)
         {
            _loc2_.value = param1;
            RewardHandler.instance.applyReward(_loc2_);
         }
      }
      
      public static function get hasEventStarted() : Boolean
      {
         return currentTime > activeTime;
      }
      
      public static function get hasEventEnded() : Boolean
      {
         return currentTime > endTime;
      }
      
      public static function get currentTime() : Number
      {
         return GLOBAL.Timestamp();
      }
      
      public static function get timeUntilNextPhase() : Number
      {
         var _loc1_:Number = activeTime;
         if(currentTime > _loc1_)
         {
            _loc1_ = endTime;
         }
         return _loc1_ - currentTime;
      }
      
      public static function get activeTime() : Number
      {
         return 1332442800;
      }
      
      public static function get endTime() : Number
      {
         return 1332788400;
      }
      
      public static function get activeDate() : Date
      {
         return EVENT_DATES[3];
      }
      
      public static function get endDate() : Date
      {
         return EVENT_DATES[EVENT_DATES.length - 1];
      }
      
      private static function getStage() : Number
      {
         var _loc1_:int = 0;
         if(currentTime <= endTime)
         {
            if(hasEventStarted)
            {
               if(MonsterMadness.points >= MonsterMadness.POINTS_GOAL2)
               {
                  _loc1_ = 4;
               }
               else if(MonsterMadness.points >= MonsterMadness.POINTS_GOAL1)
               {
                  _loc1_ = 3;
               }
               else
               {
                  _loc1_ = 2;
               }
            }
            else if(currentTime > EVENT_DATES[0].getUTCSeconds())
            {
               _loc1_ = 1;
            }
         }
         else if(currentTime > endTime)
         {
            _loc1_ = 5;
         }
         return _loc1_;
      }
      
      public static function showPopup(param1:Boolean = false) : Boolean
      {
         var _loc2_:MonsterMadnessPopup = null;
         if(GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD)
         {
            return false;
         }
         if(hasNewPopupToShow() || param1)
         {
            _loc2_ = new MonsterMadnessPopup();
            POPUPS.Push(_loc2_);
            GLOBAL.StatSet(LAST_POPUP_INDEX,_loc2_.infoIndex);
         }
         return true;
      }
      
      public static function initialize() : void
      {
         var _loc1_:uint = uint(GLOBAL.StatGet(LAST_SCORE));
         var _loc2_:* = BASE.loadObject[SAVE_ID];
         if(_loc2_ && _loc2_ >= _loc1_ && !hasEventEnded || _loc1_ == -2126479027)
         {
            points = _loc2_;
         }
         else
         {
            points = _loc1_;
         }
         if(hasEventEnded || GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD || TUTORIAL._stage < 200 || GLOBAL._sessionCount < 5)
         {
            return;
         }
         infoBar = new MonsterMadnessInfoBar();
         addInfoBar();
         showPopup();
      }
      
      private static function hasNewPopupToShow() : Boolean
      {
         return MonsterMadnessPopup.getSetIndex() > GLOBAL.StatGet(LAST_POPUP_INDEX);
      }
      
      public static function addInfoBar() : void
      {
         infoBar.Setup();
         infoBar.Resize();
         infoBar.addEventListener(Event.ENTER_FRAME,updateInfoBar);
      }
      
      private static function updateInfoBar(param1:Event) : void
      {
         infoBar.Update();
      }
      
      public static function removeInfoBar() : void
      {
         if(!infoBar)
         {
            return;
         }
         infoBar.removeEventListener(Event.ENTER_FRAME,updateInfoBar);
      }
   }
}
