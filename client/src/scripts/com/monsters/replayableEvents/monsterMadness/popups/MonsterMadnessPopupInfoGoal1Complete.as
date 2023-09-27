package com.monsters.replayableEvents.monsterMadness.popups
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   
   public class MonsterMadnessPopupInfoGoal1Complete extends MonsterMadnessPopupInfo
   {
       
      
      public function MonsterMadnessPopupInfoGoal1Complete()
      {
         super();
         isOnlySeenOnce = true;
      }
      
      protected function onClickBrag(param1:MouseEvent) : void
      {
         ShowBrag("mm_g1_complete","mm_korathunlocked_streamtitle","mm_korathunlocked_streambody",KOGOTH_BRAG_IMAGE1);
      }
      
      override public function getCopy(param1:int) : String
      {
         var _loc2_:String = null;
         if(GLOBAL._bCage)
         {
            if(CREATURES._guardian)
            {
               if(GLOBAL._bChamber)
               {
                  _loc2_ = "mm_goal1_completed4";
               }
               else
               {
                  _loc2_ = "mm_goal1_completed2";
               }
            }
            else
            {
               _loc2_ = "mm_goal1_completed3";
            }
         }
         else
         {
            _loc2_ = "mm_goal1_completed1";
         }
         return _loc2_;
      }
      
      override public function getMedia(param1:int) : DisplayObject
      {
         return setupVideo(KOGOTH_SPINNING_VIDEO);
      }
      
      override public function setupButton(param1:Button, param2:int) : void
      {
         param1.Setup(KEYS.Get("btn_brag"));
         param1.Highlight = true;
         param1.addEventListener(MouseEvent.CLICK,this.onClickBrag);
      }
      
      private function buildCage(param1:MouseEvent) : void
      {
         param1.target.removeEventListener(MouseEvent.CLICK,this.buildCage);
         close();
         BUILDINGS._buildingID = 114;
         BUILDINGS.Show();
      }
      
      private function buildChamber(param1:MouseEvent) : void
      {
         param1.target.removeEventListener(MouseEvent.CLICK,this.buildChamber);
         close();
         BUILDINGS._buildingID = 119;
         BUILDINGS.Show();
      }
      
      private function openChamber(param1:MouseEvent) : void
      {
         param1.target.removeEventListener(MouseEvent.CLICK,this.openChamber);
         close();
         CHAMPIONCHAMBER.Show();
      }
      
      private function openCage(param1:MouseEvent) : void
      {
         param1.target.removeEventListener(MouseEvent.CLICK,this.openCage);
         close();
         CHAMPIONCAGE.Show();
      }
   }
}
