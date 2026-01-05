package com.monsters.frontPage.messages.news
{
   import com.monsters.frontPage.messages.KeywordMessage;
   import com.monsters.replayableEvents.ReplayableEventLibrary;
   
   public class News03Vorg extends KeywordMessage
   {
       
      
      public function News03Vorg()
      {
         var _loc1_:String = "";
         if(!CREATURELOCKER._lockerData["C16"])
         {
            _loc1_ = "btn_unlocknow";
         }
         super("3_17_0",_loc1_);
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         return ReplayableEventLibrary.BATTLE_TOADS.doesAutomaticalyGetReward() && Boolean(BASE.loadObject["events"]);
      }
      
      override protected function onButtonClick() : void
      {
         CREATURELOCKER._popupCreatureID = "C16";
         CREATURELOCKER.Show();
         CREATURELOCKER._mc.ShowB("C16");
         POPUPS.Next();
      }
   }
}
