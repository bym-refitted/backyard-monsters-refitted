package com.monsters.frontPage.messages.buildtree
{
   import com.monsters.events.BuildingEvent;
   import com.monsters.frontPage.messages.BuildTreeMessage;
   
   public class BuildTree_19_ChampionChamber extends BuildTreeMessage
   {
       
      
      public function BuildTree_19_ChampionChamber()
      {
         super("chamber",CHAMPIONCHAMBER.TYPE,"btn_buildnow");
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         return GLOBAL.townHall._lvl.Get() >= 4 && BASE.hasNumBuildings(CHAMPIONCHAMBER.TYPE) <= 0 && BASE.hasNumBuildings(CHAMPIONCAGE.TYPE,1) >= 1;
      }
      
      override protected function onButtonClick() : void
      {
         buyBuilding(CHAMPIONCHAMBER.TYPE);
         GLOBAL.eventDispatcher.addEventListener(BuildingEvent.PLACED_FOR_CONSTRUCTION,placedForConstruction,false,0,true);
      }
   }
}
