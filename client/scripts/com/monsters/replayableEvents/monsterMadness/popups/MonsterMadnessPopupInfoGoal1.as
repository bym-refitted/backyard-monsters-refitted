package com.monsters.replayableEvents.monsterMadness.popups
{
   import flash.display.DisplayObject;
   
   public class MonsterMadnessPopupInfoGoal1 extends MonsterMadnessPopupInfo
   {
       
      
      public function MonsterMadnessPopupInfoGoal1()
      {
         super();
      }
      
      override public function getCopy(param1:int) : String
      {
         return param1 == MonsterMadnessPopup.MR2 || param1 == MonsterMadnessPopup.MR2_AND_INFERNO ? "mm_goal1_desc" : "mm_nomr2_desc";
      }
      
      override public function getMedia(param1:int) : DisplayObject
      {
         return setupVideo(KOGOTH_SPINNING_VIDEO);
      }
      
      override public function setupButton(param1:Button, param2:int) : void
      {
         setupCloseButtton(param1);
      }
   }
}
