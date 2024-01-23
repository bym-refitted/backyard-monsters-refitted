package com.monsters.replayableEvents.monsterMadness.popups
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   
   public class MonsterMadnessPopupInfoGoal3Complete extends MonsterMadnessPopupInfo
   {
       
      
      public function MonsterMadnessPopupInfoGoal3Complete()
      {
         super();
         isOnlySeenOnce = true;
      }
      
      override public function getCopy(param1:int) : String
      {
         return "mm_goal3_completed";
      }
      
      override public function getMedia(param1:int) : DisplayObject
      {
         return setupVideo(KOGOTH_SPINNING_STOMP_VIDEO);
      }
      
      override public function setupButton(param1:Button, param2:int) : void
      {
         param1.Setup(KEYS.Get("btn_brag"));
         param1.Highlight = true;
         param1.addEventListener(MouseEvent.CLICK,this.onClickBrag);
      }
      
      protected function onClickBrag(param1:MouseEvent) : void
      {
         ShowBrag("mm_g3_complete","mm_korathability2_streamtitle","mm_korathability2_streambody",KOGOTH_BRAG_IMAGE3);
      }
   }
}
