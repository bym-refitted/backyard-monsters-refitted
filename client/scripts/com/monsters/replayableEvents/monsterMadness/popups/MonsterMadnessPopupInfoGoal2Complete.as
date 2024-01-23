package com.monsters.replayableEvents.monsterMadness.popups
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   
   public class MonsterMadnessPopupInfoGoal2Complete extends MonsterMadnessPopupInfo
   {
       
      
      public function MonsterMadnessPopupInfoGoal2Complete()
      {
         super();
         isOnlySeenOnce = true;
      }
      
      override public function getCopy(param1:int) : String
      {
         return "mm_goal2_completed";
      }
      
      override public function getMedia(param1:int) : DisplayObject
      {
         return setupVideo(KOGOTH_SPINNING_FIREBALL_VIDEO);
      }
      
      override public function setupButton(param1:Button, param2:int) : void
      {
         param1.Setup(KEYS.Get("btn_brag"));
         param1.Highlight = true;
         param1.addEventListener(MouseEvent.CLICK,this.onClickBrag);
      }
      
      protected function onClickBrag(param1:MouseEvent) : void
      {
         ShowBrag("mm_g2_complete","mm_korathability1_streamtitle","mm_korathability1_streambody",KOGOTH_BRAG_IMAGE2);
      }
   }
}
