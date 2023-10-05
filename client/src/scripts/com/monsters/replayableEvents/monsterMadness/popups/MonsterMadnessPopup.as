package com.monsters.replayableEvents.monsterMadness.popups
{
   import com.monsters.display.ImageCache;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.replayableEvents.attacking.monsterMadness.MonsterMadness;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class MonsterMadnessPopup extends MonsterMadnessPopup_CLIP
   {
      
      internal static const MR2_AND_INFERNO:int = 1;
      
      internal static const MR2:int = 2;
      
      internal static const INFERNO:int = 3;
      
      internal static const TOWNHALL_GREATER_THAN_5:int = 4;
      
      internal static const TOWNHALL_LESS_THAN_5:int = 5;
      
      internal static const _MEDIA_DIMENTIONS_X:int = 200;
      
      internal static const _MEDIA_DIMENTIONS_Y:int = 200;
      
      private static const _infoSets:Vector.<com.monsters.replayableEvents.monsterMadness.popups.MonsterMadnessPopupInfo> = Vector.<com.monsters.replayableEvents.monsterMadness.popups.MonsterMadnessPopupInfo>([new MonsterMadnessPopupInfoSet1(),new MonsterMadnessPopupInfoSet2(),new MonsterMadnessPopupInfoSet3(),new MonsterMadnessPopupInfoSet4(),new MonsterMadnessPopupInfoGoal1(),new MonsterMadnessPopupInfoGoal1Complete(),new MonsterMadnessPopupInfoGoal2(),new MonsterMadnessPopupInfoGoal2Complete(),new MonsterMadnessPopupInfoGoal3(),new MonsterMadnessPopupInfoGoal3Complete(),new MonsterMadnessPopupInfoEventComplete()]);
       
      
      public var infoIndex:int;
      
      public function MonsterMadnessPopup()
      {
         var _loc3_:String = null;
         super();
         var _loc1_:int = this.getUserState();
         var _loc2_:com.monsters.replayableEvents.monsterMadness.popups.MonsterMadnessPopupInfo = _infoSets[getSetIndex()];
         this.infoIndex = _infoSets.indexOf(_loc2_);
         ImageCache.GetImageWithCallBack(_loc2_.getBanner(_loc1_),this.onImageLoad,true,4,"",[mcImage]);
         if(CREATURES._guardian)
         {
            _loc3_ = String(CHAMPIONCAGE._guardians["G" + CREATURES._guardian._type].name);
         }
         tCopy.htmlText = KEYS.Get(_loc2_.getCopy(_loc1_),{
            "v1":_loc3_,
            "v2":_loc3_
         });
         _loc2_.addEventListener(com.monsters.replayableEvents.monsterMadness.popups.MonsterMadnessPopupInfo.REMOVE_LOADING_CIRCLE,this.onRemoveLoadingCircle,false,0,true);
         _loc2_.setupButton(bAction,_loc1_);
         _loc2_.setupButton2(bAction2,_loc1_);
         mcVideo.addChild(_loc2_.getMedia(_loc1_));
         UI2.DebugWarningEdit("MM Userstate: " + _loc1_);
      }
      
      public static function getSetIndex() : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc1_:uint = MonsterMadness.EVENT_DATES.indexOf(MonsterMadness.activeDate);
         if(MonsterMadness.hasEventStarted || Boolean(MonsterMadness.points))
         {
            _loc3_ = MonsterMadness.points;
            if(_loc3_ >= MonsterMadness.POINTS_GOAL3)
            {
               _loc2_ = 9;
            }
            else if(_loc3_ >= MonsterMadness.POINTS_GOAL2)
            {
               _loc2_ = 7;
            }
            else if(_loc3_ >= MonsterMadness.POINTS_GOAL1)
            {
               _loc2_ = 5;
            }
            else
            {
               _loc2_ = 4;
            }
            _loc4_ = GLOBAL.StatGet(MonsterMadness.LAST_POPUP_INDEX);
            if(_loc2_ <= _loc4_ && _infoSets[_loc2_].isOnlySeenOnce)
            {
               _loc2_++;
            }
            return _loc2_;
         }
         _loc5_ = MonsterMadness.currentTime;
         _loc6_ = int(_loc1_);
         while(_loc6_ >= 0)
         {
            if(_loc5_ >= MonsterMadness.EVENT_DATES[_loc6_].getUTCSeconds())
            {
               return _loc6_;
            }
            _loc6_--;
         }
         return 0;
      }
      
      protected function onRemoveLoadingCircle(param1:Event) : void
      {
         if(mcLoading && mcLoading.parent && mcLoading.parent == this)
         {
            removeChild(mcLoading);
         }
      }
      
      private function onImageLoad(param1:String, param2:BitmapData, param3:Array = null) : void
      {
         MovieClip(param3[0]).addChild(new Bitmap(param2));
      }
      
      private function getUserState() : int
      {
         if(MapRoomManager.instance.isInMapRoom2 && MAPROOM_DESCENT.DescentPassed)
         {
            return MR2_AND_INFERNO;
         }
         if(MapRoomManager.instance.isInMapRoom2)
         {
            return MR2;
         }
         if(MAPROOM_DESCENT.DescentPassed)
         {
            return INFERNO;
         }
         if(Boolean(GLOBAL.townHall) && GLOBAL.townHall._lvl.Get() >= 5)
         {
            return TOWNHALL_GREATER_THAN_5;
         }
         return TOWNHALL_LESS_THAN_5;
      }
   }
}
