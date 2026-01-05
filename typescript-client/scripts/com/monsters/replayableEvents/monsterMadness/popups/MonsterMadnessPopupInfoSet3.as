package com.monsters.replayableEvents.monsterMadness.popups
{
   import flash.display.DisplayObject;
   
   public class MonsterMadnessPopupInfoSet3 extends MonsterMadnessPopupInfo
   {
       
      
      public function MonsterMadnessPopupInfoSet3()
      {
         super();
      }
      
      override public function getCopy(param1:int) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case MonsterMadnessPopup.MR2_AND_INFERNO:
               _loc2_ = "mm_pop_both3";
               break;
            case MonsterMadnessPopup.MR2:
               _loc2_ = "mm_pop_mronly3";
               break;
            case MonsterMadnessPopup.INFERNO:
               _loc2_ = "mm_pop_infonly3";
               break;
            case MonsterMadnessPopup.TOWNHALL_GREATER_THAN_5:
               _loc2_ = "mm_pop_neitherclose3";
               break;
            case MonsterMadnessPopup.TOWNHALL_LESS_THAN_5:
               _loc2_ = "mm_pop_neither3";
               break;
            default:
               _loc2_ = "invalid userstate";
         }
         return _loc2_;
      }
      
      override public function getMedia(param1:int) : DisplayObject
      {
         return setupImage("specialevent/monstermadness/pop_one_destroyedbases.png");
      }
      
      override public function setupButton(param1:Button, param2:int) : void
      {
         if(param2 == MonsterMadnessPopup.MR2 || param2 == MonsterMadnessPopup.MR2_AND_INFERNO)
         {
            setupRSVPButton(param1);
         }
         else if(param2 == MonsterMadnessPopup.INFERNO || param2 == MonsterMadnessPopup.TOWNHALL_GREATER_THAN_5)
         {
            setupUpgradeButton(param1);
         }
         else
         {
            param1.visible = false;
         }
      }
   }
}
