package com.monsters.frontPage.messages.buildtree
{
   import com.monsters.events.BuildingEvent;
   import com.monsters.frontPage.messages.BuildTreeMessage;
   
   public class BuildTree_15_LaserTower extends BuildTreeMessage
   {
       
      
      public function BuildTree_15_LaserTower()
      {
         super("laser",BUILDING23.TYPE,"btn_buildnow");
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         return GLOBAL.townHall._lvl.Get() >= 4 && BASE.hasNumBuildings(BUILDING23.TYPE) <= 0;
      }
      
      override protected function onButtonClick() : void
      {
         buyBuilding(BUILDING23.TYPE);
         GLOBAL.eventDispatcher.addEventListener(BuildingEvent.PLACED_FOR_CONSTRUCTION,placedForConstruction,false,0,true);
      }
   }
}
