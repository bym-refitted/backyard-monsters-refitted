package com.monsters.frontPage.messages.buildtree
{
   import com.monsters.events.BuildingEvent;
   import com.monsters.frontPage.messages.BuildTreeMessage;
   
   public class BuildTree_06_Catapult extends BuildTreeMessage
   {
       
      
      public function BuildTree_06_Catapult()
      {
         super("catapult1",51,"btn_buildnow");
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         if(BASE.hasNumBuildings(51) != 0)
         {
            return false;
         }
         return Boolean(GLOBAL.townHall) && GLOBAL.townHall._lvl.Get() >= 3;
      }
      
      override protected function onButtonClick() : void
      {
         buyBuilding(51);
         GLOBAL.eventDispatcher.addEventListener(BuildingEvent.PLACED_FOR_CONSTRUCTION,placedForConstruction,false,0,true);
      }
   }
}
