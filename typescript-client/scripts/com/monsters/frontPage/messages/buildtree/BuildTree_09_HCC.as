package com.monsters.frontPage.messages.buildtree
{
   import com.monsters.events.BuildingEvent;
   import com.monsters.frontPage.messages.BuildTreeMessage;
   
   public class BuildTree_09_HCC extends BuildTreeMessage
   {
       
      
      public function BuildTree_09_HCC()
      {
         super("hcc",HATCHERYCC.TYPE,"btn_buildnow");
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         var _loc1_:uint = GLOBAL.townHall._lvl.Get();
         return _loc1_ >= 3 && _loc1_ <= 5 && BASE.hasNumBuildings(HATCHERY.TYPE,2) >= 3 && BASE.hasNumBuildings(HATCHERYCC.TYPE) <= 0;
      }
      
      override protected function onButtonClick() : void
      {
         buyBuilding(HATCHERYCC.TYPE);
         GLOBAL.eventDispatcher.addEventListener(BuildingEvent.PLACED_FOR_CONSTRUCTION,placedForConstruction,false,0,true);
      }
   }
}
