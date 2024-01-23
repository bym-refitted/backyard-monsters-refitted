package com.monsters.frontPage.messages.buildtree
{
   import com.monsters.events.BuildingEvent;
   import com.monsters.frontPage.messages.BuildTreeMessage;
   
   public class BuildTree_14_TeslaTower extends BuildTreeMessage
   {
       
      
      public function BuildTree_14_TeslaTower()
      {
         super("tesla",BUILDING25.TYPE,"btn_buildnow");
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         return GLOBAL.townHall._lvl.Get() >= 4 && BASE.hasNumBuildings(BUILDING25.TYPE) <= 0;
      }
      
      override protected function onButtonClick() : void
      {
         buyBuilding(BUILDING25.TYPE);
         GLOBAL.eventDispatcher.addEventListener(BuildingEvent.PLACED_FOR_CONSTRUCTION,placedForConstruction,false,0,true);
      }
   }
}
