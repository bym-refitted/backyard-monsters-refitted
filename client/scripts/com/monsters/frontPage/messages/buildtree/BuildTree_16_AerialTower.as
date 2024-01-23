package com.monsters.frontPage.messages.buildtree
{
   import com.monsters.events.BuildingEvent;
   import com.monsters.frontPage.messages.BuildTreeMessage;
   
   public class BuildTree_16_AerialTower extends BuildTreeMessage
   {
       
      
      public function BuildTree_16_AerialTower()
      {
         super("aerial",115,"btn_buildnow");
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         if(BASE.hasNumBuildings(115) != 0)
         {
            return false;
         }
         return GLOBAL.townHall._lvl.Get() >= 4;
      }
      
      override protected function onButtonClick() : void
      {
         buyBuilding(115);
         GLOBAL.eventDispatcher.addEventListener(BuildingEvent.PLACED_FOR_CONSTRUCTION,placedForConstruction,false,0,true);
      }
   }
}
