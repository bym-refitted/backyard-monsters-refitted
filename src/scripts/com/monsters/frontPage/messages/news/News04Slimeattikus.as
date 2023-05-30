package com.monsters.frontPage.messages.news
{
   import com.monsters.frontPage.messages.KeywordMessage;
   import com.monsters.replayableEvents.ReplayableEventLibrary;
   
   public class News04Slimeattikus extends KeywordMessage
   {
       
      
      public function News04Slimeattikus()
      {
         var _loc1_:String = "";
         if(!CREATURELOCKER._lockerData["C17"])
         {
            _loc1_ = "btn_unlocknow";
         }
         super("3_18_0",_loc1_);
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         return ReplayableEventLibrary.MONSTER_BLITZKRIEG.doesAutomaticalyGetReward() && Boolean(BASE.loadObject["events"]);
      }
      
      override protected function onButtonClick() : void
      {
         CREATURELOCKER._popupCreatureID = "C17";
         CREATURELOCKER.Show();
         CREATURELOCKER._mc.ShowB("C17");
         POPUPS.Next();
      }
   }
}
