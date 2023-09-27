package com.monsters.frontPage.messages.buildtree
{
   import com.monsters.events.BuildingEvent;
   import com.monsters.frontPage.messages.BuildTreeMessage;
   
   public class BuildTree_10_YardPlanner extends BuildTreeMessage
   {
       
      
      public function BuildTree_10_YardPlanner()
      {
         super("planner",PLANNER.TYPE,"btn_buildnow");
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         if(GLOBAL._flags.yp_version == 2)
         {
            return false;
         }
         return GLOBAL.townHall._lvl.Get() >= 3 && BASE.hasNumBuildings(PLANNER.TYPE) <= 0;
      }
      
      override protected function onButtonClick() : void
      {
         buyBuilding(PLANNER.TYPE);
         GLOBAL.eventDispatcher.addEventListener(BuildingEvent.PLACED_FOR_CONSTRUCTION,placedForConstruction,false,0,true);
      }
   }
}
