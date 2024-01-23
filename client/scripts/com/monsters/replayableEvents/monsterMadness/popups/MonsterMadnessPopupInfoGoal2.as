package com.monsters.replayableEvents.monsterMadness.popups
{
   import flash.display.DisplayObject;
   
   public class MonsterMadnessPopupInfoGoal2 extends MonsterMadnessPopupInfo
   {
       
      
      public function MonsterMadnessPopupInfoGoal2()
      {
         super();
      }
      
      override public function getCopy(param1:int) : String
      {
         return "mm_goal2_desc";
      }
      
      override public function getMedia(param1:int) : DisplayObject
      {
         return setupVideo(KOGOTH_SPINNING_FIREBALL_VIDEO);
      }
      
      override public function setupButton(param1:Button, param2:int) : void
      {
         setupCloseButtton(param1);
      }
   }
}
