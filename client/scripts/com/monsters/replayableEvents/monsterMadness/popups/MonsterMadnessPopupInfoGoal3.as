package com.monsters.replayableEvents.monsterMadness.popups
{
   import flash.display.DisplayObject;
   
   public class MonsterMadnessPopupInfoGoal3 extends MonsterMadnessPopupInfo
   {
       
      
      public function MonsterMadnessPopupInfoGoal3()
      {
         super();
      }
      
      override public function getCopy(param1:int) : String
      {
         return "mm_goal3_desc";
      }
      
      override public function getMedia(param1:int) : DisplayObject
      {
         return setupVideo(KOGOTH_SPINNING_STOMP_VIDEO);
      }
      
      override public function setupButton(param1:Button, param2:int) : void
      {
         setupCloseButtton(param1);
      }
   }
}
